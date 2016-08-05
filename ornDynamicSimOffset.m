%% orn linear filter generator
% Generates linear filters (in the Fourier domain).
%
% Inputs:
%        ornCount: how many orn responses are desired
%
%        N: length of the signal to be filtered (in samples)
%
%        fs: sampling rate (in Hz)
%
% Output:
%        fFilt: matrix (complex double; numFilts x N) containing the
%        filters.
%
% Gerick Lee 2016-07-11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ornResp = ornDynamicSimOffset(ornCount, N, fs, odor)
%%
% n = 1 : N; % samples
baseLine = 0.8;
for j = 1 : ornCount;
    kBase = randi([10 90], 1);
    kRatio = 0.19 + randi(30, 1) / 100;
    kOn = kBase / fs; % convert to units of samples (larger = faster)
    kOff = kOn * kRatio; % convert to units of samples (larger = faster)
    % steadState = max(odor) / (max(odor) + kOff / kOn);
    
    rEuler = zeros(N, 1);
    rEuler(1) = odor(1) / (odor(1) + kOff / kOn);
    
    for k = 2 : N
        rStep = baseLine - kOn * odor(k) + (kOn * odor(k) + kOff) * rEuler(k - 1);
        rEuler(k) = rEuler(k - 1) + rStep;
        rEuler(rEuler < 0) = 0;
        rEuler(rEuler > 1) = 1;
    end
    %     plotyy(n, rEuler, n, odor)
    
    ornResp(:, j) = rEuler;
end
figure(1), clf
% plotyy(1 : N, ornResp, n, odor)
plot(1 : N, ornResp)
