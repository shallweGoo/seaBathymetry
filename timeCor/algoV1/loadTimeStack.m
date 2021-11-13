function pic_info = loadTimeStack(id, fold_path, params) 
    pic_info.id = id;
    pic_info.file_path =  fold_path+"\�任��ͼƬ"+pic_info.id+"\";% ͼ���ļ���·��
    pic_info.all_pic = string(ls(pic_info.file_path));%ֱ�Ӱ������е��ļ���
    pic_info.all_pic = pic_info.all_pic(3:end);
    pic_info.pic_num = size(pic_info.all_pic, 1);%ͳ��������Ƭ������

%     src=imread(pic_info.file_path+pic_info.all_pic(1));
%     clear src;

    pic_info.prm = params.dxm;               %��λ��,pixel resolution meter
    load(fold_path+"\�任��ͼƬ"+ pic_info.id +"��ش���\����Ԫ������\data_cell_det&nor.mat");
    load(fold_path+"\�任��ͼƬ"+ pic_info.id +"��ش���\����Ԫ������\after.mat");
    load(fold_path+"\�任��ͼƬ"+ pic_info.id +"��ش���\����Ԫ������\before.mat");
    pic_info.afterFilter = usefulData;
    pic_info.timelag_before = beforeData;
    pic_info.timelag_after = afterData;
    [pic_info.row, pic_info.col, ~] = size(pic_info.afterFilter);
    
    clear usefulData;
    clear beforeData;
    clear afterData;
    
end