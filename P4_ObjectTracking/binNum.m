
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          m {1x1} bin number
%          grayLevels {nx1} vector of gray scale value between 0 and 255
%
% OUTPUTS:
%          b {nx1} bin number between 0 and m-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [b] = binNum(grayLevels, m)

grayLevels = double(grayLevels);
b = round(grayLevels / 255 * (m-1));