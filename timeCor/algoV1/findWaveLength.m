%���ڷ��ֲ�������Ʋ���������ȷ�����Ʒ�Χ
%�������ᵽ�̶�ʱ��Ϊ3s���Զ�Ӧһ���ʺϵ�ʱ��
%����Ϊһ���ṹ�壬�������Ҫ��������Ԫ�����飬һ����0~end-3s���źţ�һ����3s~end���źţ��źų���һ��

function  WaveLengthInfo = findWaveLength(picInfo)
    WaveLengthInfo = nan(picInfo.row,picInfo.col);

    for i = 1:picInfo.col
        source = squeeze(picInfo.timelag_before(:,i,:))'; % ��һ�е�Ԫ�ر����������������㻥���
        cmp = squeeze(picInfo.timelag_after(:,i,:))';
       
        CorMatrix = corr(source,cmp,'type','Pearson'); %�õ�һ�е�������
        [~,index] = max(CorMatrix,[],2);%��ȡÿ�е����ֵ�Լ�����
        
        %debug���
%         figure(98);
%         title("3sʱ��������");
%         plot(CorMaxtrix(end,:));%���һ�еĻ����ֵ
%         legend('3sʱ����ض�','Location','northeast');
        
        WaveLengthInfo(:,i) = index';
    end

    
end

