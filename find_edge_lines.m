%line between every corner picked out by corner function

function [lines]=find_edge_lines(corners)

%corners should be some value a by 2 
[a,~]=size(corners); 
lines=cell(a,1); 

%add last point to the end bc you need to find line that goes from last
%point to first point again
corners(end+1,:)=corners(1,:); 

%fuck it I'm making function handles rip
%will probably go from number to string to function handle :( until I find
%a better way
for b=1:a
    x=[corners(b,1),corners(b+1,1)]; 
    y=[corners(b,2),corners(b+1,2)]; 
    coeff=polyfit(x,y,1); %straight lines 
    sl=coeff(1)+0.000001; 
    int=coeff(2)+0.000001;
    
    funcprint=('@(x)%1$c*x+%2$c'); 
    func=sprintf(funcprint,sl,int); 
    %goes from the string to the function here
    lines{b}=str2func(func); 
end 
%thaaat should be it
end 
    
    