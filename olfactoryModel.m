%% olfactory model base
% Gerick Lee 2016-07-12 (GIT TEST TEXT-DISREGARD)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
%% Generate odor

tLength = 1200; % seconds
fs = 1000; % sampling rate (samples per second)
N = tLength * fs; % samples
n = [1 : N].'; % samples
baseline = 10;
ornCount = 4;
% lnCount = 50; % unused - using stimLeng as the number 

stimLeng = 1.0 * fs; % sec * fs
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
ornResp = ornDynamicSimWithInactivation(4, N, fs, odor) * 1000 + baseline;
%% LN
% lnBasis = lnDeltaFcn(stimLeng + 50, N, fs, odor);
lnBasis = lnGaussFcn(200, N, fs, odor);
lnResp = lnBasisProjection(lnBasis, ornResp, N, fs, odor);
%% PN

pnResp = pnSim(ornResp, lnResp, N, fs, odor);

%% 
% figure(2), clf, hold on
% cMap = viridis(size(lnBasis, 2) * 2);
% cMap = viridis(25);
% % vec = 1 : 2 : 200;
% for j = 1 : 1 : 20%size(lnBasis, 2)%size(vec, 2)
% %    plot(n, lnResp(:, vec(j)), 'color', cMap(j, :)) 
%    plot(n, lnBasis(:, j), 'o', 'color', cMap(j, :), 'MarkerFaceColor', cMap(j, :)) 
% % axis([50800 52200 0 150]), axis square
% % axis([50800 52400 -0.21 1.01]), axis square
% axis([50990 51015 -0.21 1.01]), axis square
% end
%   plot(n, odor * 0.1 - 0.2, 'k')
%    plot(n, lnBasis(:, 1), 'o', 'color', cMap(1, :), 'MarkerFaceColor', cMap(1, :)) 




