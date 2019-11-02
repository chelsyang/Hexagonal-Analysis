function makereflines(lines,image,type) 

% I am TIRED OF DOING REFLINE 
%Honestly that's the only reason I make scripts anymore 

%ok no explanations because this is not worth 

[ a,~ ] = size( lines );
[ r,c ] = size( image ); 

for b = 1:a 
    if strcmp(type,'mb')
        line = refline( lines(b,1),lines(b,2) ); 
    elseif strcmp(type,'fh')
        fplot(lines(b))
    end 
    axis( [ 0 r 0 c ])
end 

end 