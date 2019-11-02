%an extremeley inefficient trial extractor 
%I reiterate(as does this shitty code,multiple times): EXTREMELY INEFFICIENT 

%INPUTS: 
%-array: (double) array from which the positions are extracted
%-tol: (double) if both white and black are within a certain percent of each other,
%the positions are NOT extracted 
%-type: (char) specifies whether the positions are extracted in the [x y] 
%format or the space in huge column vector format
%   -'coord' [rows cols] format
%   -'col' number in large column vector format
function [ positions ]=trial_extractor( array, tol, type )


[ a,b ] = size( array ); 
positions = [];

ab = sum( sum(array==0) )/( a*b ); 
aw = sum( sum(array==1) )/( a*b ); 

dfbw = abs( ab-aw ); 

if dfbw <= tol
    fprintf( 'Segmenting failed. Moving to next angle.')
    return 
else 
    if ab<aw
        d = 2;
    elseif aw<ab
        d = 1; 
    end
    
    if strcmpi( type, 'col' ) 
        for c = 1:a*b
            if array(c) == d
                positions =[ positions; c ]; 
            end
        end
    elseif strcmpi( type, 'coord' )
        for c = 1:a
            for e = 1:b 
                if array(c,e) == d 
                    positions = [ positions; c e ]; 
                end 
            end 
        end 
    end 
end 


end 
