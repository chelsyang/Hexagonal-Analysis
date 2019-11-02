function [thresholded_image] = ws_thresh1 ( image,windowsize,sizep )

%INPUTS: 
% - image:original image obtained from DM3 extractor 
% - size: average diameter of particles in pixels
%
%OUTPUT: 
% - thresholded_image: thresholded image with all particles for use in
%   construction of orientation image 
%
%About: 
% - uses watershed segmentation with markers to segment the image 
% - heavily based off of the fruity example given by mathworks
%   - basically only difference is that I used a different method of
%   obtaining the gradient image

imagem = mat2gray( image ); 

%obtain gradient image 
[ r,~ ] = size( image ); 
[ lowband,~ ] = apply_fftmask( r,50,0,image,0 ); 
[ gmag,~ ] = imgradient( lowband ); 

%now to make the particle markers
se = strel( 'disk',windowsize ); 
Io = imopen( imagem,se ); 
%Iobw = imbinarize( Io ); 
sizep = round(double(sizep)); 
Iobw = adaptivethreshold(Io,sizep,0,0); 
Iobwf = imfill( ~Iobw,'holes' ); 
Iobwfe = bwpropfilt( Iobwf,'Eccentricity',[0 0.98] ); 
Iobwfe = ~Iobwfe; 

dist = bwdist( Iobwfe ); %take distance transform and binarize
% lev2 = (mean(mean(dist))+max(max(dist)))/2;
% lev3 = graythresh( mat2gray(dist) ); 
% 
% lev = ( lev2+lev3 )/2 ; 
% dist_bw = imbinarize( dist,lev ); %particle markers

%switched to an adaptive threshold to see if that makes for better
%watershedding
dist_bw = adaptivethreshold( dist,sizep,0,0 ); 

pmark = dist_bw; 

%get minimum watershed borders 
Ie = imerode( imagem,se ); 
Iobr = imreconstruct( Ie,imagem ); 
Iobrd = imdilate( Iobr,se ); 
Iobrcbr = imreconstruct( imcomplement(Iobrd),imcomplement(Iobr) ); 

%Iobrcbr = complement( Iobrcbr );%you know, not sure if this step is
%necessary...think it might not be 

bw = imbinarize( Iobrcbr ); 

d = bwdist( bw ); 
dL = watershed( d ); 

fwsmark = dL == 0; 

%getting the final segmented image 
gmag2 = imimposemin( gmag,fwsmark | pmark ); 
Lf = watershed( gmag2 ); 

ti_int = binthresh( Lf,sizep ); 
%thresholded_image = bwconvhull( ti_int,'objects' ); 
thresholded_image = ti_int; 

end 

%anyway to speed up binthresh???
% lol this problem came up again 5-2-19 and 5-2-19 chelsea still has no
% idea 
function [ bw_thresh ] = binthresh( ws_im,sizep )

hv = max( max(ws_im) ); 
wsfin = cell( size(1:hv) ); 
bw_thresh = zeros( size(ws_im) ); 
% figure
% imshow(bw_thresh)

for a = 1:hv 
    
    wswork = ws_im; 
    wswork( wswork~=a ) = 0; 
    wswork( wswork == a ) = 1; 
    
    wsbw = imbinarize( wswork ); 
    wsbwf = bwpropfilt( wsbw,'Eccentricity',[0 0.6] );
    wsbwfa = bwareafilt( wsbwf,[0 (sizep/2)^2*pi*2] );  
    
    wsfin{a} = wsbwfa; 
    bw_thresh = bw_thresh + wsfin{a}; 
    
%     imshow(bw_thresh)
    
end 

end 


    

