function[combffigs,combfvals,f1100tot,f1120tot,edtot,httot,avg1100,avg1120,avged,avght,ratio,std1100,std1120,stded,centroids]= analysis_collective_fac( folderlocation,functionfolder,newfilename,sz,latticeangle,ias,scale )
%About: 
% -collective code for the worse images
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

%quick fixed it from dm3 to dm4 but it WAS dm3 at some point: edit this to
%make more robust
isd= size( dir( fullfile( myfolder, '*.dm4' ) ) );
ist = size( dir( fullfile( myfolder, '*.tif' ) ) ); 

if isd(1) > 0 
    
    filepattern = fullfile( myfolder,'*.dm4' ); 
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
    htvals = cell(a1,1);
    centroids = cell(a1,1); 
    
    image_mean = zeros(a1,1); 

    %don't forget to change back to parfor
    for a=1:length(filedirectory) 
        
        basename = filedirectory(a).name; 
        fullname = fullfile( myfolder,basename ); 

        fprintf( 1,'Now reading %s\n', fullname ); 

        [ combffigs{a},combfvals{a},htvals{a},threshims{a},oimage{a},centroids{a} ] = analysis_hex( basename,sz,'lattice_angle',latticeangle,'interatomic_space',ias,isd,ist,scale);
        
        if isempty(combffigs{a}) && isempty(combfvals{a}) && isempty(threshims{a}) && isempty(oimage{a})
            continue 
            
        end 

        %make figures in for loop probably, save all 
        
        [ numcells,~ ] = size( combffigs{a} ); 
        
        c_figs = combffigs{a}; 
        basename = basename(1:end-4); 
        
        cd (new_char) 
        
        %STOP trying to parfor this
        % you can't nest parfor loops dumbass
        for b = 1:numcells

            num = num2str( b ); 
            filename1 = strcat( basename,'measured',num ); 
            
            fig1 = c_figs{ b };
            
            if isempty(c_figs{b})
                warning( 'Man parfor is a pain in the ass sometimes') 
                continue 
            end 

            saveas( fig1,filename1,'png'); 
            
        end 
        
        filename2 = strcat( basename,'watershed' ); 
        
        fig2 = figure( 'visible','off' );
        imshowpair( threshims{a},oimage{a},'diff' )
        
        saveas( fig2,filename2,'png'); 
        
        %save centroids to look at the angles 

    end 
    
     
    f1100cell = cell( length(filedirectory),2 ); 
    f1120cell = cell( length(filedirectory),2 ); 
    edcell = cell( length(filedirectory),2 ); 
    
    for a1 = 1:length(filedirectory) 
        combfvalsc = combfvals{ a1 };
        
        f1100s = [ combfvalsc{:,1} ]; 
        f1120s = [ combfvalsc{:,2} ]; 
        eds = [ combfvalsc{:,3 } ]; 
        
        f1100cell{a1} = f1100s; 
        f1120cell{a1} = f1120s; 
        edcell{a1} = eds; 
               
    end 
    
    cd(new_char) 
    
    f1100tot = [ f1100cell{:,:} ]; 
    f1120tot = [ f1120cell{:,:} ]; 
    edtot = [ edcell{:,:} ]; 
    httot1 = cat( 1,htvals{:,:} ); 
    httot1 = httot1(~cellfun('isempty',httot1)); 
    httot = [ httot1{:,:} ]; 
    centroids = [ centroids{:,:} ]; 
    
    avg1100 = mean(mean(f1100tot)); 
    avg1120 = mean(mean(f1120tot)); 
    avged = mean(mean(edtot)); 
    avght = mean(httot); 
    
    ratio = avg1100/avg1120; 
    std1100 = std(std(f1100tot)); 
    std1120 = std(std(f1120tot)); 
    stded = std(std(edtot)); 
    stdht = std(httot); 
    
    fn1 = '1100 per facet distribution'; 
    fn1a = '1100 per particle distribution'; 
    fn2 = '1120 per facet distribution'; 
    fn2a = '1120 per particle distribution'; 
    fn3 = '0 Ratio per particle distribution'; 
    fn4 = '0 Effective diameter per particle distribution'; 
    fn5 = '0 Height per particle distribution'; 
    
    figa = figure('visible','off'); 
    h1 = histogram( f1100tot ); 
    saveas( h1,fn1,'png' ); 
    
    figb = figure('visible','off'); 
    h2 = histogram( sum(f1100tot)/6 ); 
    saveas( h2,fn1a,'png' ); 
    
    figc = figure('visible','off'); 
    h3 = histogram( f1120tot ); 
    saveas( h3,fn2,'png' ); 
    
    figd = figure('visible','off'); 
    h4 = histogram( sum(f1120tot)/6 );  
    saveas( h4,fn2a,'png'); 
    
    fige = figure('visible','off'); 
    h5 = histogram( sum(f1100tot)./sum(f1120tot) ); 
    saveas( h5,fn3,'png' ); 
    
    figf = figure('visible','off'); 
    h6 = histogram( sum(edtot)/6 ); 
    saveas( h6,fn4,'png'); 
    
    figg = figure('visible','off'); 
    h7 = histogram( httot ); 
    saveas( h7,fn5,'png' ); 
        
end 
