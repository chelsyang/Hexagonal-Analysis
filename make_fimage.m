function [ figure1 ] = make_fimage( image,oimage,lines,int,f1100,f1120 )

figure1 = figure( 'visible','off' ); 
imshowpair( image,oimage,'diff' )

[ r,c ] = size( oimage ); 
%[ b,~ ] = size( lines ); 
    
a1 =refline(lines(1,1),lines(1,2));
a2 = refline(lines(1,1),lines(1,3));
a3 = refline(lines(2,1),lines(2,2));
a4 = refline(lines(2,1),lines(2,3));
a5 = refline(lines(3,1),lines(3,2));
a6 = refline(lines(3,1),lines(3,3));
a7 =line([lines(4,2) lines(4,2)],[1 r]);
a8 = line([lines(4,3) lines(4,3)],[1 r]);
a9 =refline(lines(5,1),lines(5,2));
a10 = refline(lines(5,1),lines(5,3));
a11 =refline(lines(6,1),lines(6,2));
a12 = refline(lines(6,1),lines(6,3));

% a1.Color = 'b';
a1.LineWidth = 2;
% a2.Color = 'b';
a2.LineWidth = 2;
%a3.Color = 'b';
a3.LineWidth = 2;
%a4.Color = 'b';
a4.LineWidth = 2;
%a5.Color = 'b';
a5.LineWidth = 2;
%a6.Color = 'b';
a6.LineWidth = 2;
%a7.Color = 'b';
a7.LineWidth = 2;
%a8.Color = 'b';
a8.LineWidth = 2;
%a9.Color = 'b';
a9.LineWidth = 2;
%a10.Color = 'b';
a10.LineWidth =2;
%a11.Color = 'b';
a11.LineWidth = 2;
%a12.Color = 'b';
a12.LineWidth = 2;
axis([ 0 r 0 c])
axis on

hold on 
plot( int(:,1),int(:,2),'*g','MarkerSize',8 )

if abs(round(int(1,2) - int(2,2))) < 2

    mpx1 = (int(1,1)+int(2,1))/2 ;
    mpy1 = (int(1,2)+int(2,2))/2;

    mpx2 = (int(2,1)+int(3,1))/2 ;
    mpy2 = (int(2,2)+int(3,2))/2;

    mpx3 = (int(3,1)+int(4,1))/2 ;
    mpy3 = (int(3,2)+int(4,2))/2;

    mpx4 = (int(4,1)+int(5,1))/2 ;
    mpy4 = (int(4,2)+int(5,2))/2;

    mpx5 = (int(5,1)+int(6,1))/2 ;
    mpy5 = (int(5,2)+int(6,2))/2;

    mpx6 = (int(6,1)+int(7,1))/2 ;
    mpy6 = (int(6,2)+int(7,2))/2;

    mpx7 = (int(7,1)+int(8,1))/2 ;
    mpy7 = (int(7,2)+int(8,2))/2;

    mpx8 = (int(8,1)+int(9,1))/2 ;
    mpy8 = (int(8,2)+int(9,2))/2;

    mpx9 = (int(9,1)+int(10,1))/2 ;
    mpy9 = (int(9,2)+int(10,2))/2;

    mpx10 = (int(10,1)+int(11,1))/2 ;
    mpy10= (int(10,2)+int(11,2))/2;

    mpx11 = (int(11,1)+int(12,1))/2 ;
    mpy11 = (int(11,2)+int(12,2))/2;

    mpx12 = (int(12,1)+int(1,1))/2 ;
    mpy12 = (int(12,2)+int(1,2))/2;
    
elseif abs(round(int(1,2) - int(2,2))) >= 2
    
    mpx2 = (int(1,1)+int(2,1))/2 ;
    mpy2 = (int(1,2)+int(2,2))/2;

    mpx1 = (int(2,1)+int(3,1))/2 ;
    mpy1 = (int(2,2)+int(3,2))/2;

    mpx4 = (int(3,1)+int(4,1))/2 ;
    mpy4 = (int(3,2)+int(4,2))/2;

    mpx3 = (int(4,1)+int(5,1))/2 ;
    mpy3 = (int(4,2)+int(5,2))/2;

    mpx6 = (int(5,1)+int(6,1))/2 ;
    mpy6 = (int(5,2)+int(6,2))/2;

    mpx5 = (int(6,1)+int(7,1))/2 ;
    mpy5 = (int(6,2)+int(7,2))/2;

    mpx8 = (int(7,1)+int(8,1))/2 ;
    mpy8 = (int(7,2)+int(8,2))/2;

    mpx7 = (int(8,1)+int(9,1))/2 ;
    mpy7 = (int(8,2)+int(9,2))/2;

    mpx10 = (int(9,1)+int(10,1))/2 ;
    mpy10 = (int(9,2)+int(10,2))/2;

    mpx9 = (int(10,1)+int(11,1))/2 ;
    mpy9= (int(10,2)+int(11,2))/2;

    mpx12 = (int(11,1)+int(12,1))/2 ;
    mpy12 = (int(11,2)+int(12,2))/2;

    mpx11 = (int(12,1)+int(1,1))/2 ;
    mpy11 = (int(12,2)+int(1,2))/2;
    
end 

txt1 = num2str(f1100(1));
txt3 = num2str(f1100(2));
txt5 = num2str(f1100(3));
txt7 = num2str(f1100(4));
txt9 = num2str(f1100(5));
txt11 = num2str(f1100(6));
txt2 = num2str(f1120(1));
txt4 = num2str(f1120(2));
txt6 = num2str(f1120(3));
txt8 = num2str(f1120(4));
txt10 = num2str(f1120(5));
txt12 = num2str(f1120(6));

text(mpx1,mpy1,txt1,'Color','red')
text(mpx2,mpy2,txt2,'Color','red')
text(mpx3,mpy3,txt3,'Color','red')
text(mpx4,mpy4,txt4,'Color','red')
text(mpx5,mpy5,txt5,'Color','red')
text(mpx6,mpy6,txt6,'Color','red')
text(mpx7,mpy7,txt7,'Color','red')
text(mpx8,mpy8,txt8,'Color','red')
text(mpx9,mpy9,txt9,'Color','red')
text(mpx10,mpy10,txt10,'Color','red')
text(mpx11,mpy11,txt11,'Color','red')
text(mpx12,mpy12,txt12,'Color','red')

end 