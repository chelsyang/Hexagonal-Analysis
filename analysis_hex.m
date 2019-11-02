function [ facetfigs,facetvals,htvals,threshim,image,centroids ] = analysis_hex( varargin )

%INPUT: 
% 
%OUTPUT: 
% 
%About: 
% - Now optimized just for the hexagonal images
% - made to measure the faceted images 
% - TO USE WITH OTHER SHAPES: 
%   - oct: replace find_edge_lines with desired find_edge_lines version 
%       - replace find_fl with desired version 

%EDITS (March 2019)
%- now made to use with DM4s as well 
%- switch DM3 Importer with DMreader general script 

%addpath( genpath( 'C:\Users\chels\Documents\Berkeley\Research\Gabor filtering program' ) ); 

addpath( genpath( 'C:\Users\chelsea.yang\Documents\MATLAB\analysis_tr collection\facet measurements' ) ); 

addpath( genpath( 'C:\Users\chelsea.yang\Documents\MATLAB\analysis_tr collection' ) ); 

addpath( genpath( 'C:\Users\chelsea.yang\Documents\MATLAB\analysis_tr collection\CdSe Hexagonal images' ) ); 

%set variables from the varargin 

if nargin<6
    error( 'Not enough inputs.' ) 
end

file = varargin{1};
sze = varargin{2}; 

isd = varargin{end-2}; 
ist = varargin{end-1}; 

if isd == -1 
    
    %dm3 = DM3Import_cyedit( file ); 
    [ dm,mag ] = ReadDMFile( file );
    
%     if ~isstruct(dm3)
%         warning( 'dm3 not extracted' );
%         facetfigs = []; 
%         facetvals = []; 
%         threshim = []; 
%         image = []; 
%         return
%     end 

    if sum(size(dm)) == 0 
        warning( 'file not extracted...or there is something wrong with the implementation of ReadDMFile which is sadly very likely')
        facetfigs = []; 
        facetvals = []; 
        threshim = []; 
        image = [];
        return 
    end 
    
%     image = dm3.image_data;
%     original_image = image; 
%     
%     scale = dm3.xaxis.scale; 

      image = dm; 
      original_image = image; 
      
      scale = mag; 
    
elseif ist == -1 
    
    original_image = im2double( imread( file ) ); 
    image = original_image; 
    scale = varargin{end}; 
    
end 

laindex = find(strcmpi(varargin, 'lattice_angle')); 
iasindex = find(strcmpi(varargin, 'interatomic_space')); 
la_n = iasindex-laindex-1; 
ias_n = length(varargin)-3-iasindex; 

%error cases 
if la_n>2 || ias_n>3
    error( 'Nanocrystal lattice cannot be analyzed by this program.') 
end 
if la_n==0 || ias_n==0 
    error( 'Please enter at least one lattice angle and interatomic space size.') 
end 
if la_n==2 && ias_n==2 
    error( '3 interatomic space values needed in order to analyze.' ) 
end 

if la_n==1
    lattice_angle1 = varargin{laindex+1}; 
    lattice_angle2 = lattice_angle1; 
elseif la_n==2
    lattice_angle1 = varargin{laindex+1}; 
    lattice_angle2 = varargin{laindex+2}; 
end 

if exist( 'dm3' ) == 1 
    
    if ias_n == 1 
        [wv1,sz] = find_wavelength( dm3, varargin{iasindex+1}, sze ); 
        wv2 = wv1; 
        wv3 = 0; 
        
        ias = varargin{iasindex+1};
        ias1 = ias(1); 
        ias2 = ias(1); 
        
    elseif ias_n == 2
        [wv1,sz] = find_wavelength( dm3, varargin{iasindex+1}, sze );
        [wv2,~] = find_wavelength( dm3, varargin{iasindex+2}, sze );
        wv3 = 0; 
        
        ias1 = varargin{iasindex+1}; 
        ias2 = varargin{iasindex+2};
    elseif ias_n == 3
        [wv1,sz] = find_wavelength( dm3, varargin{iasindex+1}, sze );
        [wv2,~] = find_wavelength( dm3, varargin{iasindex+2}, sze );
        [wv3,~] = find_wavelength( dm3, varargin{iasindex+3}, sze );
        
        ias1 = varargin{iasindex+1}; 
        ias2 = varargin{iasindex+2}; 
        ias3 = varargin{iasindex+3}; 
    end 
    
else 
    
    if ias_n == 1 
        wv1 = varargin{iasindex+1}/(scale*20) ; 
        wv2 = wv1; 
        wv3 = 0; 
        sz = (sze/scale) ;
        
        ias1 = varargin{iasindex+1}; 
        if sum(size(ias1)) > 2
            ias1 = ias1(1); 
        end 
    elseif ias_n == 2 
        wv1 = varargin{iasindex+1}/(scale*10); 
        wv2 = varargin{iasindex+2}/(scale*10) ; 
        wv3 = 0;
        sz = (sze/scale) ;
        
        ias1 = varargin{iasindex+1}; 
        ias2 = varargin{iasindex+2}; 
    elseif ias_n == 3
        wv1 = varargin{iasindex+1}/(scale*10) ; 
        wv2 = varargin{iasindex+2}/(scale*10) ; 
        wv3 = varargin{iasindex+3}/(scale*10) ; 
        sz = (sze/scale) ;
        
        ias1 = varargin{iasindex+1}; 
        ias2 = varargin{iasindex+2}; 
        ias3 = varargin{iasindex+3}; 
    end 
end 

sz = sze/scale; 

