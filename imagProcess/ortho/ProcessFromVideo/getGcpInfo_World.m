function gcpInfo_world = getGcpInfo_World(step2) 
% �ú������ڻ�ȡgcp���Խ�����ϵ�µ����꣬Ҫ����˳�������
% �������Ϊgcp_llh(gps),o_llh(ԭ��gps),cmPara(�������)
% ������gps(��γ��llh) -> ������(enu) -> ������(ned) -> �Խ�����ϵ(new)������һ������,ԭ����Ҫ��ѡ
%
    

    gcp_llh = step2.world.gcp_llh;
    o_llh = step2.world.o_llh;
%     euler_ned2new = step2.world.euler_ned2new;
    savePath = step2.world.savePath;
    
    if(isfield(step2.world,'uav_llh'))
        uav_llh = step2.world.uav_llh;
    end
    
    gcpInfo_world = gcpllh2NED(o_llh,gcp_llh); % gcp->enu ���������֮ǰ���ļ���
    gcpInfo_world = gcpInfo_world';

    
    
%     objectPoints = gcpllh2NED(o_llh,gcp_llh); % gcp->enu ���������֮ǰ���ļ���

%     yaw = euler_ned2new(1);
%     pitch = euler_ned2new(2);
%     roll = euler_ned2new(3);
%     
%     Rotate_ned2new = Euler2Rotate(yaw,pitch,roll); 
%     Rotate_ned2new = Rotate_ned2new'; %��ȡned->new����ת����
%     
%     gcpInfo_world = Rotate_ned2new*objectPoints;
%     gcpInfo_world = gcpInfo_world';
    
    
    uav_pos_world = gcpllh2NED(o_llh,uav_llh); % gcp->ned ���������֮ǰ���ļ���
    uav_pos_world = uav_pos_world';

%     uav_pos_world = Rotate_ned2new*uav_pos_ned;
    
    disp(['uav ned pos ' num2str(uav_pos_world)]);
    
    if isempty(savePath) ~= 1
        saveName = 'gcpInfo';
        save([savePath saveName '_world'],'gcpInfo_world','uav_pos_world');
    end
    
        
end