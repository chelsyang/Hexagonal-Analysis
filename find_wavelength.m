%simple code to find right wavelength, will probably be bundled in other
%code later on

function [ wavelength, particlesize_pixels ] = find_wavelength( dm3struct, interatomic_space, size ) 

scalex = dm3struct.xaxis.scale; 
scaley = dm3struct.yaxis.scale; 
%convert to nm from angstroms
interatomic_space = interatomic_space/10; 

%just to check...not sure if these would ever be different 
%change PRINTED STATEMENT
    if scalex~=scaley
        error( 'Scale X does not match scale Y' );
    else 
        scale = scalex; 
    end 

wavelength = interatomic_space/scale; 
particlesize_pixels = size/scale; 

end 


