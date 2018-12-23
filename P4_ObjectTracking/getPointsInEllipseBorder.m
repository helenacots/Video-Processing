
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          h {1x2}[hrow hcol] the scale of ellipse in the row and col 
%                             direction
%          ImgSize {1x2}[rowsize colsize] the size of image frame
%          y {1x2}[row col] matrix containing the location of ellipse
%          center
%
% OUTPUTS:
%          RowCol {nx2}[row col] matrix containing the location of all 
%                                points in ellipse
%          loc {nx1} vector conatining the lexographical index of all 
%                    points in ellipse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [RowCol, loc] = getPointsInEllipseBorder(y, h, ImgSize)

% find the row spread of the ellipse
%r = -floor((h(1)-1)/2):ceil((h(1)-1)/2);
r = -(h(1)-1):(h(1)-1);

% find 1/2 major and minor axis
%h = h/2;

% solve for the column coordinates
c = sqrt(h(2)^2*h(1)^2 - h(2)^2*(r).^2)/h(1);

% attach both the negative and positive sqrt together
RowCol(:,1) = [r'; seqreverse(r)'] + y(1);
RowCol(:,2) = [c'; -seqreverse(c)'] + y(2);

% repeat first point for circular plot
RowCol(end+1,:) = RowCol(1,:);

% find lexographical index given coordinates.
loc = round(RowCol(:,1)) + (round(RowCol(:,2))-1)*ImgSize(1);