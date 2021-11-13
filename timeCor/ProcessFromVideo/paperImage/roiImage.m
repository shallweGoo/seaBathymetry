function roiImage(step)
%GETPIXELIMAGE �ú�����ȡ����chooseRoi������ѡ����������طֱ��ʵȵó��Ľ����mat�ļ�����������ͼƬ��ȡ
% ʹ��ǰ�ǵü���addpath(genpath('CoreFunctions')),�����������������
% inputStructΪ����Ľṹ�壬Ӧ������roi_x,roi_y,dx,dy,x_dx,x_oy,x_rag,y_dy,y_ox,y_rag,localFlag
% localFlag = 0 Ϊ��������ϵ�� = 1 Ϊ��������ϵ
% roi_x,roi_y����Ҫ����ת����������local����ϵ������world����ϵ�ж�����,����Ҫ���ñ�־λlocalFlag
% dx,dy��Ϊroi_x,roi_y�����طֱ��ʣ���λΪm
% x_dx��Ϊ x_transect(Alongshore)�����ϵ����طֱ��ʣ���λΪm
% x_oy��Ϊx_transect����yֵ
% x_rag:x_transect�ķ�Χ��x�ķ�Χ
% y_dy,y_ox,y_rag ͬ�Ͻ���

    roi_path = step.roi_path;
    extrinsicFullyInfo_path = step.extrinsicFullyInfo_path;
    unsolvedPic_path = step.unsolvedPic_path;
    savePath = step.savePath;
    inputStruct = step.inputStruct;
    





    %���˻�ϵͳ�õ���ͼƬ���߲���Ҫ��ʱ����Ϊ�վ����ˣ��ں��������extrinsicFullyInfo���¼����
    t={};
    
    % ��������˻�ϵͳ�õ�ͼƬ���ǲ���Ҫ����ô��Ϊ�ռ���
    zFixedCam={}; 
    
    %���ڽ���grid�ṹ�����
    gridPath = roi_path;
    tmp1 = load(gridPath);
    X = tmp1.X; %��֮ǰ�õ���roi_pathֻ��Ϊ�˵õ��ɹ���ֵ��X,Y,Z����
    Y = tmp1.Y;
    Z = tmp1.Z;
    localAngle = tmp1.localAngle;
    localOrigin = tmp1.localOrigin;
    localX = tmp1.localX;
    localY = tmp1.localY;
    localZ = tmp1.localZ;
    worldCoord = tmp1.worldCoord; 
    clear tmp1;
    
    %����� �������� ����� ,�ò���
    ioeopath{1} = extrinsicFullyInfo_path;
    tmp2 = load(ioeopath{1});
    extrinsics = tmp2.extrinsics;
    intrinsics = tmp2.intrinsics;
    t = tmp2.t; %ʱ��о����Ǻ���Ҫ��
