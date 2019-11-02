function origin = find_origin( centroids,image ) 

[ a,b ] = size(image); 
por_r = round(a/2); 
por_c = round(b/2): 

dists_r = (centroids(:,1).-por_r).^2; 
dists_c = (centroids(:,2).-por_c).^2; 

dists = (dists_r+dists_c).^0.5; 
minpos = find( dists==min(dists) ); 

origin = centroids(minpos,:); 

end 