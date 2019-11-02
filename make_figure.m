%It's inefficient to open the subplot things by hand in the command window
%My hands get tired 
%Thus this code was born

function make_figure(imcell)

[a,~] = size(imcell); 
afix = a; 
diff = 1; 

while diff>= 0.5 
    a = a+1; 
    [s1,s2] = find_dim(a); 
    
    if s1 >= s2
        diff = (s1-s2)/s1; 
    else
        diff = (s2-s1)/s2; 
    end 
    
end 


figure

for e=1:afix
    subplot(s1,s2,e)
    imshow(imcell{e},[])
end 

end 


function [s1,s2] = find_dim(a)
%set a bunch of zeros to fill up with possible dimensions
% 50,2 is set arbitrarily...
index = zeros( 50,2 ); 
n     = 1; 

%n is the position in the index, moved up every time that a multiple is
%found 
for b=1:a
    if rem( a,b ) == 0 
        index( n,1 ) = b; 
        index( n,2 ) = a/b; 
        n            = n+1; 
    end 
end 

%remove all 0s, then reshapes the index(it turns into a column vector)
index( index == 0 ) = []; 
[~,c1] = size( index ); 
c2 = c1/2; 
index = reshape( index, [c2,2]); 
[c,~] = size( index ); 

index( :,3 ) = 0; 

% this is used to find the best dimensions: assumed to be the dimensions
% that minimize the difference between the two 
for d=1:c
    index( d,3 ) = abs(index(d,1)-index(d,2))/index(d,1); 
end 

m = min( index( :,3 ) ); 
m_in = find( index( :,3 ) == m ); 

s1 = index( m_in,1 ); 
s2 = index( m_in,2 ); 
 
end 



        