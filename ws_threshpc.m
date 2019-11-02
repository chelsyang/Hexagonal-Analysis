function [thresholded_image] = ws_threshpc ( fimage,windowsize,sizep )

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
% - PC version: optimized for picking out those pencil things from a fft
% masked image of the pencil things 
%   - now uses entropy filtering as well and a different method of finding
%   gmag

fimage = double(fimage); 

imagem = mat2gray( fimage ); 
ent = entropyfilt( fimage ); 
entm = mat2gray( ent ); 

%obtain gradient image 
[ r,~ ] = size( fimage ); 
[ lowband,~ ] = apply_fftmask( r,50,0,fimage,0 ); 
[ gmag,~ ] = imgradient( lowband ); 

%now to make the particle markers
se = strel( 'disk',windowsize ); 
Io = imopen( imagem,se ); 
Iobw = imbinarize( Io ); 
Iobwf = imfill( ~Iobw,'holes' ); 
Iobwfe = bwpropfilt( Iobwf,'Eccentricity',[0 0.98] ); 
Iobwfe = ~Iobwfe; 

dist = bwdist( Iobwfe ); %take distance transform and binarize
lev2 = (mean(mean(dist))+max(max(dist)))/2;
lev3 = graythresh( mat2gray(dist) ); 

lev = ( lev2+lev3 )/2 ; 
dist_bw = imbinarize( dist,lev ); %particle markers

pmark = dist_bw; 

%get minimum watershed borders 
Ie = imerode( imagem,se ); 
% Iobr = imreconstruct( Ie,imagem ); 
% Iobrd = imdilate( Iobr,se ); 
Iobrcbr = imreconstruct( imcomplement(Ie),imcomplement(Ie) ); 

%Iobrcbr = complement( Iobrcbr );%you know, not sure if this step is
%necessary...think it might not be 

bw = imbinarize( Iobrcbr ); 

[gmag,~] = imgradient( bw ); 


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
    wsbwf = bwpropfilt( wsbw,'Eccentricity',[0 0.9] );
    wsbwfa = bwareafilt( wsbwf,[0 (sizep/2)^2*pi*4] );  
    
    wsfin{a} = wsbwfa; 
    bw_thresh = bw_thresh + wsfin{a}; 
    
%     imshow(bw_thresh)
    
end 

end 