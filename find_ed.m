function [ ed ] = find_ed( int )

int( end,: ) = []; 
[ num,~ ] = size( int ); 
num2 = num/2 ; 

ed = zeros( num2,1 ) ; 

int( end+1,: ) = int( 1,: ); 

for b = 1:num2
    
    topa = int( b,: ); 
    topb = int( b+1,: ); 
    
    bota = int( b+4,: ); 
    botb = int( b+5,: ); 
    
    topc = ( topa+topb )/2; 
    botc = ( bota+botb )/2; 
    
    dist = sqrt( (topc(1)-botc(1))^2 + (topc(2)-botc(2))^2 ); 
    
    ed( b ) = dist; 
    
end 

end 

    