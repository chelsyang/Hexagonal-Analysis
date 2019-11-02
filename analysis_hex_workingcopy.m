function [ facetfigs,facetvals,threshim ] = analysis_hex_workingcopy( varargin )

%INPUT: 
% 
%OUTPUT: 
% 
%About: 
% - Now optimized just for the hexagonal images
% - made to measure the faceted images 
% 

addpath( genpath( 'C:\Users\chels\Documents\Berkeley\Research\Gabor filtering program' ) ); 

%set variables from the varargin 

if nargin<6
    error( 'Not enough inputs.' ) 
end

file = varargin{1};
sze = varargin{2}; 

isd = varargin{end-2}; 
ist = varargin{end-1}; 

if isd == -1 
    
    dm3 = DM3Import_cyedit( file ); 
    image = dm3.image_data;
    original_image = image; 
    
    scale = dm3.xaxis.scale; 
    
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

% if la_n==1
%     lattice_angle1 = varargin{laindex+1}; 
%     lattice_angle2 = lattice_angle1; 
% elseif la_n==2
%     lattice_angle1 = varargin{laindex+1}; 
%     lattice_angle2 = varargin{laindex+2}; 
% end 

if exist( 'dm3' ) == 1 
    
    if ias_n == 1 
        [wv1,sz] = find_wavelength( dm3, varargin{iasindex+1}, sze ); 
        wv2 = wv1; 
        wv3 = 0; 
        
        ias1 = varargin{iasindex+1};
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

threshim = ws_thresh1( image,22 ); 
hist = imhist( threshim ); 

[ ~,xmax ] = max( hist ); 
threshim( threshim == xmax ) = 0; 
threshim( threshim > 0 ) = 1; 

threshim = imbinarize( threshim ); 
threshim = imclearborder( threshim ); 

[ crop,crop_og ] = auto_cropth( threshim,original_image,sz ); 

[ a,~ ] = size(crop); 

facetfigs = cell( a,1 ); 
facetvals = cell( a,1 ); 

for b = 1:a 
    
    cropc = crop{b}; 
    cropogc = crop_og{b}; 
    cropc = imclearborder( cropc ); 
    
    [ r,c ] = size( cropc ); 
    
    angle_ex = cropogc( round(r*0.3):round(r*0.8),round(c*0.3):round(c*0.8) ); 
    
    oa = find_angles3( angle_ex,ias1,scale ); 
    
    if oa == 0
        sprintf( 'Error: No angles found' );  
        continue
     else
        oa_1 = oa( 1 ); 

        rotim = imrotate( cropc,360-oa_1 ); 
        rotog = imrotate( cropogc,360-oa_1 ); 
        allbord = bwmorph( rotim,'remove',inf ); 
        allbordp = trial_extractor( allbord,0.4,'coord' ); 
        allbordo = order_points( allbordp ); 

        [ int,lines ] = find_edge_lines2( allbord,allbordo,rotim,sz ); 
        [ f1100,f1120 ] = find_fl( int,scale ); 

        figure1 = make_fimage( rotog,lines,int,f1100,f1120 ); 
        facetfigs{b} = figure1; 

        facetvals{b} = { f1100 f1120 }; 
     end 
    
end 

end 
    




