% VARIABLES: 
% - rows: number...of rows
% - R: radius(outer) in terms of pixels (NOT RATIO...maybe I should change
% that)
%   - If R~=0, the fft mask will just be a radial mask and not an
%   orientation mask (tb changed)
% - r: radius(inner ring) 
% - or: orientation angle 

%this script is encompassed in apply_fftmask 

function [fft_mask]=create_fftmask(rows,R,r,or)

n = rows; 
I = 1:n; 
M = zeros(n); 

%Setting center of image as origin (0,0)
x = I-n/2; 
y = n/2-I; 
[X,Y] = meshgrid(x,y); 

if R~=0 
    
    A = (X.^2+Y.^2 <= R^2); 
    M(A) = 1; 
    %smaller r value is for inner ring (for my own questionable purposes... if
    %no inner circle needed input r = 0 
    B = (X.^2+Y.^2 <= r^2); 
    M(B) = 0; 
    
else
    
    %makes the angular mask based on orientation
    
    %I AM STILL UNSURE OF THE SLOPE THAT SHOULD BE USED? AFTER ALL THIS
    %TIME I might be wrong and it should be tan(or). Also, the actual FFT
    %is like weirdly flipped so I have to deal with that
    
    m = tan( deg2rad(or) ); 
    b1 = 10; %need to figure out a way to figure out the intercepts that will isolate points
    b2 = -10; 
    
    A = Y<=m*x+b1;
    B = Y<m*x+b2;
    
    M(A)=1; 
    M(B)=0; 
    
end 

fft_mask = (M); 
% fft_mask = fft2(M); 

end 
