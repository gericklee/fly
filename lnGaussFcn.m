% LN Delta Function - ONLY WORKS FOR BINARY STIMULI (step fcn odors): _-_-_
% Gerick Lee 2016-08-17
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lnResp = lnGaussFcn(lnCount, N, fs, odor)
%% 

lnWidth = 0.125;
lnResp = zeros(N, lnCount) + 0;
oStart = find(odor - circshift(odor, -1) < 0);
% timeLag =  20; % samples delay at onset, and between delta fcns/LNs
% timeLag1 = 2;
% for j = 1 : lnCount
%     lnResp(oStart + timeLag * j, j) = 1;    
% end


oStart = oStart + 6 * round(fwhm(lnWidth, N, fs)); % was 4

for j = 1 : lnCount
    oStart = oStart +  2 * round(fwhm(lnWidth, N, fs));
    for k = 1 : length(oStart)
        lnGauss = fftshift(mkGauss(N, fwhm(lnWidth, N, fs), 0)).';
        lnResp(:, j) = lnResp(:, j) + circshift(lnGauss, [oStart(k), 0]);
        
    end
end
return
% 
% 
figure(1), clf, hold on
plot(1 : N, odor, 'k')
plot(1 : N, lnResp)
axis([4400 8900 0 1.3])

%%
plot(1 : N, lnResp(:, 1), 'b', 'LineWidth', 4)
plot(1 : N, lnResp(:, 2), 'g', 'LineWidth', 4)
% % plot(1 : N, sum(lnResp, 2), 'r')
% plot(1 : N, circshift(lnResp(:, 1), [30, 0]), 'r')
axis([4400 4600 0 1.3])
