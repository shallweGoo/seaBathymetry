%���ڻ���ط�ˮ�����
function depth = correlationProcess(picInfo,cpsdVar)

    depth = nan(picInfo.row,picInfo.col);%ˮ���
    f = nan(picInfo.row,picInfo.col); %Ƶ��
    speed = nan(picInfo.row,picInfo.col); %����

    pix_dist = picInfo.dist/picInfo.pixelResolution;
    
    for i = 1:picInfo.col
        
        for source_id = picInfo.row:-1:1

            wave_id = picInfo.waveLengthInfo(source_id,1);%�����ϵ�������Ǹ���
            
            if wave_id > source_id %������ƫ��
                
                continue;
                
            end
            
            target_id = source_id:-pix_dist:wave_id; % ��source�źŹ��Ƶ�����
            
            source = squeeze(picInfo.afterFilter(source_id,i,:)); % ��������ʽ
            
            target = squeeze(picInfo.afterFilter(target_id,i,:))'; %�ĳ�����������ʽ
            
            if size(target,1) < size(target,2) % �����������
                
                target = target';
                
            end
                
            mid = round((source_id+wave_id)/2);% �е�����
            
            %���㻥���ʱ��
            [MaxCor, TimeLag]= correlationCalc(source,target,picInfo.timeInterval); %���غ�source�ź���ص�����ʱ��
            
            TimeLag = abs(TimeLag);

            PointDist = [0:length(TimeLag)-1]'*picInfo.dist;
            
            clear invalid_id; %���������¼
            clear invalid_cur;
            
            invalid_cur = 1;%���ڼ�¼��Чʱ������
            for cur = 2:length(TimeLag)-1
                
                if abs(TimeLag(cur)-TimeLag(cur-1)) >= 2
                    TimeLag(cur) = TimeLag(cur-1);
                    invalid_id(invalid_cur) = cur;
                    invalid_cur = invalid_cur+1;
                end
                
            end
            
            if exist('invalid_id','var') == 1
                TimeLag(invalid_id) = nan;
                PointDist(invalid_id) = nan;
            end
            
            if length(TimeLag) > 1 && length(TimeLag) - (invalid_cur-1) >1 %���ʱ�ʹ��ڳ����ҷ�nanֵ����Ҫ>=2
                
                linearCurve = polyfit(TimeLag,PointDist,1); % һ�׶���ʽ��ϣ�Ϊ�˵õ�б��
                
                
                % �ٶȹ���
                if isnan(speed(mid,i))
                    speed(mid,i) = linearCurve(1);
                else
                    speed(mid,i) = (linearCurve(1)+speed(mid,i))/2;
                end
                
                target_f = squeeze(picInfo.afterFilter(wave_id,i,:));

                % Ƶ�ʹ���
                if isnan(f(mid,i))
                    f(mid,i) = ForMidPoint_f(source,target_f,cpsdVar);% ����f_ref,�����е��Ƶ��
                else
                    f(mid,i) = ( ForMidPoint_f(source,target_f,cpsdVar) + f(mid,i) )/2;
                end
                
            end

            % debug���
%             clf;
%             figure(90);% ͼ����Ϊ90
%             plot(TimeLag,PointDist,'k.');
%             hold on;
%             tmp_y = polyval(linearCurve,TimeLag);
%             plot(TimeLag,tmp_y,'b');

            
            

            
            
            
            
        end
        
        depth(:,i) = calDepth(speed(:,i),f(:,i));
        
        disp("correlation process "+ num2str(i/picInfo.col*100)+ "% completed");
        
        
    end
     

end


%         [point.f(:,i),point.speed(:,i)] = corForFandC(picInfo,i,cpsdVar);
%         seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
%         disp(['process:' num2str(i/picInfo.col*100) '% completed']);
    %     run_time = cputime-t1;