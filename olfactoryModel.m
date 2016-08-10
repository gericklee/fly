%% olfactory model base
% Gerick Lee 2016-07-12 (GIT TEST TEXT-DISREGARD)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
%% Generate odor

tLength = 60; % seconds
fs = 1000; % sampling rate (samples per second)
N = tLength * fs; % samples
n = [1 : N].'; % samples
baseline = 10;
ornCount = 4;
% lnCount = 50; % unused - using stimLeng as the number 

stimLeng = 0.5 * fs; % sec * fs
stimInt = 0.5; %intensity (arbitrary units)
numTrial = 6;
fBin = (n - (N / 2)) * (fs / N); % set center to zero, fs/N is freq res. (nyquist is fs/(2N))

odor = zeros(N, 1);
for j = 4 : 4 : floor(stimLeng \ N) - 2; % try with 1.2 instead of 3!
    odor(stimLeng * (j - 1) + 1 : j * stimLeng, 1) = stimInt;
end
% odor(45000 : end) = 0;
%% Generate Orn responses
rng('default'); % ensure same curve each time (can test later on different seeds)
ornResp = ornDynamicSimWithInactivation(4, N, fs, odor);
%% LN
lnResp = lnDeltaFcn(stimLeng, N, fs, odor);

%% PN

pnResp = pnSim(ornResp, lnResp, N, fs, ornCount, odor);



















