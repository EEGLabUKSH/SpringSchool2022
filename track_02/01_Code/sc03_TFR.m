%% Sample Script to Read Kiel Smarting Data
%
% 1. Load the preprocessed data
% 2. Compute a Fourier Transform
% 3. Compute a Wavelet Transform
% 4. Compute a Multitaper Convolution Transform
% 5. Compute the grand average across participants
% 6. Look at the data
% 7. Statistics in Matlab

%% 0. Set the basics
% Go to Current Folder
clear all
close all
ft_defaults; % Set the defualts of the FieldTrip Toolbox

% Where are the data?
inpath = ('/Users/juliankeil/Documents/Arbeit/Kiel/Lehre/WS2021/Springschool Open Science 2022/Track2/02_Data/');
% What are the data called?
indat = dir('*_preproc.mat');

%% Loop Participants
for v = 1:length(indat)
    %% 1. Load the preprocessed data
    load(indat(v).name);
    
    %% 2. Option 1: FFT
    % The Fourier Transform computes the power spectral density for each frequency across time
    
    % 2.1.Cut the Data into Baseline and Activation
    cfg=[];
    cfg.toilim=[-.6 -.1]; % Define the Time-Window for the Baseline. Should be as long as the activation window
    bl_sta=ft_redefinetrial(cfg,data_sta);
    bl_tar=ft_redefinetrial(cfg,data_tar);

    cfg.toilim=[0 .5]; % Define the window in which the activation takes place 
    act_sta=ft_redefinetrial(cfg,data_sta);
    act_tar=ft_redefinetrial(cfg,data_tar);
    
    % 2.2. Settings for FFT
    cfg=[];
    cfg.method='mtmfft'; % Method: Fourier Transformation
    cfg.output='pow'; % Output parameter
    cfg.foi=[2:1:40]; % Frequency resolution
    cfg.taper = 'hanning';
  
        % 2.2.1. FFT for Standard
        bl = ft_freqanalysis(cfg,bl_sta);
        act = ft_freqanalysis(cfg,act_sta);
        % Normalize by baseline
        bl_TFR_sta{v} = act;
        bl_TFR_sta{v}.powspctrm = (act.powspctrm - bl.powspctrm)./bl.powspctrm;
    
        % 2.2.2. FFT for Target
        bl = ft_freqanalysis(cfg,bl_tar);
        act = ft_freqanalysis(cfg,act_tar);
        % Normalize by baseline
        bl_TFR_tar{v} = act;
        bl_TFR_tar{v}.powspctrm = (act.powspctrm - bl.powspctrm)./bl.powspctrm;
    
    %% 3. Option 2: Wavelet
    % The Wavelet transform multiplies a time-window around each timepoint with a
    % frequency-specific wave template (hence "wavelet"), resulting in the
    % power spectral density for each frequency at each timepoint
    % 
    % Hint: This can also be done on the ERP to get the "evoked power"
    % data_sta = ft_timelockanalysis([],data_sta);
    % data_tar = ft_timelockanalysis([],data_tar);
    
    % 3.1. Settings for the Wavelet
    cfg=[];
    cfg.method='wavelet'; % Method: Wavelet Transformation
    cfg.output='pow'; % Output parameter
    cfg.foi=[2:1:40]; % Frequency resolution
    cfg.toi=[-.5:.01: .5]; % Temporal resolution
    cfg.width = 3; % How many cycles per frequency?
    % More cycles = better frequency resolution, but worse time resolution
    % Usually between 3 and 7

    % Compute the Wavelet transform
    TFR_sta{v}=ft_freqanalysis(cfg,data_sta);
    TFR_tar{v}=ft_freqanalysis(cfg,data_tar);
    
    % 3.2. Baseline-correction
    cfg=[];
    cfg.baseline=[-.5 -.1]; % Baseline
    cfg.baselinetype='relchange'; % Method, same as for FFT above
    cfg.parameter='powspctrm'; % Input parameter

    bl_TFR_sta{v}=ft_freqbaseline(cfg,TFR_sta{v});
    bl_TFR_tar{v}=ft_freqbaseline(cfg,TFR_tar{v});
    
    %% 4. Option 3: Multitaper Convolution
    % The multitaper convolution transform multiplies a time-window around each timepoint with a
    % frequency-specific taper function, which can be tuned very finely.
    % Again, this results in the power spectral density for each frequency at each timepoint
    
    % 4.1. Settings for the multitaper
    cfg=[];
    cfg.method='mtmconvol'; % Method: Multitaper Convolution
    cfg.output='pow'; % Output parameter
    cfg.foi=[2:1:40]; % Frequency resolution
    cfg.toi=[-.5:.01: .5]; % Temporal resolution
    
        % 4.1.1. Option 3.1.: Adaptive Hann Tapers (looks like a Normal
        % distribution
        cfg.t_ftimwin = 3./cfg.foi; % Number of cycles per frequency, c.f. Wavelet
        cfg.taper = 'hanning'; % Frequency-Adaptive Smoothing
    
        % 4.1.2. Option 3.2.: Fixed Slepian Tapers (can also be adaptive)
        cfg.t_ftimwin = 0.2 * ones(numel(cfg.foi)); % Fixed 200ms Time Window
        cfg.tapsmofrq = 10 * ones(numel(cfg.foi)); % Fixed 10 Hz Smoothing
        cfg.taper = 'dpss'; % Adapt Slepian Tapers to the time-frequency window

    % Compute the multitaper transform
    TFR_sta{v}=ft_freqanalysis(cfg,data_sta);
    TFR_tar{v}=ft_freqanalysis(cfg,data_tar);

    % 4.2. Baseline-correction
    cfg=[];
    cfg.baseline=[-.5 -.1]; % Baseline
    cfg.baselinetype='relchange'; % Method, same as for FFT above
    cfg.parameter='powspctrm'; % Input parameter

    bl_TFR_sta{v}=ft_freqbaseline(cfg,TFR_sta{v});
    bl_TFR_tar{v}=ft_freqbaseline(cfg,TFR_tar{v});
end

%% 5. Grand Average
GA_sta = ft_freqgrandaverage([],bl_TFR_sta{:});
GA_tar = ft_freqgrandaverage([],bl_TFR_tar{:});

%% 6. What do we see here?
% Plot all channels at once
cfg=[];
%cfg.channel={'Pz'};
cfg.layout = 'EEG1020.lay';
cfg.zparameter='powspctrm'; % Color-coded
cfg.xparameter='time'; % x-axis
cfg.yparameter='freq'; % y-axis
cfg.zlim=[-.50 .50]; % limits of the color scale
%cfg.xlim=[-.1 .5]; % limits of the x-axis

figure;ft_multiplotTFR(cfg,GA_sta);
figure;ft_multiplotTFR(cfg,GA_tar);

% % In case of Frequency-Only Data set the x-axis to frequency
% cfg.xparameter='freq';

% plot only a single channel
cfg.channel={'Pz'};

figure;ft_singleplotTFR(cfg,GA_sta);
figure;ft_singleplotTFR(cfg,GA_tar);

%% 7. STATS: Mass Univariate Approach
% In case of time-frequency data, it does not make much sense to extract
% specific time-frequency and channel windows, unless you have very
% specific hypotheses.

    % 7.1. Define Neighbours
    cfg = []; 
    cfg.method = 'distance'; % how should the neighbors be selected?
    cfg.neighbourdist = 50; % I have no Idea what range this has, just make sure, that you get meaningful neighbors
    cfg.elec = 'standard_1020.elc'; % Here we need the 3d-positions!

    neigh = ft_prepare_neighbours(cfg); % between 5 and 10 neighbors is a good value, always good to check!
    
    % 7.2. Statistics
    % Similar settings as in the ERP
    cfg = [];
    cfg.parameter = 'powspctrm';
    cfg.method = 'montecarlo';
    cfg.numrandomization = 2000;
    cfg.correctm = 'cluster';
    cfg.neighbours = neigh;
    cfg.statistic = 'depsamplesT';
    cfg.correcttail = 'alpha';
    cfg.uvar = 1;
    cfg.ivar = 2;
    cfg.design = [1:length(bl_TFR_tar),1:length(bl_TFR_sta);...
                ones(1,length(bl_TFR_tar)),ones(1,length(bl_TFR_sta)).*2];
    % Restrict the data of interest
    cfg.channel = 'all'; % all channels (you can also set the ROI here)
    cfg.avgoverchan = 'no'; % Should we average actross a ROI?
    cfg.latency = [0 1]; % Post-Stimulus interval
    cfg.avgovertime = 'no';
    %cfg.frequency = [8 12]; % Alpha Range
    %cfg.avgoverfreq = 'yes';
    
    % And compute the stats
    stats_tfr = ft_freqstatistics(cfg,bl_TFR_tar{:},bl_TFR_sta{:});

    % 7.3. Plot
    cfg=[];
    %cfg.channel={'Pz'};
    cfg.layout = 'EEG1020.lay';
    cfg.parameter='stat';
    cfg.xparameter='time';
    cfg.yparameter='freq';
    cfg.zlim=[-2 2];
    cfg.maskparameter = 'mask';
    cfg.maskstyle = 'outline';
    %cfg.xlim=[-.1 .5];

    figure;ft_multiplotTFR(cfg,stats_tfr);