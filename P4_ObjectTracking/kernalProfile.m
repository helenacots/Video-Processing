
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          x A vector of values to kernal profile (x>=0 for all values). It
%            is assumed x has been squared before sending it to this
%            function.
%
% OUTPUTS:
%          k A vector of corresponding kernal weights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [k] = kernalProfile(x)

if (numel(find(x < 0)) > 0)
    disp('Warning input to kernalProfile must be non negative!');
    pause
end

k = zeros(size(x));
k(find(x<=1)) = 3/4 .* (1 - x(find(x<=1)));