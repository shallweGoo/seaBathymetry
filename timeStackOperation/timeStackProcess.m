%ͳһtimeStack������
%
clear 
clc
foldPath = "F:\workSpace\matlabWork\corNeed_imgResult\";
fs = 2;
% ��ָ��·�������ļ���
dir_ind = 19;
dir_ind = num2str(dir_ind);
fileInfo.file_dir.dir_name = foldPath + "�任��ͼƬ"+dir_ind+"��ش���\";
fileInfo.file_dir.res_dir = ["�任��ͼƬ"+dir_ind+"ʱ���ջ", "�任��ͼƬ"+dir_ind+"��ͨ�˲�", "�任��ͼƬ"+dir_ind+"���ݽض�", "����Ԫ������", "���ս��"];


for i = 1:length(fileInfo.file_dir.res_dir)
    if ~exist(fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(i),'dir')
         mkdir(fileInfo.file_dir.dir_name,fileInfo.file_dir.res_dir(i));
    end
end


%%
% ����fullTimeStack,����Ҫ����Ϣ
fileInfo.org_imag.file_path = foldPath + "�任��ͼƬ"+dir_ind+"\";
fileInfo.org_imag.pic_name = string(ls(fileInfo.org_imag.file_path));
fileInfo.org_imag.pic_name = fileInfo.org_imag.pic_name(3:end);
fileInfo.org_imag.pic_num = length(fileInfo.org_imag.pic_name);
tmp=imread(fileInfo.org_imag.file_path+fileInfo.org_imag.pic_name(1));
[fileInfo.org_imag.pic_row,fileInfo.org_imag.pic_col] = size(tmp);

%% ����fullTimeStack.m
fullTimestack(fileInfo);

%% ����bpFilterForTimeStack����Ҫ����Ϣ
fileInfo.time_stack.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(1)+"\";
fileInfo.time_stack.file_name = string(ls(fileInfo.time_stack.file_path));
fileInfo.time_stack.file_name = fileInfo.time_stack.file_name(3:end);
fileInfo.time_stack.file_num = length(fileInfo.time_stack.file_name);



% bp_filter��Ϣ
fileInfo.bp_filter.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(2)+"\";
fileInfo.bp_filter.used_filter = load(['F:\workSpace\matlabWork\seaBathymetry\filter_mat\bpfilter0.05_0.5Fs' num2str(fs) '.mat']); %ע���޸Ķ�Ӧ���˲���
fileInfo.bp_filter.file_name = string(ls(fileInfo.bp_filter.file_path));
fileInfo.bp_filter.file_name = fileInfo.bp_filter.file_name(3:end);
fileInfo.bp_filter.file_num = length(fileInfo.bp_filter.file_name);

% partition��Ϣ��û��
% fileInfo.partition.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(3)+"\";
% fileInfo.partition.file_name = string(ls(fileInfo.partition.file_path));
% fileInfo.partition.file_name = fileInfo.partition.file_name(3:end);
% fileInfo.partition.file_num = length(fileInfo.partition.file_name);
% 
% % �˲�֮���źſ�ͷ�ͽ�β�����ܻ�ʧ�棬���Բ�Ҫ�Ƕ��ˣ����淢�ֲ���ȡҲ����
% fileInfo.partition.begin = 30; %�ܹ�300s,����600�㣬��ȡһ�³���
% fileInfo.partition.end = 570;


%% ����bpFilterForTimeStack.m  ��getPartOfData.m�ϲ��汾 ���ɲ��õ�����getPartOfData.m�汾���н�ȡ�źţ�
bpFilterForTimeStack(fileInfo); %����������˽�ȡ�źŵĲ���

%% ���һ��Ԫ������
fileInfo.create_cell.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(4)+"\";
fileInfo.create_cell.file_name = string(ls(fileInfo.create_cell.file_path));
fileInfo.create_cell.file_name = fileInfo.create_cell.file_name(3:end);
fileInfo.create_cell.file_num = length(fileInfo.create_cell.file_name);

%ʱ���ź�Ԫ������
fileInfo.time_lag.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(4)+"\";
fileInfo.time_lag.timelag = 3; %3s
fileInfo.time_lag.delta_t = 1/fs;
fileInfo.time_lag.save_name_before = "before";
fileInfo.time_lag.save_name_after = "after";

%% �����cBathyһ���Ĵ����裬ȥ��һЩ�޹ص�Ƶ�ʷ���



%% ����getSignalFromTimeStack.m
getSignalFromTimeStack(fileInfo);%����һ���Ž����ݹ�һ��������һ��Ԫ������


