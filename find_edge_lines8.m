function [ int,lines ] = find_edge_lines8( bord,pos,rotim,~ ) 
%INPUTS: 
% - bord: border points in image form(should STILL go through order points)
% - pos: ordered points 
% - rotim: image rotated to have 1100 on bottom 
% - size: size of particle in pixels
%OUTPUT: 
% - int: intersections of lines 
% - lines: edge lines, in...function handle form? Up for edits 
%About: 
% matches up 
% - trying Justins suggestion of just moving intercept of lines until stuff

%THIS TIME FOR OCTAGONS 
%create lines 135 deg apart for moving and adjusting 
%will make/fit in pairs I think 

stats = regionprops(rotim); 
centroid = stats.Centroid; 

% horizontal and vertical lines 
m_array = zeros( 4,4 ); 
[ a,b ] = size( rotim ); 

m1 = 0; b1a = 1; b1b = centroid(2); b1c = a; 
m_array( 1,: ) = [ m1 b1a b1b b1c ]; 

m2 = tan( deg2rad(135) ); b2a = a - m2*b; b2b = centroid(2)-m2*centroid(1); b2c = 1-m2;  
m_array( 2,: ) = [ m2 b2a b2b b2c ]; 

m3 = tan( deg2rad(3*135) ); b3a = 0-m3*b; b3b = centroid(2)-m3*centroid(1); b3c = m3*a; 
m_array( 3,: ) = [ m3 b3a b3b b3c ]; 

%this one is the vertical one
%m3 = tan( deg2rad(3*150) ); b3a = a - m3*a; b3b = 0; 
%m_array( 4,: ) = [ m3 b3a b3b ];
m4 = inf; 
b4a = 1; 
b4b = centroid(1); 
b4c = b; 
m_array( 4,: ) = [ m4 b4a b4b b4c ]; 


% m5 = tan( deg2rad(4*135) ); b5a = a-m5; b5b = centroid(2)-m5*centroid(1); b5c = 1 - m5*b;  
% m_array( 5,: ) = [ m5 b5a b5b b5c ]; 
% 
% m6 = tan( deg2rad(5*135) ); b6a = a-m6; b6b = centroid(2)-m6*centroid(1); b6c = 1 - m6*b; 
% m_array( 6,: ) = [ m6 b6a b6b b6c ]; 

% m6 = tan( deg2rad(6*150) ); b6a = a - m6*a; b6b = 0; 
% m_array( 7,: ) = [ m6 b6a b6b ]; 
%meh 
x_real = [ 1:b ]; 
y_real = pos( :,2 ); 

fin_lines = zeros( 4,3 );

for c = 1:4         
    
    mc = m_array( c,1 )+0.00001; 
    bs = m_array( c,2 ); 
    bm = m_array( c,3 ); 
    bf = m_array( c,4 ); 
    
    if bs < bm
        b_array = [ round(bs):round(bm) ]; 
        b_array2 = [ round(bm):round(bf) ]; 
        start = 1; 
    elseif bm < bs 
        b_array = [ round(bm):round(bs) ]; 
        b_array2 = [ round(bf):round(bm) ]; 
        start = 0; 
    end 
    
    [ d ] = length( b_array ); 
    
    r2_check = zeros( d,2 ); 
    
    [ f ] = length( b_array2 ); 

    r2_check2 = zeros( f,2 ); 
    
    if c == 4 
        
        for e = 1:d 
            bc = round( b_array(e) ); 
            r2_check( e,1 ) = bc; 
            r2_check( e,2 ) = sum( bord( :,bc ) ); 
        end 
        
        for g = 1:f 