%     variableCamSolutionMeta = tmp2.variableCamSolutionMeta;
    clear tmp2;
    
    
    
    imageDirectory{1} = unsolvedPic_path; %�����ͼƬ·��,ֻ��һ��·����д��1�Ϳ�����
     
    saveName = 'pixelImg';




    %  If a Fixed station, most likely images will span times where Z is no
    %  longer constant. We have to account for this in our Z grid. To do this,
    %  enter a z vector below that is the same length as t. For each frame, the
    %  entire z grid will be assigned to this value.  It is assumed elevation
    %  is constant during a short
    %  collect. If you would like to enter a z grid that is variable in space
    %  and time, the user would have to alter the code to assign a unique Z in
    %  every loop iteration. See section 3 of D_gridGenExampleRect for more
    %  information. If UAS or not desired, leave empty.
    


    



    %% Section 4: User Input: Instrument Information



    % ʹ���Խ�����ϵ�����˱�־λ��Ϊ1��ʹ�����й淶����������ϵ��NED,ENU...������ñ�־λΪ0 
    % localAngle,localOrigin, and localX,Y,Z����Ϊ��
    localFlag = 1;

    
    %  Instrument Entries
    %  Enter the parameters for the isntruments below. If more than one insturment
    %  is desired copy and paste the entry with a second entry in the structure.
    %  Note, the coordinate system
    %  should be the same as specified above, if localFlag==1 the specified
    %  parameters should be in local coordinates and same units.

    %  Note: To reduce clutter in the code, pixel instruments were input in
    %  local coordinates so it could be used for both mulit and Uas demos. The
    %  entered coordinates are optimized for the UASDemo and may not be
    %  optmized for the multi-camera demo.



    %  grid����Ҳ���ǲ�����Ĳ������ã�dx,dy���Բ���ͬ��ȡ��������
    pixInst(1).type='Grid';
    pixInst(1). dx =inputStruct.dx;  % x�����طֱ��ʣ���ÿ�����صļ��
    pixInst(1). dy =inputStruct.dy;
    pixInst(1). xlim =inputStruct.x_rag;
    pixInst(1). ylim =inputStruct.y_rag;
    pixInst(1).z={}; % Leave empty if you would like it interpolated from input
    % Z grid or zFixedCam. If entered here it is assumed constant
    % across domain and in time.

   



    %  ��y���ϲɵ㣬��ΪyTransect��y��ΪAlong shore��������������ز���
    pixInst(2).type='yTransect';
    pixInst(2).x= inputStruct.y_ox; % y������Ӧx�ĳ�ʼλ��
    pixInst(2).ylim=inputStruct.y_rag;
    pixInst(2).dy =inputStruct.y_dy; %���طֱ���
    pixInst(2).z ={};  %ʵ������z���꣬�ں����Ͽ��Թ���Ϊ0��Ϊ��˵����ͨ�������Zֵ���в�ֵ��
    % �����Ϊ��˵��Ϊ�̶�ֵ

    %
    %
    %  Runup (Cross-shore Transects)
    %  ͬ�ϣ�x���ϲɵ㣬Cross-shore��������������ز���

    pixInst(3).type='xTransect';
    pixInst(3).y= inputStruct.x_oy;
    pixInst(3).xlim=inputStruct.x_rag;
    pixInst(3).dx =inputStruct.x_dx;
    pixInst(3).z ={};  % �ò�����Ϊ��˵��z��Ϊ��ֵ��Ϊ�տ�ͨ�������Zֵ���в�ֵ,����ֱ����Ϊ��


    %% Section 5: Load Files

    % Load Grid File And Check if local is desired
    % ѡ��local����ϵ���м���
    
    if localFlag==1
        X=localX;
        Y=localY;
        Z=localZ;
    end

    % ��������κ�Ŀ��ͼƬ·��

    %  Determine Number of Cameras
    camnum=length(ioeopath);

    for k=1:camnum
        % Load List of Collection Images
        L{k}=string(ls(imageDirectory{k}));
        L{k}=L{k}(3:end); % ǰ����Ϊ��ǰĿ¼.���ϼ�Ŀ¼..

        % Check if fixed or variable. If fixed (length(extrinsics(:,1))==1), make
        % an extrinsic matrix the same length as L, just with initial extrinsics
        % repeated.
        if length(extrinsics(:,1))==1 %������Ϊ�̶�ֵ����������ֻ��һ�飬1*6����ô�м���ͼƬ�͸��Ƽ��ݼ��ɣ�Ϊ�˳���ķ�����
            extrinsics=repmat(extrinsics,length(L{k}(:)),1);
        end
        if localFlag==1     %�����׼����(ned)->�Զ�������(local),CRIN�õ��Ƕ����죨ENU��
            extrinsics=localTransformExtrinsics(localOrigin,localAngle,1,extrinsics);
        end

        % �������ݱ��ں�������
        Extrinsics{k}=extrinsics;
        Intrinsics{k}=intrinsics;

        clear extrinsics;
        clear intrinsics;
    end






    %% Section 6: Initialize Pixel Instruments

    % Make XYZ Grids/Vectors from Specifications.
    [pixInst]=pixInstPrepXYZ(pixInst); %ƴ��pixInst�ṹ��

    % Assign Z Elevations Depending on provided parameters.
    % If pixInst.z is left empty, assign it correct elevation
    for p=1:length(pixInst)
        if isempty(pixInst(p).z)==1
            if isempty(zFixedCam)==1 % If a Time-varying z is not specified 
                pixInst(p).Z=interp2(X,Y,Z,pixInst(p).X,pixInst(p).Y); % ���������zֵ��ѡ���������в�ֵ
            end

            if isempty(zFixedCam)==0 % If a time varying z is specified
                pixInst(p).Z=pixInst(p).X.*0+zFixedCam(1); % �����ȷzֵ�Ǻ����Ķ�Ϊ��ֵ
            end
            
        end
    end





    %% Section 7: Plot Pixel Instruments

    for k=1:camnum
        % Load and Display initial Oblique Distorted Image
        I=imread(strcat(imageDirectory{k}, L{k}(1)));
%         title('Pixel Instruments');

        % For Each Instrument, Determin UVd points and plot on image
       p = 1;

            % Put in Format xyz for xyz2distUVd
       xyz=cat(2,pixInst(p).X(:),pixInst(p).Y(:),pixInst(p).Z(:));
            

            %Pull Correct Extrinsics out, Corresponding In time

        extrinsics=Extrinsics{k}(1,:);
        intrinsics=Intrinsics{k};
            
        %������������ݶԱ�
        roi_range(1, :) = [pixInst(1).xlim(1), pixInst(1).ylim(1), 0];
        roi_range(2, :) = [pixInst(1).xlim(1), pixInst(1).ylim(2), 0];
        roi_range(3, :) = [pixInst(1).xlim(2), pixInst(1).ylim(2), 0];
        roi_range(4, :) = [pixInst(1).xlim(2), pixInst(1).ylim(1), 0];
        roi_uv = xyz2DistUV(intrinsics, extrinsics, roi_range);
        roi_uv = reshape(roi_uv, [], 2);
        tmp = insertShape(I, 'Line',[roi_uv(1, :) roi_uv(2, :)], 'LineWidth', 2, 'Color', 'blue');
        tmp = insertShape(tmp,'Line',[roi_uv(2, :) roi_uv(3, :)], 'LineWidth', 2, 'Color', 'blue');
        tmp = insertShape(tmp,'Line',[roi_uv(3, :) roi_uv(4, :)], 'LineWidth', 2, 'Color', 'blue');
        tmp = insertShape(tmp,'Line',[roi_uv(4, :) roi_uv(1, :)], 'LineWidth', 2, 'Color', 'blue');
        figure;
        imshow(tmp);
            % Determine UVd Points from intrinsics and initial extrinsics
        [UVd] = xyz2DistUV(intrinsics,extrinsics,xyz); %����chooseRoi��ѡ�������������е�xyz��Ϣ��ֵ��õ�z�����ø�ֵ����uv����

        % Make A size Suitable for Plotting
        UVd = reshape(UVd,[],2);
        xlim([0 intrinsics(1)]);
        ylim([0  intrinsics(2)]);

        % Make legend
        clear extrinsics;
        clear intrinsics;
    end

    % Allows for the instruments to be plotted before processing



    
end






