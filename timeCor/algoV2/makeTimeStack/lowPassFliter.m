% ���źŽ��е�ͨ�˲�

function filter_data = lowPassFliter(ori_data, params)
% bp_filter��Ϣ
bp_filter = load(['F:\workSpace\matlabWork\seaBathymetry\filter_mat\bpfilter0.05_0.5Fs' num2str(params.fs) '.mat']); %ע���޸Ķ�Ӧ���˲���
bpfilter = bp_filter.bpfilter;
filter_len = length(bpfilter);
data = detrend(double(ori_data)); % ȥ���Ի�
filter_mid =  floor(filter_len / 2);
f_start = filter_mid + 1;
for point_id = 1: length(ori_data)  
    one_data = [data(:, point_id) ; zeros(filter_len , 1)]; %�˲�����
    one_data = filter(bpfilter, 1, one_data); 
    filter_data(:, point_id) = one_data(f_start : size(ori_data, 1) + filter_mid);
end

end