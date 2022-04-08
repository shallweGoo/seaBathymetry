function plotThreeCrossShoreCurve(gt, timeCor, cBathy, col, f_size)
    figure;
    subplot(3, 1, 1)
    plot(-gt(:, col(1)), 'color','k','linewidth', 2);
    hold on;
    plot(-timeCor(:, col(1)), 'color', 'b', 'linewidth', 2);
    hold on;
    plot(-cBathy(:, col(1)), 'color','r','linewidth', 2);
    
    legend('��ʵֵ', 'timeCor', 'cBathy','FontSize',10);
    axis tight;
    xlabel('�簶����(m)','FontSize',f_size);
    ylabel('ˮ��(m)','FontSize',f_size);
    title(['�ذ�����Ϊ' num2str(col(1)) 'm���Ŀ簶ˮ��'],'FontSize',f_size);

    subplot(3, 1, 2)
    plot(-gt(:, col(2)), 'k','linewidth', 2);
    hold on;
    plot(-timeCor(:, col(2)), 'color', 'b', 'linewidth', 2);
    hold on;
    plot(-cBathy(:, col(2)), 'color','r','linewidth', 2);
    
    legend('��ʵֵ', 'timeCor', 'cBathy','FontSize',10);
    axis tight;
    xlabel('�簶����(m)','FontSize',f_size);
    ylabel('ˮ��(m)','FontSize',f_size);
    title(['�ذ�����Ϊ' num2str(col(2)) 'm���Ŀ簶ˮ��'],'FontSize',f_size);
    
    subplot(3, 1, 3)
    plot(-gt(:, col(3)), 'k','linewidth', 2);
    hold on;
    plot(-timeCor(:, col(3)), 'color', 'b', 'linewidth', 2);
    hold on;
    plot(-cBathy(:, col(3)), 'color','r','linewidth', 2);
    
    legend('��ʵֵ', 'timeCor', 'cBathy','FontSize',10);
    axis tight;
    xlabel('�簶����(m)','FontSize',f_size);
    ylabel('ˮ��(m)','FontSize',f_size);
    title(['�ذ�����Ϊ' num2str(col(3)) 'm���Ŀ簶ˮ��'],'FontSize',f_size);
    
   
end