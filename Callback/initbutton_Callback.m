function initbutton_Callback(source,eventdata)
    % Function to reinitialize the camera link and settings.

    % Load gloabl variables from the handles of hFig
    fig = get(source,'parent');
    handles = guidata(fig);
    
    hpopup_init = getappdata(handles.hFigure,'hpopup_init') ;


    imaqreset % Reset all imaq device that may have been logged on recently and avoid some bugs..
    
    pixelformat = hpopup_init.String{hpopup_init.Value}
    vid = videoinput('gige', 1, pixelformat);
    src = getselectedsource(vid); % 'src' variable enables to rule the parameters of the camera.
    
    vid.FramesPerTrigger = 1; % Only 1 image is acquired when trigger is activated.
%     vid.TriggerRepeat = Inf; % When acquiring, the trigger is activated repeatedly. Use 'stop(vid)' to stop it.
    triggerconfig(vid, 'manual');
    
    src.DeviceStreamChannelPacketSize = 9000; % The packets size of the data transmitted is set to the maximum value. (recommended)
    src.PacketSize = 9000; % The packets size of the data transmitted is set to the maximum value. (recommended)
    src.PacketDelay = 200000; % A value around 10000 leads to a stable transmission with near 10 frames per second.
%     src.DeviceLinkThroughputLimit = 100000000; % default value : 125000000
%     framesPerSecond = CalculateFrameRate(vid, 10) % Mathwork function which calculate the numbre of frames per seconde transmited by the camera.

    src.DefectCorrectionEnable = 'False'; % One diseables the pixel correction.

    src.ExposureAuto = 'Off'; % Deactivate the auto exposure time.
    src.ExposureTime = 20000; % We set the initial exposure time. In ambiente light thi value doesn't saturate the camera.
    hexpo.String = src.ExposureTime; % The effective exposure time (may be a litle bit different from the asked one) is displayed on a text box. 
    hsizeX.String = 2448;
    hsizeY.String = 2048;
    
    setappdata(handles.hFigure,'vid',vid) ;
    setappdata(handles.hFigure,'src',src) ;
    setappdata(handles.hFigure,'hsizeX',hsizeX) ;
    setappdata(handles.hFigure,'hsizeY',hsizeY) ;
    setappdata(handles.hFigure,'hexpo',hexpo) ;
    src
end