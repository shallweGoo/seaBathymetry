%�ú�����������־txt�е�������ȡ��������ȡ��γ����Ϣ������
%��ȡ�����xyz

function XYZ = load_txt_for_extrinsic(o_llh,file_name)
    datas = load(file_name);
    llh = [datas(:,1), datas(:,2), datas(:,4)];
    XYZ = gcpllh2NED(o_llh,llh);
    XYZ = XYZ';
end

