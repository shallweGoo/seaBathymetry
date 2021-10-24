dbstop if all error  % �������
station_str = 'phantom4';
% ִ�в���ע��
eval(station_str);

% �����˲�֮����ź���ȡ


x = xyz(:, 1);
y = xyz(:, 2);
z = xyz(:, 3);
params.DEBUG = 0;
bathy.h = nan((max(x) - min(x)) / params.dist + 1, (max(y) - min(y)) / params.dist + 1); % �� * ��
bathy.speed = bathy.h;
bathy.f = bathy.h;

for longshore = min(y) : params.dist : max(y)
    one_long_shore_id = find(y == longshore);
    cross_shore_x = x(one_long_shore_id, :);
    one_long_shore_data = data_final(:, one_long_shore_id);
    for cross_shore = min(cross_shore_x) : params.dist : max(cross_shore_x)
        
        ref_id = find(cross_shore_x == cross_shore); % �ҵ����ڵ�����
        ref = one_long_shore_data(:, ref_id);
        data_set = one_long_shore_data(:, 1 : (ref_id - 1));
        
%         range_id = getSuitRange1(ref, ref_id, data_set, params); % version1����ȡ����������Ǹ�ֵ����������Ϊrange_id��û�ж��źŽ���ɸѡ���õ���
        range_id = getSuitRange2(ref(1: end - params.fix_time / params.dt), data_set(1 + params.fix_time / params.dt : end, :), params);
        [mid_id, speed, f] = getMidSpeedFreq(ref, ref_id, data_set, params, range_id);% ��ȡ����ص�һ��
        if isinf(speed) 
            speed = (ref_id - range_id) * params.dist ./ params.fix_time; % ������ʧ�ܣ�����õڶ��ַ������̶�ʱ�����, speed = dx / dt;
        end
        
        col = (longshore - min(y)) / params.dist + 1;
        if isnan(mid_id) % ɸѡ����
            continue
        end
        bathy.speed(mid_id, col) = speed;
        bathy.f(mid_id, col) = f;
        
        if isnan(bathy.h(mid_id, col))
            bathy.h(mid_id, col) = abs(calDepth(speed, f));
        else 
            bathy.h(mid_id, col) = (bathy.h(mid_id, col) + abs(calDepth(speed, f))) / 2;
        end
        
    end
    
    disp(['progress:' num2str((longshore - min(y)) / (max(y) - min(y)) * 100) '% completed']);
    
end
disp('���ݽ�����');

%% test
ref_id = 200;
longshore = 1;
params.DEBUG = 1;
one_long_shore_id = find(y == longshore);
cross_shore_x = x(one_long_shore_id, :);
one_long_shore_data = data_final(:, one_long_shore_id);
ref = one_long_shore_data(:, ref_id);
data_set = one_long_shore_data(:, 1 : (ref_id - 1));
range_id = getSuitRange2(ref(1: end - params.fix_time / params.dt), data_set(1 + params.fix_time / params.dt : end, :), params);
[mid_id, speed, f] = getMidSpeedFreq(ref, ref_id, data_set, params, range_id); % ��ȡ����ص�һ��


%%
    bathy.h(bathy.h == inf) = nan;
    world_info.x = 0 : params.dist : (params.xy_range(4) - params.xy_range(3));
    world_info.y = 0 : params.dist : (params.xy_range(2) - params.xy_range(1));
    plotBathy(world_info, abs(bathy.h));
    
    
 %%
%     itp.seaDepth = bathy.h;
%     for i = 1 : size(bathy.h, 2) % ���в�ֵ
%         interpolation.total_x = 1 : size(bathy.h, 2);
%         interpolation.now_y  = interpolation.seaDepth(:, i)';
%         interpolation.temp = interpolation.now_y;
%         interpolation.insert_x = find(isnan(interpolation.now_y));
%         interpolation.terminate_x = find(~isnan(interpolation.now_y), 1, 'last');
%         interpolation.first_x = find(~isnan(interpolation.now_y), 1, 'first');
%         interpolation.insert_x_idx = find(interpolation.insert_x >= interpolation.first_x & interpolation.insert_x <= interpolation.terminate_x);
%         interpolation.insert_x = interpolation.insert_x(interpolation.insert_x_idx);
%         interpolation.total_x(interpolation.insert_x) = [];
%         interpolation.now_y(interpolation.insert_x) = [];
%         interpolation.insert_y = interp1(interpolation.total_x, interpolation.now_y, interpolation.insert_x, 'nearest');
%         interpolation.temp(interpolation.insert_x) = interpolation.insert_y;
%         interpolation.seaDepth(:,i) = interpolation.temp;
%     end
    itp.h = bathy.h;
    for i = 1 : size(bathy.h, 2) % ���в�ֵ
        itp.tmp = bathy.h( : , i);
        itp.need_points = 1 : size(bathy.h, 1);
        itp.ins_id = find(isnan(itp.tmp));  %��Ҫ��ֵ��id
        itp.ins_x = itp.need_points(itp.ins_id);
        itp.src_id = find(~isnan(itp.tmp));    % ����ԭʼ����
        itp.src_x = itp.need_points(itp.src_id);
        itp.src_y = itp.tmp(itp.src_id);
        itp.ins_y = interp1(itp.src_x, itp.src_y', itp.ins_x, 'nearest');
        itp.tmp(itp.ins_id) = itp.ins_y;
        itp.h(:, i) = itp.tmp;
    end
    
    %% ��һЩ���ݴ����������ͻ�����һ�����Ϊ�Ƿ��ݴ�����Ҫɾ�����²�ֵ
    
    
    %%
    close all;
    figure;
    plotBathy(world_info,abs(itp.h));
