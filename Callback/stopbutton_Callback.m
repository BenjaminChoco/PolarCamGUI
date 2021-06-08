function stopbutton_Callback(source,eventdata)
  
    % Load gloabl variables from the handles of hFig
    fig = get(source,'parent');
    handles = guidata(fig);
    
    vid = getappdata(handles.hFigure,'vid') ;

    display = 0; % Set the variable to 0 to exit the loop in the startbuton_Callback function.
    flushdata(vid)
    
    setappdata(handles.hFigure,'display',display) ;
end