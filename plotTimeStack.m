% �ú���������Ϊ����ĳһ�е�����ʱ���ջ
% img_pathΪ����·��
% colΪҪ������һ��
function time_stack = plotTimeStack(img_path, col)
    all_pic = string(ls(img_path));%ֱ�Ӱ������е��ļ���
    all_pic = all_pic(3:end);
    for i = 1 : length(all_pic)
        src = imread(img_path + all_pic(i));
        time_stack(:,i) = src(:, col);
    end
%     imshow(time_stack);
%     image(time_stack);
%     colorbar;
%     xlabel('x');
%     xlabel('y');
end