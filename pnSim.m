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
function [pnResp, weights] = pnSim(ornResp, lnResp, N, fs, odor)
%%
% ornResp = ornResp .* repmat(power(max(ornResp()), -1), N, 1) .* 1; % normalize to 1
% lnResp = lnResp .* repmat(power(max(lnResp()), -1), N, 1) .* 0.85; % normalize to 1

pnCount = size(ornResp, 2);
n = 1 : N;
weights = -0.3 * ones(size(lnResp, 2), pnCount);
learnRate = 0.1;
% wStore = zeros(size(lnResp, 2), N);
% wStore(:, 1) = weights;
backTime = 500;

eiScale = 0.0000051;

for j = backTime + 1 : N;
    for k = 1 : pnCount
        
        pnResp(j, k) = ornResp(j - 1, k) + eiScale * lnResp(j - 1, :) * weights(:, k);
               
weightStep = learnRate * (lnResp(j, :) * sum(ornResp(j, k) - mean(ornResp(j - backTime : j - 1, k))      )); % time-average of last [backTime] points.

% temp = ornResp(j - backTime : j - 1, k);
% timeWeight = [1 : backTime] / sum([1 : backTime]);
% 
% weightStep = learnRate * (lnResp(j, :) * (ornResp(j, k) - timeWeight * temp)); % weight in time - more recent weighted more heavily.  Smooths PN curve.



%         weightStep = learnRate * (lnResp(j, :) * sum(ornResp(j, k) - ornResp(1, k)    )); % use first ORN time point (baseline) as metric

        weights(:, k) = weights(:, k) - weightStep.';

        if pnResp(j, k) < 0
            pnResp(j, k) = 0;
        elseif pnResp(j, k) > 100;
%             pnResp(j, k) = 100;
        end
        
        
        weights(weights > 0) = 0;
%         weights(weights < -1) = -1; % consider removing this?
%         wStore(:, j) = weights;

    end
end
%
figure(1), clf, %subplot(1, 2, 1)
for j = 1 : pnCount
    subplot(2, 2, j), hold on%
    plot(n, ornResp(:, j), 'Color', [0 0.2 0.8], 'LineWidth', 2); hold on
    plot(n, pnResp(:, j), 'Color', [0 0.8 0.2]);
    plot(n, odor * 0.1, 'k')
%     legend('ORN', 'PN', 'odor', 'Location', 'NorthEast')
% axis([52470 54040 0 1]), axis square
axis([50470 52040 0 150]), axis square
% axis([4470 6040 0 1]), axis square
end


























return
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