%             if g == 512 
%                 rand = 1; 
%             end 
            
            bc2 = round( b_array2(g) ); 
            r2_check2( g,1 ) = bc2; 
            r2_check2( g,2 ) = sum(bord( :,bc2 ) ); 
        end
        
        if std(r2_check(:,2))<2
            r2_check(r2_check(:,2)==0,2) = inf; 
            minpos = find( r2_check(:,2)~= inf); 
            
            if start == 1 
                mpos = minpos(1); 
            elseif start == 0 
                mpos = minpos(end); 
            end 
        else
            mpos = find( r2_check(:,2)==max(r2_check(:,2)) ); 
            
            if sum(size(mpos))>2
                mpos = mpos(end); 
            end 
            
        end 
       
        
        fin_lines( c,1 ) = inf; 
        fin_lines( c,2 ) = r2_check( mpos,1 ); 
        
        if std(r2_check2(:,2))<2
            r2_check2(r2_check2(:,2)==0,2) = inf; 
            minpos2 = find( r2_check2(:,2)~=inf);
            
            if start == 1 
                mpos2 = minpos2(end); 
            elseif start == 0 
                mpos2 = minpos2(1); 
            end 
            
        else
            mpos2 = find( r2_check2(:,2)==max(r2_check2(:,2)) ); 
        
            if sum(size(mpos2))>2
                mpos2 = mpos2(end); 
            end 
            
        end 
                
        if sum(size(mpos2))>2
            mpos2 = mpos2(end); 
        end 
        
%         fin_lines( c,3 ) = r2_check2( mpos2,1 ); 
        fin_lines( c,: ) = [ inf r2_check( mpos,1 ) r2_check2( mpos2,1 ) ]; 
        
    else
        %it's just going to be really long because there are so many
        %particles rip
        for e = 1:d 
             
            bc = b_array( e )+0.00001; 
            funcprint = ( '@(x)%1$c*x+%2$c' ); 
            func = sprintf( funcprint,mc,bc );
            funch = str2func( func ); 

            y_calc = round(funch( x_real )); 
            y_calc = y_calc'; 
            x_real = x_real'; 

            checkval = get_check( x_real,y_calc,bord ); 

            r2_check( e,1 ) = bc; 
            r2_check( e,2 ) = checkval; 

        end 
        
        if std(r2_check(:,2))<2 
            r2_check(r2_check(:,2)==0,2) = inf; 
            minpos = find( r2_check(:,2)~= inf); 
            
            if start == 1 
                mpos = minpos(1); 
            elseif start == 0 
                mpos = minpos(end); 
            end 
            
        else
            mpos = find( r2_check(:,2)==max(r2_check(:,2)) ); 
        end 

        if sum(size(mpos))>2
            mpos = mpos(end); 
        end 
        
%         fin_lines( c,1 ) = mc; 
%         fin_lines( c,2 ) = r2_check( mpos,1 ); 

        for g = 1:f

            bc2 = b_array2( g )+0.00001; 
            funcprint2 = ( '@(x)%1$c*x+%2$c' ); 
            func2 = sprintf( funcprint2,mc,bc2 );
            funch2 = str2func( func2 ); 

            y_calc2 = round(funch2( x_real )); 
            y_calc2 = y_calc2';  

            checkval2 = get_check( x_real,y_calc2,bord ); 

            r2_check2( g,1 ) = bc2; 
            r2_check2( g,2 ) = checkval2; 

        end 
        
        if std(r2_check2(:,2))<2 
            r2_check2(r2_check2(:,2)==0,2) = inf; 
            minpos2 = find( r2_check2(:,2)~=inf); 
            
            if start == 1 
                mpos2 = minpos2(end); 
            elseif start == 0 
                mpos2 = minpos2(1); 
            end 
            
        else
            mpos2 = find( r2_check2(:,2)==max(r2_check2(:,2)) ); 
            
            if sum(size(mpos2))>2
                mpos2 = mpos2(end); 
            end 
        
        end 

%         fin_lines( c,3 ) = r2_check2( mpos2,1 ); 
        fin_lines( c,: ) = [ mc r2_check(mpos,1) r2_check2( mpos2,1 )]; 
        
    end 
    
end 

lines = fin_lines; 
intm = get_int8( lines,centroid ); 
int = order_points( intm ); 

