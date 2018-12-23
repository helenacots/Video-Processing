% Description:  meanShift.m
%               This will perform the meanShift algorithm to determine the 
%               location of target in the current frame.
%
% References:
%     D. Comaniciu, V. Ramesh, P. Meer: Real-Time Tracking of Non-Rigid 
%     Objects using Mean Shift, IEEE Conf. Computer Vision and Pattern 
%     Recognition (CVPR'00), Hilton Head Island, South  Carolina, Vol. 2, 
%     142-149, 2000 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          y0 {1x2}[row col] initial guess of target location in frame F_I
%          hCurr {1x2}[rowScale colScale] the scale of the object
%          q  {1xm} the model histogram
%          F_I The frame image (gray scale uint8) in which to search for
%              the model 
%          m The number of bins in the histogram
%
% OUTPUTS:
%          y1 {1x2}[row col] the acutal location of the model as determined
%             by the mean shift algorithm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y1] = meanShift(y0, hCurr, q, F_I, m)

ImgSize = size(F_I);

% ****************************
% * do MeanShift Algorithm   *
% ****************************

continueWithMeanShift = true;
numItt = 0;
while (continueWithMeanShift == true & numItt < 20)

    % ****************************
    % * get p_y0                 *
    % ****************************

    % get pixel locations inside ellipse
    [y0_RowCol, y0_loc] = getPointsInEllipse(y0, hCurr, ImgSize);
    %y0_RowCol : locations of pixels inside the ellipse
       
    % get histogram p_y0 of model:
      % The search for the new target location in this current frame starts
      % at the location y0 of the target in the previous frame. 
    [p_y0, binNums] = probProfile(hCurr, y0, y0_RowCol, F_I(y0_loc), m);
    %binNums: at which bin number corresponds the pixel in the ellipse
        
    
    % ****************************
    % * get weights              *
    % ****************************

    % we derive the weigths according to this equation in order to give more
    % importance to the locations where values are more similar to the
    % target model. 
 for i = 1:numel(binNums)
       w(i,1) = sqrt(q(binNums(i)+1)/(p_y0(binNums(i)+1)));
 end
    sumw=sum(w);
  
    % ****************************
    % * get y1                   *
    % ****************************
    %Compute the  new location from the current location y0
    y1 = [sum(y0_RowCol(:,1).*w)/sumw, sum(y0_RowCol(:,2).*w) / sumw];
    
    % In case we want to compute the similarity function between targets:
%     [y1_RowCol, y1_loc] = getPointsInEllipse( hCurr,round(y1), ImgSize);
%     [p_y1, binNums] = probProfile(hCurr, round(y1), y1_RowCol, F_I(y1_loc), m);
    
      
    % ****************************
    % * check stoping condition  *
    % ****************************
    % along the paper, the step 5 is not necessary, which implies that
    % there is no need to evaluate the Bhattacharyya coefficient in Steps 1
    % and 4. 
    
%  Step 4 : Battacharyya coefficient
%      %similarity function for p_y0 and q
%      simy0 = sum(sqrt(p_y0.*q));
%      %similarity function for p_y1 and q
%      simy1 = sum(sqrt(p_y1.*q));
%  Step 5
%     while simy1 > simy0          
%         y1=(1/2).*(y0+y1);
%         [y1_RowCol, y1_loc] = getPointsInEllipse( hCurr,round(y1), ImgSize);
%         [p_y1, binNums] = probProfile(hCurr, round(y1), y1_RowCol, F_I(y1_loc), m);
%         simy1=sum(sqrt(p_y1.*q));           
%     end
    
%  Step 6 of the algorithm
    eps = 0.5;
    if abs(y1-y0) < eps
        continueWithMeanShift = false;
    else
        y0 = round(y1);
        %We return on computing again the weights until we find the best
        %location
        continueWithMeanShift = true;
    end
     

    numItt = numItt + 1;
end
y1 = round(y1);
