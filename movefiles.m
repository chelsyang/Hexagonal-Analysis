%written because I'm WAY too lazy to go through and move files 1 by 1

%so it's written to move the orientation images to their own folder so I
%can scroll through really fast and appreciate my code 

%%%%%% VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%folder location --> basic folder loaction, what else should I say
%origin_foldername --> folder from which you want to move things (no folder
%path)
%new_foldername ---> name of new folder that you're going to move things
%to (no folder path) 
%codeword ---> the search term that MICROSOFT DOESN'T LET YOU USE
%filetype ---> just the file type in the format 'png' or 'tif'

function movefiles( folderlocation,origin_foldername,new_foldername,codeword,filetype )

new_folder = fullfile( folderlocation,new_foldername ); 
mkdir( folderlocation,new_foldername ) 

origin_folder = fullfile( folderlocation,origin_foldername ); 
addpath( origin_folder ) 

filedirectory = dir( origin_folder ); 
filedirectorycell = struct2cell( filedirectory ); 

[a,~] = size( filedirectory ); 

%I made the file directory into a cell because I HATE STRUCTS 
%filenames will also be a cell array 

filenames = filedirectorycell( 1,: ); 

filetype1 = strcat( '*.',filetype ); 

ist = size( dir( fullfile( origin_folder, filetype1 ) ) ); 

if ist(1) == 0 
    warning( 'No files of selected type exist in folder.' )
end 

for b=1:a
    
    if sum( strfind(filenames{b},filetype )>0 )==1
        
        if sum( strfind(filenames{b},codeword )>0 ) ==1
            
            copyfile (filenames{b}, new_folder) 
            
        end 
        
    end 
    
end 

end 
        
        
    