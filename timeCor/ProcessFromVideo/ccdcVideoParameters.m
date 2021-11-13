addpath(genpath('./ProcessFromVideo/CoreFunctions/'));
% rootPath = 'F:/workSpace/matlabWork/imgResult/';
rootPath = 'H:/imgResult/';
foldName = ["downSample/" "filt/" "resMat/" "orthImg/" "gaussFilt/"];
ds_image_savePath =  [rootPath char(foldName(1))];
filter_image_savePath = [rootPath char(foldName(2))];
mat_savePath = [rootPath char(foldName(3))];
% intrinsics_name = 'intrinsicMat_phantom4rtk.mat';
intrinsics_name = 'intrinsicMat_mavir_pro_1080.mat';
fs = 4;
%% step1
% videoPath �� ��Ƶ�ľ���·��
% savePath �� ��Ž��ͼƬ�ľ���·��
% fs �� ����Ƶ��
% videoRange �� Ϊһ��1*2���飬videoRange(1)Ϊ��ȡ��Ƶ�Ŀ�ʼʱ�䣬videoRange(2)Ϊ��Ƶ����ʱ�䣬��λΪ��
step1.videoPath = 'E:/����ԭʼ����/2021.01.21˫����/2021_01_21��/DJI_0183.MOV'; % 
step1.savePath = ds_image_savePath;
step1.filterPath = filter_image_savePath;
step1.fs = fs;
step1.d0 = 50;
step1.videoRange = [300, 600]; %5���ӵĽ�ȡʱ��,һ���У�end-begin��*fs�Ų���ͼƬ

%% step2
% ���������
% gcp_llh �� gcp�ľ�γ�ߣ�gps�ó�
% o_llh �� local����ϵԭ��ľ�γ�ߣ�gps�ó�
% euler_ned2new �� ned����ϵתlocal����ϵ��ŷ���ǣ�һ��ֻ��ƫ���й� 1*3����,��Ӧyaw,pitch,roll
% savePath �� �������ľ���·��
step2.world.savePath = mat_savePath;
step2.world.gcp_llh = [
    [22.5960988,114.8759359,0];
    [22.5959546,114.8762086,0];
    [22.5958634,114.8765426,0.1];
    [22.5952071,114.8767393,2.2];
    [22.5948237,114.8764282,2.1];
];
step2.world.o_llh = [22.5958634,114.8765426,0.1];
step2.world.euler_ned2new = [-148.5, 0, 0];
step2.world.uav_llh = [22.596833 114.877683 88];

%   fs �� ����Ƶ��
%   mode �� ģʽ1����ȡgcp�ں����ڶ������Ϣ��ģʽ2����ȡ����֮ǰ����Ϣ֮�⣬�������gcpģ��
ff_name = string(ls(ds_image_savePath));
ff_name = ff_name(3);%Ϊ��һ֡��ͼƬ����
ff_name = char(ff_name);
step2.UV.imagePath = [ds_image_savePath ff_name];
step2.UV.gcpSavePath = mat_savePath;
step2.UV.fs = fs;
getGcpInfo_UV(step2, 1);


%% step3
% ������ �Ե�һ֡��ȡ����gcp���ݣ���UV���ݺ�World���ݽ�ϣ�,�Լ���һ֡�����
% ����ԭ�� matchGcp(gcpInfo_UV_path,gcpInfo_world_path,intrinsic_path,savePath,mode)
% ���������
% gcpInfo_UV_path��gcp_UV��Ϣmat��ʽ���ݵľ���·��
% gcpInfo_world_path��gcp_world��Ϣmat��ʽ���ݵľ���·��
% intrinsic_path��1*11�Ľṹ�壬����ڲ�
% savePath��gcpȫ����Ϣ���ϵĽṹ�����һ֡ͼƬ�����δ�ŵľ���·��

step3.gcpInfo_UV_path = [mat_savePath 'gcpInfo_firstFrame.mat'];
step3.gcpInfo_world_path = [mat_savePath 'gcpInfo_world.mat'];
step3.intrinsic_path = ['./neededData/',intrinsics_name];
step3.savePath = mat_savePath;

% mode = 1�� ��������ϼ������
% mode = 2��������̬��ֱ�Ӽ������
step3.mode = 1; 
%��������ϵĳ�ʼֵ��

% ǰ��Ϊ�����NED����ϵ�µ�����
% ����Ϊ�����roll, yaw, pitch
% rtk�汾
% step3.extrinsicsInitialGuess = [50  50  -90 deg2rad(-26.7) deg2rad(0) deg2rad(-100)];
% mavoc
step3.extrinsicsInitialGuess = [110  120  -87 deg2rad(-16) deg2rad(0) deg2rad(-114)];
step3.extrinsicsKnownsFlag = [0,0,0,0,0,0];

%% step4
% gcp_path �� ��step3���õ���gcp��ȫ����Ϣ��mat��ʽ���ݵľ���·��
% savePath �� ���յõ���scp��Ϣ�Ĵ��·��
% fs ������Ƶ��
% brightFlag����ɫӳ��ѡ���ѡΪ'bright'��'dark' �ֱ��Ӧ ��ɫΪ������ֵӳ�����ɫΪ������ֵӳ��
step4.gcp_path = [mat_savePath 'gcpFullyInfo.mat'];
step4.savePath = mat_savePath;
step4.fs = fs;
step4.brightFlag = 'bright'; 

