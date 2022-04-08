function plotThreeCrossShoreCurve(gt, timeCor, cBathy, col, f_size)
    figure;
    subplot(3, 1, 1)
    plot(-gt(:, col(1)), 'color','k','linewidth', 2);
    hold on;
    plot(-timeCor(:, col(1)), 'color', 'b', 'linewidth', 2);
    hold on;
    plot(-cBathy(:, col(1)), 'color','r','linewidth', 2);
    
    legend('真实值', 'timeCor', 'cBathy','FontSize',10);
    axis tight;
    xlabel('跨岸距离(m)','FontSize',f_size);
    ylabel('水深(m)','FontSize',f_size);
    title(['沿岸距离为' num2str(col(1)) 'm处的跨岸水深'],'FontSize',f_size);

    subplot(3, 1, 2)
    plot(-gt(:, col(2)), 'k','linewidth', 2);
    hold on;
    plot(-timeCor(:, col(2)), 'color', 'b', 'linewidth', 2);
    hold on;
    plot(-cBathy(:, col(2)), 'color','r','linewidth', 2);
    
    legend('真实值', 'timeCor', 'cBathy','FontSize',10);
    axis tight;
    xlabel('跨岸距离(m)','FontSize',f_size);
    ylabel('水深(m)','FontSize',f_size);
    title(['沿岸距离为' num2str(col(2)) 'm处的跨岸水深'],'FontSize',f_size);
    
    subplot(3, 1, 3)
    plot(-gt(:, col(3)), 'k','linewidth', 2);
    hold on;
    plot(-timeCor(:, col(3)), 'color', 'b', 'linewidth', 2);
    hold on;
    plot(-cBathy(:, col(3)), 'color','r','linewidth', 2);
    
    legend('真实值', 'timeCor', 'cBathy','FontSize',10);
    axis tight;
    xlabel('跨岸距离(m)','FontSize',f_size);
    ylabel('水深(m)','FontSize',f_size);
    title(['沿岸距离为' num2str(col(3)) 'm处的跨岸水深'],'FontSize',f_size);
    
   
end