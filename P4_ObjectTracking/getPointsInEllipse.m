
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          h {1x2}[hrow hcol] the scale of ellipse in the row and col 
%                             direction
%          ImgSize {1x2}[rowsize colsize] the size of image frame
%          y {1x2}[row col] matrix containing the location of ellipse center
%
% OUTPUTS:
%          RowCol {nx2}[row col] matrix containing the loc of all points 
%                   in ellipse
%          loc {nx1} vector conatining the lexographical index of all 
%                   points in ellipse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [RowCol, loc] = getPointsInEllipse(y, h, ImgSize)

% get the meshgrid (all x,y locations) for a rectangle fitting an ellipse
% with major and minor axis of lenght h along x and y axis.

[C R] = meshgrid(-(h(2)-1):(h(2)-1), -(h(1)-1):(h(1)-1));
C = reshape(C,1,[]);
R = reshape(R,1,[]);

% Calculate the ellipse formula for all points in box

ONE = (R).^2/(h(1))^2 + (C).^2/(h(2))^2;

% Only points with ellipse formula lessthan or equal to 1 are inside
% ellipse
RowCol2(:,1) = R(find(ONE<=1))+y(1);
RowCol2(:,2) = C(find(ONE<=1))+y(2);

% eliminate all points outside image size
index = 1;
for i = 1:size(RowCol2,1)
    if (RowCol2(i,2) > 0 & RowCol2(i,2) <= ImgSize(2) & RowCol2(i,1) > 0 & RowCol2(i,1) <= ImgSize(1))
        RowCol(index,:) = RowCol2(i,:);
        index = index + 1;
    end
end

% convert image coorinates to lexographically ordered index
loc = RowCol(:,1) + (RowCol(:,2)-1)*ImgSize(1);