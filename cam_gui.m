
% cam_gui create a window to visualize the videostream of the camera. It
% also enable us to choose between different processing applied to the
% images : separation of the polarisations for 4D imaging, DoLP processing,
% AoP processing or just the RAW image (no precessing).


imaqreset % Reset all imaq device that may have been logged on recently and avoid some bugs..

%%  Create and then hide the UI as it is being constructed.
% Color window parameters
DarkWindow = [0.1, 0.1, 0.1];
DarkBackground = [0.2, 0.2, 0.2];
DarkForeground = [0.8, 0.8, 0.8];

% Initialize the window
hFig = figure('Visible','off',...
            'Tag', 'hFigure', ...
            'Position',[200,200,900,550],...
            'Color',DarkWindow);

%% Construct the components.

% Creation of a 'initiate' button to initialize the camera with the pixel
% format selected in the popup menu :
htext_init = uicontrol('Style','text',...
             'String','Pixel Format : ',...
             'Position',[10,520,100,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);
 
hpopup_init = uicontrol('Style','popupmenu',...
           'String',{'Mono8','Mono12','Mono16', 'BayerRG8', 'BayerRG12', 'BayerRG16'},...
           'Position',[10,500,100,25],...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);  

hinit    = uicontrol('Style','pushbutton',...
             'String','(Re)Initialize camera','Position',[170,500,120,25],...
             'Callback',@initbutton_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);
       

% Modification of the offset :
htext_offset = uicontrol('Style','text','String','Offset :',...
           'Position',[10,470,100,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);
       
hoffset = uicontrol('style','Edit',...
           'String','0',...
           'Position',[10, 450 100 25],...
           'Callback',@offsetedit_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground); 
       
% Modification of the image size :
htext_size = uicontrol('Style','text','String','Size :',...
           'Position',[170,470,100,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);
       
htext_sizeX = uicontrol('Style','text','String','X :',...
           'Position',[140,450,20,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);
       
hsizeX = uicontrol('style','Edit',...
           'String','2448',...
           'Position',[160, 450 50 25],...
           'Callback',@sizeXedit_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);
       
htext_sizeY = uicontrol('Style','text','String','Y :',...
           'Position',[220,450,20,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);
       
hsizeY = uicontrol('style','Edit',...
           'String','2048',...
           'Position',[240, 450 50 25],...
           'Callback',@sizeYedit_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);
         
% Text box enabling to modify the exposition time :
htext_expo  = uicontrol('Style','text','String','ExposureTime (�s) :',...
           'Position',[10,410,100,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);

hexpo = uicontrol('style','Edit',...
           'String','20000',...
           'Position',[10, 390 100 25],...
           'Callback',@expoedit_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);

% Histogram plot :
hhist = uicontrol('style','pushbutton',...
           'String','hist',...
           'Position',[170, 390 100 25],...
           'Callback',@histbutton_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);     

       
% Creation of start/stop buttons to lauch and stop the visualisation of a
% video stream :
htext_stream = uicontrol('Style','text',...
             'String','Video stream control :',...
             'Position',[50,330,150,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);

% 'start to start a video stream :
hstart    = uicontrol('Style','pushbutton',...
             'String','start','Position',[10,310,70,25],...
             'Callback',@startbutton_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);

% 'stop' to stop the video stream :
hstop    = uicontrol('Style','pushbutton',...
             'String','stop','Position',[150,310,70,25],...
             'Callback',@stopbutton_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);
        
htext_mode  = uicontrol('Style','text','String','Display choice :',...
           'Position',[50,280,100,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);

% Popup menu enabling to choose between the different processings to apply
% to the image : (4D, DOLP, AOP, RAW).
hpopup = uicontrol('Style','popupmenu',...
           'String',{'Mosaique', 'DOLP', 'AOP', 'Raw', 'S0', 'HSV'},...
           'Position',[50,260,100,25],...
           'Callback',@popup_menu_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);       
       

% Saving menu : to save image series
htext_save = uicontrol('Style','text','String','Saving tools :',...
           'Position',[50,190,100,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);

htext_save_nb = uicontrol('Style','text','String','nb of frames to save :',...
           'Position',[0,160,140,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);
hsave_nb = uicontrol('style','Edit',...
           'String','1',...
           'Position',[0, 140 60 25],...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);

htext_save_path = uicontrol('Style','text','String','Path :',...
           'Position',[50,100,150,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);

hsave_path  = uicontrol('Style','Edit','String','C:\Users\Benjamin\Desktop\CamData\Tests',...
           'Position',[50,85,200,25],...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);

htext_save_name = uicontrol('Style','text','String','Experience name :',...
           'Position',[150,160,150,25],...
             'BackgroundColor', DarkWindow,...
             'ForegroundColor', DarkForeground);

hsave_name  = uicontrol('Style','Edit','String','MyExp',...
           'Position',[150,140,100,25],...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);
       
hpopup_save = uicontrol('Style','popupmenu',...
           'String',{'RAW','4 Polarizations'},...
           'Position',[10,50,100,25],...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);
       
hsave_btn = uicontrol('style','pushbutton',...
           'String','save',...
           'Position',[170, 50, 100, 25],...
           'Callback',@savebutton_Callback,...
             'BackgroundColor', DarkBackground,...
             'ForegroundColor', DarkForeground);

       
hclosegui_btn = uicontrol('style','pushbutton',...
           'String','Close GUI',...
           'Position',[170, 20, 100, 25],...
           'Callback',@CloseGUIbutton_Callback, 'BackgroundColor', 'r');
       
%% Initialisation of the image size and position. 
ha = axes('Units','pixels','Position',[300,0,550,550]);

% Making the different button well aligned.
align([htext_save_path, hsave_path, htext_save,...
    htext_stream, htext_mode, hpopup],'Center','None');

align([htext_offset, hoffset, htext_init, hpopup_init, hstart, htext_save_nb, hsave_nb, hexpo, htext_expo, hpopup_save],'Center','None');
align([hinit, hstop, htext_save_name, hsave_name, hhist, hsave_btn, hclosegui_btn],'Center','None');   


% Initialize the UI.
% Change units to normalized so components resize automatically.
hFig.Units = 'normalized';
ha.Units = 'normalized';
hstart.Units = 'normalized';
hstop.Units = 'normalized';
hpopup.Units = 'normalized';
hexpo.Units = 'normalized';
htext_expo.Units = 'normalized';
hsave_nb.Units = 'normalized';
hsave_btn.Units = 'normalized';
htext_stream.Units = 'normalized';
htext_save_nb.Units = 'normalized';
htext_save_path.Units = 'normalized';
hsave_path.Units = 'normalized';
htext_save_name.Units = 'normalized';
hsave_name.Units = 'normalized';
htext_save.Units = 'normalized';
htext_mode.Units = 'normalized';
hpopup_init.Units = 'normalized';
hhist.Units = 'normalized';
htext_init.Units = 'normalized';
hinit.Units = 'normalized';
hpopup_save.Units = 'normalized';
htext_offset.Units = 'normalized';
hoffset.Units = 'normalized';
htext_size.Units = 'normalized';
htext_sizeX.Units = 'normalized';
hsizeX.Units = 'normalized';
htext_sizeY.Units = 'normalized';
hsizeY.Units = 'normalized';
hclosegui_btn = 'normalized';

%% Initiate camera/ check which camera is connected
imaqreset
try
    vid = videoinput('gige', 1, 'Mono12'); % 'vid' variable enable to drive the camera.
    hpopup_init.Value = 2;
catch
    warning('Mono12 pixel format isn t available on this camera, BayerRG12 format will be used insted if available');
    try
        vid = videoinput('gige', 1, 'BayerRG12'); % 'vid' variable enable to drive the camera.
        hpopup_init.Value = 5;
        vid.ReturnedColorSpace = 'grayscale';
    catch exception
%         msg = 'Mono12 and BayerRG12 pixel format aren t available on this camera';
%         exception = addCause(exception, msg);
        rethrow(exception)
    end
end

%% Initialisation of the camera parameters
flushdata(vid)
src = getselectedsource(vid); % 'src' variable enable to rule the parameters of the camera.
vid.FramesPerTrigger = 1; % Only 1 image is acquire when trigger is activated.
% vid.TriggerRepeat = Inf; % When acquiring, the trigger is activated repeatedly. Use 'stop(vid)' to stop it.
triggerconfig(vid, 'manual');

src.DeviceStreamChannelPacketSize = 9000; % The packets size of the data transmitted is set to the maximum value. (recommended)
src.PacketSize = 9000; % The packets size of the data transmitted is set to the maximum value. (recommended)
src.PacketDelay = 100000; % A value around 10000 lead to a stable transmission with near 10 frames per second.
src.AcquisitionFrameRateEnable = 'False';
% src.AcquisitionFrameRate = 2; % Frame rate fixed.
% framesPerSecond = CalculateFrameRate(vid, 10) % Mathwork function which calculate the numbre of frames per seconde transmited by the camera.

src.DefectCorrectionEnable = 'False'; % One diseable the pixel correction.

src.ExposureAuto = 'Off'; % Deactivate the auto exposure time.
src.ExposureTime = 20000; % We set the initial exposure time. In ambiente light thi value doesn't saturate the camera.
hexpo.String = src.ExposureTime; % The effective exposure time (may be a litle bit different from the asked one) is displayed on a text box.

src.BlackLevelRaw = 5; % Set the Offset to 5.
hoffset.String = src.BlackLevelRaw; %Show the effective offset


%% Loading the polarim�tric calibration matrix : Wt_sparse (pseudo inverse
% of W)
g = 0.37; % (ADU/e-)
Wt_sparse = load('CalibrationData\Wt_sparse');
Wt_sparse = Wt_sparse.Wt_sparse;

% Size of the images
Dx = 2448;
Dy = 2048;

%% Acquisition of a first image to initialize the display window :
imaqfind
start(vid) % start the transmission of images
pause(1)
Iraw = getsnapshot(vid); % Acquisition of an image save in the variable I.
stop(vid) % Stop the transmission of images.

% Initial correction of the DSNU
Ioffset_FullSize = load('CalibrationData\DSNU_20ms_Ne.mat');
Ioffset_FullSize = double(getfield(Ioffset_FullSize, cell2mat(fieldnames(Ioffset_FullSize))));
% Ioffset_FullSize = ones(size(Iraw))*5./g;
Ioffset = Ioffset_FullSize;
Iraw = double(Iraw)/g - Ioffset;

% We initialy use the 4D display for wich we separate the polarisations.
I = MosaicPolar(Iraw); % Custom function to separate the different polarisation into 4 quadrants of the image.

% Diplay an image
% h=imshow(I); % We create a 'handler' h which enables to change the image without relaoding the window.
h = imagesc(I);
colormap gray
axis equal
colorbar('Color',[0.8 0.8 0.8])
axis off

%% Assign the a name to appear in the window title.
hFig.Name = 'PolarCam GUI';

% Move the window to the center of the screen.
movegui(hFig,'center')

% We display in the CommandeWindow the parameters of the camera.
vid
src


%% Display On
% Make the window visible.
hFig.Visible = 'on';

% We initiate the display mode to the 4D display (a mosaique of the 4 different polarisations).
display_type = 'mos';

% The video stream is initialy disabled
display = 0; % variable enabling/disabling the video stream.

%% Storage of global variables in the handle of hFig
handles = guihandles(hFig) ;
guidata(hFig,handles) ;

setappdata(handles.hFigure,'vid',vid) ;
setappdata(handles.hFigure,'src',src) ;
setappdata(handles.hFigure,'g',g) ;
setappdata(handles.hFigure,'Wt_sparse',Wt_sparse) ;
setappdata(handles.hFigure,'Dx',Dx) ;
setappdata(handles.hFigure,'Dy',Dy) ;
setappdata(handles.hFigure,'Iraw',Iraw) ;
setappdata(handles.hFigure,'Ioffset',Ioffset) ;
setappdata(handles.hFigure,'Ioffset_FullSize',Ioffset_FullSize) ;
setappdata(handles.hFigure,'I',I) ;
setappdata(handles.hFigure,'h',h) ;
setappdata(handles.hFigure,'display_type',display_type) ;
setappdata(handles.hFigure,'display',display) ;

setappdata(handles.hFigure,'hpopup_init',hpopup_init) ;
setappdata(handles.hFigure,'hsizeX',hsizeX) ;
setappdata(handles.hFigure,'hsizeY',hsizeY) ;
setappdata(handles.hFigure,'hexpo',hexpo) ;
setappdata(handles.hFigure,'hsave_nb',hsave_nb) ;
setappdata(handles.hFigure,'hsave_path',hsave_path) ;
setappdata(handles.hFigure,'hsave_name',hsave_name) ;
setappdata(handles.hFigure,'hpopup_save',hpopup_save) ;


f_hist = figure('Visible','off','Position',[10,10,850,500]);
ax_hist = axes(f_hist);
delete f_hist ax_hist
setappdata(handles.hFigure,'ax_hist',ax_hist) ;



%{
%% Function to (re)initialize the camera :
function initbutton_Callback(source,eventdata)
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
    framesPerSecond = CalculateFrameRate(vid, 10) % Mathwork function which calculate the numbre of frames per seconde transmited by the camera.

    src.DefectCorrectionEnable = 'False'; % One diseables the pixel correction.

    src.ExposureAuto = 'Off'; % Deactivate the auto exposure time.
    src.ExposureTime = 20000; % We set the initial exposure time. In ambiente light thi value doesn't saturate the camera.
    hexpo.String = src.ExposureTime; % The effective exposure time (may be a litle bit different from the asked one) is displayed on a text box. 
    hsizeX.String = 2448;
    hsizeY.String = 2048;
    src
end
%}

%{
%% popup menu function:
% Enable to change the disaply mode (4D, DoLP, AoP, RAW)
function popup_menu_Callback(source,eventdata) 
    % Determine the selected data set.
    str = get(source, 'String');
    val = get(source,'Value');
    % Set current data to the selected data set.
    switch str{val}
    case 'Mosaique' % Choice of a 4D mosaic display
        display_type = 'mos';
        I = MosaicPolar(Iraw);
        colormap gray

    case 'DOLP'
        display_type = 'dolp';
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        I = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
        I(I>1) = 1;
        I(I<0) = 0;
        colormap parula

    case 'AOP' % Choice of AoP display
        display_type = 'aop';
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        I = (180/pi)*Stokes2AoP(S(:,:,2),S(:,:,3));
        colormap hsv

    case 'Raw' % Choice of RAW display
        display_type = 'raw';
        if or(isequal(vid.VideoFormat, 'Mono16'), isequal(vid.VideoFormat, 'BayerRG16'))
            I = uint8(Iraw/256);
        else
            I = Iraw; % Raw image without any process.
        end
        colormap gray
        
    case 'S0' % Choice of RAW display
        display_type = 'S0';
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        I = S(:,:,1);
        colormap gray
    case 'HSV' 
        display_type = 'hsv';
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        
        DoLP = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
        DoLP(DoLP>1) = 1;
        DoLP(DoLP<0) = 0;
        
        AoP = pi + Stokes2AoP(S(:,:,2),S(:,:,3));
        
        Hue = AoP/max(max(AoP));
        Sat = DoLP;
%         Val = S(:,:,1)./max(max(S(:,:,1)));
        Val = max(cat(3, DoLP, S(:,:,1)./max(max(S(:,:,1)))),[],3);

        HSV = cat(3,Hue,Sat,Val);
        I = hsv2rgb(HSV);
    end
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
    h.XData = [1,2448];
    h.YData = [1,2048];
end
%}

%{
%% Function ruling the start button :
function startbutton_Callback(source,eventdata)
  display = 1; % we enable the display of the video stream
  flushdata(vid)
  start(vid) % then start the transmission of images from the camera
  pause(1)
  
  % The loop will run until the display variable is set to an other
  % value :
   while display == 1
        Iraw = double(getsnapshot(vid))./g - Ioffset; % Acquisition of an image save in the variable I.
%         wait(vid,1,"logging")
        
        I = Display();
        h.CData = I; % Update of the image with the handler of the display function 'imshow'.
        drawnow() % Used to refresh the display.
        h.XData = [1,2448];
        h.YData = [1,2048];
%         flushdata(vid) % We erase the image data save by the variable vid to keep memory occupation stable.
   end
   stop(vid) % stop the transmission of images by the camera
end
%}

%{
function stopbutton_Callback(source,eventdata)
  display = 0; % Set the variable to 0 to exit the loop in the startbuton_Callback function.
  flushdata(vid)
end
%}

%{
%% Exposure time control
function expoedit_Callback(source,eventdata)
    src.ExposureTime = str2double(get(source,'String')); % Set the exposure time as wrote in the text box.
    source.String = src.ExposureTime; % write in the text box the effective exposure time used by the camera.
    flushdata(vid)

    Iraw = double(getsnapshot(vid))./g - Ioffset; % Acquisition of an image save in the variable I.
    hexpo.String = src.ExposureTime;
    I = Display();
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    h.XData = [1,2448];
    h.YData = [1,2048];
    drawnow() % Used to refresh the display.
%   flushdata(vid) % We erase the image data save by the variable vid to keep memory occupation stable.
end
%}

%{
%% Offset control
function offsetedit_Callback(source,eventdata)
    src.BlackLevelRaw = str2double(get(source,'String')); % Set the exposure time as wrote in the text box.
    source.String = src.BlackLevelRaw; % write in the text box the effective exposure time used by the camera.
    flushdata(vid)

    Iraw = getsnapshot(vid)./g; % Acquisition of an image save in the variable I.
    I = Display();
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
    h.XData = [1,2448];
    h.YData = [1,2048];
%   flushdata(vid) % We erase the image data save by the variable vid to keep memory occupation stable.
end
%}

%{
%% Regin of Interest (ROI) :
function sizeXedit_Callback(source,eventdata)
    roi = vid.ROIPosition;
    Dx = str2double(get(source,'String')); % Set the ROI as wrote in the text box.
    vid.ROIPosition = [floor((2448-Dx)/2) roi(2) Dx roi(4)];
    roi = vid.ROIPosition;
    source.String = roi(3); % write in the text box the effective exposure time used by the camera.
    flushdata(vid)
    
    hexpo.String = src.ExposureTime;
    Iraw = getsnapshot(vid)./g; % Acquisition of an image save in the variable I.
    I = Display();
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
    h.XData = [1,2448];
    h.YData = [1,2048];
%   flushdata(vid) % We erase the image data save by the variable vid to keep memory occupation stable.
end
%}

%{
function sizeYedit_Callback(source,eventdata)
    roi = vid.ROIPosition;
    Dy = str2double(get(source,'String')); % Set the ROI as wrote in the text box.

    vid.ROIPosition = [roi(1) floor((2048-Dy)/2) roi(3) Dy];
    roi = vid.ROIPosition;
    source.String = roi(4); % write in the text box the effective exposure time used by the camera.
    flushdata(vid)
    
    hexpo.String = src.ExposureTime;
    Iraw = getsnapshot(vid)./g; % Acquisition of an image save in the variable I.
    I = Display();
    h.XData = [1,2448];
    h.YData = [1,2048];
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
%   flushdata(vid) % We erase the image data save by the variable vid to keep memory occupation stable.
end
%}

%{
%% Saving function
function savebutton_Callback(source,eventdata)
  % Saving parameters :
  path = hsave_path.String;
  ExpName = hsave_name.String;
  Nb = str2double(hsave_nb.String) ;
  display = 1; % we enable the display of the video stream
  i = 0;
  flushdata(vid)
  start(vid) % then start the transmission of images from the camera
  pause(1)
  
  % The loop will run until the display variable is set to an other
  % value :
  tic
   while and(display == 1, i < Nb)
        i = i + 1;
        Iraw = double(getsnapshot(vid))./g - Ioffset; % Acquisition of an image save in the variable I.

        I = Display();
        h.CData = I; % Update of the image with the handler of the display function 'imshow'.
        h.XData = [1,2448];
        h.YData = [1,2048];
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
   stop(vid) % stop the transmission of images by the camera
end
%}

%{
%% Display histogram
function histbutton_Callback(source,eventdata)
    I = Display();
    f_hist = figure('Visible','off','Position',[10,10,850,500]);
    if isequal(display_type,'raw')
        histogram(I,'BinMethod','integers','DisplayStyle','stairs');
    end
    if isequal(display_type,'mos')
        [I0, I45, I90, I135] = SeparPolar(I);
        hold on
        histogram(I0,'DisplayStyle','stairs')
        histogram(I45,'DisplayStyle','stairs')
        histogram(I90,'DisplayStyle','stairs')
        histogram(I135,'DisplayStyle','stairs')
        hold off
        legend('0�','45�','90�','135�')
        clear I0 I45 I90 I135
    end
    if or(isequal(display_type,'dolp'),isequal(display_type,'aop'))
        histogram(I,'DisplayStyle','stairs');
    end
    if isequal(display_type,'S0')
        histogram(I,'DisplayStyle','stairs');
    end
    grid on
    f_hist.Visible = 'on';
end
%}

%{
%% General display control
function [I] = Display()
    if isequal(display_type,'mos')
        I = MosaicPolar(Iraw); % Custom function to separate the different polarisation into 4 quadrants of the image.
        colormap gray
    end
    if isequal(display_type,'dolp')
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        I = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
        I(I>1) = 1;
        I(I<0) = 0;
        colormap parula
    end
    if isequal(display_type,'aop')
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        I = (180/pi)*Stokes2AoP(S(:,:,2),S(:,:,3));
        colormap hsv
    end
    if isequal(display_type,'raw')
        if or(isequal(vid.VideoFormat, 'Mono16'), isequal(vid.VideoFormat, 'BayerRG16'))
            I = uint8(Iraw/256);
        else
            I = Iraw; % Raw image without any process.
        end
        colormap gray
    end
    if isequal(display_type,'S0')
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        I = S(:,:,1);
        colormap gray
    end
    if isequal(display_type,'hsv')
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        
        DoLP = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
        DoLP(DoLP>1) = 1;
        DoLP(DoLP<0) = 0;
        
        AoP = pi + Stokes2AoP(S(:,:,2),S(:,:,3));
        
        Hue = AoP/max(max(AoP));
        Sat = DoLP;
%         Val = S(:,:,1)./max(max(S(:,:,1)));
        Val = max(cat(3, DoLP, S(:,:,1)./max(max(S(:,:,1)))),[],3);

        HSV = cat(3,Hue,Sat,Val);
        I = hsv2rgb(HSV);
        
    end
end
%}

%{
%% Function for closing the GUI and resetting the camera

function CloseGUIbutton_Callback(source,eventdata)
    flushdata(vid)
    imaqreset
    close(hFig)
end
%}

