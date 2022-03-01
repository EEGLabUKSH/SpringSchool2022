%% Sample Script to Read Kiel Smarting Data
%
% 1. Load the preprocessed data
% 2. Apply additional filters
% 3. Compute the ERP across trials
% 4. Apply a baseline correction
% 5. Compute the grand average across participants
% 6. Extract ERP peaks for statistics outside of matlab
% 7. Alternative: Statistics in Matlab

%% Set the basics
% Go to Current Folder
clear all
close all
ft_defaults; % Set the defualts of the FieldTrip Toolbox

% Where are the data?
inpath = ('/Users/juliankeil/Documents/Arbeit/Kiel/Lehre/WS2021/Springschool Open Science 2022/Track2/02_Data/');
% What are the data called?
indat = dir('*_preproc.mat');

%% Loop participants
for v = 1:length(indat)
    %% 1. Load the preprocessed data
    load(indat(v).name);
    
    %% 2. Apply additional Low-Pass-Filter for ERPs
    cfg = [];
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 35;
    cfg.lpfilttype = 'firws';

    data_cif = ft_preprocessing(cfg,data_cif);
    data_sta = ft_preprocessing(cfg,data_sta);
    data_tar = ft_preprocessing(cfg,data_tar);

    %% 3. Average across trials: ERP
    ERP_all{v} = ft_timelockanalysis([],data_cif);
    ERP_sta{v} = ft_timelockanalysis([],data_sta);
    ERP_tar{v} = ft_timelockanalysis([],data_tar);

    %% 4. Correct for offset: Baseline-Correction
    cfg = [];
    cfg.baseline = [-.2 -.05]; % Keep a bit away from stimulus onset
    
    ERP_all_bl{v} = ft_timelockbaseline(cfg,ERP_all{v});
    ERP_sta_bl{v} = ft_timelockbaseline(cfg,ERP_sta{v});
    ERP_tar_bl{v} = ft_timelockbaseline(cfg,ERP_tar{v});
end % Loop across participants is done

%% 5. Compute the Grand Average across participants
GA_all = ft_timelockgrandaverage([],ERP_all_bl{:});
GA_sta = ft_timelockgrandaverage([],ERP_sta_bl{:});
GA_tar = ft_timelockgrandaverage([],ERP_tar_bl{:});

    % 5.1. And take a look at one channel (Cz)
    figure; hold;
    plot(GA_sta.time,GA_sta.avg(18,:),'b');
    plot(GA_tar.time,GA_tar.avg(18,:),'r');

    % 5.2. You can also look at all channels at the same time
    cfg = [];
    cfg.xlim = [-.5 .5]; % Set the interval to display
    cfg.layout = 'EEG1020.lay'; % Set the channel layout

    ft_multiplotER(cfg,GA_sta,GA_tar);

%% 6. Extract Peaks for R
% Find index of window of interest, e.g. between 320 and 600 ms (Comerchero
% et al., 1999)
starti = nearest(ERP_sta_bl{1}.time,.32); % Start point
endi = nearest(ERP_sta_bl{1}.time,.6); % End point

% Define a region of interest here, e.g. only take the Cz and
% Pz electrodes
for v = 1:length(ERP_sta_bl) % Loop VPn
    cfg = [];
    cfg.channel = {'Cz','Pz'};
    
    ROI_sta_bl{v} = ft_selectdata(cfg,ERP_sta_bl{v});
    ROI_tar_bl{v} = ft_selectdata(cfg,ERP_tar_bl{v});
    ROI_all_bl{v} = ft_selectdata(cfg,ERP_all_bl{v});
