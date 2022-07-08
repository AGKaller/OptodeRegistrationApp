%% start optode registration app

warning("off",'MATLAB:ui:Slider:fixedHeight');
hmFile = fullfile(fileparts(mfilename('fullpath')),'99_testMdl','tesModel_hsRegistered.mat'); % '';%
optRegApp = OptodeReg(hmFile);