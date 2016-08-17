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
for j = 1 : lnCount
%     useTime = find(lnBasis(:, j) == 1);
%     useTime = find(lnBasis(:, j) > 0.1);
    for k = 1 : size(lnBasis, 1)
        lnResp(k, j) = sum(lnBasis(k, j) * ornResp(k, :));
    end
end


%%
return
