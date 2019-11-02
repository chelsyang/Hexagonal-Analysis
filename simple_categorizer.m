%inputs: array to be organized, frequency at or above which angle will be
%selected 

%may want to adjust freq_occ for max number of occurrences, check this out
%later
function [ org_data ] = simple_categorizer( array )

    nu_array = ( array ); 
    org_data1 = []; 

while sum(sum(nu_array~=0))~=0
    
    c = max( nu_array(:,2)); 

    position = find( nu_array(:,2)==c );
    [ row,col ] = size( position ); 
    if row>1
        position = position(1); 
    end 
    org_data1 = [ org_data1;array(position,:) ]; 
    nu_array(position,:) = [0 0];  
end 

[ rows,~ ] = size( org_data1 ); 
org_data = org_data1; 

end 
    
    
    


