%% orn dynamic model simulator
% Generates linear filters (in the Fourier domain).
%
% Inputs:
%        ornCount: how many orn responses are desired
%
%        N: length of the signal to be filtered (in samples)
%
%        fs: sampling rate (in Hz)
%
%        odor: odor stimulus as a vector
%
% Output:
%        ornResp: orn responses (as column vector or matrix)
%
% Gerick Lee 2016-07-06
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ornResp = ornDynamicSimWithInactivation(ornCount, N, fs, odor)
%%
% n = 1 : N; % samples

for j = 1 : ornCount;
%     kBase = randi([10 90], 1);
    kBase = randi([5 90], 1);
    if j == 2;
        kBase = 5; % force the smallest value - added 2016-08-19
    end
    kRatio = 0.19 + randi(30, 1) / 100;
    kOn = kBase / fs; % convert to units of samples (larger = faster)
    kOff = kOn * kRatio; % convert to units of samples (larger = faster)
    % steadState = max(odor) / (max(odor) + kOff / kOn);
    %     kOn = 0.1; kOff = 0.1;
    kRe = 0.01;
    kDe = 0.2;
    
    rStar = zeros(N, 1);
    rStar(1) = odor(1) / (odor(1) + kOff / kOn);
    rI = zeros(N, 1);
    rI(1) = 0;
    
    for k = 2 : N
        %         rStarStep = kOn * odor(k) + ((kRe - kOn * odor(k)) * rI(k - 1)) - (kOn * odor(k) + kOff + kDe) * rStar(k - 1); % rI to rStar
        
        rStarStep = 0.0 + kOn * odor(k) - ((kOn * odor(k) + kOff + kDe) * rStar(k - 1)) - (kOn * odor(k) * rI(k - 1)); % rI to R
        rIstep = kDe * rStar(k - 1) - kRe * rI(k - 1);
        
        rStar(k) = rStar(k - 1) + rStarStep;
        rI(k) = rI(k - 1) + rIstep;
        
        if rStar(k) < 0
            rStar(k) = 0;
        elseif rStar(k) > 1
            rStar(k) = 1;
        end
        if rI(k) < 0
            rI(k) = 0;
        elseif rI(k) > 1
            rI(k) = 1;
        end
    end
    %     plotyy(n, rEuler, n, odor)
    
    ornResp(:, j) = rStar;
end

% figure(1), clf, hold on
% plotyy(1 : N, rStar, 1 : N, odor)
% plot(1 : N, rStar, 'Color', [0 0.6 0.2], 'LineWidth', 3)
% % plot(1 : N, rI, 'Color', [0 0.2 0.8], 'LineWidth', 2)
% axis([0 N 0 1])
