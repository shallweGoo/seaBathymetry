%�ú���Ϊ��ȷ��ݵ�������
dbstop if all error  % �������
addpath('./timeStackOperation/');
foldPath = "F:\workSpace\matlabWork\corNeed_imgResult\";
%% ��������
prepare.fs = 2; %����Ƶ��Ϊ2Hz
prepare.pixelResolution = 0.5; %���طֱ���Ϊ0.5m
%% ��ȡ����õ�ʱ����������

%1��ͼƬ��Ϣ
picInfo.idx = 14;
picInfo.file_path =  foldPath+"\�任��ͼƬ"+picInfo.idx+"\";% ͼ���ļ���·��
picInfo.allPic = string(ls(picInfo.file_path));%ֱ�Ӱ������е��ļ���
picInfo.allPic = picInfo.allPic(3:end);
picInfo.picnum = size(picInfo.allPic,1);%ͳ��������Ƭ������

src=imread(picInfo.file_path+picInfo.allPic(1));
[picInfo.row,picInfo.col] = size(src);
clear src;
picInfo.timeInterval = 1/prepare.fs; %��λs 
picInfo.pixelResolution = prepare.pixelResolution; %��λ��
load(foldPath+"\�任��ͼƬ"+picInfo.idx+"��ش���\����Ԫ������\data_cell_det&nor.mat");
picInfo.afterFilter = usefulData;

prepare.N = length(usefulData{1}); % �ж��ٸ�������
prepare.t = 1/prepare.fs*(0:N-1); % ʱ��

%2��������Ϣ
world.crossShoreRange = (picInfo.row-1)*prepare.pixelResolution;
world.longShoreRange = (picInfo.col-1)*prepare.pixelResolution;
world.x = 0:prepare.pixelResolution:world.longShoreRange;
world.y = 0:prepare.pixelResolution:world.crossShoreRange;

%3���ṩ���㽻��������Ҫ����Ϣ
cpsdVar.waveLow  = 0.05; %�������Ƶ����Ҫ�õĽ�����Ƶ�ʷ�Χ
cpsdVar.waveHigh = 0.25;
cpsdVar.Fs = fs;%����Ƶ�ʣ���λhz

clear usefulData;

N = prepare.N; % ���������
n = 0:N-1; % �����㣨������
t = prepare.t; % ʱ��

%% ���й���
range = zeros(picInfo.row,picInfo.col);
point.speed = zeros(picInfo.row,picInfo.col);
point.f = zeros(picInfo.row,picInfo.col);


%  ���밶��Զ�����ص���й���,˳�������ȷ���
seaDepth = NaN(picInfo.row,picInfo.col);
fixed_time = 3; %�̶�ʱ��Ϊ3s�����ĵõ������ʺ�ʱ��

%����ʹ�õķ���
%1Ϊ�е�ȡ�ٶȷ�
%2Ϊ�̶�ʱ��Ϊ3s,��fixed_time = 3ʱ����Ϊ�ĵ�;
mode = 2;


%% ����Ҷ�任�ҳ�����ص��źź�Ƶ��
    
    




%%
% �Ի���ؽ��м��㣨�Ľ��棬����ÿ����һ�����ݼӿ������ٶȣ���Ŀǰʧ����
% ����һ�����������ÿһ�е�����ֵ
if mode == 1
    for i = 1:picInfo.col
    %     t1 = cputime;
        [point.f(:,i),point.speed(:,i)] = corForFandC(picInfo,i,cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
        disp(['progress:' num2str(i/picInfo.col*100) '% completed']);
    %     run_time = cputime-t1;
    end
    
% ���ù̶�ʱ��ķ�ʽ�����й����ٶȵĹ���
% ÿһ�н��з�Χ����

% �ֱ��ʸ���Ҫ�ǵøò���
elseif mode == 2
    for i = 1:picInfo.col                  
        [TimeStack1,TimeStack2] = getTimeStack(picInfo,i,fixed_time);
        res = fixedTimeForCor(TimeStack1,TimeStack2); 
        [~,idx] = max(res,[],2); %����ÿ�е����ϵ��
        idx(1:49) = nan;  %ֱ������1��49Ϊ�����Ƶķ�Χ
        point.speed(:,i) = idx*picInfo.pixel2Distance/fixed_time;
%         point.f(:,i) = fixedTimeCorForF(idx,i,picInfo,cpsdVar);
        point.f(:,i) = fixedTimeCorForF_PS(i,picInfo,cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
        disp(['progress:' num2str(i/picInfo.col*100) '% completed']);
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

    
    seaDepth(imag(seaDepth)~=0) = nan;
    
    figure;   
    plotBathy(world,seaDepth);
%     figure;
%     plotBathy(world,mean_seaDepth);
    
%% ���Խ������Բ�ֵ������ֵΪnan��,���е㷽������ʱ�ͻ���ֺܶ��

if mode == 1 
    %
    interpolation.seaDepth = seaDepth;
    for i = 1:picInfo.col
        interpolation.total_x = 1:picInfo.row;
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
    plotBathy(world,interpolation.seaDepth);
    
end
   





            
            









    

    
    
  
    
    