function plotError(world, e1, e2, f_size)
    % set up the figure
    set(gcf,'RendererMode','manual','Renderer','painters');
    cmap = colormap( 'jet' );
    colormap( flipud( cmap ) );

    clf;
    subplot(121);
%     WorldCor.y = flipud(WorldCor.y);
    pcolor(world.x, world.y, e1);
    %֮��Ҫ�ǵ÷�תy����
    shading flat
    caxis([0 2]); %������ȵ���ʾ��Χ
    set(gca, 'ydir', 'nor');
    axis equal;
    axis tight;
    xlabel('x (m)','FontSize',f_size);
    ylabel('y (m)','FontSize',f_size);
%     titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
%     'mmm dd yyyy, HH:MM' );
    title( 'timeCor','FontSize',f_size );
    h=colorbar('peer', gca);
    set(h, 'ydir', 'rev');
    set(get(h,'title'),'string', 'h (m)');
    
%     set(gca,'ydir','reverse','xaxislocation','top');
     set(gca,'ydir','reverse');
    
     
     
     %�ڶ���
      subplot(122);
%     WorldCor.y = flipud(WorldCor.y);
    pcolor(world.x, world.y, e2);
    %֮��Ҫ�ǵ÷�תy����
    shading flat
    caxis([0 2]); %������ȵ���ʾ��Χ
    set(gca, 'ydir', 'nor');
    axis equal;
    axis tight;
    xlabel('x (m)','FontSize',f_size);
    ylabel('y (m)','FontSize',f_size);
%     titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
%     'mmm dd yyyy, HH:MM' );
    title( 'cBathy','FontSize', f_size);
    h=colorbar('peer', gca);
    set(h, 'ydir', 'rev');
    set(get(h,'title'),'string', 'h (m)');
    
%     set(gca,'ydir','reverse','xaxislocation','top');
     set(gca,'ydir','reverse');
end