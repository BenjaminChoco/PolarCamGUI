function savebutton_Callback(source,eventdata)

    % Load global variables from the handles of hFig
    fig = get(source,'parent');
    handles = guidata(fig);
    
    g = getappdata(handles.hFigure,'g') ;
    vid = getappdata(handles.hFigure,'vid') ;
    Ioffset = getappdata(handles.hFigure,'Ioffset') ;
    h = getappdata(handles.hFigure,'h') ;
    Wt_sparse = getappdata(handles.hFigure,'Wt_sparse') ;
    Dx = getappdata(handles.hFigure,'Dx') ;
    Dy = getappdata(handles.hFigure,'Dy') ;
    display_type = getappdata(handles.hFigure,'display_type') ;
    hsave_path = getappdata(handles.hFigure,'hsave_path') ;
    hsave_name = getappdata(handles.hFigure,'hsave_name') ;
    hsave_nb = getappdata(handles.hFigure,'hsave_nb') ;
    hpopup_save = getappdata(handles.hFigure,'hpopup_save') ;
    
    % Saving parameters :
    path = hsave_path.String;
    ExpName = hsave_name.String;
    Nb = str2double(hsave_nb.String);
    display = 1; % we enable the display of the video stream
    setappdata(handles.hFigure,'display',display) ;
    i = 0;
    flushdata(vid)
    start(vid) % then start the transmission of images from the camera
    pause(1)

    % The loop will run until the display variable is set to an other
    % value :
    tic
    while and(display == 1, i < Nb)
        display = getappdata(handles.hFigure,'display') ;
        i = i + 1;
        
        Iraw = double(getsnapshot(vid))./g - Ioffset; % Acquisition of an image saved in the variable I.
        setappdata(handles.hFigure,'Iraw',Iraw) ;
        
        I = Display(Iraw, Dx, Dy, display_type, Wt_sparse, vid);
        setappdata(handles.hFigure,'I',I) ;
        
        h.CData = I; % Update of the image with the handler of the display function 'imshow'.
        h.XData = [1,2448];
        h.YData = [1,2048];
        setappdata(handles.hFigure,'h',h) ;
        % saving the 4 polarisation separetely or the RAW image as
        % matfiles.
        if isequal(hpopup_save.Value, 2)
            [I0, I45, I90, I135] = SeparPolar(Iraw);
            save(strcat(path,'\',ExpName,'_I0_',sprintf('%d',i),'.mat'),'I0');
            save(strcat(path,'\',ExpName,'_I45_',sprintf('%d',i),'.mat'),'I45');
            save(strcat(path,'\',ExpName,'_I90_',sprintf('%d',i),'.mat'),'I90');
            save(strcat(path,'\',ExpName,'_I135_',sprintf('%d',i),'.mat'),'I135');
        else
            if Nb == 1
                save(strcat(path,'\',ExpName,'.mat'),'Iraw');
            else
                save(strcat(path,'\',ExpName,sprintf('_%d',i),'.mat'),'Iraw');
            end
        end

        drawnow() % Used to refresh the display.
    %         flushdata(vid) % We erase the image data save by the variable vid to keep memory occupation stable.
    end
    toc
    display = 0;
    setappdata(handles.hFigure,'display',display) ;
    stop(vid) % stop the transmission of images by the camera
    setappdata(handles.hFigure,'vid',vid) ;
end