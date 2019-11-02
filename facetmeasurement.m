function [functionlocationfile,imagelocationfile]=facetmeasurement 
% I don't know anything about making guis? I guess I'll mess around with it
% here for a bit 

% Setting up screensize 
screen = get( 0,'ScreenSize' ); 
width = 600; 
height = 400; 

left = screen(3)/2 - width/2; 
bottom = screen(4)/2 - height/2; 

f1 = figure( 'Visible','off','Position',[ left,bottom,width,height] ); %selection windows?

%choosing file buttons
filechoosepanel = uipanel( 'Title','File Selection','Position',[48,282,497,96] ); 

functionlocationfile = uicontrol( ...
    'Style','pushbutton',...
    'String','Functions',...
    'Position',[18,49,132,24],...
    'Callback',@getffile_cb); 
% 
imagelocationfile = uicontrol(...
    'Style','pushbutton',...
    'String','Images',...
    'Position',[18,16,132,24],...
    'Callback',@getifile_cb); 
f1.Visible = 'on'; 
% 
% folder = uigetdir('Function location') ; 
% textlabel = sprintf( 'Function location is %s',folder ); 
% set( handletoyourtextlabel,'String',textlabel); 

% chosendir = uigetdir('Pick a directory, any directory');
% set(handles.edit1, 'String', chosendir);    %update edit box

align( [functionlocationfile,imagelocationfile],'Center','None' )


% functionlocationtext = uicontrol( 'Style','edit','Position',[161,49,319,22],...
%     'String',functionlocationfile);
% imagelocationtext = uicontrol( 'Style','edit','Position',[161,16,319,22],...
%     'String',imagelocationfile); 
% 
% align( [functionlocationtext,imagelocationtext],'Center','None' )

    function b = getffile_cb( source,eventdata ) 
        b = uigetdir; 
    end 

    function b = getifile_cb( source,eventdata )
        b = uigetdir; 
    end 


end 





