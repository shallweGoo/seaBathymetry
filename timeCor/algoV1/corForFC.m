%�ú������ڶ�ͼ���е�һ��ʱ���������ݽ���������е����
%�õ�ÿһ������Ӧ�ĺ�ˮ���
function [f,c] = corForFC(picInfo, params, currentCol, cpsdVar)
    %һ����Χ���밶����ô����ʱ��Ͳ������ˣ���Ϊͼ�����а�������������ø��ռ�ֱ������
    % ���ֱ���Ϊ0.5mʱ���ò���������Ϊ40��20m��
    
    %%%%%%%%%  �����в�����6Hz�²���Ƶ�ʺ�2m�ľ�����ƣ�����ʾ���в���2Hz���²���Ƶ�ʣ����й��Ƶľ�����Ҫ���Գ�һ�����ʵ���ֵ %%%%%%%%%%
    % ���ڲ���Ƶ�ʵ����ƣ�2Hz����ʱ���ͺ�ֻ��Ϊ0.5s�����������ʾ���Ҫ�����Ӧ��
    % ������ø��ߵĲ���Ƶ�ʣ���ôʱ�͵Ĳ��ͻ��СһЩ����ÿ�ι��Ƶľ����Ҫ����
    a_range = 40;

    %temp_����Ϊ�˽�ʡ��parfor��ϵͳ�Ŀ���
    temp_data = picInfo.afterFilter;
    temp_timeInterval = params.dt;
    
    f = nan(picInfo.row, 1);
    c = nan(picInfo.row, 1);
    
%     debug_cor = nan(picInfo.row,1);
    
    % ���û���ع��Ƶľ������ƣ�Ŀǰ�������20��֮�⣨10m��֮��������ϵ������ѡȡ
    % �ò�����������ռ�ֱ����йأ�����ʱ��10mΪ��׼
    ov_range = 10; % ��Ҫ���ӵľ��룬��λΪ��(m)
    ov_range = round(ov_range / picInfo.pixelResolution);
    dst_itv = picInfo.dist / picInfo.pixelResolution;%ÿ������������һ�λ���ؼ���
    
    for i = picInfo.row : -1 : a_range %�ӵ����һ�п�ʼ��ǰ����

%     for i = aRange:picInfo.row %�ӵ�һ�п�ʼ������
        ref = squeeze(temp_data(i, currentCol,:)); 
%         maxCorVal = nan(1,i-1);%��¼ÿ����Ͳο���(Ҳ������һ����)��������ֵ
%         timeLag = nan(1,i-1);%��¼ÿ����Ͳο���������ֵ����Ӧ��ʱ��
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  �޸������Ǹ����м���ṹ(parfor)�汾 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        target = squeeze(temp_data(1 : i-1, currentCol, :))'; 
        
        cor_cof = corr(ref, target, 'type', 'Pearson'); %��ȡ�����ϵ��
        
        cor_cof_begin = round(length(cor_cof) * 0.6);
        
        cor_cof_end = length(cor_cof) - ov_range;
        
        while (cor_cof_begin > ov_range && cor_cof_begin > cor_cof_end)
           cor_cof_begin = cor_cof_begin - 5;
        end
        
        [maxCorVal, mostSim] = max(cor_cof(cor_cof_begin:cor_cof_end));  % ѡȡcor_cof�����Ƶľ���
        
        mostSim = mostSim + cor_cof_begin - 1;
        % debug���
        if params.DEBUG
            figure(1);
            plot(maxCorVal,'b');
            figure(2);
            plot(cor_cof,'r');
        end

        %����ʱ�ͻ���Ҫ�����һ��ѭ����xcorr��֧�ֶ��м���
        %����ÿ��2m������һ�ι���
        t_lag_idx = mostSim: dst_itv : i-1; %��������
        
%         ��������汾��ÿ���㶼���м���Ļ�����)        
%         parfor j =  mostSim:i-1
%             [~,timeLag(j)]= correlationCalc(ref,target(j,:),temp_timeInterval);
%         end
%         sup_count = 1;
%         for j = t_lag_idx
%             [~,timeLag(sup_count)]= correlationCalc(ref,target(:,j),temp_timeInterval);
%             sup_count = sup_count+1;
%         end
        [~, timeLag]= correlationCalc(ref , target(:,t_lag_idx) , temp_timeInterval, params.DEBUG);
        
        timeLag = flip(abs(timeLag)); %ʱ�ͼ���
        
        for idx = 2:length(timeLag)      % �����źŵ�����ԭ��ʱ�䲢����չ�ֵ����Ĺ��ɣ���������䣬���Դ�ʱ��Ҫɸѡʱ���ź�
            
             if timeLag(idx)<timeLag(idx-1) || timeLag(idx)>timeLag(idx-1) + 5
                    break;
             end
             
        end

        timeLag = [0,timeLag(1:idx-1)'];
        
        shoreDistance = [0,(1:idx-1) * picInfo.pixelResolution * dst_itv]; %���ھ���Ĺ���

        midPoint = round((i+mostSim)/2); %�е㴦������

        linearCurve = polyfit(timeLag, shoreDistance,1); % ��Ͻ����е㴦�ٶȵļ��㣨��ѡȡ�������ص��ź�֮������ѡȡ��Χ
% %%%%%%%%%%%%%%%%%%%%%%%debug���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if params.DEBUG
            clf;
            figure(3);
            plot(timeLag,shoreDistance,'r*');
            hold on;
            tmp_y = polyval(linearCurve, timeLag);
            plot(timeLag,tmp_y,'b');
        end
        
        % ȡƽ��ֵ����
        if(isnan(c(midPoint)))
            c(midPoint) = linearCurve(1);
        else
            c(midPoint) = (linearCurve(1)+c(midPoint)) / 2;
        end
        
        target_f = squeeze(temp_data(mostSim,currentCol,:));
        
        % ȡƽ��ֵ����
        if(isnan(f(midPoint)))
            f(midPoint) = ForMidPoint_f(ref,target_f,cpsdVar);% ����f_ref,�����е��Ƶ��
        else
            temp_f = ForMidPoint_f(ref,target_f,cpsdVar);
            f(midPoint) = (temp_f+f(midPoint))/2;
        end

    end

end

