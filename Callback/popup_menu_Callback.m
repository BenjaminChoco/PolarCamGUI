function popup_menu_Callback(source,eventdata) 
    % Enable to change the disaply mode (4D, DoLP, AoP, RAW)
    
    % Load gloabl variables from the handles of hFig
    fig = get(source,'parent');
    handles = guidata(fig);
    
    Iraw = getappdata(handles.hFigure,'Iraw') ;
    Wt_sparse = getappdata(handles.hFigure,'Wt_sparse') ;
    vid = getappdata(handles.hFigure,'vid') ;
    h = getappdata(handles.hFigure,'h') ;
    Dx = getappdata(handles.hFigure,'Dx') ;
    Dy = getappdata(handles.hFigure,'Dy') ;
    
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
    
    setappdata(handles.hFigure,'I',I) ;
    setappdata(handles.hFigure,'display_type',display_type) ;
    
    h.CData = I; % Update of the image with the handler of the display function 'imshow'.
    drawnow() % Used to refresh the display.
    h.XData = [1,2448];
    h.YData = [1,2048];
    
end