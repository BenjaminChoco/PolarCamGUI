function startbutton_Callback(source,eventdata)
    % Function ruling the start button :
    
    % Load gloabl variables from the handles of hFig
    fig = get(source,'parent');
    handles = guidata(fig);
    
    vid = getappdata(handles.hFigure,'vid') ;
    g = getappdata(handles.hFigure,'g') ;
    Wt_sparse = getappdata(handles.hFigure,'Wt_sparse') ;
    Dx = getappdata(handles.hFigure,'Dx') ;
    Dy = getappdata(handles.hFigure,'Dy') ;
    Ioffset = getappdata(handles.hFigure,'Ioffset') ;
    ax_hist = getappdata(handles.hFigure,'ax_hist') ;
    
    display = 1; % we enable the display of the video stream
    setappdata(handles.hFigure,'display', display) ;
    flushdata(vid)
    start(vid) % then start the transmission of images from the camera
    pause(1)

    % The loop will run until the display variable is set to an other
    % value :
    while display == 1
        display_type = getappdata(handles.hFigure,'display_type') ;
        display = getappdata(handles.hFigure,'display') ;
        
        
        Iraw = double(getsnapshot(vid))./g - Ioffset; % Acquisition of an image save in the variable I.
        setappdata(handles.hFigure,'Iraw',Iraw) ;
    %         wait(vid,1,"logging")
        
        I = Display(Iraw, Dx, Dy, display_type, Wt_sparse, vid);
        setappdata(handles.hFigure,'I',I) ;
        h = getappdata(handles.hFigure,'h') ;
        h.CData = I; % Update of the image with the handler of the display function 'imshow'.
        drawnow() % Used to refresh the display.
        h.XData = [1,2448];
        h.YData = [1,2048];
        setappdata(handles.hFigure,'h',h) ;
        
        if isvalid(ax_hist)
            ax_hist
            if isequal(display_type,'raw')
                histogram(ax_hist, I,'BinMethod','integers','DisplayStyle','stairs');
            end
            if isequal(display_type,'mos')
                [I0, I45, I90, I135] = SeparPolar(I);
                hold on
                histogram(ax_hist, I0,'DisplayStyle','stairs')
                histogram(ax_hist, I45,'DisplayStyle','stairs')
                histogram(ax_hist, I90,'DisplayStyle','stairs')
                histogram(ax_hist, I135,'DisplayStyle','stairs')
                hold off
                legend(ax_hist, '0°','45°','90°','135°')
                clear I0 I45 I90 I135
            end
            if or(isequal(display_type,'dolp'),isequal(display_type,'aop'))
                histogram(ax_hist, I,'DisplayStyle','stairs');
            end
            if isequal(display_type,'S0')
                histogram(ax_hist, I,'DisplayStyle','stairs');
            end
        end
        
    %         flushdata(vid) % We erase the image data save by the variable vid to keep memory occupation stable.
    end
    stop(vid) % stop the transmission of images by the camera
    
end