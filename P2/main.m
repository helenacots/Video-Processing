
%Videos 
videoName = 'PV1.mp4'; %or 'PV1.mp4'

%Features that could be extracted:
feature = 'colour histogram'; % or 'colour histogram' 

%Similarity measures that can be used:
similarityMeasure = 'MSE'; % or 'MAD' or 'Bhattacharyya'


%[accuracy, precision, recall, F1score] = TempSegmen(videoName, feature, similarityMeasure);

A=[];
P=[];
R=[];
F=[];
thr= [4000000,5000000,6000000,7000000,8000000,9000000,10000000];

for i = 1:length(thr)
    [accuracy, precision, recall, F1score] = TempSegmen(videoName, feature, similarityMeasure, thr(i));
    A = [A accuracy];
    P = [P precision];
    R = [R recall];
    F = [F F1score];
end

subplot(2,2,1)
plot(thr,A)
xlabel('threshold')
title('Accuracy')

subplot(2,2,2)
plot(thr,R)
xlabel('threshold')
title('Recall')

subplot(2,2,3)
plot(thr,P)
xlabel('threshold')
title('Precision')

subplot(2,2,4)
plot(thr,F)
xlabel('threshold')
title('F1-Score')