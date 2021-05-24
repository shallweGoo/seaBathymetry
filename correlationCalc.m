%计算pos1点处signal1和pos2处signal2的互相关,返回互相相关最大的那个点的幅值和时间
 %先发生的x,后发生的y.例如x = sin(2*pi*0.2*(t+1))，y =sin(2*pi*0.2*t)，此时结果为负
 %后发生的x,先发生的x,例如x = sin(2*pi*0.2*(t-1))，y =sin(2*pi*0.2*t)，此时结果为正
function [maxCor,TimeLag]=correlationCalc(signal1,signal2,timeInterval) 
% %   gpu加速版本(貌似没有加速很多)
%     [corMag_gpu,seriesNum]=xcorr(gpuArray(signal1),gpuArray(signal2),'coeff');
% %     plot(seriesNum,corMag_gpu); 
%     corMag = gather(corMag_gpu);

%     plot(signal1);
%     hold on;
%     plot(signal2);

    
    [corMag,seriesNum]=xcorr(signal1,signal2,'coeff');%'coeff'参数为归一化互相关曲线所得到的
    
    
    figure(32);% 互相关图窗编号
    plot(seriesNum,corMag);
    
    [maxCor,TimeLag] = max(corMag);%最大的值,
    TimeLag = seriesNum(TimeLag)*timeInterval; %得到当前的时间
    
end
    
    

