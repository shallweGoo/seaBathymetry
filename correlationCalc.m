%����pos1�㴦signal1��pos2��signal2�Ļ����,���ػ�����������Ǹ���ķ�ֵ��ʱ��
 %�ȷ�����x,������y.����x = sin(2*pi*0.2*(t+1))��y =sin(2*pi*0.2*t)����ʱ���Ϊ��
 %������x,�ȷ�����x,����x = sin(2*pi*0.2*(t-1))��y =sin(2*pi*0.2*t)����ʱ���Ϊ��
function [maxCor,TimeLag]=correlationCalc(signal1,signal2,timeInterval) 
% %   gpu���ٰ汾(ò��û�м��ٺܶ�)
%     [corMag_gpu,seriesNum]=xcorr(gpuArray(signal1),gpuArray(signal2),'coeff');
% %     plot(seriesNum,corMag_gpu); 
%     corMag = gather(corMag_gpu);

%     plot(signal1);
%     hold on;
%     plot(signal2);

    
    [corMag,seriesNum]=xcorr(signal1,signal2,'coeff');%'coeff'����Ϊ��һ��������������õ���
    
    
    figure(32);% �����ͼ�����
    plot(seriesNum,corMag);
    
    [maxCor,TimeLag] = max(corMag);%����ֵ,
    TimeLag = seriesNum(TimeLag)*timeInterval; %�õ���ǰ��ʱ��
    
end
    
    