end 

function [ checkval ] = get_check( xs,ys,image ) 

[ r,c ] = size( image ); 
a = length( ys ); 
checkval = 0; 

for b = 1:a 
    
    if ys(b)>r
        ys(b) = r; 
    elseif ys(b)<=0 
        ys(b) = 1; 
    end 

    addval = image( ys(b),xs(b) ); 
    checkval = checkval + addval ; 
    
end 

end  
    
function [ int ] = get_int8( lines,centroid ) 

%set up "box" for the integers to go into
intm = zeros( 8,2 );

centx = centroid( 1 ); 
centy = centroid( 2 ); 

%find horizontal intersections 
b1 = lines( 1,2 ); 
bb1 = lines( 1,3 ); 

mt = 1; 

for a = 1:2 
    
    mn = lines( a+1,1 ); 
    bn = lines( a+1,2 ); 
    bbn = lines( a+1,3 ); 
    
    n1y_a = b1; 
    n1x_a = (b1-bn)/mn; 
    
    n1y_b = b1; 
    n1x_b = (b1-bbn)/mn; 
    
    dista = sqrt( (n1x_a-centx)^2 + (n1y_a-centy)^2 ); 
    distb = sqrt( (n1x_b-centx)^2 + (n1y_b-centy)^2 ); 
    
    if dista > distb 
        
        intm( mt,: ) = [ n1x_b n1y_b ]; 
        mt = mt+1; 
        
        rn1y_a = bb1; 
        rn1x_a = (bb1-bn)/mn; 
        
        intm( mt,: ) = [ rn1x_a rn1y_a ]; 
        mt = mt+1; 
        
    elseif dista < distb 
        
        intm( mt,: ) = [ n1x_a n1y_a ]; 
        mt = mt+1; 
        
        rn1y_b = bb1; 
        rn1x_b = (bb1-bbn)/mn; 
        
        intm( mt,: ) = [ rn1x_b rn1y_b ];
        mt = mt+1; 
        
    end 
    
end 

%find vertical intersections 

b4 = lines( 4,2 ); 
bb4 = lines( 4,3 ); 



for b = 1:2 
    
    mn = lines( b+1,1 ); 
    bn = lines( b+1,2 ); 
    bbn = lines( b+1,3 ); 
    
    n4y_a = mn*b4 + bn ; 
    n4x_a = b4; 
    
    n4y_b = mn*b4 + bbn; 
    n4x_b = b4; 
    
    dista = sqrt( (n4x_a-centx)^2 + (n4y_a-centy)^2 ); 
    distb = sqrt( (n4x_b-centx)^2 + (n4y_b-centy)^2 ); 
    
    if dista > distb 
        
        intm( mt,: ) = [ n4x_b n4y_b ]; 
        mt = mt+1; 
        
        rn4y_a = mn*bb4 + bn; 
        rn4x_a = bb4; 
        
        intm( mt,: ) = [ rn4x_a rn4y_a ]; 
        mt = mt+1; 
        
    elseif distb > dista 
        
        intm( mt,: ) = [ n4x_a n4y_a ]; 
        mt = mt+1; 
        
        rn4y_b = mn*bb4 + bbn; 
        rn4x_b = bb4; 
        
        intm( mt,: ) = [ rn4x_b rn4y_b ]; 
        mt = mt+1; 
        
    end 
    
end 

int = intm; 
 
end 
    
function [ordered_points] = order_points( og )

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
% - edit2: now a part of find_edge_lines2, took out the same x refiner 

c = 2; 
d = 1; 
ord = zeros( size(og) );
work = zeros( size(og) ); 
ord( 1,: ) = og( 1,: ); 

oge = og; 
oge( 1,: ) = [10000 10000]; 

while sum(sum(oge~=10000))>=1 
    
    work( :,1 ) = og( d,1 ); 
    work( :,2 ) = og( d,2 ); 
    
    oge1 = oge - work; 
    
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