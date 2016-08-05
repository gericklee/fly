%% orn linear filter generator
% Generates linear filters (in the Fourier domain).
%
% Inputs:
%        numFilts: how many filters are desired
%
%        N: length of the signal to be filtered (in samples)
%
%        fs: sampling rate (in Hz)
%
% Output:
%        fFilt: matrix (complex double; numFilts x N) containing the
%        filters.
%
% Gerick Lee 2016-06-23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ornResp = ornFilter(numFilts, N, fs, odor)
%%
n = 0 : N - 1; % samples
baseline = 10;
fFilt = zeros(N, numFilts);
for j = 1 : numFilts
    gWid = randi([5 20], 1); % fwhm, Hz
%     gWid = randi([5 90], 1); % fwhm, Hz
    filtDelay = 240 + round(gWid * 2) + randi([-5 5], 1); % samples: delay between odor and filter.
    % base is 60 samples, plus a delay that correlates with width, plus jitter
    gFilt = circshift(mkGauss(N, fwhm(gWid, N, fs), 0), [0, filtDelay]); % make gaussian, shift
    slope = 2 / gWid; % line slope, fixed as a function of gWid.
    lineDelay = (0.5 + rand) * gWid; % delay between line and gaussian
    yInt = slope * (filtDelay + lineDelay + N / 2); % adjust line to be centered on gaussian + delay
    filtLine = slope * n - yInt;
    
    % if gWid
    if rand < 0.2
        filt = filtLine .* gFilt;
    else
        filt = -filtLine .* gFilt;
    end
    fFilt(:, j) = fft(filt);
end


fOdor = fft(odor);
powOdor = abs(fOdor);
phiOdor = angle(fOdor);

for j = 1 : numFilts
    powFilt = fFilt(:, j) .* powOdor;
    ornResp(j, :) = ifftshift(ifft(powFilt .* exp(phiOdor .* 1i), 'symmetric')) + baseline;
    ornResp(j, ornResp(j, :) < 0) = 0;
end
return