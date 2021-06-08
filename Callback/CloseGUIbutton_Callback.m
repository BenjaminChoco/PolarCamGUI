function CloseGUIbutton_Callback(source,eventdata)
    
    % Load global variables from the handles of hFig
    fig = get(source,'parent');
    handles = guidata(fig);

    vid = getappdata(handles.hFigure,'vid') ;

    flushdata(vid)
    imaqreset
    close(fig)
    
end