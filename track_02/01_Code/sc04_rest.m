%% Sample Script to Read Kiel BioTrace Data for Resting State data
% Go to Current Folder
clear all
close all
ft_defaults;

cd ('/Users/juliankeil/Documents/Arbeit/Kiel/Lehre/SS2019/Rhythms of the Brain/EEG/data/rest')
indat = dir('*_rest.txt');

%%
for v = 1:length(indat)
    
    cfg=[];
    cfg.trialdef.eventvalue = [100,101];
    cfg.trialdef.prestim = 0;
    cfg.trialdef.poststim = 300; % 5 min * 60 s
    [data,trl] = eeg_getBiotraceData(cfg,indat(v).name);

    %ft_databrowser([],data);
    data.label{3} = 'Pz';
    
    %% Preprocessing

    cfg = [];
    cfg.hpfilter = 'yes';
    cfg.hpfreq = .5;
    cfg.hpfilttype = 'firws';
    cfg.demean = 'yes';

    data_p = ft_preprocessing(cfg,data);

    %ft_databrowser([],data_p);

    %% Cut into Eyes open and Eyes Closed

    cfg = [];
    cfg.trl = trl(trl(:,4)==100,:);

    data_eo = ft_redefinetrial(cfg,data_p);
    
    cfg = [];
    cfg.trl = trl(trl(:,4)==101,:);

    data_ec = ft_redefinetrial(cfg,data_p);

    %ft_databrowser([],data_t);
    
    %% Cut into smaller segmets
    
    cfg = [];
    cfg.length = 3;
    
    data_eo_t = ft_redefinetrial(cfg,data_eo);
    data_ec_t = ft_redefinetrial(cfg,data_ec);
  
    %% FFT
    
    cfg = [];
    cfg.method = 'mtmfft';
    cfg.output = 'pow';
    cfg.pad = 'nextpow2';
    cfg.taper = 'dpss';
    cfg.foi = [1:.25:45]; % cfg.foilim = [1 45];
    cfg.tapsmofrq = 1;
    
    fft_eo{v} = ft_freqanalysis(cfg,data_eo_t);
    fft_ec{v} = ft_freqanalysis(cfg,data_ec_t);

end

%% Grand Average

GA_eo = ft_freqgrandaverage([],fft_eo{:});
GA_ec = ft_freqgrandaverage([],fft_ec{:});

%% Plot

cfg = [];
%cfg.xlim = [1 45];
cfg.layout = 'EEG1020.lay';
cfg.parameter = 'powspctrm';

ft_multiplotER(cfg,GA_eo,GA_ec);

%% Find individual Alpha Peak
% Find index of frequency-window of interest
startf = nearest(fft_eo{1}.freq,5);
endf = nearest(fft_eo{1}.freq,20);
% Pick individual Peaks
peaks = zeros(length(fft_eo),3,2);
freq = zeros(length(fft_eo),3,2);
for v = 1:length(fft_eo) % Loop VPn
    for c = 1:size(fft_eo{v}.powspctrm,1) % Loop Channels
        [peaks(v,c,1) freq(v,c,1)] = max(fft_eo{v}.powspctrm(c,startf:endf));
        [peaks(v,c,2) freq(v,c,2)] = max(fft_ec{v}.powspctrm(c,startf:endf));
    end % for c
end % for v

% Assing actual Frequencies to freq
realfreq = fft_eo{v}.freq(freq+startf);

%% Stats

% Option 1: Extracted Peak Power Values
for c = 1:size(peaks,2)
    [H(c),P(c),CI(c,:),STATS{c}] = ttest(squeeze(peaks(:,c,1)),squeeze(peaks(:,c,2)), 'alpha', .05/3);
end

% Option 2: Extracted Peak Frequencies
for c = 1:size(peaks,2)
    [H(c),P(c),CI(c,:),STATS{c}] = ttest(squeeze(realfreq(:,c,1)),squeeze(realfreq(:,c,2)), 'alpha', .05/3);
end

% Option 3: Mass Univariate Approach
cfg = [];
cfg.parameter = 'powspctrm';
cfg.method = 'montecarlo';
cfg.correctm = 'cluster';
cfg.neighbours = [];
cfg.numrandomization = 2000;
cfg.statistic = 'depsamplesT';
cfg.correcttail = 'alpha';
cfg.uvar = 1;
cfg.ivar = 2;

% Option 3.1.: Average over Frequency of Interest
cfg.avgoverfreq = 'yes';
cfg.frequency = [8 12]; % Alpha Range

cfg.design = [1:length(fft_eo),1:length(fft_ec);...
                ones(1,length(fft_eo)),ones(1,length(fft_ec)).*2];
            
stats_fft = ft_freqstatistics(cfg,fft_eo{:},fft_ec{:});

%% Plot Unrestricted Stats
cfg = [];
cfg.layout = 'EEG1020.lay';
cfg.parameter = 'stat';
cfg.maskparameter = 'mask';

ft_multiplotER(cfg,stats_fft);

%% Difference Wave for ANOVA
for v = 1:length(fft_eo)
   
    cfg = [];
    cfg.channel = 'Fz';
    cfg.parameter = 'powspctrm';
    cfg.operation = 'x1-x2';
    FFT_diff{v} = ft_math(cfg,fft_eo{v},fft_ec{v});
    
    cfg = [];
    cfg.channel = 'Fz';

    FFT_Fz{v} = ft_selectdata(cfg,FFT_diff{v});
    FFT_Fz{v}.label = {'diff'};
    
    cfg.channel = 'Cz';

    FFT_Cz{v} = ft_selectdata(cfg,FFT_diff{v});
    FFT_Cz{v}.label = {'diff'};

    cfg.channel = 'Pz';

    FFT_Pz{v} = ft_selectdata(cfg,FFT_diff{v});
    FFT_Pz{v}.label = {'diff'};
end

%% Grand Average
GA_Fz = ft_freqgrandaverage([],FFT_Fz{:});
GA_Cz = ft_freqgrandaverage([],FFT_Cz{:});
GA_Pz = ft_freqgrandaverage([],FFT_Pz{:});

%%
figure; hold;
plot(GA_Fz.freq,GA_Fz.powspctrm);
plot(GA_Cz.freq,GA_Cz.powspctrm);
plot(GA_Pz.freq,GA_Pz.powspctrm);
%% 1-Faktorielle ANOVA (Faktor Elektrode)

cfg = [];
cfg.parameter = 'powspctrm';
cfg.method = 'montecarlo';
cfg.correctm = 'cluster';
cfg.neighbours = [];
cfg.numrandomization = 2000;
cfg.statistic = 'depsamplesFunivariate';
cfg.correcttail = 'alpha';
cfg.tail = 1;
cfg.uvar = 1;
cfg.ivar = 2;

% Option 3.1.: Average over Frequency of Interest
cfg.avgoverfreq = 'yes';
cfg.frequency = [8 12]; % Alpha Range

cfg.design = [1:length(FFT_Fz),1:length(FFT_Cz),1:length(FFT_Pz);...
                ones(1,length(FFT_Fz)),ones(1,length(FFT_Cz)).*2,ones(1,length(FFT_Pz)).*3];
            

stats_anova = ft_freqstatistics(cfg,FFT_Fz{:},FFT_Cz{:},FFT_Pz{:});
%% Plot Unrestricted Stats
cfg = [];
cfg.layout = 'EEG1020.lay';
cfg.parameter = 'stat';
cfg.maskparameter = 'mask';

ft_singleplotER(cfg,stats_anova);