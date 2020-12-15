function matchGcp(gcpInfo_UV_Path,gcpInfo_World_Path,mode,gcpsUsed)
%calcRotateMatrix 根据第一帧的控制点来匹配接下来帧的控制点
%

% 输入参数介绍
% gcpInfo分别为gcpInfo的
    
% cmPara为相机参数
    

% ***mode为拟采用的每帧gcp匹配模式
% ***mode1为 CRIN 的阈值匹配，非线性拟合（优化）得到外参
% ***mode2为 自己做的模板匹配


    addpath(genpath('./photogrammetryFunctions'));
    
    %载入gcpInfo_UV和gcpInfo_World数据
    
    load(gcpInfo_UV_Path);
    load(gcpInfo_World_Path);
    
    
    if nargin < 3
        %默认为CRIN阈值匹配
        mode = 1;
        gcpsUsed = [];
        for i = 1 : size(gcpInfo_world,1)  %默认全部使用
            gcpsUsed = cat(2,gcpsUsed,i);
        end
    end
    
    
    
    worldCoord = '现实坐标系：x轴垂直于岸，y轴平行于岸 ';
    
    extrinsicsInitialGuess= [ 901726 274606 100 deg2rad(80) deg2rad(60) deg2rad(0)]; % [ x y z azimuth tilt swing]

    %  Enter the number of knowns, or what you would like fixed in your EO
    %  solution. 1 represents fixed where 0 represents floating (solvable) for
    %  each value in beta.
    
    extrinsicsKnownsFlag= [ 0 0 0 0 0 0];  % [ x y z azimuth tilt swing]
    
    
    
    % 整合一下数据，将数据都弄到gcp这个结构体中
    for k=1:size(gcpInfo_world,1)
    
        gcp(k).x=gcpInfo_world(k,1);
        gcp(k).y=gcpInfo_world(k,2);
        gcp(k).z=gcpInfo_world(k,3);
        gcp(k).WorldCoordSys = worldCoord;
        
    end
    
    % 展示修改之后的GCP信息
    disp(' ');
    disp('最终GCP信息（结构体）:');
    disp(gcp);
    
    %创建一些临时变量方便使用
    
    for k=1:length(gcp)
        gnum(k)=gcp(k).num;
    end
    [~,gcpInd] = ismember(gcpsUsed,gnum);
    
    x=[gcp(gcpInd).x];
    y=[gcp(gcpInd).y];
    z=[gcp(gcpInd).z];

    xyz = [x' y' z'];  %每个gcp在显示坐标系下的xyz: N x 3 矩阵代表N个gcp，列分别为x，y，z
    UVd = reshape([gcp(gcpInd).UVd],2,length(x))';  % N x 2 矩阵代表N个gcp, 列分别为U,V
    
    
    %用一个非线性优化去求解外参矩阵
    [extrinsics ,extrinsicsError]= extrinsicsSolver(extrinsicsInitialGuess,extrinsicsKnownsFlag,intrinsics,UVd,xyz);
    extrinsicsInitialGuess= [ 901726 274606 100 deg2rad(80) deg2rad(60) deg2rad(0)];

    % Display the results
    disp(' ')
    disp('Solved Extrinsics and NLinfit Error')
    disp( [' x = ' num2str(extrinsics(1)) ' +- ' num2str(extrinsicsError(1))])
    disp( [' y = ' num2str(extrinsics(2)) ' +- ' num2str(extrinsicsError(2))])
    disp( [' z = ' num2str(extrinsics(3)) ' +- ' num2str(extrinsicsError(3))])
    disp( [' azimuth = ' num2str(rad2deg(extrinsics(4))) ' +- ' num2str(rad2deg(extrinsicsError(4))) ' degrees'])
    disp( [' tilt = ' num2str(rad2deg(extrinsics(5))) ' +- ' num2str(rad2deg(extrinsicsError(5))) ' degrees'])
    disp( [' swing = ' num2str(rad2deg(extrinsics(6))) ' +- ' num2str(rad2deg(extrinsicsError(6))) ' degrees'])
    
    %% Section 7: Reproject GCPs into UVd Space
    %  Use the newly solved  extrinsics to calculate new UVd coordinates for the
    %  GCP xyz points and compare to original clicked UVd. All GCPs will be
    %  evaluated, not just those used for the solution.

    % Format All GCP World and UVd coordinates into correctly sized matrices for
    % non-linear solver and transformation functions (xyzToDistUV).
    xCheck=[gcp(:).x];
    yCheck=[gcp(:).y];
    zCheck=[gcp(:).z];
    xyzCheck = [xCheck' yCheck' zCheck'];  % N x 3 matrix with rows= N gcps, columns= x,y,z

    % Transform xyz World Coordinates to Distorted Image Coordinates
    [UVdReproj ] = xyz2DistUV(intrinsics,extrinsics,xyzCheck);

    %  Reshape UVdCheck so easier to interpret
    UVdReproj = reshape(UVdReproj ,[],2);


    % Load Specified Image and Plot Clicked and Reprojected UV GCP Coordinates
    f1=figure;
    imshow(imagePath)
    hold on

    for k=1:length(gcp)
        % Clicked Values
        h1=plot(gcp(k).UVd(1),gcp(k).UVd(2),'ro','markersize',10,'linewidth',3);
        text(gcp(k).UVd(1)+30,gcp(k).UVd(2),num2str(gcp(k).num),'color','r','fontweight','bold','fontsize',15)

        % New Reprojected Values
        h2=plot(UVdReproj(k,1),UVdReproj(k,2),'yo','markersize',10,'linewidth',3);
        text(UVdReproj(k,1)+30,UVdReproj(k,2),num2str(gcp(k).num),'color','y','fontweight','bold','fontsize',15)
    end
    legend([h1 h2],'Clicked UVd','Reprojected UVd')





    %% Section 8: Determine Reprojection Error
    %  Use the newly solved  extrinsics to calculate new xyz coordinates for the
    %  clicked UVd points and compare to original gcp xyzs. All GCPs will be
    %  evaluated, not just those used for the solution.
    for k=1:length(gcp)

        % Assumes Z is the known value; Reproject World XYZ from Clicked UVd
        [xyzReproj(k,:)] = distUV2XYZ(intrinsics,extrinsics,[gcp(k).UVd(1); gcp(k).UVd(2)],'z',gcp(k).z);

        % Calculate Difference from Surveyd GCP World Coordinates
        gcp(k).xReprojError=xyzCheck(k,1)-xyzReproj(k,1);
        gcp(k).yReprojError=xyzCheck(k,2)-xyzReproj(k,2);


    end

    rms=sqrt(nanmean((xyzCheck-xyzReproj).^2));

    % Display the results
    disp(' ')
    disp('Horizontal GCP Reprojection Error')
    disp( (['GCP Num / X Err /  YErr']))

    for k=1:length(gcp)
        disp( ([num2str(gcp(k).num) '/' num2str(gcp(k).xReprojError) '/' num2str(gcp(k).yReprojError) ]));
    end





    %% Section 9: Save Results & MetaData

    % Construct the MetaData Structure
    % Identify files used for GCP XYZ and UV Coord
    initialCamSolutionMeta.iopath=iopath;
    initialCamSolutionMeta.gcpUvPath=gcpUvdPath;
    initialCamSolutionMeta.gcpXyzPath=gcpXyzPath;

    % Identify Solution Parameters
    initialCamSolutionMeta.gcpsUsed=gcpsUsed;
    initialCamSolutionMeta.gcpRMSE=rms;
    initialCamSolutionMeta.gcps=gcp;
    initialCamSolutionMeta.extrinsicsInitialGuess=extrinsicsInitialGuess;
    initialCamSolutionMeta.extrinsicsKnownsFlag=extrinsicsKnownsFlag;
    initialCamSolutionMeta.extrinsicsUncert=extrinsicsError';
    initialCamSolutionMeta.imagePath=initialCamSolutionMeta.gcps(1).imagePath;

    % Coordinate System Information
    initialCamSolutionMeta.worldCoordSys=gcpCoord;



    % Save Results
    save([odir '/' oname '_IOEOInitial' ],'initialCamSolutionMeta','extrinsics','intrinsics')


    % Display
    disp(' ')
    disp('Finished Solution')

    disp(initialCamSolutionMeta)
    
    
    
    
    %% 模式选择，后面再加进去
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

