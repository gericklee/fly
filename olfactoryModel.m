%% olfactory model base
% Gerick Lee 2016-07-12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
%% Generate odor

tLength = 8; % seconds
fs = 1000; % sampling rate (samples per second)
N = tLength * fs; % samples
n = [1 : N].'; % samples
baseline = 10;

stimLeng = 0.5 * fs; % sec * fs
stimInt = 0.5; %intensity (arbitrary units)
numTrial = 6;
fBin = (n - (N / 2)) * (fs / N); % set center to zero, fs/N is freq res. (nyquist is fs/(2N))

odor = zeros(N, 1);
for j = 2 : 2 : floor(stimLeng \ N); % try with 1.2 instead of 3!
    odor(stimLeng * (j - 1) + 1 : j * stimLeng, 1) = stimInt;
end

%% Generate Orn responses

ornResp = ornDynamicSimWithInactivation(100, N, fs, odor);
ornResp = ornResp * 1000 + baseline; % convert to realistic firing rate

%% LN


