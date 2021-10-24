%计算pos1点处signal1和pos2处signal2的互相关,返回互相相关最大的那个点的幅值和时间
 %先发生的x,后发生的y.例如x = sin(2*pi*0.2*(t+1))，y =sin(2*pi*0.2*t)，此时结果为负
 %后发生的x,先发生的y,例如x = sin(2*pi*0.2*(t-1))，y =sin(2*pi*0.2*t)，此时结果为正
 %输入参数：
 % source：源信号，为单一列向量
 % target：目标信号，为一个范围内的所有信号集合，每一列表示为一个单独信号
 
function [MaxCor,TimeLag] = correlationCalc(source, target, timeInterval) 
% %   gpu加速版本(貌似没有加速很多)
%     [corMag_gpu,seriesNum]=xcorr(gpuArray(signal1),gpuArray(signal2),'coeff');
% %     plot(seriesNum,corMag_gpu); 
%     corMag = gather(corMag_gpu);

    s_cnt = size(target,2);
    
    TimeLag = zeros(s_cnt,1);
    MaxCor = TimeLag;
    for i = 1 : size(target ,2) % 有n个信号
        
        target_signal = target(:,i);
            
%         plot(signal1); %debug相关
%         hold on;
%         plot(signal2);


        [corMag, seriesNum]= xcorr(source, target_signal, 30, 'coeff');%'coeff'参数为归一化互相关曲线所得到的
        
        [maxCor,time_id] = max(corMag);%最大的值
        
        timelag = seriesNum(time_id) * timeInterval; %得到当前的时间
        
        TimeLag(i) = timelag;
        
        MaxCor(i) = maxCor;
        
    figure(33);
    plot(seriesNum .* timelag ,corMag);
    xlabel('time delay(s)');
    ylabel('correlation coefficient');
    title('Relationship between correlation coefficient and time delay');

    end
    
    

    
    
    
    
end
    
    

