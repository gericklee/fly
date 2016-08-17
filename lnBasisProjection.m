%% LN basis projection - convert LN delta spikes to a firing rate based on ORN input
%
%
% Gerick Lee - 2016-08-10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lnResp = lnBasisProjection(lnBasis, ornResp, N, fs, odor);
%%
lnCount = size(lnBasis, 2);
lnResp = zeros(size(lnBasis));
for j = 1 : lnCount
    useTime = find(lnBasis(:, j) == 1);
    for k = 1 : length(useTime)
        lnResp(useTime(k), j) = sum(lnBasis(useTime(k), j) * ornResp(useTime(k), :));
    end
end



return
%%

test = ornResp(:, 1);
t2 = test.' * lnBasis(:, 1);
%%
test = lnBasis(:, 1);
t2 = ornResp(1600, 1);

ornResp.' * test;