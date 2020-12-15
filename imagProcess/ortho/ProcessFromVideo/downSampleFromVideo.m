function downSampleFromVideo(VideoPath,SavePath,Fs,Multiple)
%DOWNSAMPLEFORVIDEO 该函数用于对一个视频进行图像降采样,事先最好先知道Video的信息


%自己写的部分，不能用string(ls),不想写了，直接借鉴CIRN_A0的内容
%     obj = VideoReader(VideoPath);
%     totalFrames = obj.NumberOfFrames;% 视频帧的总数
%     frameInterval = floor(ceil(obj.FrameRate)/Fs);
%     lastFrames = floor(totalFrames/Multiple);
        
    
    
%     for k = 1 : frameInterval : lastFrames
%         frame = read(obj,k);
%         % imshow(frame);%显示帧
%         imwrite(rgb2gray(frame),strcat(SavePath,"6Hz"+num2str(ceil(k/frameInterval)),'.jpg'),'jpg');
%     end

%% 以下为CIRN修改

    %如果不设置采样频率和采样帧时，默认为2Hz和全部帧转换
    if nargin <=2
        Fs = 2;
        Multiple = 1;
    elseif nargin <=3
        Multiple = 1;
    end
        
    v =VideoReader(VideoPath);

    to = datenum(2020,10,24,7,30,0); %第一帧的年月日时分秒，不知道也没事直接设置为0
    
    SaveName = 'upSample';
    
    
    
% 初始化时间
if to==datenum(0,0,0,0,0,0) % 如果不知道时间默认为0
    to=0;
else % if to known
    to=(to-datenum(1970,1,1))*24*3600; % 从unix系统默认诞生时间开始算的秒数
end

% 初始化循环
k=1;
% count=1;
numFrames= v.Duration.*v.FrameRate;  %总帧数

while k <= numFrames/Multiple
    
    I = read(v,k);
    
    if k==1
        vto=v.CurrentTime;
    end
    
    t=v.CurrentTime;
    ts= (t-vto)+to; % ts为提取帧对应的秒数
    
    
    
    
    %Because of the way Matlab defines time. 
    if k== numFrames
        ts=ts+1./v.FrameRate;
    end
    
    % 防止文件名中出现小数,将秒转化为毫秒
    ts=round(ts.*1000);
    
    % 保存图片
    imwrite(rgb2gray(I),[SavePath SaveName '_' num2str(ts) '.tif'])
    
    % 显示进度，非常叼的机制
    disp([ num2str( k./numFrames*100) '% Extraction Complete'])
    
    % 得到下一帧的索引
    k=k+round(v.FrameRate./Fs);
    
    % 储存时间信息
    T(count)=ts/1000; %转化为秒
    count=count+1;
    
end
    %显示转换完成的信息
    disp(' ');
    disp(['原始视频帧率: ' num2str(v.FrameRate) ' fps'])
    disp(['指定视频帧率: ' num2str(frameRate) ' fps']);
    disp(['指定提取图片的时间间隔: ' num2str(1./frameRate) ' s']);
    disp(['实际平均时间间隔: ' num2str(nanmean(diff(T(1:(end-1))))) ' s']);
% 	disp(['STD of actual dt: ' num2str(sqrt(var(diff(T(1:(end-1))),'omitnan'))) ' s']);

end




