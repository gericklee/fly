%% LN Simulator
%
% Inputs:
%        lnCount: how many ln responses are desired
%
%        N: length of the signal to be filtered (in samples)
%
%        fs: sampling rate (in Hz)
%
%        orn: orn input as a vector
%
% Output:
%        lnResp: orn responses (as column vector or matrix)
%
% Gerick Lee 2016-07-12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lnResp = lnDelayLineSim(lnCount, N, fs, orn)

if size(orn, 2) > 1
    orn = orn(:, 1);
end
fOrn = fft(orn);
ampOrn = abs(fOrn);
phiOrn = angle(fOrn);
baseline = 0; % from Nagel et al., 2015
%%
% test = orn(:, 1);
for j = 1 : lnCount
    lnFilt = circshift(mkGauss(length(orn), fwhm(4, N, fs), 0), [0 -20]);
    lnFilt = lnFilt - circshift(lnFilt, [0 40]);
    lnFilt = circshift(lnFilt, [0 randi([60 160], 1)]);
    
    fFilt = fft(lnFilt).';
    fAmp = fFilt .* ampOrn;
    
    lnResp(j, :) = ifftshift(ifft(fAmp .* exp(phiOrn .* 1i), 'symmetric')) + baseline;
    lnResp(j, lnResp(j, :) < 0) = 0;
    
    
%     lnResp = conv(orn, lnFilt, 'same');
%     lnResp(lnResp < 0) = 0;
    figure(1)
    clf
    plot(1 : N, lnResp(j, :))
end
lnResp = lnResp.';


figure(1), clf,subplot(2, 1, 1), hold on
plot(1 : N, orn)
plot(1 : N, lnResp);
subplot(2, 1, 2)
plot(1 : N, lnFilt)
% lnResp = 1;







