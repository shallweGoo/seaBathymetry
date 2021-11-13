%�ú���Ϊ��ȷ��ݵ�������

%% ������ز���
dbstop if all error  % �������

% addpath('./algoV1/timeStackOperation/');
addpath(genpath('./algoV1'));
addpath(genpath('./common'));
fold_path = "F:/workSpace/matlabWork/corNeed_imgResult/";
station_str = 'phantom4';
% ִ�в���ע��
eval(station_str);

% ��ȡ����õ�ʱ����������

% 1��ͼƬ��Ϣ
id = 14;
pic_info = loadTimeStack(id, fold_path, params);
% 2��������Ϣ
world_info = getWorldInfo(params, pic_info);
% 3���ṩ���㽻��������Ҫ����Ϣ
cpsdVar.waveLow  = 0.05; %�������Ƶ����Ҫ�õĽ�����Ƶ�ʷ�Χ
cpsdVar.waveHigh = 0.25;
cpsdVar.Fs = params.fs;%����Ƶ�ʣ���λhz

% prepare������������
% N = prepare.N; % ���������
% n = 0:N-1; % �����㣨������
% t = prepare.t; % ʱ��


% ���÷�Χ����
range = zeros(pic_info.row, pic_info.col);
point.speed = zeros(pic_info.row, pic_info.col);
point.f = zeros(pic_info.row, pic_info.col);

%  ���밶��Զ�����ص���й���,˳�������ȷ���
seaDepth = NaN(pic_info.row, pic_info.col);
fixed_time = 3; %�̶�ʱ��Ϊ3s�����ĵõ������ʺ�ʱ��




% ����Ҷ�任�ҳ�����ص��źź�Ƶ��
%1.ȷ����Χ���ҳ�ÿ�����Ӧ����صĵ㣬�������ķ�Χ�ڽ��й���
pic_info.waveLengthInfo = findWaveLength(pic_info);
pic_info.dist = 2; %��cross shore�����ϸ������׹���һ��
pic_info.pixelResolution = 0.5; % ���طֱ���
%2������fft��������ȷ����һЩ��Ƶ�Ͳ���صķ�����ѧϰcBathy����һ�������ڽ���fft�������׷�����ɸѡ���Ƶ��
    


%% ������
% �Ի���ؽ��м��㣨�Ľ��棬����ÿ����һ�����ݼӿ������ٶȣ���Ŀǰʧ����
% ����һ�����������ÿһ�е�����ֵ
%����ʹ�õķ���
%1Ϊ�е�ȡ�ٶȷ���UAV-based mapping of nearshore bathymetry over broad areas��
%2Ϊ�̶�ʱ��Ϊ3s
mode = 1;

if mode == 1
    % û������ȫ�°汾
%     seaDepth = correlationProcess(picInfo,cpsdVar);
    
    %�ɰ汾
    for i = 1:pic_info.col
    %     t1 = cputime;
        [point.f(:,i), point.speed(:,i)] = corForFC(pic_info, params, i, cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i), point.f(:,i));
        disp(['process:' num2str(i/pic_info.col*100) '% completed']);
    %     run_time = cputime-t1;
    end
    
% ���ù̶�ʱ��ķ�ʽ�����й����ٶȵĹ���
% ÿһ�н��з�Χ����

% �ֱ��ʸ���Ҫ�ǵøò���
elseif mode == 2
    for i = 1:pic_info.col                  
        [TimeStack1,TimeStack2] = getTimeStack(pic_info,i,fixed_time);
        res = fixedTimeForCor(TimeStack1,TimeStack2); 
        [~,idx] = max(res,[],2); %����ÿ�е����ϵ��
        idx(1:49) = nan;  %ֱ������1��49Ϊ�����Ƶķ�Χ
        point.speed(:,i) = idx*pic_info.pixel2Distance/fixed_time;
%         point.f(:,i) = fixedTimeCorForF(idx,i,picInfo,cpsdVar);
        point.f(:,i) = fixedTimeCorForF_PS(i,pic_info,cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
        disp(['progress:' num2str(i/pic_info.col*100) '% completed']);
    end
    % ��ƽ������Ĺ���
    
end
        
    
%% Ϊ�̶�ʱ��Ľ����һ��ƽ������

%     mean_seaDepth = seaDepth;
%     for i = 1:picInfo.col
%         for j = 1:5:picInfo.row
%             if j+2 <= picInfo.row
%                 mean_seaDepth(j:j+5,i) = mean(seaDepth(j:j+2,i));
%             else
%                 mean_seaDepth(j:end,i) = mean(seaDepth(j:end,i));
%             end
%         end
%     end
%    
   
    

        
%% ����plot

    
    seaDepth(imag(seaDepth)~=0) = nan; % �鲿Ϊ0��ֱ�Ӹ��nan
    
    figure;   
    plotBathy(world_info,seaDepth);
%     figure;
%     plotBathy(world,mean_seaDepth);
    
%% ���Խ������Բ�ֵ������ֵΪnan��,���е㷽������ʱ�ͻ���ֺܶ��

if mode == 1 
    %
    interpolation.seaDepth = seaDepth;
    for i = 1:pic_info.col
        interpolation.total_x = 1:pic_info.row;
        interpolation.now_y  = interpolation.seaDepth(:,i)';
        interpolation.temp = interpolation.now_y;
        interpolation.insert_x = find(isnan(interpolation.now_y));
        interpolation.terminate_x = find(~isnan(interpolation.now_y),1,'last');
        interpolation.first_x = find(~isnan(interpolation.now_y),1,'first');
        interpolation.insert_x_idx = find(interpolation.insert_x>=interpolation.first_x & interpolation.insert_x <= interpolation.terminate_x);
        interpolation.insert_x = interpolation.insert_x(interpolation.insert_x_idx);
        interpolation.total_x(interpolation.insert_x) = [];
        interpolation.now_y(interpolation.insert_x) = [];
        interpolation.insert_y = interp1(interpolation.total_x,interpolation.now_y,interpolation.insert_x,'nearest');
        interpolation.temp(interpolation.insert_x) = interpolation.insert_y;
        interpolation.seaDepth(:,i) = interpolation.temp;
    end
    figure;
    plotBathy(world_info,interpolation.seaDepth);
end
   





            
            









    

    
    
  
    
    