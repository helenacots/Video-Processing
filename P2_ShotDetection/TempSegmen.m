function [Accuracy, Precision, Recall, F1score] = TempSegmen(videoName, feature, similarityMeasure, thr)

%Clean the memory


if (videoName == 'PV1.mp4') 
    Fshots = [24, 52, 77, 104, 130, 165, 212, 239, 261];
elseif (videoName == 'PV2.mp4') 
    Fshots = [8, 17, 35, 66, 115, 143, 156, 169, 183];
end
    

%Object will read the video
videoObj = VideoReader(videoName);


nFrames   = videoObj.NumberOfFrames;   % Number of frames of video
vidHeight = videoObj.Height;           %height of the frame            
vidWidth  = videoObj.Width;            %weight of the frame       
        
fig_number=1;

%Initialize vector where wesave the number of the frame where a shot
%transition in detected
ShotsDetected = [];

%Show the video
%for k = 1 : nFrames-1	
    %frame    = read(videoObj,k);
    %imagesc(frame);
    %pause(0.05)
%end


% Segmentation3
for k = 1 : nFrames-1
    %First frame	
    frameA    = read(videoObj,k);
    %We transform into black and white picture.	The transform is done computing the mean value of the RGB three channel
    %frameA_bw = mean(frameA,3);
    I_ycbcr = rgb2ycbcr(frameA);
    frameA_bw = I_ycbcr(:,:,1); % we keep only the luminance component
    %Same for the second frame
    frameB    = read(videoObj, k+1);
    I_ycbcr = rgb2ycbcr(frameB);
    frameB_bw = I_ycbcr(:,:,1);
      
    %%%%%%%%%%%%
    
    % TODO 2: Compute the Feature
    switch feature
        case 'luminance histogram'
            [hist_fA, countA ] = imhist(frameA_bw);
            [hist_fB, countB] = imhist(frameB_bw);
        case 'colour histogram'
            [hist_fA, countA] = imhist(frameA);
            [hist_fB, countB] = imhist(frameB);
    end
    %%% END TODO 2;
    
    %%%%%%%%%%%
    % TODO 3: Compute the distance (similitary measure) between the frames
    switch similarityMeasure
        case 'Bhattacharyya'
            %thr = 0.05;
            %we can compute the Bhattacharyya coefficient (bc) between the 
            %two distributions (histograms) so we must normalize the histograms
            hA=hist_fA/sum(hist_fA);
            hB=hist_fB/sum(hist_fB);

            func = sqrt(hA(:).*hB(:));
            BC = sum(func);
            db(k) = -log(BC);
             
        case 'MAD'
            %thr = 436000;
            func = abs(hist_fA(:)-hist_fB(:));
            MAD = sum(func);
            db(k) = MAD;
        
        case 'MSE'
            %thr = 80000000;
            MSE = immse(hist_fA, hist_fB);
            db(k) = MSE;
            
        %End TODO 3
        %%%%%%%%%%%%%
            
    end


     if db(k)>thr 
       msg=sprintf('Shot detected between frames %d and %d\n', k, k+1);
       disp(msg)

        %plot the frames where a shot is detected 
        figure(fig_number)   
        subplot(1,2,1)
        imshow(frameA)
        title(['frame ' num2str(k) ]);
        subplot(1,2,2)
        imshow(frameB)
        title(['frame ' num2str(k+1) ]);
 
        fig_number=fig_number+1;
        ShotsDetected = [ShotsDetected k];
      end
    
    
end  
    %%%%%%%%%%%%%%%%%% EVALUATION %%%%%%%%%%%%%%%%%%

    
%RECALL = TP/(TP+FN) --> Proportion of correct entities detected

%Compute TP (Shot transitions correctly detected)
%we compare ShotsDetected with Fshots, if they are the same the detection
%is perfectly done
TP = 0;
for i = 1 : length(Fshots)
    for j = 1 : length(ShotsDetected)
        if(Fshots(i)==ShotsDetected(j))
        TP = TP+1;
        end
    end
end 

%Compute FN (Number of missed shot transitions)
FN = 0;
for i = 1 : length(Fshots)
    if(Fshots(i)~=ShotsDetected(:))
    FN = FN+1;
    end
end 

Recall = TP/(TP+FN);


%PRECISION = TP/(TP+FP) --> Proportion of detected entities that are correct

%Compute FP (Number of detected transitions that do not correspond to real transitions))
FP = 0;
for i = 1 : length(ShotsDetected)
    if(ShotsDetected(i)~=Fshots(:))
    FP = FP+1;
    end
end 

Precision = TP/(TP+FP);


%ACCURACY = (TP+TN)/(TP+FP+TN+FN)

%compute TN (Number of non-transitions that are NOT detected as transitions)
TN = nFrames-1-length(Fshots)-FP;

Accuracy = (TP+TN)/(TP+FP+TN+FN);


%F1SCORE 
F1score = (2*Recall*Precision)/(Recall+Precision);

% figure(fig_number+1);
% plot(db)
% hold on 
% plot(ones(size(db))*thr)
% title('Similarity measures');