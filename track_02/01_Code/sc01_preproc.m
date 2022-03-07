%% Sample Script to Read Kiel Smarting Data
% 
% 0. Set the basics
% 1. Define the current dataset
% 2. Read in the continuous data and apply filters
% 3. Reject artifacts
% 4. Perform ICA
% 5. Interpolate Channels
% 6. Select relevant trials
% 7. Save for later

% This script requires the FieldTrip Toolbox
%% 0. Set the basics
% Go to Current Folder
clear all
close all
ft_defaults; % Set the defualts of the FieldTrip Toolbox

% Where are the data?
inpath = ('/Users/juliankeil/Documents/Arbeit/Kiel/Lehre/WS2021/Springschool Open Science 2022/Track2/02_Data/');
% What are the data called?
indat = dir('*.xdf');

%% Loop participants
for v = 1:length(indat)
    %% 1. Define the current dataset
    % Attention!
    % If there is an error with sccn_xdf, change:
    % * line 120: 'channels' to e.g. 'Xchannels' to avoid looking for
    % missing channel info
    % * line 150: streams{i}.time_series{j}; to streams{i}.time_series(j);
    % to change cell array to structure
    
    % 1.1. First, read in the header to define the trials
    cfg = []; % Always clear the configuration
    cfg.dataset = [inpath,indat(1).name]; % Set the dataset
