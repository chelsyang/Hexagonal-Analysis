function [ h ] = find_height( crop,scale ) 

stats = regionprops( crop,'centroid' ); 
cent = cat(1,stats.Centroid); 

y = round(cent( 1 )); 

pos1 = find( crop( :,y )==1 ); 

if isempty(pos1)
    rand = 1; 
end 

top = pos1( 1 ); 
bot = pos1( end ); 

length = bot-top+1; 
h = length*scale; 

end 
