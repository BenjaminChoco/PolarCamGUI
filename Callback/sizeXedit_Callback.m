function sizeXedit_Callback(source,eventdata)
    
    % Load global variables from the handles of hFig
    fig = get(source,'parent');
    handles = guidata(fig);
    
    g = getappdata(handles.hFigure,'g') ;
    vid = getappdata(handles.hFigure,'vid') ;
    hexpo = getappdata(handles.hFigure,'hexpo') ;
    Ioffset_FullSize = getappdata(handles.hFigure,'Ioffset_FullSize') ;
    h = getappdata(handles.hFigure,'h') ;
    Wt_sparse = getappdata(handles.hFigure,'Wt_sparse') ;
%     Dx = getappdata(handles.hFigure,'Dx') ;
    Dy = getappdata(handles.hFigure,'Dy') ;
    display_type = getappdata(handles.hFigure,'display_type') ;
    
    
    roi = vid.ROIPosition;
    Dx = str2double(get(source,'String')); % Set the ROI as wrote in the text box.
    vid.ROIPosition = [floor((2448-Dx)/2) roi(2) Dx roi(4)];
    roi = vid.ROIPosition;
    source.String = roi(3); % write in the text box the effective exposure time used by the camera.
    flushdata(vid)
    
    Ioffset = Ioffset_FullSize((floor((2048-Dy)/2)+1):(floor((2048-Dy)/2) + Dy) , (floor((2448-Dx)/2)+1):(floor((2448-Dx)/2) + Dx) );
    
    src = getappdata(handles.hFigure,'src') ;
    hexpo.String = src.ExposureTime;
    Iraw = double(getsnapshot(vid))./g - Ioffset; % Acquisition of an image save in the variable I.
    I = Display(Iraw, Dx, Dy, display_type, Wt_sparse, vid);
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
    h.XData = [1,2448];
    h.YData = [1,2048];
%   flushdata(vid) % We erase the image data save by the variable vid to keep memory occupation stable.

    setappdata(handles.hFigure,'I',I) ;
    setappdata(handles.hFigure,'Ioffset',Ioffset) ;
    setappdata(handles.hFigure,'Dx',Dx) ;
    setappdata(handles.hFigure,'Iraw',Iraw) ;
    setappdata(handles.hFigure,'h',h) ;
    setappdata(handles.hFigure,'src',src) ;
    setappdata(handles.hFigure,'vid',vid) ;
    setappdata(handles.hFigure,'hexpo',hexpo) ;

end