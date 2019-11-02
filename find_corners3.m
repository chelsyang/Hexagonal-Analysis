function [ lines ] = find_corners3( pos,image ) 

stats = regionprops( image ); 
centroid = stats.Centroid; 

work = zeros( size(pos) );
work( :,1 ) = centroid( 1,1 );
work( :,2 ) = centroid( 1,2 ); 

pose = work - pos; 
pose1 = pose.^2; 
pose2 = pose1( :,1 ) + pose1( :,2 );
pose3 = sqrt( pose2 ); 

[ maxtab,mintab ] = peakdet( pose3,range(pose3)/200 ); 
[ a,~ ] = size( maxtab ); 

extrema = zeros( a,2 ); 

for b = 1:a 
    
    posn_l = sum( pose3 == maxtab(b,2),2 ) ; 
    posn = find( posn_l == 1 ); 
    
    extrema( b,1 ) = pos( posn,1 ); 
    extrema( b,2 ) = pos( posn,2 ); 
    
end 

lines = extrema; 

end 
    
    
    