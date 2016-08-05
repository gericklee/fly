%% mkGauss - make a One-dimensional gaussian
% Makes a one-dimensional gaussian filter with parameters a, b, and c.  
% Input:
%       xSize - double: desired filter size.
%       
%       sd - double: width of the filter in samples
% 
%       pad - logical: if 1, pad to the next power of two.
% 
% 
% Output:
%        gOut: gaussian filter
% 
% Gerick Lee 2016-06-16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function gOut = mkGauss(xSize, sd, pad);
%%
if ~exist('pad', 'var') || isempty(pad); pad = 1; end; % default to pad
if pad == 1; xSize = power(2, ceil(log2(xSize))); end; % filter as power of 2  end
if mod(xSize, 2) == 0
    centerPt = 1 + xSize / 2;
else 
    centerPt = (xSize + 1) / 2;
end

x = 1 : xSize; % x in bins.  To convert to freq, multiply by N / fs

xD = power(x - centerPt, 2);
gOut = exp(-xD ./ (2 * power(sd, 2)));
%%
end