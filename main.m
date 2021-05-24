%该函数为深度反演的主函数
dbstop if all error  % 方便调试
addpath('./timeStackOperation/');
foldPath = "F:\workSpace\matlabWork\corNeed_imgResult\";
%% 采样参数
prepare.fs = 2; %采样频率为2Hz
prepare.pixelResolution = 0.5; %像素分辨率为0.5m
%% 获取处理好的时间序列数据

%1、图片信息
picInfo.idx = 14;
picInfo.file_path =  foldPath+"\变换后图片"+picInfo.idx+"\";% 图像文件夹路径
picInfo.allPic = string(ls(picInfo.file_path));%直接包括所有的文件名
picInfo.allPic = picInfo.allPic(3:end);
picInfo.picnum = size(picInfo.allPic,1);%统计所有照片的数量

src=imread(picInfo.file_path+picInfo.allPic(1));
[picInfo.row,picInfo.col] = size(src);
clear src;
picInfo.timeInterval = 1/prepare.fs; %单位s 
picInfo.pixelResolution = prepare.pixelResolution; %单位米
load(foldPath+"\变换后图片"+picInfo.idx+"相关处理\最终元胞数据\data_cell_det&nor.mat");
picInfo.afterFilter = usefulData;

prepare.N = length(usefulData{1}); % 有多少个采样点
prepare.t = 1/prepare.fs*(0:N-1); % 时间

%2、世界信息
world.crossShoreRange = (picInfo.row-1)*prepare.pixelResolution;
world.longShoreRange = (picInfo.col-1)*prepare.pixelResolution;
world.x = 0:prepare.pixelResolution:world.longShoreRange;
world.y = 0:prepare.pixelResolution:world.crossShoreRange;

%3、提供计算交叉谱所需要的信息
cpsdVar.waveLow  = 0.05; %计算代表频率所要用的交叉谱频率范围
cpsdVar.waveHigh = 0.25;
cpsdVar.Fs = fs;%采样频率，单位hz

clear usefulData;

N = prepare.N; % 采样点个数
n = 0:N-1; % 采样点（向量）
t = prepare.t; % 时间

%% 进行估计
range = zeros(picInfo.row,picInfo.col);
point.speed = zeros(picInfo.row,picInfo.col);
point.f = zeros(picInfo.row,picInfo.col);


%  从离岸最远的像素点进行估计,顺便进行深度反演
seaDepth = NaN(picInfo.row,picInfo.col);
fixed_time = 3; %固定时间为3s，论文得到的最适合时间

%设置使用的方法
%1为中点取速度法
%2为固定时间为3s,即fixed_time = 3时所成为的点;
mode = 2;


%% 傅里叶变换找出最相关的信号和频率
    
    




%%
% 对互相关进行计算（改进版，尝试每次用一列数据加快运算速度），目前失败了
% 利用一个数组来存放每一行的索引值
if mode == 1
    for i = 1:picInfo.col
    %     t1 = cputime;
        [point.f(:,i),point.speed(:,i)] = corForFandC(picInfo,i,cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
        disp(['progress:' num2str(i/picInfo.col*100) '% completed']);
    %     run_time = cputime-t1;
    end
    
% 采用固定时间的方式来进行估计速度的估计
% 每一列进行范围估计

% 分辨率改了要记得该参数
elseif mode == 2
    for i = 1:picInfo.col                  
        [TimeStack1,TimeStack2] = getTimeStack(picInfo,i,fixed_time);
        res = fixedTimeForCor(TimeStack1,TimeStack2); 
        [~,idx] = max(res,[],2); %计算每行的相关系数
        idx(1:49) = nan;  %直接设置1：49为不估计的范围
        point.speed(:,i) = idx*picInfo.pixel2Distance/fixed_time;
%         point.f(:,i) = fixedTimeCorForF(idx,i,picInfo,cpsdVar);
        point.f(:,i) = fixedTimeCorForF_PS(i,picInfo,cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
        disp(['progress:' num2str(i/picInfo.col*100) '% completed']);
    end
    % 加平滑处理的过程
    
end
        


    
%% 为固定时间的结果加一个平均操作

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
   
    

        
%% 进行plot

    
    seaDepth(imag(seaDepth)~=0) = nan;
    
    figure;   
    plotBathy(world,seaDepth);
%     figure;
%     plotBathy(world,mean_seaDepth);
    
%% 可以进行线性插值，补上值为nan的,用中点方法计算时就会出现很多空

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
   





            
            









    

    
    
  
    
    