function imP = ImToPolar (imR, rMin, rMax, M, N)
% IMTOPOLAR converts rectangular image to polar form. The output image is 
% an MxN image with M points along the r axis and N points along the theta
% axis. The origin of the image is assumed to be at the center of the given
% image. The image is assumed to be grayscale.
% Bilinear interpolation is used to interpolate between points not exactly
% in the image.
%
% rMin and rMax should be between 0 and 1 and rMin < rMax. r = 0 is the
% center of the image and r = 1 is half the width or height of the image.
%
% V0.1 7 Dec 2007 (Created), Prakash Manandhar pmanandhar@umassd.edu

[Mr Nr] = size(imR); % size of rectangular image
Om = (Mr+1)/2; % co-ordinates of the center of the image
On = (Nr+1)/2;
sx = (Mr-1)/2; % scale factors
sy = (Nr-1)/2;

imP  = zeros(M,  N);

delR = (rMax - rMin)/(M-1);
delT = 2*pi/N;

% loop in radius and 
for ri = 1:M
for ti = 1:N
    r = rMin + (ri - 1)*delR; %iterating the radial value (what area of the image the program looks at)
    t = (ti - 1)*delT; %iterating the piece of the pie that is the image that the program is looking at
    x = r*cos(t); %finding the percentage of R as coordinates for where the program is actually looking
    y = r*sin(t); %same as above for y
    xR = x*sx + Om;  %finding actual coordinates from the percentages calculated in x and y
    yR = y*sy + On; 
    imP (ri, ti) = interpolate (imR, xR, yR);
end
end
end

function v = interpolate (imR, xR, yR)
%going to assume that v is the value at that image? 
    xf = floor(xR);%basically rounding the coordinates up/down to make sure they're real numbers 
    xc = ceil(xR);
    yf = floor(yR);
    yc = ceil(yR);
    if xf == xc & yc == yf
        v = imR (xc, yc);
    elseif xf == xc
        v = imR (xf, yf) + (yR - yf)*(imR (xf, yc) - imR (xf, yf));
    elseif yf == yc
        v = imR (xf, yf) + (xR - xf)*(imR (xc, yf) - imR (xf, yf));
    else
       %don't really understand this construction of A and r??? Aren't we
       %just trying to obtain the value of this??? 
%        A = [ xf yf xf*yf 1
%              xf yc xf*yc 1
%              xc yf xc*yf 1
%              xc yc xc*yc 1 ];

% I guess in some ways it would be WRONG to assume that it's a linear type
% relationship between the 4 points that surround the actual point...BUT I
% am TIRED of WAITING for this stupid thing and SEEING THE INTERPOLATION
% ERRORS 
% tldr: I changed the interpolation to a simple average between the 4
% points in the hopes that it would speed this up
       r = [ imR(xf, yf)
             imR(xf, yc)
             imR(xc, yf)
             imR(xc, yc) ];
       v = mean(r); 
%        a = A\double(r);
%        w = [xR yR xR*yR 1];
%        v = w*a;
    end
end 