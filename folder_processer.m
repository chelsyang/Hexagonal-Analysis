%function so that whole folders can be processed because I am tired
%not sure what outputs will be atm

%INPUTS: 
%file location=location of file(string)
%ex: 'C:\Users\YourUserName\Documents\MyPictures'

function [segmented] = folder_processer( folderlocation , functionfolder )

myfolder = folderlocation;

if ~isdir( myfolder )
    error = sprintf( 'Error: The following folder does not exist :\n%s' , myfolder ); 
    uiwait( warndlg( error ) ); 
    return 
end 

filepattern = fullfile( myfolder,'*.dm3' ); 
filedirectory = dir( filepattern );

segmented = cell( length( filedirectory ),1 ); 

addpath( genpath( functionfolder ) ); 

parfor a=1:length(filedirectory) 
    basename = filedirectory(a).name; 
    fullname = fullfile( myfolder,basename ); 
    fprintf( 1,'Now reading %s\n', fullname ); 
    segmented{a} = analysis_3ls( basename, 3.23, 4, 90 );
end 

end 