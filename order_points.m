function [ordered_points] = order_points( og )

%wellllll fuck am I right 

%INPUT: 
% - og: the extracted or obtained edge points 

%OUTPUT: 
% - orderedpoints: points that SHOULD be in the order of like, going around
% the circle 

%About:
% - made to order border points in a way that makes it seem like you're
% going around the circle 
%   - this is for finding the corners 
% - edit: removing close points with same x values

c = 2; 
d = 1; 
ord = zeros( size(og) );
work = zeros( size(og) ); 

if isempty(og)
    warning( 'No border points detected. Moving on to next.' )
    ordered_points = []; 
    return 
end 

ord( 1,: ) = og( 1,: ); 

oge = og; 
oge( 1,: ) = [10000 10000]; 

while sum(sum(oge~=10000))>=1 
    
    work( :,1 ) = og( d,1 ); 
    work( :,2 ) = og( d,2 ); 
    
    oge1 = oge - work; 
    
    samex = find( oge1(:,1)==0 ); 
    
%     if sum(size(samex)) > 10
%         oge1 = oge1; 
    if sum(size(samex))>0
        smallyp = find( oge1(:,1) == 0 & abs(oge1(:,2))<10 ); 
       [r,~]=size(smallyp); 
        makefill = zeros( r,2 );
        makefill( makefill==0 ) = 10000; 
        
        oge1(smallyp,:) = makefill; 
        oge(smallyp,:) = makefill; 
    end 
    
    oge2 = oge1.^2; 
    oge3 = oge2(:,1) + oge2(:,2); 
    dists = sqrt(oge3); 
    
    min_d = min( dists ); 
    min_p = find( dists == min_d );
    

    if sum(sum(oge~=10000))==0
        break
    end 
    
    if sum(size(min_p))>2
        min_p = min_p(1); 
    end 
    
    ord( c,: ) = og( min_p,: ); 
    
    oge( min_p,: ) = [10000 10000]; 
    
    d = min_p; 
    c = c+1; 
    
end 

ordered_points = ord; 

end 
    