threshim = ws_thresh1( image,10,sz ); 
% hist = imhist( threshim ); 
% 
% [ ~,xmax ] = max( hist ); 
% threshim( threshim == xmax ) = 0; 
% threshim( threshim > 0 ) = 1; 
% 
% threshim = imbinarize( threshim ); 
threshim1 = imclearborder( threshim ); 

[ crop,crop_og,centroids ] = auto_cropth( threshim1,original_image,sz ); 

[ a,~ ] = size(crop); 

facetfigs = cell( a,1 ); 
facetvals = cell( a,3 ); 

%re-parfor
parfor b = 1:a 
    
    cropc = crop{b}; 
    cropogc = crop_og{b}; 
    cropc = imclearborder( cropc ); 
    
    cropc = bwconvhull( cropc,'objects' ); 
    
    [ r,~ ] = size( cropc ); 
    s = regionprops(cropc,'centroid'); 
    cent = cat(1,s.Centroid); 
    
    if sum(size(cent))>3
        warning('Multiple particles in crop. Moving to next crop.')
        continue 
    end 
    
    angle_ex = cropogc( round(r*0.3):round(r*0.8),round(r*0.3):round(r*0.8) ); 
    
%     if b == 13 || b == 18 || b == 24 || b == 25
%         rand = 1; 
%     end 
    
    oa = find_angles3( angle_ex,ias1,scale,1 ); 
    
    if oa == 0
        warning( 'Error: No angles found' );  
        continue
%     elseif oa == 0.5    
%         oa2 = find_angles3( angle_ex,ias2,scale ); 
%         
%         oa_3 = oa2( 1 ); 
%         
%         if oa_3 == 0.5 
%             warning( 'Error: No known lattice spacings found.' )
%             continue 
%         end 
%         
%         rotim = imrotate( cropc,360-oa_3 ); 
%         rotog = imrotate( cropogc,360-oa_3 ); 
% 
%         ht = find_height( cropc,scale );
%         htvals{ b } = ht; 
%         continue 
     else
        oa_1 = oa( 1 ); 

        rotim = imrotate( cropc,360-oa_1 ); 
        rotog = imrotate( cropogc,360-oa_1 ); 
        allbord = bwmorph( rotim,'remove',inf ); 
        allbordp = trial_extractor( allbord,0.4,'coord' ); 
        allbordo = order_points( allbordp ); 
        
        if isempty( allbordo )
            continue 
        end 
        
%         if b == 4 || b == 16
%             rnad = 1; 
%         end 

        %hexagonal lattice 
%         [ int,lines ] = find_edge_lines2( allbord,allbordo,rotim,sz ); 
% 
%         [ f1100,f1120,ed ] = find_fl( int,scale ); 
% 
%         figure1 = make_fimage( rotog,rotim,lines,int,f1100,f1120 ); 
%         facetfigs{b} = figure1; 

        
        % PbS cubes with rock salt lattice edit: 
        [ int,lines ] = find_edge_lines8( allbord,allbordo,rotim,sz );
        [ f1100,f1120,ed ] = find_fl8( int,scale ); 
        figure1 = make_fimage8( rotog,rotim,lines,int,f1100,f1120 ); 
        facetfigs{b} = figure1; 
        
        facetvals(b,:) = [{ f1100 } {f1120} {ed}];     
        
     end 
    
end 

ftmagbw = make_fftim( image );

center = size(ftmagbw)/2 +1; 
f = (ias1/10)*(1/scale); 
j = size(ftmagbw,2)/(sqrt(2)*f) + center(2); 
rmean = sqrt(((center(1)-j)^2)*2); 

%get better method of determining lc LATER
% sounds like a future me problem 
[ pc1,~ ] = apply_fftmask( size(image,2),rmean+50,rmean+20,image,0 ); 
pc_thresh = ws_threshpc( pc1,15,sz*2 ); 

[ cpc,cpcog,~ ] = auto_cropth( pc_thresh,image,sz*3 ); 

[ c,~ ] = size( cpc ); 

htvals = cell( c,1 ); 

% for d = 1:c 
%     
%     cpc1 = cpc{ d }; 
%     cpcog1 = cpcog{ d };
%     cpc1 = imclearborder( cpc1 ); 
%     
%     [ r1,~ ] = size( cpc1 ); 
%     
%     s = regionprops(cpc1,'centroid'); 
%     cent = cat(1,s.Centroid); 
%     
%     if sum(size(cent))>3
%         warning('Multiple particles in crop. Moving to next crop.')
%         continue 
%     elseif isempty(cent) 
%         warning('Make your crop area bigger dumbass')
%         continue
%     end 
%     
%     %change this to something referencing size of crop instead of random
%     %number 
%     horz_indexa = round(cent(2)-r1*0.1):round(cent(2)+r1*0.1); 
%     horz_index_non0 = horz_indexa>0; 
%     horz_indexb = horz_index_non0.*horz_indexa; 
%     horz_indexb = horz_indexb ~= 0; 
%     
%     vert_indexa = round(cent(2)-r1*0.1):round(cent(2)+r1*0.1); 
%     vert_index_non0 = vert_indexa>0; 
%     vert_indexb = vert_index_non0.*vert_indexa; 
%     vert_indexb = vert_indexb ~= 0; 
%     
%     angle_ex2 = cpcog1( horz_indexb,vert_indexb );
%     
%     oa2 = find_angles3( angle_ex2,ias1,scale,2 );
%     oa3 = oa2(1); 
%     
%     if oa3 == 0 
%         warning( 'Error: No angles found.' ); 
%         continue 
%     end 
%     
%     rotim1 = imrotate( cpc1,360-oa3 ); 
%     rotog1 = imrotate( cpcog1,360-oa3 );
%     
%     ht = find_height( cpc1,scale );
%     htvals{ d } = ht; 
%     
% end 


end 
    




