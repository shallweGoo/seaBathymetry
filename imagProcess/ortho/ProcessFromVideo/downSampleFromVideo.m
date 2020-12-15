function downSampleFromVideo(VideoPath,SavePath,Fs,Multiple)
%DOWNSAMPLEFORVIDEO �ú������ڶ�һ����Ƶ����ͼ�񽵲���,���������֪��Video����Ϣ


%�Լ�д�Ĳ��֣�������string(ls),����д�ˣ�ֱ�ӽ��CIRN_A0������
%     obj = VideoReader(VideoPath);
%     totalFrames = obj.NumberOfFrames;% ��Ƶ֡������
%     frameInterval = floor(ceil(obj.FrameRate)/Fs);
%     lastFrames = floor(totalFrames/Multiple);
        
    
    
%     for k = 1 : frameInterval : lastFrames
%         frame = read(obj,k);
%         % imshow(frame);%��ʾ֡
%         imwrite(rgb2gray(frame),strcat(SavePath,"6Hz"+num2str(ceil(k/frameInterval)),'.jpg'),'jpg');
%     end

%% ����ΪCIRN�޸�

    %��������ò���Ƶ�ʺͲ���֡ʱ��Ĭ��Ϊ2Hz��ȫ��֡ת��
    if nargin <=2
        Fs = 2;
        Multiple = 1;
    elseif nargin <=3
        Multiple = 1;
    end
        
    v =VideoReader(VideoPath);

    to = datenum(2020,10,24,7,30,0); %��һ֡��������ʱ���룬��֪��Ҳû��ֱ������Ϊ0
    
    SaveName = 'upSample';
    
    
    
% ��ʼ��ʱ��
if to==datenum(0,0,0,0,0,0) % �����֪��ʱ��Ĭ��Ϊ0
    to=0;
else % if to known
    to=(to-datenum(1970,1,1))*24*3600; % ��unixϵͳĬ�ϵ���ʱ�俪ʼ�������
end

% ��ʼ��ѭ��
k=1;
% count=1;
numFrames= v.Duration.*v.FrameRate;  %��֡��

while k <= numFrames/Multiple
    
    I = read(v,k);
    
    if k==1
        vto=v.CurrentTime;
    end
    
    t=v.CurrentTime;
    ts= (t-vto)+to; % tsΪ��ȡ֡��Ӧ������
    
    
    
    
    %Because of the way Matlab defines time. 
    if k== numFrames
        ts=ts+1./v.FrameRate;
    end
    
    % ��ֹ�ļ����г���С��,����ת��Ϊ����
    ts=round(ts.*1000);
    
    % ����ͼƬ
    imwrite(rgb2gray(I),[SavePath SaveName '_' num2str(ts) '.tif'])
    
    % ��ʾ���ȣ��ǳ���Ļ���
    disp([ num2str( k./numFrames*100) '% Extraction Complete'])
    
    % �õ���һ֡������
    k=k+round(v.FrameRate./Fs);
    
    % ����ʱ����Ϣ
    T(count)=ts/1000; %ת��Ϊ��
    count=count+1;
    
end
    %��ʾת����ɵ���Ϣ
    disp(' ');
    disp(['ԭʼ��Ƶ֡��: ' num2str(v.FrameRate) ' fps'])
    disp(['ָ����Ƶ֡��: ' num2str(frameRate) ' fps']);
    disp(['ָ����ȡͼƬ��ʱ����: ' num2str(1./frameRate) ' s']);
    disp(['ʵ��ƽ��ʱ����: ' num2str(nanmean(diff(T(1:(end-1))))) ' s']);
% 	disp(['STD of actual dt: ' num2str(sqrt(var(diff(T(1:(end-1))),'omitnan'))) ' s']);

end




