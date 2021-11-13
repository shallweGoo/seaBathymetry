function downSampleFromVideo(step)
%DOWNSAMPLEFORVIDEO �ú������ڶ�һ����Ƶ����ͼ�񽵲���,���������֪��Video����Ϣ


%�Լ�д�Ĳ��֣�������string(ls),����д�ˣ�ֱ�ӽ��CIRN_A0������
%     obj = VideoReader(VideoPath);
%     totalFrames = obj.NumberOfFrames;% ��Ƶ֡������
%     frameInterval = floor(ceil(obj.FrameRate)/Fs);
%     lastFrames = floor(totalFrames/Multiple);
        
    
    
%         % imshow(frame);%��ʾ֡
%         imwrite(rgb2gray(frame),strcat(SavePath,"6Hz"+num2str(ceil(k/frameInterval)),'.jpg'),'jpg');
%     end

%     for k = 1 : frameInterval : lastFrames
%         frame = read(obj,k);
%% ����ΪCIRN�޸�

    %��������ò���Ƶ�ʺͲ���֡ʱ��Ĭ��Ϊ2Hz��ȫ��֡ת��
    
    videoPath = step.videoPath;
    savePath = step.savePath;
    savePath2 = step.filterPath;
    
    
    if(isfield(step,'fs')) 
        fs = step.fs;
    else
        fs = 2;
    end
    
    if(isfield(step,'videoRange')) 
        videoRange = step.videoRange;
    else
        videoRange = [];
    end
    
    
%     if nargin < 3
%         fs = 2;
%         videoRange = []; 
%     elseif nargin < 4 
%         videoRange = [];
%     end 
        
    v =VideoReader(videoPath);

    to = datenum(2020,10,24,7,30,0); %��һ֡��������ʱ���룬��֪��Ҳû��ֱ������Ϊ0
    
    SaveName = 'downSample';
    
    
    
    % ��ʼ��ʱ��
    if to==datenum(0,0,0,0,0,0) % �����֪��ʱ��Ĭ��Ϊ0
        to=0;
    else % if to known
        to=(to-datenum(1970,1,1))*24*3600; % ��unixϵͳĬ�ϵ���ʱ�俪ʼ�������
    end

    % ��ʼ��ѭ��
    k=1;
    count=1;
    numFrames= v.Duration.*v.FrameRate;  %��֡��


    if isempty(videoRange) %Ϊ����˵����ͷ��β��ȡ��Ƶ֡
        while k <= numFrames

            I = read(v,k);

            if k==1
                vto=v.CurrentTime;%��λΪ��
            end

            t=v.CurrentTime; 
            ts= (t-vto)+to; % tsΪ��ȡ֡��Ӧ������,��λΪs




            %Because of the way Matlab defines time. 
            if k== numFrames
                ts=ts+1./v.FrameRate;
            end

            % ��ֹ�ļ����г���С��,����ת��Ϊ����
            ts=round(ts.*1000);

            % ����ͼƬ
            I_gray = rgb2gray(I);
            imwrite(I_gray,[savePath SaveName '_' num2str(ts) '.tif']);%���Կ��Ƿŵ����ȥ�Ҷ�
            I_filter = gaussfilter(I_gray,50);
            imwrite(I_filter,[savePath2 SaveName '_' num2str(ts) '.jpg']);%���Կ��Ƿŵ����ȥ�Ҷ�

