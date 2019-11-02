function [ crop_im,crop_or,centroids ]=auto_cropth( thresh_im,or_im,sz )

%INPUTS: 
%   -sz: size of particle in pixels 
%       - should be obtained from analysis_collective_tr 
%   -thresh_im : thresholded image (preferably with the orientation values
%   as the particle values, considering I don't really want to crop 2
%   images... 
%   - or_im : actually now that I think about it it might just be easier to
%   have 2 different images to crop... or just attach a value? Will have to
%   see 
% 

%OUTPUTS: 
%   - crop_im: cropped images around the particle in a cell

%About: 
%   - this code is a modification to the original auto_crop(used for
%   gridlines/step edge analysis) 
%       - created to crop the thresholded image and orientation image for
%       measurement and angle/facet analysis
%   -I'm writing this code ONLY TO CROP
%       - the rest of the stuff should be done somewhere else lol 
%   - probably won't crop those on the borders (disregard particles that
%   are not completely in the image

thresh_im1 = imclearborder( thresh_im ); 
thresh_iml = logical( thresh_im1 ); 

%find centroids using regionprops
s = regionprops( thresh_iml,'centroid' ); 
centroids = cat( 1,s.Centroid ); 

[ a,~ ] = size( centroids ); 
[ r,c ] = size( thresh_im ); 

%set empty cell arrays for the cropped images and size stuff
crop_im = cell( a,1 ); 
crop_or = cell( a,1 ); 

sides = round( (sz/2)*1.25 ); 

%time to crop
%parfor this later

for b = 1:a
    
    %pretty sure centroids are given in (x,y) format and not (r,c) format
    point = centroids( b,: ); 
    upr = point( 2 )+sides; 
    lowr = point( 2 )-sides; 
    upc = point( 1 )+sides; 
    lowc = point( 1 )-sides; 
    
    padc = []; 
    padr = []; 
    
    if lowc <= 0 
        padc = zeros( r,round(abs(lowc)+1) ); 
        lowc = 1; 
    end 
    if upc > c
        padc = zeros( r,round(abs(upc)-c+1) ); 
        upc = c; 
    end 
    if lowr <= 0
        padr = zeros( round(abs(lowr)+1),c ); 
        lowr = 1; 
    end 
    if upr > r
        padr = zeros( round(abs(upr)+1-r),c ); 
        upr = r; 
    end 
   
    crop_im{ b } = thresh_im( lowr:upr,lowc:upc ); 
    crop_or{ b } = or_im( lowr:upr,lowc:upc ); 
    
    crop_im{ b } = imclearborder( crop_im{b} ); 
    crop_im{ b } = bwconvhull( crop_im{b},'objects' ); 
    [ rc,cc ] = size(crop_im{b}); 
  
    if ~isempty(padc) && ~isempty(padr)
        
        [ incr,~ ] = size( padr ); 
        [ ~,c1 ] = size( padc ); 
   
        padc = zeros( rc+incr,c1 ); 
        padr = zeros( incr,cc ); 
        
        crop_im{ b } = [thresh_im( lowr:upr,lowc:upc ); padr]; 
        crop_or{ b } = [or_im( lowr:upr,lowc:upc ); padr]; 
        
        crop_im{ b } = [crop_im{b} padc]; 
        crop_or{ b } = [crop_or{b} padc];
    elseif ~isempty(padc)
        [ ~,c1 ] = size( padc ); 
        
        padc = zeros( rc,c1 ); 

        crop_im{ b } = [crop_im{b} padc]; 
        crop_or{ b } = [crop_or{b} padc];
    elseif ~isempty(padr)
        
        [ incr,~ ] = size( padr ); 
        
        padr = zeros( incr,cc ); 
        
        crop_im{ b } = [crop_im{b}; padr]; 
        crop_or{ b } = [crop_or{b}; padr];  
    end 
        
end 

end 
