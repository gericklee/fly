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
backTime = 200;

eiScale = 0.0000001; % if using mean of all ORNs for weightStep
% eiScale = 0.0000005; % if using only the same ORN
% eiScale = 1;

pnResp = zeros(size(ornResp));
for j = backTime + 1 : N;
    for k = 1 : pnCount
        
        pnResp(j, k) = ornResp(j - 1, k) + eiScale * lnResp(j - 1, :) * weights(:, k);
%         pnResp(j, k) = mean(ornResp(j - 20 : j - 1, k)) + eiScale * lnResp(j - 1, :) * weights(:, k); % sliding mean - weakens onset transient  

weightStep = learnRate * (lnResp(j, :) * sum(ornResp(j, k) - mean(ornResp(j - backTime : j - 1, :))      )); % time-average of last [backTime] points.

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
figure(1), clf, subplot(1, 2, 1)
for j = 1 : 2% pnCount
%     subplot(1, 2, j)
    subplot(2, 2, j + 2), hold on%
    plot(n, ornResp(:, j), 'Color', [0 0.2 0.8], 'LineWidth', 2); hold on
    plot(n, pnResp(:, j), 'Color', [0 0.8 0.2]);
    plot(n, odor * 10, 'k')
%     legend('ORN', 'PN', 'odor', 'Location', 'NorthEast')
% axis([52470 54040 0 1]), axis square
axis([90800 92200 0 150]), axis square
% axis([900 6200 0 150]), axis square
end


% figure(2), clf, subplot(1, 2, 1)
for j = 1 : 2% pnCount
%     subplot(1, 2, j)
    subplot(2, 2, j), hold on%
    plot(n, ornResp(:, j), 'Color', [0 0.2 0.8], 'LineWidth', 5); hold on
    plot(n, pnResp(:, j), 'Color', [0 0.8 0.2]);
    plot(n, odor * 10, 'k')
%     legend('ORN', 'PN', 'odor', 'Location', 'NorthEast')
% axis([52470 54040 0 1]), axis square
axis([2900 4100 0 150]), axis square
axis([50800 52200 0 150]), axis square
% axis([900 6200 0 150]), axis square
end

%%
cMap = viridis(200);
w = weights;
w(weights == 0) = NaN;
figure(2), clf
for j = 1 : 2
subplot(1, 2, j), 
plotyy(50800 : 52200, ornResp(50800 : 52200, j), 51010 : 6 : 52204, (-w(:, j))), hold on
plot(50800 : 52200, 10 * odor(50800 : 52200), 'k')
plot(50800 : 52200, pnResp(50800 : 52200, j), 'Color', [0 0.8 0.2])
% plotyy([NaN], [NaN], [50800 52200], [0.3 0.3])

rax = findall(0, 'YAxisLocation','right');
lax = findall(0, 'YAxisLocation','left');
set(rax, 'YLim', [1e-3 1e6])
set(lax, 'YLim', [0 140])
set(rax,'Yscale','log','box','off');
set(rax, 'YTick', [0 1e-2 1 100 10000 1000000 100000000])
% set(rax, 'YTick', [1e-3 1 1e3 1e6 ])
set(rax, 'YColor', cMap(30, :))
set(lax, 'YColor', [0 0 0])
set(lax, 'YTick', [0 140])

end









%%