%            imwrite(I,[savePath SaveName '_' num2str(ts) '.tif']);
            % ��ʾ���ȣ��ǳ���Ļ���
            disp([ num2str( k./numFrames*100) '% Extraction Complete'])

            % �õ���һ֡������
            k=k+round(v.FrameRate./fs);

            % ����ʱ����Ϣ
            T(count)=ts/1000; %ת��Ϊ��
            count=count+1;

        end

    %ָ��videoRange��Χ֮��
    else 
        %��ȷ������ʱ������Ӧ��֡��
        while k <= numFrames

            I = read(v,k);

            if k==1
                vto=v.CurrentTime;%��λΪ��
            end

            t=v.CurrentTime;
            if t < videoRange(1)
                k=k+round(v.FrameRate./fs);
                disp(['waiting for extraction:' num2str(videoRange(1)-t) 's']);
                continue;
            elseif t > videoRange(2)
                disp('Out of specific video range');
                break;
            end

            ts= (t-vto)+to; % tsΪ��ȡ֡��Ӧ������,��λΪs



            %Because of the way Matlab defines time. 
            if k== numFrames
                ts=ts+1./v.FrameRate;
            end

            % ��ֹ�ļ����г���С��,����ת��Ϊ����
            ts=round(ts.*1000);

            % ����ͼƬ
            I_gray  = rgb2gray(I);
            
            imwrite(I_gray,[savePath SaveName '_' num2str(ts) '.tif']);%���Կ��Ƿŵ����ȥ�ҶȻ�
            I_filter = gaussfilter(I_gray,50);
            imwrite(I_filter,[savePath2 SaveName '_' num2str(ts) '.jpg']);%���Կ��Ƿŵ����ȥ�Ҷ�

            % ��ʾ���ȣ��ǳ���Ļ���
            disp([ num2str( (t-videoRange(1))./(videoRange(2)- videoRange(1))*100) '% Extraction Complete'])
            
            % �õ���һ֡������
            k=k+round(v.FrameRate./fs);

            % ����ʱ����Ϣ
            T(count)=ts/1000; %ת��Ϊ��
            count=count+1;

        end
    end
    
    
    
    
    %��ʾת����ɵ���Ϣ
    disp(' ');
    disp(['ԭʼ��Ƶ֡��: ' num2str(v.FrameRate) ' fps'])
    disp(['ָ����Ƶ֡��: ' num2str(fs) ' fps']);
    disp(['ָ����ȡͼƬ��ʱ����: ' num2str(1./fs) ' s']);
    disp(['ʵ��ƽ��ʱ����: ' num2str(nanmean(diff(T(1:(end-1))))) ' s']);
% 	disp(['STD of actual dt: ' num2str(sqrt(var(diff(T(1:(end-1))),'omitnan'))) ' s']);

end


function [image_result] =gaussfilter(image_orign,D0)

    %GULS ��˹��ͨ�˲���

    % D0Ϊ����Ƶ�ʵģ��൱�������ڸ���Ҷ��ͼ�İ뾶ֵ��

    if (ndims(image_orign) == 3)

    %�ж϶����ͼƬ�Ƿ�Ϊ�Ҷ�ͼ�����������ת��Ϊ�Ҷ�ͼ���������������

    image_2zhi = rgb2gray(image_orign);

    else 

    image_2zhi = image_orign;

    end

    image_fft = fft2(image_2zhi);%�ø���Ҷ�任��ͼ��ӿռ���ת��ΪƵ����

    image_fftshift = fftshift(image_fft);

    %����Ƶ�ʳɷ֣�����ԭ�㣩�任������ҶƵ��ͼ����

    [width,high] = size(image_2zhi);

    D = zeros(width,high);

    %����һ��width�У�high�����飬���ڱ�������ص㵽����Ҷ�任���ĵľ���

    for i=1:width

    for j=1:high

        D(i,j) = sqrt((i-width/2)^2+(j-high/2)^2);

    %���ص㣨i,j��������Ҷ�任���ĵľ���

        H(i,j) = exp(-1/2*(D(i,j).^2)/(D0*D0));

    %��˹��ͨ�˲�����

        image_fftshift(i,j)= H(i,j)*image_fftshift(i,j);

    %���˲������������ص㱣�浽��Ӧ����

    end

    end

    image_result = ifftshift(image_fftshift);%��ԭ�㷴�任��ԭʼλ��

    image_result = uint8(real(ifft2(image_result)));
end



