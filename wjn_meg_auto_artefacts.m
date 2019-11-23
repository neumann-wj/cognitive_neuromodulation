function D=wjn_meg_auto_artefacts(filename)
S = [];

ampthresh = 10098;
flatthresh = 3.4241;
D=spm_eeg_load(filename);
S.D = D;
S.mode = 'reject';
S.badchanthresh = 0.2; % 0.4; % 0.8;
S.methods(1).channels = {'MEGGRAD'};
S.methods(1).fun = 'flat';
S.methods(1).settings.threshold = flatthresh; 
S.methods(1).settings.seqlength = 10;
S.methods(2).channels = {'MEGPLANAR'};
S.methods(2).fun = 'flat';
S.methods(2).settings.threshold = 0.1;
S.methods(2).settings.seqlength = 10;
S.methods(3).channels = {'MEGGRAD'};
S.methods(3).fun = 'jump';
S.methods(3).settings.threshold = 1e4;
S.methods(3).settings.excwin = 2000;
S.methods(4).channels = {'MEGPLANAR'};
S.methods(4).fun = 'jump';
S.methods(4).settings.threshold = 5000;
S.methods(4).settings.excwin = 2000;
S.methods(5).channels = {'MEG'};
S.methods(5).fun = 'threshchan';
S.methods(5).settings.threshold = ampthresh;
S.methods(5).settings.excwin = 1000;
D = spm_eeg_artefact(S);

D=wjn_remove_bad_trials(D.fullfile);
D=wjn_remove_bad_channels(D.fullfile);