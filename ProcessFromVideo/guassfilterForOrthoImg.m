function guassfilterForOrthoImg(step)

    imgInfo.path = step.path;
    imgInfo.save_path = step.save_path;


    allFile = string(ls(imgInfo.path));
    allFile = allFile(3:end);

    len = length(allFile);

    for i = 1:len
        org_pic = imread((imgInfo.path+allFile(i)));
        res = gaussfilter(org_pic,50);
        imwrite(res,(imgInfo.save_path+allFile(i)));
        disp([num2str(i/len*100) '% Complete'])
    end



    pi1 = org_pic(:,90);
    res = gaussfilter(org_pic,50);
    pi2 = res(:,90);
    figure(1);plot((1:size(pi1,1)),pi1,'r',(1:size(pi1,1)),pi2,'black');
    figure(2);imshow(res);
%     
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

%real��������ȡ������ʵ����

%uint8�������ڽ����ص���ֵת��Ϊ�޷���8λ������ifft����������Ҷ�任

