% �汾2����ȡ����������Ǹ���,����ʱ���źţ�Ĭ��3s
function [id, cor_val] = getSuitRange2(ref, data_set, params)
num = 60;
cor_val = nan(num, 1);
id = nan;
if isempty(data_set)
   return;
end
for i = 1 : size(data_set, 2) % ��n���ź�
    cor_coff(:, i) = corr(ref, data_set(:, i), 'type', 'Pearson'); %��ȡ�����ϵ��
end

if params.DEBUG == 1
    figure(2);  % 2�Ŵ�������debug
    plot(cor_coff, 'r'); 
end

[~, id] = max(cor_coff);

tmp = cor_coff(max(end - num + 1, 1) : end)'; % ����Ϊ50�Ļ������ֵ

if length(tmp) ~= num
    cor_val(1 : length(tmp), 1) = tmp;
    cor_val = flipud(cor_val);
else 
    cor_val = tmp;
end
    
end