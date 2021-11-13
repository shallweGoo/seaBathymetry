function [gcpInfo_world, uav_local] = getGcpInfo_World(step2) 
% �ú������ڻ�ȡgcp���Խ�����ϵ�µ����꣬Ҫ����˳�������
% �������Ϊgcp_llh(gps),o_llh(ԭ��gps),cmPara(�������)
% ������gps(��γ��llh) -> ������(enu) -> ������(ned) -> �Խ�����ϵ(new)������һ������,ԭ����Ҫ��ѡ
%
    

    gcp_llh = step2.world.gcp_llh;
    o_llh = step2.world.o_llh;

    savePath = step2.world.savePath;
    
    if(isfield(step2.world,'uav_llh'))
        uav_llh = step2.world.uav_llh;
    end
    
    gcpInfo_world = gcpllh2NED(o_llh, gcp_llh); % gcp->enu ���������֮ǰ���ļ���
    gcpInfo_world = gcpInfo_world';
%     gpcInfo_local = ned2local(o_llh, gcpInfo_world);
    
    uav_pos_world = gcpllh2NED(o_llh, uav_llh); % gcp->ned ���������֮ǰ���ļ���
    uav_pos_world = uav_pos_world';
    uav_local = ned2local(uav_pos_world, step2);
    
    disp(['uav loal pos ' num2str(uav_local)]);
    
    if isempty(savePath) ~= 1
        saveName = 'gcpInfo';
        save([savePath saveName '_world'],'gcpInfo_world','uav_pos_world');
    end
    
        
end


% ����Ϊned����
function local = ned2local(target_ned, step2)
    euler_ned2new = step2.world.euler_ned2new;    

    yaw = euler_ned2new(1);
    pitch = euler_ned2new(2);
    roll = euler_ned2new(3);
    
    Rotate_ned2new = Euler2Rotate(yaw, pitch, roll); 
    Rotate_ned2new = Rotate_ned2new'; %��ȡned->new����ת����
    
    local = Rotate_ned2new * target_ned';
    local = local';
end

