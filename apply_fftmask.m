%VARIABLES: 
% - rows: # rows 
% - R: radius (Actually do I need this?) in terms of pixels 
% - r: smaller radius 
% - image: image that's going to be masked 
% - or: orientation

%This script actually does everything, including MAKING the fft mask 

function [masked_im,masked_fftim] = apply_fftmask(rows,R,r,image,or) 

%check the class of matrix
%if int16, unsupported by fft2 so need to convert the image to uint16 
%if double, no need to do anything, can just fft2 it

if isa(image,'int16')== 1
    
    image = uint16(image); 
    
end

ft = fft2(image);

[ ~,a ] = size(or); 
fft_mask1 = zeros(size(image)); 

if a == 1 
    
    fft_mask = create_fftmask(rows,R,r,or); 
    
elseif a > 1 
    
    for b = 1:a
        fft_mask2 = create_fftmask(rows,R,r,or(b)); 
        
        fft_mask1 = fft_mask1 + fft_mask2; 
    end 
    
    fft_mask = fft_mask1; 
    
end 

fft_ms = fftshift(fft_mask); 

masked = fft_ms.*ft; 

masked_fftim = make_fftim(masked); 

inv_masked = ifft2(masked); 
% inv_masked_shift = ifftshift(inv_masked);

if isa(image,'uint16')==1
    
    inv_mr = int16(inv_masked); 
    
else
    
    inv_mr =inv_masked; 

end 

masked_im = real(inv_mr); 

end 
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
    
    %UGH THE FFT IS FLIPPEDDDDDD 
    %Why is matlab the devils language 
    
    m = tan( deg2rad(or+90) ); % applied strangely? check this area
    if or == 90 || or == 270
        A = Y <= 10; 
        B = Y < -10; 
    elseif or == 0 || or == 180 || or == 360
        A = X <=10; 
        B = X < -10;     
    else 
        if m < 0 
            b1 = abs(25/cos(deg2rad(or+90))); %cos and sin are flipped in this case because in order to calculate the slope m I added 90 deg to make the lines match up(weird flipping stuff)
            b2 = -1*b1;
        elseif m > 0 
            b1 = abs(25/cos(deg2rad(or+90))); 
            b2 = -1*b1; 
        end  
        
    end 
        
%     m = tan(or); 
%     b1 = 10; %need to figure out a way to figure out the intercepts that will isolate points
%     b2 = -10;
 
    if or~=90 && or~=270 && or~= 0 && or~=360 && or~=180
        
        A = Y<=m*x+b1;
        B = Y<m*x+b2;

%     elseif m == 90 
%         
%         A = Y <= 3*wv; 
%         B = Y < -3*wv; 
    end 
    
    M(A)=1; 
    M(B)=0; 
        
end 

fft_mask = (M); 
% fft_mask = fft2(M); 

end 

function [fft_im] = make_fftim(ft_im)

ft_im = fftshift( ft_im ); 
ftmag = abs( ft_im ); 
ftmags = log( ftmag+1 ); 
fft_im = mat2gray( ftmags ); 

end 