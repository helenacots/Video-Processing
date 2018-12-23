
clearvars  ;
clc

% Video parameters
video_name = 'hall_qcif.yuv';

startFrame = 40;
nFrames = 50;%250;

% Mean-Shift Parameters
% Width and height of the ellispe (target model shape)
h = [25 7];%[60 20];
% Target    position (center of the ellipse)
y = [71 61];
% Number of bins in the spatially-weighted histograms
m = 5;


displayImages = true;


%************************************************************************
% Read a video in YUV format
[video,imgRGB] = readYUV(video_name, nFrames, 'QCIF_PAL');
%we start at frame startFrame
video=video(startFrame:end);
imgRGB=imgRGB(:,:,:,startFrame:end);


% display the image used to derive the model. Note the image is displayed
% using the specified number of bins.
%I = video(1).cdata;
%R=I(:,:,1);
%G=I(:,:,2);
%B=I(:,:,3)

%I_bined = uint8(reshape(binNum(reshape(I,1,[]),m),size(I,1),[]));
%figure; 
%imshow(I_bined,[]); 
%hold on;

I = video(1).cdata;
[RowCol, loc] = getPointsInEllipseBorder(y, h, size(I));
imshow(I);
hold on;
plot(RowCol(:,2),RowCol(:,1),'-','LineWidth',2); 
plot(y(2),y(1),'.','MarkerSize',5);
hold off
%title('Binned image used to obtain model q.');



% Start tracking!! *******************************************************
% Update frame number
currFrameNum = 1;

% Load next frame
I = video(currFrameNum).cdata;

% Get model (spatially-weighted) pdf
[q] = getModel(I, y, h, m);
    % we take the model from the first frame where the object to track is


ModelLocs(1,:) = y;
index = 2;
y1 = y;
currFrameNum = currFrameNum + 1;
i=1;
while (currFrameNum < nFrames-startFrame)
    
    % load next frame by calling getImage function handle    
    F_I = video(currFrameNum).cdata;
    currFrameNum = currFrameNum + 1;
    
    % get size of frame F_I 
    ImgSize = size(F_I);
    
    % find the location of model in current frame using mean shift
    [y1] = meanShift(y1, h, q, F_I, m);
    track(i,:)=y1;
    %[q] = getModel(F_I, y1, h, m);
   
    % save location
    ModelLocs(index,:) = y1;
    index = index + 1;
    
    
    [RowCol, loc] = getPointsInEllipseBorder(y1, h, size(F_I));
    imshow(F_I);
    title(['Location [',num2str(y1),']'])
    hold on; 
    plot(RowCol(:,2),RowCol(:,1),'-','LineWidth',2); 
    plot(y1(2),y1(1),'rx','MarkerSize',30,'LineWidth',2);
    
    plot(track(:,2),track(:,1),'r-','LineWidth',2); 
    hold off;
    
    
    pause(0.05); 
    i=i+1;
end

