function histbutton_Callback(source,eventdata)

    % Load global variables from the handles of hFig
    fig = get(source,'parent');
    handles = guidata(fig);

    vid = getappdata(handles.hFigure,'vid') ;
    Iraw = getappdata(handles.hFigure,'Iraw') ;
    Wt_sparse = getappdata(handles.hFigure,'Wt_sparse') ;
    Dx = getappdata(handles.hFigure,'Dx') ;
    Dy = getappdata(handles.hFigure,'Dy') ;
    display_type = getappdata(handles.hFigure,'display_type') ;

    I = Display(Iraw, Dx, Dy, display_type, Wt_sparse, vid);
    f_hist = figure('Visible','off','Position',[10,10,850,500]);
    ax_hist = axes(f_hist);
    if isequal(display_type,'raw')
        histogram(ax_hist, I,'BinMethod','integers','DisplayStyle','stairs');
    end
    if isequal(display_type,'mos')
        [I0, I45, I90, I135] = SeparPolar(Iraw);
        hold on
        histogram(ax_hist, I0,'DisplayStyle','stairs')
        histogram(ax_hist, I45,'DisplayStyle','stairs')
        histogram(ax_hist, I90,'DisplayStyle','stairs')
        histogram(ax_hist, I135,'DisplayStyle','stairs')
        hold off
        legend(sprintf('0° MEAN=%.2d / VAR=%.2d', mean(I0(:)), var(I0(:))),...
            sprintf('45°MEAN=%.2d / VAR=%.2d', mean(I45(:)), var(I45(:))),...
            sprintf('90°MEAN=%.2d / VAR=%.2d', mean(I90(:)), var(I90(:))),...
            sprintf('135° MEAN=%.2d / VAR=%.2d', mean(I135(:)), var(I135(:))))
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
    
    setappdata(handles.hFigure,'I',I) ;
    setappdata(handles.hFigure,'ax_hist',ax_hist) ;
end