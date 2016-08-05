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
% Gerick Lee 2016-07-06
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ornResp = ornDynamicSim(ornCount, N, fs, odor)
%%
% n = 1 : N; % samples

for j = 1 : ornCount;
    kBase = randi([10 90], 1);
    kRatio = 0.19 + randi(30, 1) / 100;
    kOn = kBase / fs; % convert to units of samples (larger = faster)
    kOff = kOn * kRatio; % convert to units of samples (larger = faster)
    % steadState = max(odor) / (max(odor) + kOff / kOn);
    
    rEuler = zeros(N, 1);
    rEuler(1) = odor(1) / (odor(1) + kOff / kOn);
    
    for k = 2 : N
        rStep = kOn * odor(k) - (kOn * odor(k) + kOff) * rEuler(k - 1);
        rEuler(k) = rEuler(k - 1) + rStep;
    end
    %     plotyy(n, rEuler, n, odor)
    
    ornResp(:, j) = rEuler;
end


