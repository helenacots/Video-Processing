
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          I the image in grayscale uint8 format
%          y {1x2}[row col] location of ellipse center
%          h {1x2}[rowScale colScale] the scale of ellipse centered at y
%          m {1x1} number of bins to use in histogram
%
% OUTPUTS:
%          q {1xm} the normalized histogram (pdf)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [q] = getModel(I, y, h, m)

% get size of model image
ImgSize = size(I);
% get pixel locations inside model ellipse
[q_RowCol, q_loc] = getPointsInEllipse(y, h, ImgSize);
% get histogram q of model
%Transfor into a gray-scale images (gray scale histogram)
I_bw = mean(I,3);

[q, binNums] = probProfile(h, y, q_RowCol, I_bw(q_loc), m);