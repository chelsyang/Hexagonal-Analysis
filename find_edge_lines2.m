function [ int,lines ] = find_edge_lines2( bord,pos,rotim,~ ) 
%INPUTS: 
% - bord: border points in image form(should STILL go through order points)
% - pos: ordered points 
% - rotim: image rotated to have 1100 on bottom 
% - size: size of particle in pixels
%OUTPUT: 
% - int: intersections of lines 
% - lines: edge lines, in...function handle form? Up for edits 
%About: 
% - trying Justins suggestion of just moving intercept of lines until stuff
% matches up 

%create lines 150 deg apart for moving and adjusting 
%specifically for dodecagons at the moment, ufe 
%will make/fit in pairs I think 

stats = regionprops(rotim); 
centroid = stats.Centroid; 

% horizontal and vertical lines 
m_array = zeros( 6,4 ); 
[ a,b ] = size( rotim ); 

m1 = 0; b1a = 1; b1b = centroid(2); b1c = a; 
m_array( 1,: ) = [ m1 b1a b1b b1c ]; 

m2 = tan( deg2rad(150) ); b2a = a - m2*b; b2b = centroid(2)-m2*centroid(1); b2c = 1-m2;  
m_array( 2,: ) = [ m2 b2a b2b b2c ]; 

m3 = tan( deg2rad(2*150) ); b3a = a-m3*b; b3b = centroid(2)-m3*centroid(1); b3c = 1-m3; 
m_array( 3,: ) = [ m3 b3a b3b b3c ]; 

%this one is the vertical one
%m3 = tan( deg2rad(3*150) ); b3a = a - m3*a; b3b = 0; 
%m_array( 4,: ) = [ m3 b3a b3b ];
m4 = inf; 
b4a = 1; 
b4b = centroid(1); 
b4c = b; 
m_array( 4,: ) = [ m4 b4a b4b b4c ]; 

m5 = tan( deg2rad(4*150) ); b5a = a-m5; b5b = centroid(2)-m5*centroid(1); b5c = 1 - m5*b;  
m_array( 5,: ) = [ m5 b5a b5b b5c ]; 

m6 = tan( deg2rad(5*150) ); b6a = a-m6; b6b = centroid(2)-m6*centroid(1); b6c = 1 - m6*b; 
m_array( 6,: ) = [ m6 b6a b6b b6c ]; 

% m6 = tan( deg2rad(6*150) ); b6a = a - m6*a; b6b = 0; 
% m_array( 7,: ) = [ m6 b6a b6b ]; 
%meh 
x_real = [ 1:b ]; 
y_real = pos( :,2 ); 

fin_lines = zeros( 6,3 );

for c = 1:6         
    
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
intm = get_int( lines,centroid ); 
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
    
function [ int ] = get_int( lines,centroid )

intm = zeros( 12,2 ); 
mt = 1; 

well = lines; 
well(4,:) = 0; 

centx = centroid( 1 ); 
centy = centroid( 2 ); 

absmax = max( well(:,1) ); 

for a = 1:2:5
        
    cm = lines( a,1 ); 
    cb1 = lines( a,2 ); 
    cb2 = lines( a,3 ); 

    a1 = [ 1:6 ];
    a1( a1==a ) =[]; 
    otherlines = lines( a1,: );

    ol_work = otherlines; 
    ol_work(:,1) = abs( ol_work(:,1)-cm );
    ol_work(:,2:3) = abs( ol_work(:,2:3)-cb1 ); 
    
    v_lines = find( otherlines(:,1)==max(otherlines(:,1)) ); 

    min_pos = find( ol_work(:,1) == min(ol_work(:,1)) ); 
    
    %need other way of determining which is nb and which is nob, currently
    %kind of easily broken
    
    % so I edited it and it's still not right....FIx 7/11
%     if ol_work(min_pos,2)>ol_work(min_pos,3) 
    nm = otherlines( min_pos,1); 
    nb = otherlines( min_pos,3); 
    nob = otherlines( min_pos,2 ); 

    int1x = (nb - cb1)/(cm - nm); 
    int1y = cm*int1x + cb1;
    dist1 = sqrt( (int1x-centx)^2 + (int1y-centy)^2 ); 

    o_int1x = ( nob - cb1 )/(cm - nm); 
    o_int1y = cm*o_int1x + cb1;
    dist2 = sqrt( (o_int1x-centx)^2 + (o_int1y-centy)^2 ); 

    if dist1 > dist2 
        intm( mt,: ) = [ o_int1x o_int1y ]; 
        mt = mt+1; 

        int1x = (nb - cb2)/(cm - nm); 
        int1y = cm*int1x + cb2; 

        intm( mt,: ) = [ int1x int1y ]; 
        mt = mt+1;

    elseif dist2 > dist1 
        intm( mt,: ) = [ int1x int1y ]; 
        mt = mt+1; 

        o_int1x = ( nob - cb2 )/(cm - nm); 
        o_int1y = cm*o_int1x + cb2; 

        intm( mt,: ) = [ o_int1x o_int1y ]; 
        mt = mt+1; 
