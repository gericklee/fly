%% PN Simulator
%
% Inputs:
%        inputs: matrix of inputs (both ORNs and LNs)
%
%        N: length of the signal to be filtered (in samples)
%
%        fs: sampling rate (in Hz)
%
%
% Output:
%        pnResp: orn responses (as column vector or matrix)
% 
%        weights: vector of final weights per neuron
%
% Gerick Lee 2016-07-15 (was on vacation 20th thru 03-Aug)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pnResp, weights] = pnSim(ornResp, lnResp, N, fs, ornCount, odor)
%%
n = 1 : N;
pnCount = 1;
backTime = 5; % 5
ornResp = ornResp * diag(power(max(ornResp(:)), -1)); % normalize to 1.
% ornResp = 0.5 * ornResp;
weights = -0.3 * ones(size(lnResp, 2), 1);

% % % lnCount = size(inputs, 2) - ornCount; %%% = not used anymore.
% % % eiVec = -ones(ornCount + lnCount, 1);
% % % eiVec(1 : ornCount) = -eiVec(1 : ornCount);
% % % weights = 0.1 * ones(size(inputs, 2), 1);
% % % weights(ornCount + 1 : end) = weights(ornCount + 1 : end) / .3; % initialize weights.

pnResp = zeros(N, pnCount);
baseline = 5;
pnResp(1, :) = baseline;
% tauR = 1;
% tauW = 1000;
learnRate = 0.1;
%%
wStore = zeros(size(lnResp, 2), N);
wStore(:, 1) = weights;


for j = 1 : pnCount
    for k = 2 : N
        
        pnStep = sum(1 * ornResp(k - 1, :)) + lnResp(k - 1, :) * weights; 
        if k > backTime
            weightStep = learnRate * (lnResp(k - 1, :) * sum(ornResp(k - 1, :) - mean(ornResp(k - backTime : k - 1, :)      )));
%             weightStep = learnRate * (lnResp(k - 1, :) * sum(ornResp(k - 1, :) - mean(ornResp(1, :)      )));
        else
            weightStep = learnRate * (lnResp(k - 1, :) * sum(ornResp(k - 1, :) - mean(ornResp(k - 1, :)      )));
        end
%         weightStep = learnRate * (lnResp(k - 1, :) * (ornResp(k - 1, j) - mean(ornResp(k - 1, :))));
        

                %         pnStep = -pnResp(k - 1, j) / tauR + inputs(k - 1, :) * weights / tauR;
        
%         weightStep = ((pnResp(k - 1, j) - baseline) / tauW) * (inputs(k - 1, :) * power(tauW, -1));
%         wsStore(k, :) = weightStep;
        
        
        pnResp(k, j) = pnResp(k - 1, j) + pnStep;
        weights = weights - weightStep.';
        if pnResp(k, j) < 0
            pnResp(k, j) = 0;
        elseif pnResp(k, j) > 100;
%             pnResp(k, j) = 100;
        end
        
        
        
        weights(weights > 0) = 0;
        weights(weights < -1) = -1; % consider removing this?
        wStore(:, k) = weights;

    end
end
figure(1), clf, %subplot(1, 2, 1)
plot(n, odor * 100, 'k'), hold on
plot(n, pnResp, 'Color', [0 0.6 0.2]), axis square
xlabel('time (ms)')
ylabel('Firing rate (sp/s)')
legend('PN response', 'Odor strength')
weights
% subplot(1, 2, 2)
% plot(1 : 10000, pnResp(1 : 10000), 'Color', [0 0.6 0.2]), hold on
% plot(1 : 10000, odor(1 : 10000) * 100, 'k'), axis([0 10000 0 500]), axis square
% xlabel('time (ms)')


% plotyy(1 : N, odor, 1 : N, pnResp)
% axis([0 10000 0 1000])

% figure(1), clf
% plotyy(1 : 10000, odor(1 : 10000), 1 : 10000, pnResp(1 : 10000))
% axis([0 10000 0 1])





