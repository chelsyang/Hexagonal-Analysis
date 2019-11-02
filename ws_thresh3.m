function [thresholded_image] = ws_thresh3 ( image,windowsize,sizep )

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
[ lowband,mfftim ] = apply_fftmask( r,100,0,image,0 ); 
[ gmag,~ ] = imgradient( lowband ); 

%now to make the particle markers
se = strel( 'disk',windowsize ); 
Io = imopen( imagem,se ); 

lg = graythresh( Io ); 
lt = triangle_th( imhist(Io),256 ); 

Iobw = imbinarize( Io ,(lg+lt)/2 ); 
Iobwf = imfill( ~Iobw,'holes' ); 
Iobwfe = bwpropfilt( Iobwf,'Eccentricity',[0 0.9] ); 
Iobwfe = ~Iobwfe; 

dist = bwdist( Iobwfe ); %take distance transform and binarize
distmg = mat2gray( dist ); 

lev2 = (mean(mean(distmg))+max(max(distmg)))/2;
lev3 = graythresh( distmg ); 

lev = ( lev2+lev3 )/2 ; 
dist_bw = imbinarize( dist,lev ); %particle markers

pmark = dist_bw; 

%get minimum watershed borders 
Ie = imerode( imagem,se ); 
Iobr = imreconstruct( Ie,imagem ); 
Iobrd = imdilate( Iobr,se ); 
Iobrcbr = imreconstruct( imcomplement(Iobrd),imcomplement(Iobr) ); 

%Iobrcbr = complement( Iobrcbr );%you know, not sure if this step is
%necessary...think it might not be 
tth = triangle_th( imhist(Iobrcbr),256 ); 
gth = graythresh( Iobrcbr ); 
bw = imbinarize( Iobrcbr,gth-0.01 ); 

d = bwdist( bw ); 
dL = watershed( d ); 

fwsmark = dL == 0; 

%getting the final segmented image 
gmag2 = imimposemin( gmag,fwsmark | pmark ); 
Lf = watershed( gmag2 ); 

ti_int = binthresh( Lf,sizep ); 
thresholded_image = bwconvhull( ti_int,'objects' ); 

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
    wsbwf = bwpropfilt( wsbw,'Eccentricity',[0 0.5] );
    
    wsbwfa = bwareafilt( wsbwf,[(sizep/2)^2*pi*2*(1/8) (sizep/2)^2*pi*2] );  
    
    wsfin{a} = wsbwfa; 
    bw_thresh = bw_thresh + wsfin{a}; 
    
%     imshow(bw_thresh)
    
end 

end 


    

