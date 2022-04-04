function gt = getGroundTruth(gt_path, mat_savePath, ds_image_savePath, xyz, o_llh, bathy, tide)
    data = load(gt_path.path1);
    objectPoints = gcpllh2NED(o_llh, data);
    objectPoints = objectPoints';
    Rotate_ned2cs = Euler2Rotate(-148.5,0,0); %֮ǰ��148,
    Rotate_ned2cs = Rotate_ned2cs';
    objectPointsInCs = Rotate_ned2cs*objectPoints';
    objectPointsInCs = objectPointsInCs'; %��һ��ת��Ϊ�Խ�����ϵ�µ�����


    %%%% 2����ͼ�ϵ������Ӧ����
    % ����ת��Ϊ����

    % Load and Display initial Oblique Distorted Image

    roi_path = [mat_savePath 'GRID_roiInfo.mat'];
    extrinsicFullyInfo_path = [mat_savePath 'extrinsicFullyInfo.mat'];

    L=string(ls(ds_image_savePath));
    L=L(3:end); % ǰ����Ϊ��ǰĿ¼.���ϼ�Ŀ¼..
    I=imread(strcat(ds_image_savePath, L(1)));
    figure;
    hold on;

    imshow(I);
    hold on;
    title('���˴������켣');
    load(roi_path);
    ex = load(extrinsicFullyInfo_path);
    Extrinsics=localTransformExtrinsics([0,0], -148.5 ,1, ex.extrinsics);
    extrinsics_ff=Extrinsics(1,:);
    [step7.UVd] = xyz2DistUV(ex.intrinsics, extrinsics_ff, objectPointsInCs); %����chooseRoi��ѡ�������������е�xyz��Ϣ��ֵ��õ�z�����ø�ֵ����uv����
    step7.UVd = reshape(step7.UVd, [], 2);
    plot(step7.UVd(:,1), step7.UVd(:,2), '*');
    xlim([0 ex.intrinsics(1)]);
    ylim([0 ex.intrinsics(2)]);
    
    % 3. get gt
    closest_point_idx = -1;
    seaDepth = bathy.h_final;
    depth = reshape(seaDepth,[], 1);
    groundTruth = nan(size(depth,1), 1);
    r = size(xyz, 1);
%     c = size(xyz, 2);
    real_depth = load(gt_path.path2);
    for i = 1 : r
        if xyz(i, 1) <= 70 % x>90��ȥ����
            continue;
        end
        ground_idx = -1;
        dis = 1e9;
        for j = 1 : size(objectPointsInCs, 1) %�м�����ʵ����data��
                ground_idx = i;
                every_dis = sqrt(abs(xyz(i,1)-objectPointsInCs(j,1))^2 + abs(xyz(i,2) + 0 -objectPointsInCs(j,2))^2); %yΪ50-150����Ҫ��50
                if(every_dis < dis) %���С�������
                    closest_point_idx = j;
                    dis = every_dis;
                end
        end
        if ground_idx ~= -1
            groundTruth(ground_idx) = real_depth(closest_point_idx);
        end

    end

    groundTruth_mat = reshape(groundTruth, size(seaDepth, 2), size(seaDepth,1));
    groundTruth_mat = rot90(groundTruth_mat,3);

    gt = tidyFix(groundTruth_mat, tide);
end