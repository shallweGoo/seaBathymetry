%����pos1�㴦signal1��pos2��signal2�Ļ����,���ػ�����������Ǹ���ķ�ֵ��ʱ��
 %�ȷ�����x,������y.����x = sin(2*pi*0.2*(t+1))��y =sin(2*pi*0.2*t)����ʱ���Ϊ��
 %������x,�ȷ�����y,����x = sin(2*pi*0.2*(t-1))��y =sin(2*pi*0.2*t)����ʱ���Ϊ��
 %���������
 % source��Դ�źţ�Ϊ��һ������
 % target��Ŀ���źţ�Ϊһ����Χ�ڵ������źż��ϣ�ÿһ�б�ʾΪһ�������ź�
 
function [MaxCor,TimeLag] = correlationCalc(source, target, timeInterval) 
% %   gpu���ٰ汾(ò��û�м��ٺܶ�)
%     [corMag_gpu,seriesNum]=xcorr(gpuArray(signal1),gpuArray(signal2),'coeff');
% %     plot(seriesNum,corMag_gpu); 
%     corMag = gather(corMag_gpu);

    s_cnt = size(target,2);
    
    TimeLag = zeros(s_cnt,1);
    MaxCor = TimeLag;
    for i = 1 : size(target ,2) % ��n���ź�
        
        target_signal = target(:,i);
            
%         plot(signal1); %debug���
%         hold on;
%         plot(signal2);


        [corMag, seriesNum]= xcorr(source, target_signal, 30, 'coeff');%'coeff'����Ϊ��һ��������������õ���
        
        [maxCor,time_id] = max(corMag);%����ֵ
        
        timelag = seriesNum(time_id) * timeInterval; %�õ���ǰ��ʱ��
        
        TimeLag(i) = timelag;
        
        MaxCor(i) = maxCor;
        
    figure(33);
    plot(seriesNum .* timelag ,corMag);
    xlabel('time delay(s)');
    ylabel('correlation coefficient');
    title('Relationship between correlation coefficient and time delay');

    end
    
    

    
    
    
    
end
    
    

