function plotGtTimeCBathy(world, gt, timeCor, cBathy, f_size)
    
    set(gcf,'RendererMode','manual','Renderer','painters');
    cmap = colormap( 'jet' );
    colormap( flipud( cmap ) );
    
	clf; %���ͼ���ϵ�����clear figure
    subplot(131); % the first image is ground truth.
    pcolor(world.x, world.y, gt);
    %֮��Ҫ�ǵ÷�תy����
    shading flat
    caxis([0 5]); %������ȵ���ʾ��Χ
    set(gca, 'ydir', 'nor');
    axis equal;
    axis tight;
    xlabel('x (m)','FontSize',f_size);
    ylabel('y (m)','FontSize',f_size);
%     titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
%     'mmm dd yyyy, HH:MM' );
%     title_name = "testBathy";
    title('���˴�������ʵֵ','FontSize',f_size);
    h=colorbar('peer', gca);
    set(h, 'ydir', 'rev');
    set(get(h,'title'),'string', 'h (m)');
    set(gca,'ydir','reverse');

    

    subplot(132);
    pcolor(world.x, world.y, timeCor);

    shading flat
    caxis([0 5]); %������ȵ���ʾ��Χ
    set(gca, 'ydir', 'nor');
    axis equal;
    axis tight;
    xlabel('x (m)','FontSize',f_size);
    ylabel('y (m)','FontSize',f_size);
%     titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
%     'mmm dd yyyy, HH:MM' );
%     title_name = "testBathy";
    title('timeCor','FontSize',f_size);
    h=colorbar('peer', gca);
    set(h, 'ydir', 'rev');
    set(get(h,'title'),'string', 'h (m)');
    set(gca,'ydir','reverse');
    
   
    
    subplot(133);
    pcolor(world.x, world.y, cBathy);

    shading flat
    caxis([0 5]); %������ȵ���ʾ��Χ
    set(gca, 'ydir', 'nor');
    axis equal;
    axis tight;
    xlabel('x (m)','FontSize',f_size);
    ylabel('y (m)','FontSize',f_size);
%     titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
%     'mmm dd yyyy, HH:MM' );
%     title_name = "testBathy";
    title('cBathy','FontSize',f_size);
    h=colorbar('peer', gca);
    set(h, 'ydir', 'rev');
    set(get(h,'title'),'string', 'h (m)');
    set(gca,'ydir','reverse');

    
end

