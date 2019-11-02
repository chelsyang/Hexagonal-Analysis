function [orderedangles]=find_angles3(image,ias,scale,type) 
%INPUTS: 
% - image: cropped original image(with color map)
% - ias: space between columns, used to calculate desired radius on fft 
% - scale: pixels per nm 
%OUTPUTS: 
% - angles..ordered 
%About: 
% - edits: chooses max std over certain selected radius to find point of
%   interest 
% - requires certain standard deviation in peaks in order to pass:
%   segmented particles without lattices skipped 

[a,~] = size(image); 

ftmagbw = make_fftim(image); 

center = size(ftmagbw)/2 +1; 
f = (ias/10)*(1/scale); 

j = size(ftmagbw,2)/(sqrt(2)*f) + center(2); 

rmean = sqrt(((center(1)-j)^2)*2); 
rmin = 2*(rmean-10)/a; 
rmax = 2*(rmean+10)/a; 

M = 206; 
N = 361;
%make sure that this won't error out with a different 206 361??  separated
%into MxN number of squares (the points that are examined)
imP = ImToPolar( ftmagbw,rmin,rmax,M,N ); %rmin before rmax

 
row_check = sum(imP); 

tozero = find( row_check > 0.55*M ); 
imP(:,tozero) = mean(mean(imP)); 

%adding in a standard deviation to determine where the actual desired areas
%are, then will only sum over those areas in order to avoid summing the
%middle parts 

max_std = max(std( imP,[],2 )); 
rmaxs = range(std( imP,[],2 )); 
maxsp = find( std(imP,[],2)==max_std ); 

if type == 1 
    %check for incorrect lattice spacings 
    rmean_check = 2*rmean/a; 
    lat_val = maxsp*(rmax-rmin)/206+rmin; 
    lat_check = abs( rmean_check-lat_val ); 
elseif type == 2 
    rmean_check = 2*rmean/a; 
    lat_val = maxsp*(rmax-rmin)/206+rmin; 
    lat_check = abs( rmean_check-lat_val ); 
    lat_check = 0; 
%     if lat_check>=0.02
%         lat_check = 0; 
%     else
%         lat_check = 1; 
    end 
 
    

max_row = imP( round(maxsp),: ); 

min_peak = min( max_row(:,2) ); 
med_peak = median( max_row(:,2) ); 
% lowavg_peak = ( min_peak+med_peak )/2; 

% max_rowc = max_row; 
max_rowc = max_row.^8; 
max_rowc( max_rowc< mean(max_rowc(:,2)) ) = median( max_rowc(:,2) ); 
range_row = range( max_rowc );
delta = range_row/10; 

%yeah, figure out what latcheck is and fix that shit because it's not
%checking proper
%yeaaaah rmaxs is too high rip
%possible that rmaxs had a non-real value? 
%possible that somehow the check values are turning into nonscalars??
if ~isscalar(delta) || ~isscalar(rmaxs) || ~isscalar(lat_check)
    warning( 'Delta,rmaxs,or lat_check is not scalar, No angles found')
    orderedangles = 0; 
    return
end 

if delta == 0 || rmaxs<=0.01 || lat_check >= 0.0185
    warning( 'No angles found' ) 
    orderedangles = 0; 
    return
    
else 
    [ maxtab,~] = peakdet( max_rowc,delta ); 

    min_peak2 = min( maxtab(:,2) ); 
    med_peak2 = median( maxtab(:,2) ); 
    lowavg_peak2 = ( min_peak2+med_peak2 )/2; 

    highpeak_pos = find( maxtab(:,2)>=lowavg_peak2 ); 
    %0.6*max(maxtab(:,2)) previous limit
    highpeaks = maxtab( highpeak_pos,: ); 

    org_peaks = simple_categorizer( highpeaks ); 

    % rows = sum( imP(maxsp-10:maxsp+10,:) ); 
    % org_rows = simple_categorizer( rows ); 
    org_rows2 = org_peaks( :,1 )*( 2*pi/361 );
    %org_angles = clean_angles2( org_rows2,org_peaks(:,1),90 ); 


    orderedangles = org_peaks(:,1); 
end 

end 
