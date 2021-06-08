function offsetedit_Callback(source,eventdata)
    % Function to control the offset of the camera
    
    % Load gloabl variables from the handles of hFig
    fig = get(source,'parent');
    handles = guidata(fig);
    
    g = getappdata(handles.hFigure,'g') ;
    src = getappdata(handles.hFigure,'src') ;
    vid = getappdata(handles.hFigure,'vid') ;
    Ioffset = getappdata(handles.hFigure,'Ioffset') ;
    h = getappdata(handles.hFigure,'h') ;
    Wt_sparse = getappdata(handles.hFigure,'Wt_sparse') ;
    Dx = getappdata(handles.hFigure,'Dx') ;
    Dy = getappdata(handles.hFigure,'Dy') ;
    display_type = getappdata(handles.hFigure,'display_type') ;
    
    src.BlackLevelRaw = str2double(get(source,'String')); % Set the exposure time as wrote in the text box.
    source.String = src.BlackLevelRaw; % write in the text box the effective exposure time used by the camera.
    flushdata(vid)

    Iraw = double(getsnapshot(vid))./g - Ioffset; % Acquisition of an image save in the variable I.
    I = Display(Iraw, Dx, Dy, display_type, Wt_sparse, vid);
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
    h.XData = [1,2448];
    h.YData = [1,2048];
%   flushdata(vid) % We erase the image data save by the variable vid to keep memory occupation stable.

    setappdata(handles.hFigure,'I',I) ;
    setappdata(handles.hFigure,'Iraw',Iraw) ;
    setappdata(handles.hFigure,'h',h) ;
    setappdata(handles.hFigure,'src',src) ;
    setappdata(handles.hFigure,'vid',vid) ;
end