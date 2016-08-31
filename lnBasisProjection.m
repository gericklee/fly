%% LN basis projection - convert LN delta spikes to a firing rate based on ORN input
%
%
% Gerick Lee - 2016-08-10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lnResp = lnBasisProjection(lnBasis, ornResp, N, fs, odor);
%%
% lnCount = size(lnBasis, 2);
% lnResp = zeros(size(lnBasis));
% for j = 1 : lnCount
%     useTime = find(lnBasis(:, j) == 1);
%     for k = 1 : length(useTime)
%         lnResp(useTime(k), j) = sum(lnBasis(useTime(k), j) * ornResp(useTime(k), :));
%     end
% end

%%
lnCount = size(lnBasis, 2);
lnResp = zeros(size(lnBasis));

for k = 1 : size(lnBasis, 1)
    lnResp(k, :) = sum(lnBasis(k, :).' * ornResp(k, :), 2); % vectorized! From 344s to 10s :D
end



%%
return
%%
% figure(4), clf, hold on
% cMap = viridis(60);
% cMap([1 : 10], :) = [];
% for j = 1 : 20
%     plot(2950 : 3100, lnBasis(2950 : 3100, j), 'Color', cMap(j, :))
%     plot(2950 : 3100, odor(2950 : 3100), 'k')
% end
% axis square