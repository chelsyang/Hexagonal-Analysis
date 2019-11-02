function [ f1100,f1120,ed ] = find_fl8( int,scale ) 

%INPUT: 
% - int: intersections from find_edge_lines2
%OUTPUT: 
% - array? of facet lengths(in ANGSTROMS)
%   - ofc f1100 is the 1100 facet lengths and such 
% - ed: effective diameter
%About: 
% - this time optimized for the octagons 

%find what facet the first 2 points are giving
% should be 0 if it's the 1100 and not 0 otherwise 

facet1 = zeros( 4,1 ); 
facet2 = zeros( 4,1 ); 
ed = zeros( 4,1 ); 

int( end+1,: ) = int( 1,: ); 
mt = 1; 

for a = 1:8
    
    x1 = int(a,1); 
    x2 = int(a+1,1); 
    y1 = int(a,2); 
    y2 = int(a+1,2); 
    
    dist = sqrt( (x1-x2)^2 +(y1-y2)^2 ); 
    
    if rem(a,2) > 0 
        facet1(mt) = dist; 
    elseif rem(a,2) == 0 
        facet2(mt) = dist; 
        mt = mt+1; 
    end 
    
end 

if abs(round(int(1,2) - int(2,2))) < 2
    f1100 = facet1; 
    f1120 = facet2; 
else 
    f1120 = facet1; 
    f1100 = facet2; 
end 

f1100 = f1100.*scale; 
f1120 = f1120.*scale; 

end 