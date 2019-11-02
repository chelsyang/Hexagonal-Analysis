function[image_mean]= analysis_collective_fac_workingcopy( folderlocation,functionfolder,newfilename,sz,~,ias,~ )
%About: 
% -collective code for the shittier images 
% -because everything can and should be analyzed, no matter how shitty
%OUTPUT: 
% -image_mean: the segmented particle image 
%INPUTS:
% -folderlocation/functionfolder/newfilename: self-explanatory 
% -sz: average size of particles in nm
% -latticeangle: angle of lattice(may be unnecessary); hexagonal would be
% 60 
% -ias: interatomic space, space between planes, d-spacing
% -scale: for .tiff images, obtain from ImageJ (scale isn't extracted w/
% this program unless using a dm3 image 

%% Creating new folder to put figures into

new_file = strcat( folderlocation,'\',newfilename ); 
new_char = char( new_file );

mkdir( folderlocation, newfilename ) 

%% Folder processing for loop 

%file location=location of file(string)
%ex: 'C:\Users\YourUserName\Documents\MyPictures'

myfolder = folderlocation;

if ~isdir( myfolder )
    error = sprintf( 'Error: The following folder does not exist :\n%s' , myfolder ); 
    uiwait( warndlg( error ) ); 
    return 
end

isd= size( dir( fullfile( myfolder, '*.dm3' ) ) );
ist = size( dir( fullfile( myfolder, '*.tif' ) ) ); 

if isd(1) > 0 
    
    filepattern = fullfile( myfolder,'*.dm3' ); 
    isd = -1; 
    
elseif ist(1) > 0 
    
    filepattern = fullfile( myfolder,'*.tif' );
    ist = -1; 

else 
    
    warning( 'File type unsupported.' ) 

end  

    filedirectory = dir( filepattern );

    segmented = cell( length( filedirectory ),1 ); 

    addpath( genpath( functionfolder ) ); 

    a1 = length(filedirectory); 

    combffigs = cell(a1,1); 
    combfvals = cell(a1,1); 
    threshims = cell(a1,1); 
    
    image_mean = zeros(a1,1); 

    for a=1:length(filedirectory) 

%         a 
        
        basename = filedirectory(a).name; 
        fullname = fullfile( myfolder,basename ); 

        fprintf( 1,'Now reading %s\n', fullname ); 

        [ combffigs{a},combfvals{a},threshims{a} ] = analysis_hex( basename,sz,'lattice_angle',90,'interatomic_space',ias,isd,ist,scale);

        %make figures in for loop probably, save all 
        
        [ numcells,~ ] = size( combffigs{a} ); 
        
        c_figs = combffigs{a}; 
        basename = basename(1:end-4); 
        
        cd (new_char) 
        
        for b = 1:numcells
            
%             b

            num = num2str( b ); 
            filename1 = strcat( basename,'measured',num ); 
            
            fig1 = c_figs{ b };

            saveas( fig1,filename1,'png'); 
            
        end 
        
        filename2 = strcat( basename,'watershed' ); 
        
        fig2 = figure( 'visible','off' );
        imshow( threshims{a} )
        
        saveas( fig2,filename2,'png'); 

    end 
    
end 
