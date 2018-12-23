
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          h {1x2}[hrow hcol] the scale of ellipse in the row and col 
%                             direction
%          y {1x2}[row col] matrix containing the location of ellipse center
%          locXi {nx2}[row col] matrix containing the location of all 
%                               pixels inside ellipse
%          pixelValues 1-D vector of all pixel values in ellipse
%          m {1x1} the number of bins
%
% OUTPUTS:
%          P {1xm} the normalized pdf
%          binNums the bin number to which the pixel at coordinate locXi 
%                  belongs to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [P, binNums] = probProfile(h, y, locXi, pixelValues, m)

% find the distance from ellipse center, need to obtain weight
scaledDistSquared = ((y(1) - locXi(:,1))/(h(1))).^2 + ((y(2) - locXi(:,2))/(h(2))).^2;

% find the wieight of pixels in ellipse
kLocXi = kernalProfile(scaledDistSquared);

% calculate the normalization factor (NOTE this can be precalculated)
Ch = 1/sum(kLocXi);

% find the bin number of all pixels inside ellipse
binNums = binNum(pixelValues,m);

% for each bin number find the probability
for i = 0:m-1
    P(i+1) = Ch*sum(kLocXi(binNums==i));
end