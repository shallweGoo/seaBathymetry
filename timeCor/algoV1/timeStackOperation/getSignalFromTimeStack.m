function getSignalFromTimeStack(fileInfo,pattern)

% pattern ģʽ˵��
% pattern == 0 Ϊ3ά����汾
% pattern == 1 Ϊδ��һ��Ԫ���汾
% == 2,Ϊ��һ���汾


if nargin<2
    pattern = 2;
end

%�ӽ�ȡ���źŵ��ļ����л�ȡ����ͼƬ�ź�
% fileInfo.file_path = "..\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ2��ش���\�任��ͼƬ2���ݽض�\���ݽض�1\";
% % addpath(fileInfo.file_path);
% fileInfo.file_name = string(ls(fileInfo.file_path));
% fileInfo.file_name = fileInfo.file_name(3:end);
% fileInfo.file_num = size(fileInfo.file_name,1); 

% src = load(fileInfo.file_path+fileInfo.file_name(1));
% [timeStack.row,timeStack.col] = size(src.part);

% ͼƬ��СΪ361*271

% ��ԭ���ĳ���Ľ���������һ����ά����洢����,��֪���ܲ������Ч��
% usefulData = zeros(361,271,timeStack.col);


% Ԫ������汾
% org_path ="..\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ2\";
% org_name = string(ls(org_path));
% org_name = org_name(3:end);
% org = imread(org_path+org_name(1));

% ���ݽṹ��ʼ��
% usefulData = cell(fileInfo.org_imag.pic_row,fileInfo.org_imag.pic_col);

% if isfield(fileInfo,'time_lag')
%     beforeData = cell(fileInfo.org_imag.pic_row,fileInfo.org_imag.pic_col);
%     afterData = cell(fileInfo.org_imag.pic_row,fileInfo.org_imag.pic_col);
% end



% temp = fileInfo.partition.file_path; %���ٿ���
temp = fileInfo.bp_filter.file_path;





switch pattern 
    case 0
    % 3ά����汾���ݣ�֮����Ҫreshape
        for i = 1:fileInfo.time_stack.file_num
            mat_file = load(temp+"col"+num2str(i)+".mat"); %���ݵ�mat��ʽ�ļ�
            usefulData{:,i} = mat_file.part;
        end
    case 1
    % Ԫ������汾����Ҫ˫ѭ�����������㣨���Ǹо�Ԫ������������ݽṹ����ʹ�ã� δ��һ��
    temp = fileInfo.file_path; %���ٿ���
        for i = 1:fileInfo.time_stack.file_num
            mat_file = load(temp+"col"+num2str(i)+".mat"); %���ݵ�mat��ʽ�ļ�
            temp_mat = mat_file.part;
            for j= 1:size(temp_mat,1)
                usefulData{j,i} = temp_mat(j,:);
            end
        end
    case 2
    % Ԫ������汾��һ���汾����Ҫ˫ѭ�����������㣨���Ǹо�Ԫ������������ݽṹ����ʹ�ã� v1.0
    % 2021.05.26�������Ϊ����汾
        for i = 1 :fileInfo.time_stack.file_num
            
            mat_file = load(temp+"col"+num2str(i)+".mat"); %���ݵ�mat��ʽ�ļ�
%             temp_mat = mat_file.part;
            temp_mat = mat_file.afterFilt;
            for j= 1:size(temp_mat,1)
                signal =  temp_mat(j,:)./max(abs(temp_mat(j,:)));
%                 usefulData{j,i} = signal;
                usefulData(j,i,:) = signal;
                if isfield(fileInfo,'time_lag')
                    if mod(fileInfo.time_lag.timelag,fileInfo.time_lag.delta_t) ~= 0
                        error("you need to reselect fixed_time in interval time's integer multiple");
                    end
                    beforeData(j,i,:) = signal(:,1:end-fileInfo.time_lag.timelag/fileInfo.time_lag.delta_t);
                    afterData(j,i,:) = signal(:,fileInfo.time_lag.timelag/fileInfo.time_lag.delta_t+1:end);
                    
               end
            end
            
            disp("data prepare" + num2str(i/fileInfo.time_stack.file_num*100) + "% completed ..." ) ;
        end
end

target_dir = fileInfo.create_cell.file_path;
save(target_dir + "data_cell_det&nor.mat","usefulData"); %�õ�ȥֱ��������0Ƶ������һ��������

if isfield(fileInfo, 'time_lag')
    target_dir = fileInfo.time_lag.file_path;
    save(target_dir + fileInfo.time_lag.save_name_before,"beforeData"); %�õ�ǰ�������ݣ�(�ȷ���)
    save(target_dir + fileInfo.time_lag.save_name_after,"afterData"); %�õ�����������,(����)
end

end