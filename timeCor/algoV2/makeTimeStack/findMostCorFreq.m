% �ҵ�Ƶ������صļ�����

function ff = findMostCorFreq(G, params) 
nKeep = params.nKeep;
% g = 9.82;   % ����
f = params.f;   % ʵ�ʵ�Ƶ�ʷ�Χ
fB = params.fB; % ��Ҫö�ٵ�fB��Χ
for i = 1 : length(fB)
    f_id = find(abs(fB(i)-f) < (fB(2)-fB(1))/2);    %�ҵ���Ӧ��Ƶ�ʷ�Χ
    C(:, :, i) = G(f_id, :)' * G(f_id,:) / length(f_id);    % �������׾���
end

coh2 = squeeze(sum(sum(abs(C)))/(size(G, 2) * (size(G, 2)- 1))); % �����ϵ��

[~, coh2Sortid] = sort(coh2, 1, 'descend');  % sort by coh2 ������ֵ��������,coh2Sortid������ԭ��������ֵ�����������CEOF��ԭ���
ff = fB(coh2Sortid(1:nKeep));         % keep only the nKeep most coherent��ѡnKeep������ɵ�Ƶ��

end