%             
%     else 
%         nm = otherlines( min_pos,1 ); 
%         nb = otherlines( min_pos,2 ); 
%         nob = otherlines( min_pos,3 ); 
    end 

%     int1x = (nb - cb1)/(cm - nm); 
%     int1y = cm*int1x + cb1; 
% 
%     intm( mt,: ) = [ int1x int1y ]; 
%     mt = mt+1; 
% 
%     o_int1x = ( nob - cb2 )/(cm - nm ); 
%     o_int1y = cm*o_int1x + cb2; 
% 
%     intm( mt,: ) = [ o_int1x o_int1y ]; 
%     mt = mt+1; 

    ol_work(min_pos,:) = [ inf inf inf ]; 

    if abs( abs(cm)-absmax )<= 0.0001 
%         if ol_work(v_lines,2)>ol_work(v_lines,3)
%             int2x = otherlines( v_lines,3 ); 
%             o_int2x = otherlines( v_lines,2 ); 
%         elseif ol_work(v_lines,3)>ol_work(v_lines,2)
%             int2x = otherlines( v_lines,2 ); 
%             o_int2x = otherlines( v_lines,3 ); 
%         end  
%         int2y = cm*int2x + cb1; 
%         
%         intm( mt,: ) = [ int2x int2y ];
%         mt = mt+1; 
%         
%         o_int2y = cm*o_int2x + cb2; 
%         intm( mt,: ) = [ o_int2x o_int2y ]; 
%         mt = mt+1; 
        
        int2x = otherlines( v_lines,3 ); 
        
        int2y = cm*int2x + cb1; 
        dist12 = sqrt( (int2x-centx)^2 + (int2y-centy)^2 ); 

        o_int2y = cm*int2x + cb2; 
        dist22 = sqrt( (int2x-centx)^2 + (o_int2y-centy)^2 ); 
        
        if dist12 < dist22 
            intm( mt,: ) = [ int2x int2y ]; 
            mt = mt+1; 
            
            o_int2x = otherlines( v_lines,2 ); 
            o_int2y = cm*o_int2x + cb2; 
            
            intm( mt,: ) = [ o_int2x o_int2y ]; 
            mt = mt+1; 
        
        elseif dist22 < dist12 
           
            intm( mt,: ) = [ int2x o_int2y ]; 
            mt = mt+1; 
            
            o_int2x = otherlines( v_lines,2 ); 
            int2y = cm*o_int2x + cb1; 
            
            intm( mt,: ) = [ o_int2x int2y ]; 
            mt = mt+1; 
            
        end 
     
    else
        
        min_pos2 = find( ol_work(:,1) == min(ol_work(:,1)) ); 

        nm2 = otherlines( min_pos2,1); 
        nb2 = otherlines( min_pos2,3); 
        nob2 = otherlines( min_pos2,2 ); 

        int2x = (nb2 - cb2)/(cm - nm2); 
        int2y = cm*int2x + cb2;
        dist12 = sqrt( (int2x-centx)^2 + (int2y-centy)^2 ); 

        o_int2x = ( nob2 - cb2 )/(cm - nm2); 
        o_int2y = cm*o_int2x + cb2;
        dist22 = sqrt( (o_int2x-centx)^2 + (o_int2y-centy)^2 ); 

        if dist12 > dist22 
            intm( mt,: ) = [ o_int2x o_int2y ]; 
            mt = mt+1; 

            int2x = (nb2 - cb1)/(cm - nm2); 
            int2y = cm*int2x + cb1; 

            intm( mt,: ) = [ int2x int2y ]; 
            mt = mt+1;

        elseif dist22 > dist12 
            intm( mt,: ) = [ int2x int2y ]; 
            mt = mt+1; 

            o_int2x = ( nob - cb1 )/(cm - nm2); 
            o_int2y = cm*o_int2x + cb1; 

            intm( mt,: ) = [ o_int2x o_int2y ]; 
            mt = mt+1; 
    %             
    %     else 
    %         nm = otherlines( min_pos,1 ); 
    %         nb = otherlines( min_pos,2 ); 
    %         nob = otherlines( min_pos,3 ); 
        end 
%         if ol_work(min_pos2,2)>ol_work(min_pos2,3) 
%             nm2 = otherlines( min_pos2,1 ); 
%             nb2 = otherlines( min_pos2,3 );
%             nob2 = otherlines( min_pos2,2 ); 
% 
%         else 
%             nm2 = otherlines( min_pos2,1 ); 
%             nb2 = otherlines( min_pos2,2 );
%             nob2 = otherlines( min_pos2,3 ); 
%         end 
% 
%         int2x = (nb2 - cb1)/(cm - nm2); 
%         int2y = cm*int1x + cb1;
% 
%         intm( mt,: ) = [ int2x int2y ]; 
%         mt = mt+1; 
% 
%         o_int2x = ( nob2 - cb2 )/( cm - nm2 ); 
%         o_int2y = cm*o_int1y + cb2; 
% 
%         intm( mt,: ) = [ o_int2x o_int2y ]; 
%         mt = mt+1; 
        
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
    
    

    
        
        
        