%% step5
% ���������
% scp_path �� scp��Ϣ��mat��ʽ���ݾ���·��
% gcp_path �� gcp��Ϣ��mat��ʽ���ݾ���·��
% rotateInfo_path �� ��һ֡����ת��Ϣ��mat��ʽ���ݾ���·��
% unsovledExtrinsic_pic_path �� ���������ͼƬ�Ĵ�ž���·��
% savePath �� ȫ������ξ�����Լ������Ϣ�Ĵ�ž���·����Ϊ���·��
% mode ��ģʽ1Ϊ����scp��Ϣ��ģʽ2Ϊ����ģ����Ϣ
step5.scp_path =[mat_savePath 'scpInfo_firstFrame.mat'];
step5.gcp_path = [mat_savePath 'gcpFullyInfo.mat'];
step5.rotateInfo_path = [mat_savePath 'RotateInfo_firstFrame.mat']; %��һ����matchGcp�õ��ĵ�һ֡�����
step5.unsovledExtrinsic_pic_path = ds_image_savePath;
step5.savePath = mat_savePath;
step5.mode = 1;
step5.fs = fs;


%% step6
% ��������ѡ�����Ȥ������,��Ҫ�ǻ�ȡ�������local_xyz��Ϣ
% ����ԭ�� chooseRoi(gcpInfo_path,rotateInfo_path,roi_x,roi_y,pixel_resolution,savePath)
% ���������
% gcpInfo_path��gcp��Ϣ��mat��ʽ���ݾ���·��
% rotateInfo_path �� ��һ֡����ת��Ϣ��mat��ʽ���ݾ���·��
% roi_x,roi_y ������Ȥ�����x��y�᷶Χ����Ϊ1*2����
% pixel_resolution �� ÿ�����ص�����ľ���
% savePath �� ������Ϣ�Ĵ���·��
step6.gcpInfo_path = [mat_savePath 'gcpFullyInfo.mat'];
step6.rotateInfo_path = [mat_savePath 'RotateInfo_firstFrame.mat'];
step6.roi_x = [0,300]; % ������300
step6.roi_y = [0,150];
%��NED->Local����ϵ�Ĳ���������һ����ʵ��
% step6.local_angle = -148.5; %GEO(NED)->Local(world)��ƫ���ǣ����ֶ��򶨷���
step6.local_angle = -148.5;
step6.local_origin = [0,0]; %NED��world��ԭ��ƫ�ã�һ�㶼��0
step6.pixel_resolution = 0.5;
step6.savePath = mat_savePath;

step6.local_flag_input = 1;%����Ĳ��������world����ϵ�ġ�


%% step7
% ���������
% roi_path �� roiϢ��mat��ʽ���ݾ���·��
% extrinsicFullyInfo_path ������ͼƬ��ε�mat��ʽ���ݵľ���·��
% unsolvedPic_path �� �����ͼƬ�Ĵ�ž���·��
% savePath �� ���·����������ص�ͼƬ

% inputStruct �� ����Ľṹ�壬Ӧ������roi_x,roi_y,dx,dy,x_dx,x_oy,x_rag,y_dy,y_ox,y_rag,localFlag
% localFlag = 0 Ϊ��������ϵ�� = 1 Ϊ��������ϵ
% roi_x,roi_y����Ҫ����ת����������local����ϵ������world����ϵ�ж�����,����Ҫ���ñ�־λlocalFlag
% dx,dy��Ϊroi_x,roi_y�����طֱ��ʣ���λΪm
% x_dx��Ϊ x_transect(Alongshore)�����ϵ����طֱ��ʣ���λΪm
% x_oy��Ϊx_transect����yֵ
% x_rag:x_transect�ķ�Χ��x�ķ�Χ
% y_dy,y_ox,y_rag ͬ�Ͻ���
step7.roi_path = [mat_savePath 'GRID_roiInfo.mat'];
step7.extrinsicFullyInfo_path = [mat_savePath 'extrinsicFullyInfo.mat'];
step7.unsolvedPic_path = filter_image_savePath;
step7.savePath = mat_savePath;


step7.inputStruct.roi_x = [0,300];
step7.inputStruct.roi_y = [0,100];
step7.inputStruct.dx = 0.5;
step7.inputStruct.dy = 0.5;

step7.inputStruct.x_dx = 0.5;
step7.inputStruct.x_oy = 0;
step7.inputStruct.x_rag = [0,300];

step7.inputStruct.y_dy = 0.5;
step7.inputStruct.y_ox = 0;
step7.inputStruct.y_rag = [0,100];
%% step8

% pixelInst_path �� ������Ϣ�Ľṹ�ľ���·��
% savePath �� ������Ϣ
step8.pixelInst_path = [mat_savePath 'pixelImg.mat'];
step8.savePath = [rootPath char(foldName(4))];