end

    % 6.1. Option 1: Pick individual Peaks
    peaks = zeros(length(ROI_sta_bl),3,2);
    lat = zeros(length(ROI_sta_bl),3,2);
    for v = 1:length(ROI_sta_bl) % Loop VPn
        for c = 1:size(ROI_sta_bl{v}.avg,1) % Loop Channels
            [peaks(v,c,1) lat(v,c,1)] = max(ROI_sta_bl{v}.avg(c,starti:endi));
            [peaks(v,c,2) lat(v,c,2)] = max(ROI_tar_bl{v}.avg(c,starti:endi));
        end % for c
    end % for v

    % 6.2. Option 2: Average over interval
    peaks = zeros(length(ROI_sta_bl),3,2);
    for v = 1:length(ROI_sta_bl) % Loop VPn
        for c = 1:size(ROI_sta_bl{v}.avg,1) % Loop Channels
            peaks(v,c,1) = mean(ROI_sta_bl{v}.avg(c,starti:endi));
            peaks(v,c,2) = mean(ROI_tar_bl{v}.avg(c,starti:endi));
        end % for c
    end % for v

    % 6.3. Option 3: Pick Peaks based on GA and average around them
    GA_ROI_all = ft_timelockgrandaverage([],ROI_all_bl{:});
    for c = 1:size(GA_ROI_all.avg,1) % Loop Channels
        [tmppeaks(c) tmplat(c)] = max(abs(GA_ROI_all.avg(c,starti:endi)));
    end

    peaks = zeros(length(ROI_sta_bl),3,2);
    for v = 1:length(ROI_sta_bl) % Loop VPn
        for c = 1:size(ROI_sta_bl{v}.avg,1) % Loop Channels
            peaks(v,c,1) = mean(ROI_sta_bl{v}.avg(c,starti+tmplat(c)-10 : starti+tmplat(c)+10));
            peaks(v,c,2) = mean(ROI_tar_bl{v}.avg(c,starti+tmplat(c)-10 : starti+tmplat(c)+10));
        end % for c
    end % for v

    % 6.4. Save Values to use in R
    save('P300_peaks_lats.mat','peaks','lat');

%% 7. Stats in Matlab
% In Matlab, you can either work with the extracted peaks, or you can work
% with the entire dataset. The latter is called "Mass Univariate Approach".

    % 7.1. Option 1: Extracted Values
    % Bonferroni-correct p-value for multiple comparisons!
    for c = 1:size(peaks,2)
        [H(c),P(c),CI(c,:),STATS{c}] = ttest(squeeze(peaks(:,c,1)),squeeze(peaks(:,c,2)), 'alpha', .05/3);
    end

    % 7.2. Option 2: Mass Univariate Approach
    % Correct for temporal and spatial clusters (c.f. Maris & Oostenveld,
    % 2007)
    
        % 7.2.1. Define Neighbours
        cfg = []; 
        cfg.method = 'distance'; % how should the neighbors be selected?
        cfg.neighbourdist = 50; % I have no Idea what range this has, just make sure, that you get meaningful neighbors
        cfg.elec = 'standard_1020.elc'; % Here we need the 3d-positions!
        
        neigh = ft_prepare_neighbours(cfg); % between 5 and 10 neighbors is a good value, always good to check!
        
        % 7.2.2. Compute Stats
        cfg = [];
        cfg.parameter = 'avg'; % On which parameter?
        cfg.method = 'montecarlo'; % non-parametric stats based on montecarlo simulation
        cfg.numrandomization = 2000; % Number of steps in the simulation
        cfg.correctm = 'cluster'; % cluster-correction
        cfg.neighbours = neigh; % Define neighbors
        cfg.statistic = 'depsamplesT'; % Dependent-samples t-test
        cfg.correcttail = 'alpha'; % Correct the alpha-level for 2-tailed test
        cfg.uvar = 1; % How many "units" = VPn
        cfg.ivar = 2; % Who belongs to which group
        % Set the design to correspondent to uvar and ivar
        % First row: Two vectors from 1 to the number of VPn
        % Second row: Two vector, one of 1s and one of 2s
        cfg.design = [1:length(ERP_tar_bl),1:length(ERP_sta_bl);...
                        ones(1,length(ERP_tar_bl)),ones(1,length(ERP_sta_bl)).*2];
        % Restrict the data of interest
        cfg.channel = 'all'; % all channels (you can also set the ROI here)
        cfg.avgoverchan = 'no'; % Should we average actross a ROI?
        cfg.latency = [0 1]; % The post-stimulus interval
        cfg.avgovertime = 'no'; % Should we average across time

        % And compute the stats
        stats = ft_timelockstatistics(cfg,ERP_tar_bl{:},ERP_sta_bl{:});

        % 7.2.3. Plot Unrestricted Stats
        cfg = [];
        cfg.layout = 'EEG1020.lay';
        cfg.parameter = 'stat';
        cfg.maskparameter = 'mask';

        ft_multiplotER(cfg,stats);

        % 7.2.4 Find the Cluster
        [chan lat] = find(stats.negclusterslabelmat == 1);
        chan = unique(chan)
        lat = unique(lat);

        starti = stats.time(lat(1))
        endi = stats.time(lat(end))
        
        figure; hold;
        plot(GA_sta.time,squeeze(mean(GA_sta.avg(chan,:))),'b');
        plot(GA_tar.time,squeeze(mean(GA_tar.avg(chan,:))),'r');