%     cfg.trialfun = 'ft_trialfun_show'; % If we don't know what events have happened
    cfg.trialdef.eventtype = 'Markers'; % We now know that the trigger channel is called 'Stimulus'
    cfg.trialdef.eventvalue = {20,30}; % Define the relevant triggers
    cfg.trialdef.prestim = 1.5; % Seconds before the stimulus
    cfg.trialdef.poststim = 1.5; % Seconds after the stimulus

    cfg = ft_definetrial(cfg); % Store the trial definition

    % 1.2. Save the trial-definition
    trl = cfg.trl;

    % 1.3. Then define the entire dataset
    cfg = []; % Always clear the configuration
    cfg.dataset = [inpath,indat(1).name]; % Set the dataset
    cfg.trialdef.ntrials = 1; % One long trial to cover the entire dataset

    cfg = ft_definetrial(cfg); % Store the trial definition
    
    %% 2. Preprocessing
    % This step will read, filter and cut the raw data
    
    % 2.1. Read in the raw data and filter
    cfg.demean = 'yes'; % Remove mean across time to get rid of offset
    cfg.hpfilter = 'yes'; % Highpassfilter to remove slow drifts
    cfg.hpfreq = .1; % Highpass frequency. 0.1 removes most slow drifts
    cfg.hpfilttype = 'firws'; % Type of filter
    cfg.lpfilter = 'yes'; % The same for lowpass
    cfg.lpfreq = 45; % 50Hz line noise destroys the data, only take data below
    cfg.lpfilttype = 'firws'; % Again the type

    data_p = ft_preprocessing(cfg);
    
        % 2.1.1. Fix the channel labels for the smarting amp
        for c = 1:length(data_p.label)
            data_p.label{c} = data_p.hdr.orig.desc.channels.channel{c}.label;
        end
    % 2.2. Cut the data according to the trial definition
    cfg = [];
    cfg.trl = trl; % Use the trl-structure defined above

    data_t = ft_redefinetrial(cfg,data_p);
   
    % Now we have the dat-structure containing the actual EEG-Data with the
    % fields:
    % hdr: Header information
    % label: labels for the data-channels
    % time: time-vector for each trial
    % trial: actual data for each trial in chan-by-samplepoint
    % fsample: sample-frequency
    % sampleinfo: Beginning and End for each trial in sample points
    % trialinfo: trigger value for each trial
    % cfg: configuration that was used to call definetrial

        %% 2.2.1 Take a look at the data
        % Compare the data_p and data_t
        cfg = []; % empty the cfg-structure
        cfg.viewmode = 'vertical'; % or butterfly

        ft_databrowser(cfg,data_t); % we call the databrowser with the cfg-settings and the dat-structure defined above
   
    %% 3. Visual Artifact Rejection
    cfg = [];
    cfg.method = 'summary';
    cfg.layout = 'EEG1020.lay';
    cfg.keepchannel = 'no'; % Remove Bad channels
    % We can also specify filters just for the artifact rejection
    % These settings are good to identify eye blinks
    cfg.preproc.bpfilter = 'yes';
    cfg.preproc.bpfilttype = 'but';
    cfg.preproc.bpfreq = [1 15];
    cfg.preproc.bpfiltord = 4;
    cfg.preproc.rectify = 'yes';
    
    data_c = ft_rejectvisual(cfg,data_t);
    
    % You have different options to identify artifacts.
    % The most useful are:
    % var: The variance across trials. Trials with blinks will have a
    % larger variance than those without
    % kurtosis: how tailed is the trial, are there outliers? Trials with
    % artifacts will deviate from the normal distribution
    % z-value: are there outliers in the data?
    
        %% 3.1. Alternative: Automatic trial removal
        % It is also possible to compute all these measures by hand, and remove
        % trials based on fixed thresholds
        clear kurt    
        clear zval
        clear vari
        clear maxi
        clear mini

            % 3.1.1. Compute the kurtosis
            for t = 1:length(data_t.trial)
                kurt(t) = kurtosis(data_t.trial{t},[],2);
            end

            % 3.1.2. Z-Value, Variance, and Peaks
            for t = 1:length(data_t.trial)
                clear zsc mu sig
                [zsc, mu, sig] = zscore(data_t.trial{t},0,2);
                zval(t) = max(abs(zsc));
                vari(t) = sig; % standard deviation
                maxi(t) = any(data_t.trial{t} >= mu+(3*sig)); % 3 STD above or
                mini(t) = any(data_t.trial{t} <= mu-(3*sig)); % below the mean
            end

            % 3.1.3. Define thresholds
            z_thresh = mean(zval) + std(zval);
            k_thresh = mean(kurt) + std(kurt);
            v_thresh = mean(vari) + std(vari);

            % 3.1.4. Apply thresholds
            clear outs
            for t = 1:length(data_t.trial)
                outs(t) = any(zval(t) >= z_thresh ...
                            | kurt(t) >= k_thresh ...
                            | vari(t) >= v_thresh ...
                            | maxi(t) == 1 ...
                            | mini(t) == 1);
            end

            clear goodtrials
            goodtrials = find(outs == 0); % Select what's left

            % 3.1.5. Keep only good trials
            cfg = [];
            cfg.trials = goodtrials;

            data_c = ft_selectdata(cfg,data_t); % data_psc is the, preprocessed, selected and clean data
        
        %% 3.2. Re-Reference
        % After cleaning the data, it is best to re-reference the data to
        % the average across channels to remove the influence of the
        % reference
        cfg = [];
        cfg.reref = 'yes';
        cfg.refchannel = 'all'; % Take all channels
        cfg.refmethod = 'avg'; % Take the average
        
        data_c = ft_preprocessing(cfg,data_c);
        
    %% 4. ICA
    % in order to get rid of blink artefacts and external noise, the
    % independent component analysis can be useful. But beware, don't exclude
    % to much! Whereas teh ICA can split the signal into independent
    % components, this does not mean that one component does not contain
    % information from more than one source!

        %% 4.1. Compute ICA-Components
        cfg = [];
        %cfg.channel = {'e*'}; % Super important to only use the EEG-Channels, otherwise the ICA won't work
        cfg.method = 'runica'; % Whcih method should be used? 
        cfg.runica.pca = size(data_c.trial{1},1)-1; % Reduce the data dimensions to the number of channels-1
        %cfg.runica.extended = 1; % If there is lot of line-nois (50Hz)
        %include subgaussian noise
        %cfg.numcomponents = 20; % if the ICA does not converge, limit the number of components to compute
        cfg.demean = 'yes'; % remove trial-wise offset

        comp = ft_componentanalysis(cfg,data_c);

        %% 4.2. Take a look at the components
        cfg = [];
        cfg.layout = 'EEG1020.lay';
        cfg.viewmode = 'component'; % same as above, just with a different mode
        ft_databrowser(cfg,comp);

        % Here, you'll actually have to write down or remember the bad
        % components

        %% 4.3. And take out the ones that are clearly artefacts
        cfg = [];
        cfg.component = [1,2,3,4]; % I focus on blinks and muscle artefacts
        data_ci = ft_rejectcomponent(cfg,comp,data_c);

        %% 4.4 Compare before & after
        figure;plot(data_ci.time{1},data_ci.trial{1}(1,:),'r');hold;plot(data_c.time{1},data_c.trial{1}(1,:),'b')
    
    %% 5. Interpolate Channels
    % First you have to define, which channels are neighbors to which channels
    % Then you can interpolate from the surrounding channels
    % However, we need to do this in 3D-space, so we need the actual
    % 3-Dimensional Senesor positions from the elec-structure

        %% 5.1. Neighbors
        cfg = []; 
        cfg.method = 'distance'; % how should the neighbors be selected?
        cfg.neighbourdist = 50; % I have no Idea what range this has, just make sure, that you get meaningful neighbors
        cfg.elec = 'standard_1020.elc'; % Here we need the 3d-positions!
        
        neigh = ft_prepare_neighbours(cfg); % between 5 and 10 neighbors is a good value, always good to check!

        %% 5.2. Check!
        cfg = [];
        cfg.neighbours = neigh; % what neighbor-structure
        cfg.elec = 'standard_1020.elc';
        
        ft_neighbourplot(cfg)
        % Again, ist's best to check the actual neighbors for each channel. On
        % average you'll want to end up with ahout 5 to 10 neighbors for each
        % channel, at least have 2, otherwise you'll just end up copying one
        % channel.

        %% 5.3. Repair the Cleaned and ICA-Corrected Data
        % For further analyses, it is helpful if all subjects have the same number
        % of channels.
        cfg=[];
        cfg.method = 'spline';
        cfg.missingchannel = setdiff(data_t.label,data_ci.label);%{'e52' 'e72' 'e88'}; % Who's bad?
        cfg.neighbours = neigh; % What channels should be used to fix?
        cfg.elec = 'standard_1020.elc'; % Where are the channels?

        data_cif=ft_channelrepair(cfg,data_ci);

    %% 6. Trial selection
    sta = find(data_t.trialinfo == 30);
    tar = find(data_t.trialinfo == 20);

    cfg = [];
    cfg.trials = sta;
    data_sta = ft_selectdata(cfg,data_t);

    cfg.trials = tar;
    data_tar = ft_selectdata(cfg,data_t);

    % Equalize Trial numbers -> Draw Random Trials
    vec = [ones(1,length(data_tar.trial)),zeros(1,(length(data_sta.trial)-length(data_tar.trial)))];
    selvec = randperm(length(vec),length(data_tar.trial));

    cfg = [];
    cfg.trials = selvec;
    data_sta = ft_selectdata(cfg,data_sta);
    
    %% 7. Save for later
    save([indat(v).name,'_preproc.mat'],'data_cif','data_sta','data_tar','selvec');
    
end % Loop across participants is done

