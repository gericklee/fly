%% full width at half max - return the requisite standard deviation for gaussians
% Returns the standard deviation in samples for generating a gaussian with
% a full-width-at-half-max of the desired Hertz.
% Input:
%      fWidHz: FWHM in Hz
% 
%      sigLength: length of the signal in bins
% 
%      fs: sampling rate of the signal
% 
% Output:
%      filtSD: standard deviation for use in generating a gaussian
% 
% Gerick Lee 2016-06-16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function filtSD = fwhm(fWidHz, sigLength, fs);

if mod(sigLength, 2) == 0
    centerPt = 1 + sigLength / 2;
else 
    centerPt = (sigLength + 1) / 2;
end

fWidBins = fWidHz * (sigLength / fs);

filtSD = fWidBins ./ (2 * sqrt(2 * log(2)));

end
