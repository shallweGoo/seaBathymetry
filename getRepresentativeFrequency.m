% ���������
% 1��signal1:��һ��ʱ���ź�
% 2��signal2:�ڶ���ʱ���ź�
% 3��Ŀ��Ƶ�ʵ�
function f = getRepresentativeFrequency(signal1,signal2,source_f,Fs)
    %���㻥������
    [Pxy,F] = cpsd(signal1,signal2,[],[],[],Fs);
    mag = abs(Pxy);
    figure(33); % ������ͼ�����
    plot(F,mag);
    
    id = find_target_f_point(source_f,F,mag); %��ȡƵ��

    f = F(id)'*mag(id)/sum(mag(id));
    
end


%��Ŀ��Ƶ�ʵ�
function target_id = find_target_f_point(source_f,total_f,cpsd_val)
    target_val = zeros(1,length(source_f));
    for i = 1:length(source_f)
        id = find(abs(source_f(i)-total_f)<0.01);%����
        for j = 1:length(id)
            if target_val(i) < cpsd_val(id(j))
                target_val(i) = cpsd_val(id(j));
                target_id(i) = id(j);
            end
        end
    end
end