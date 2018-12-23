function [I2_warped] = warping(I1, I2, u, v)
%Inputs:
    %I1, I2, input images
    %u, v: vectors optical flow

%Output:
    %I2_warped: image warped I1 from I2

[M, N, C] = size(I1);

[x,y]=meshgrid(1:N,1:M);

%Take the pixel positions of I1 and apply u,v, taking into account the
%borders
idxx = x+u; %index columnes
idyy = y+v;%index files
%BORDERS de la imatge final
for i=1:size(idxx,1)
    for j=1:size(idxx,2)
       
        if idxx(i,j)>N
            idxx(i,j)=N;
        elseif idxx(i,j)<1
             idxx(i,j)=1;
        end
        
         if idyy(i,j)>M
            idyy(i,j)=M;
        elseif idyy(i,j)<1
             idyy(i,j)=1;
        end
            
    end    
end


%warp the image in each channel
for i=1:C
    %interpolate I2 image with idxx, idyy
    I2_warped(:,:,i) = interp2(I2(:,:,i),idxx,idyy,'cubic');
    
    
    
    for fil=1:size(idxx,1)
        for col=1:size(idxx,2)
            if I2_warped(fil,col,i)<0
                I2_warped(fil,col,i)=0;
            end
        end    
    end
 
    
end


end
