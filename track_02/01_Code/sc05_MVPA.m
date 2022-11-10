%% Sample Script to Read Kiel Smarting Data

%% Set the basics
% Go to Current Folder
clear all
close all
ft_defaults; % Set the defualts of the FieldTrip Toolbox
startup_MVPA_Light; % Load MVPA toolbox

% Where are the data?
inpath = ('/Users/juliankeil/Documents/Arbeit/Kiel/Lehre/WS2021/Springschool Open Science 2022/GitHub/track_02/02_Data/');% What are the data called?

indat = dir([inpath,'*_preproc.mat']);

%% Loop participants
for v = 1:length(indat)
    %% 1. Load the preprocessed data
    load([inpath,indat(v).name],'data_cif','data_sta','data_tar');
    
    %% 2. Apply additional Low-Pass-Filter for ERPs
    cfg = [];
    cfg.hpfilter = 'yes'; 
    cfg.hpfreq = 1; 
    cfg.hpfilttype = 'firws'; 
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 35;
    cfg.lpfilttype = 'firws';
    cfg.demean = 'yes';
    cfg.baselinewindow = [-.2 -.05];

    data_sta = ft_preprocessing(cfg,data_sta);
    data_tar = ft_preprocessing(cfg,data_tar);

    %% 3. Average across trials: ERP
    ERP_sta{v} = ft_timelockanalysis([],data_sta);
    ERP_tar{v} = ft_timelockanalysis([],data_tar);
   
    %% 4. Classify
        % 4.1. Neighbors
        cfg = []; 
        cfg.channel = data_sta.label;
        cfg.method = 'distance'; 
        cfg.neighbourdist = 70; 
        cfg.elec = 'standard_1020.elc'; % Here we need the 3d-positions!; 

        neigh = ft_prepare_neighbours(cfg); 
    
        % 4.2. First-Level stats: MVPA
        cfg = [] ;  
        cfg.method        = 'mvpa';
        cfg.latency       = [0 0.5];
        cfg.neighbours    = neigh;
        cfg.timwin        = 3;
        cfg.features      = [];
        cfg.mvpa.repeat   = 5;
        cfg.mvpa.k        = 10;
        cfg.mvpa.classifier = 'lda';
        cfg.mvpa.metric   = {'accuracy','tval'};

        cfg.design        = [ones(length(data_sta.trial),1);...
                             ones(length(data_tar.trial),1)*2];

        stat{v} = ft_timelockstatistics(cfg, data_sta, data_tar);
        dummy{v} = stat{v};
        dummy{v}.tval = zeros(size(dummy{v}.tval));
    
    %% 5. Fix Time vectors
    ERP_sta{v}.time = ERP_sta{1}.time;
    ERP_tar{v}.time = ERP_sta{1}.time;
    stat{v}.time = stat{1}.time;
    dummy{v}.time = stat{1}.time;
end % Loop across participants is done

%% 5. Compute the Grand Average across participants

cfg = [];
cfg.latency = [-.2 .5];
cfg.keepindividual = 'no';

GA_sta = ft_timelockgrandaverage(cfg,ERP_sta{:});
GA_tar = ft_timelockgrandaverage(cfg,ERP_tar{:});

cfg.parameter = 'accuracy';
GA_acc = ft_timelockgrandaverage(cfg,stat{:});


    % 5.1. And take a look at one channel (Cz) with Matlab basics
    figure; hold;
    plot(GA_sta.time,GA_sta.avg(18,:),'b');
    plot(GA_tar.time,GA_tar.avg(18,:),'r');

    % 5.2. You can also look at all channels at the same time
    cfg = [];
    cfg.xlim = [-.2 .5]; % Set the interval to display
    cfg.layout = 'EEG1020.lay'; % Set the channel layout

    ft_multiplotER(cfg,GA_sta,GA_tar);
    
    % 5.2. You can also look at all channels at the same time
    cfg = [];
    cfg.xlim = [0 .5]; % Set the interval to display
    cfg.ylim = [0 1];
    cfg.layout = 'EEG1020.lay'; % Set the channel layout

    ft_multiplotER(cfg,GA_acc);
    
%% 7.2. Option 2: Mass Univariate Approach
% Correct for temporal and spatial clusters (c.f. Maris & Oostenveld, 2007)
    
cfg = [];
cfg.parameter = 'tval'; % On which parameter?
cfg.method = 'montecarlo'; % non-parametric stats based on montecarlo simulation
cfg.numrandomization = 2000; % Number of steps in the simulation
cfg.correctm = 'cluster'; % cluster-correction
cfg.neighbours = neigh; % Define neighbors
cfg.statistic = 'depsamplesT'; % Dependent-samples t-test
cfg.correcttail = 'alpha'; % Correct the alpha-level for 2-tailed test
cfg.uvar = 1; % How many "units" = VPn
cfg.ivar = 2; % Who belongs to which group
cfg.design = [1:length(stat),1:length(dummy);...
                ones(1,length(stat)),ones(1,length(dummy)).*2];
% Restrict the data of interest
cfg.channel = 'all'; % all channels (you can also set the ROI here)
cfg.avgoverchan = 'no'; % Should we average actross a ROI?
cfg.latency = [0 .5]; % The post-stimulus interval
cfg.avgovertime = 'no'; % Should we average across time

% And compute the stats
stats = ft_timelockstatistics(cfg,stat{:},dummy{:});

    % 7.2.3. Plot Unrestricted Stats
    cfg = [];
    cfg.layout = 'EEG1020.lay';
    cfg.parameter = 'stat';
    cfg.maskparameter = 'mask';

    ft_multiplotER(cfg,stats);

    % 7.2.4 Find the Cluster
    [chan lat] = find(stats.posclusterslabelmat == 1);
    chan = unique(chan)
    lat = unique(lat);

    starti = stats.time(lat(1))
    endi = stats.time(lat(end))

    figure; hold;
    plot(GA_sta.time,squeeze(mean(GA_sta.avg(chan,:))),'b');
    plot(GA_tar.time,squeeze(mean(GA_tar.avg(chan,:))),'r');


