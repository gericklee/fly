%% ornGenerator - makes ORN filters
function ornFilt = ornGenerator(N, fs, pLobeWidth, nLobeWidth, pLobeMag, nLobeMag, lobeTimeLag, lobeTimeDiff);

posLobe = mkGauss(N, fwhm(pLobeWidth, N, fs), 0).'; % time domain filter
negLobe = mkGauss(N, fwhm(nLobeWidth, N, fs), 0).';

filt = pLobeMag * posLobe - nLobeMag * circshift(negLobe, lobeTimeDiff);
% filt = filt ./ max(abs(filt(:))); % normalize to max of 1.
filt = circshift(filt, lobeTimeLag);
ornFilt = (fft(filt)); 

% testVec = rand(N, 1);
% fVec = fft(odor);
% powVec = abs(fVec);
% phiVec = angle(fVec);
% 
% filtVec = (fFilt) .* powVec;
% ornFilt = ifftshift(ifft(filtVec .* exp(phiVec .* 1i), 'symmetric')); % reconstruct signal
