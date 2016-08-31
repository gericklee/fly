% LN Delta Function - ONLY WORKS FOR BINARY STIMULI (step fcn odors): _-_-_
% Gerick Lee 2016-08-17
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lnResp = lnGaussFcn(lnCount, N, fs, odor)
%% 
lnWidth = 0.125;
lnWidth = N / 480000;
% lnWidth = power(480000 / N, 1);
lnResp = zeros(N, lnCount) + 0;
oStart = find(odor - circshift(odor, -1) < 0);
oStart = oStart + 1 * 3; % was 4, more recently 6

% mkGauss(1000, 3.185, 1).'; % this is the thing to work with to fix the gaussians!
for j = 1 : lnCount
    oStart = oStart +  2 * 3;% round(fwhm(lnWidth, N, fs));
    for k = 1 : length(oStart)
        lnGauss = fftshift(mkGauss(N, 3, 0)).';
        lnResp(:, j) = lnResp(:, j) + circshift(lnGauss, [oStart(k), 0]);
        
    end
end
return
% %%
% for j = 1 : lnCount
%     oStart = oStart +  2 * round(fwhm(lnWidth, N, fs));
%     for k = 1 : length(oStart)
%         lnGauss = fftshift(mkGauss(N, fwhm(lnWidth, N, fs), 0)).';
%         lnResp(:, j) = lnResp(:, j) + circshift(lnGauss, [oStart(k), 0]);
%         
%     end
% end
% return
%%













%% 
figure(2), clf, hold on
plot(1 : N, odor, 'k')
plot(1 : N, lnResp)
axis([4400 8900 0 1.3])

%%
plot(1 : N, lnResp(:, 1), 'b', 'LineWidth', 4)
plot(1 : N, lnResp(:, 2), 'g', 'LineWidth', 4)
% % plot(1 : N, sum(lnResp, 2), 'r')
% plot(1 : N, circshift(lnResp(:, 1), [30, 0]), 'r')
axis([4400 4600 0 1.3])
