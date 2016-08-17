% LN Delta Function - ONLY WORKS FOR BINARY STIMULI (step fcn odors): _-_-_
function lnResp = lnDeltaFcn(lnCount, N, fs, odor)
%% 

lnResp = zeros(N, lnCount) + 0;
oStart = find(odor - circshift(odor, -1) < 0);
timeLag =  1; % samples delay at onset, and between delta fcns/LNs
timeLag1 = 2;
for j = 1 : lnCount
    lnResp(oStart + timeLag * j, j) = 1;    
end
