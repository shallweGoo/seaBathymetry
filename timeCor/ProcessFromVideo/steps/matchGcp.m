function matchGcp(step3)
%calcRotateMatrix ���ݵ�һ֡�Ŀ��Ƶ���Σ����õ��Ƿ�������ϵķ�ʽ�����GCP����Ϣ
%ʵ���Ͽ���ͨ��solvePnP���������
% mode = 1,nlinfit
% mode = 2,solvePnP           


    gcpInfo_world_path = step3.gcpInfo_world_path;
    gcpInfo_UV_path = step3.gcpInfo_UV_path;
    intrinsic_path = step3.intrinsic_path;
    savePath = step3.savePath;
    mode = step3.mode;

    %�������������
    uav_pos_world = nan(1,3);
    
    %����gcp��UV������Ϣ
    tmp1 = load(gcpInfo_UV_path);
    gcp = tmp1.gcp;
    
    
    %����gcp��world������Ϣ
    tmp2 = load(gcpInfo_world_path);
    gcpInfo_world = tmp2.gcpInfo_world;
    uav_pos_world = tmp2.uav_pos_world;
    
    clear tmp1;
    clear tmp2;
    
    
    %�����ڲ���Ϣ
    tmp3 = load(intrinsic_path);
    intrinsics = tmp3.intrinsics;
    iopath = intrinsic_path;
    

    %gcp��Ϣ���·��
    gcpUvdPath = gcpInfo_UV_path;
    gcpXyzPath = gcpInfo_world_path;
    
    saveName = 'RotateInfo'; %��ŵ�����κ��ڲ���Ϣ��ͳһ��Ϊ��ת��Ϣ
    
    
    gcpsUsed = []; % ����Ĭ��ʹ��ȫ����gcp
    for i = 1 : size(gcpInfo_world,1)  %Ĭ��ȫ��ʹ��
        gcpsUsed = cat(2,gcpsUsed,i);
    end
    
    %����ϵ����
    gcpCoord = '�����أ�NED��:�� ';
    
    
    % ����һ�����ݣ������ݶ�Ū��gcp����ṹ����
    for k=1:size(gcpInfo_world,1)
    
        gcp(k).x=gcpInfo_world(k,1);
        gcp(k).y=gcpInfo_world(k,2);
        gcp(k).z=gcpInfo_world(k,3);
        gcp(k).WorldCoordSys = gcpCoord;
        
    end
    
    imagePath = gcp(1).imagePath; %����ͼƬ·��
    
    
    % չʾ�޸�֮���GCP��Ϣ
    disp(' ');
    disp('����GCP��Ϣ���ṹ�壩:');
    disp(gcp);
    
    %����һЩ��ʱ��������ʹ��
    
    for k=1:length(gcp)
        gnum(k)=gcp(k).num;
    end
    [~,gcpInd] = ismember(gcpsUsed,gnum);
    
    x=[gcp(gcpInd).x];
    y=[gcp(gcpInd).y];
    z=[gcp(gcpInd).z];

    xyz = [x' y' z'];  %ÿ��gcp����ʾ����ϵ�µ�xyz: N x 3 �������N��gcp���зֱ�Ϊx��y��z
    UVd = reshape([gcp(gcpInd).UVd],2,length(x))';  % N x 2 �������N��gcp, �зֱ�ΪU,V
    
    
    % ���ϵ�������ʱ����ȫ������Ϊ�˷�ֹ˳����ң�����һ�㲻����
    % Format All GCP World and UVd coordinates into correctly sized matrices for
    % non-linear solver and transformation functions (xyzToDistUV).
    xCheck=[gcp(:).x];
    yCheck=[gcp(:).y];
    zCheck=[gcp(:).z];
    xyzCheck = [xCheck' yCheck' zCheck'];  % N x 3 matrix with rows= N gcps, columns= x,y,z
    
    
if mode == 1

%��
%     extrinsicsInitialGuess= [50  50  -100 deg2rad(-35.6) deg2rad(0) deg2rad(-122.8)];
    

%����4
    extrinsicsInitialGuess= step3.extrinsicsInitialGuess;

    %  Ҫȥ���Ĳ���
    extrinsicsKnownsFlag= step3.extrinsicsKnownsFlag;  % [ x y z roll yaw pitch]
    
    %��һ���������Ż�ȥ�����ξ���
    [extrinsics,extrinsicsError]= extrinsicsSolver(extrinsicsInitialGuess,extrinsicsKnownsFlag,intrinsics,UVd,xyz);

%     extrinsicsInitialGuess= [50  50  -100 deg2rad(-35.6) deg2rad(0) deg2rad(-122.8)];
    extrinsicsInitialGuess = step3.extrinsicsInitialGuess;
    
    
    % Transform xyz World Coordinates to Distorted Image Coordinates
    
    [UVdReproj ] = xyz2DistUV(intrinsics,extrinsics,xyzCheck);
    
    
    % չʾxyz(�������������ϵ�µ�����)����������λ����Ϣ
    disp(' ')
    disp('Solved Extrinsics and NLinfit Error')
    disp( [' x = ' num2str(extrinsics(1)) ' +- ' num2str(extrinsicsError(1))])
    disp( [' y = ' num2str(extrinsics(2)) ' +- ' num2str(extrinsicsError(2))])
    disp( [' z = ' num2str(extrinsics(3)) ' +- ' num2str(extrinsicsError(3))])
    disp( [' roll = ' num2str(rad2deg(extrinsics(4))) ' +- ' num2str(rad2deg(extrinsicsError(4))) ' degrees'])
    disp( [' pitch = ' num2str(rad2deg(extrinsics(5))) ' +- ' num2str(rad2deg(extrinsicsError(5))) ' degrees'])
    disp( [' yaw = ' num2str(rad2deg(extrinsics(6))) ' +- ' num2str(rad2deg(extrinsicsError(6))) ' degrees'])
    

    %% ����������
    for k=1:length(gcp)

        % ��Ŀֻ��֪���߶�����Pz��Ҳ���������Ϣ�����ܵõ�2d->3d,��Ȼ��Ҫ��֪һά����Ϣ�����н⣨x,y,z��
        [xyzReproj(k,:)] = distUV2XYZ(intrinsics,extrinsics,[gcp(k).UVd(1); gcp(k).UVd(2)],'z',gcp(k).z);

        %�������
        gcp(k).xReprojError=xyzCheck(k,1)-xyzReproj(k,1);
        gcp(k).yReprojError=xyzCheck(k,2)-xyzReproj(k,2);

    end

    rms=sqrt(nanmean((xyzCheck-xyzReproj).^2));

    % չʾ����Ĺ���
    disp(' ');
    disp('Horizontal GCP Reprojection Error');
    disp( ('GCP Num / X Err /  YErr'));
    
    for k=1:length(gcp)
        disp( ([num2str(gcp(k).num) '/' num2str(gcp(k).xReprojError) '/' num2str(gcp(k).yReprojError) ]));
    end

    
    
    
        
    %% ��Ž��

    % ԭʼ���ݵĴ�Žṹ����Ϣ
    initialCamSolutionMeta.iopath=iopath;
    initialCamSolutionMeta.gcpUvPath=gcpUvdPath;
    initialCamSolutionMeta.gcpXyzPath=gcpXyzPath;

    % �������
    initialCamSolutionMeta.gcpsUsed=gcpsUsed;
    initialCamSolutionMeta.gcpRMSE=rms;
    initialCamSolutionMeta.gcps=gcp;
    initialCamSolutionMeta.extrinsicsInitialGuess=extrinsicsInitialGuess;
    initialCamSolutionMeta.extrinsicsKnownsFlag=extrinsicsKnownsFlag;
    initialCamSolutionMeta.extrinsicsUncert=extrinsicsError';
    initialCamSolutionMeta.imagePath=initialCamSolutionMeta.gcps(1).imagePath;

    % ����ϵͳ���
    initialCamSolutionMeta.worldCoordSys=gcpCoord;
    
    
    %% ֱ�������������̬���Լ�������̬�ǽ�����εļ���%%%%%%%%%%%%%%%%%%%%
elseif mode == 2 
    if(~isfield(step3,'no_use_gcp') || any(isnan(uav_pos_world)))
        error('mode 2 is required no_use_gcp and uav_pos_world info!!!');
    end
    
    ned2b = step3.no_use_gcp.ned2b;
    
    extrinsics = nan(1,3); %��ʼ��nan����
    extrinsics(1) = uav_pos_world(1);
    extrinsics(2) = uav_pos_world(2);
    extrinsics(3) = uav_pos_world(3);
    
    %����roll,pitch,yaw����
    extrinsics(4) = deg2rad(ned2b(1));
    extrinsics(5) = deg2rad(ned2b(2));
    extrinsics(6) = deg2rad(ned2b(3));
    

    %����������ϵ��xyzת��Ϊuv
    [UVdReproj] = shallwe_xyz2DistUV(intrinsics,extrinsics,xyzCheck);

    
    %% ������
    % ԭʼ���ݵĴ�Žṹ����Ϣ
    initialCamSolutionMeta.iopath=iopath;
    initialCamSolutionMeta.gcps=gcp;
    % �������
    initialCamSolutionMeta.imagePath=initialCamSolutionMeta.gcps(1).imagePath;

    % ����ϵͳ���
    initialCamSolutionMeta.worldCoordSys=gcpCoord;

end
    
        %% ����gcp���������鿴У��Ч��

    %  Reshape UVdCheck so easier to interpret
    UVdReproj = reshape(UVdReproj ,[],2);

    % Load Specified Image and Plot Clicked and Reprojected UV GCP Coordinates
    f1=figure;
    imshow(imagePath);
    hold on;

    for k=1:length(gcp)
        % ������ɵ�gcp��Ϣ
        h1=plot(gcp(k).UVd(1),gcp(k).UVd(2),'ro','markersize',10,'linewidth',3);
        text(gcp(k).UVd(1)+30,gcp(k).UVd(2),num2str(gcp(k).num),'color','r','fontweight','bold','fontsize',15);

        % ����У����gcp��Ϣ
        h2=plot(UVdReproj(k,1),UVdReproj(k,2),'yo','markersize',10,'linewidth',3);
        text(UVdReproj(k,1)+30,UVdReproj(k,2),num2str(gcp(k).num),'color','y','fontweight','bold','fontsize',15);
    end
    
    legend([h1 h2],'������ɵ�gcp','�������֮���������gcp');
    
    

    % �������ν��
    save([savePath saveName '_firstFrame' ],'initialCamSolutionMeta','extrinsics','intrinsics');

    %���������gcp��Ϣ�ṹ��
    save([savePath 'gcpFullyInfo'],'gcp');
    
    % չʾ���
    disp(' ');
    disp('Finished Solution');

    disp(initialCamSolutionMeta);
    
    
    
    %% ģʽѡ�񣬺����ټӽ�ȥ
%     switch mode
%         case 1
%             
%         
%         
%         case 2
%         
%                     
%         
%         otherwise
%             error("happened confliction because of unsituable mode");
%             
%             
%     end
    



end






