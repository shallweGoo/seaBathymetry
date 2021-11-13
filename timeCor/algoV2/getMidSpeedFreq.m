
% �ú������������ҵ���reference�źŻ����ϵ�������Ǹ���
% ��������� 
% 1��ref �� �ο��ź�
% 2��data_set �� �źż�
% 3��ref_id �� 

function [mid_id , speed, freq] = getMidSpeedFreq(ref, ref_id, data_set, params, range_id)
if isempty(data_set) || isnan(range_id) 
    mid_id = nan;
    speed = nan;
    freq = nan;
    return;
end
freq = getFreq(ref, ref, params);
data_range = data_set(:, range_id : end);
timelag = getTimelag(ref, data_range, params);
timelag = flipud(timelag);
for time_id = 2 : length(timelag)      % �����źŵ�����ԭ��ʱ�䲢����չ�ֵ����Ĺ��ɣ���������䣬���Դ�ʱ��Ҫɸѡʱ���ź�
     if timelag(time_id) < timelag(time_id - 1) || timelag(time_id) > timelag(time_id - 1) + 2
            break;
     end
end
timelag = [0; timelag(1 : time_id - 1, :)];
position = [0 : length(timelag) - 1]' .* params.dist;


% ����ʱ��Ӧ�ò�����10
time_id = find(timelag < 10);
timelag = timelag(time_id);
position = position(time_id);


% timelag = [0; timelag(1 : time_id - 1, :)];

% position = [0 : length(timelag) - 1]' .* params.dist;



linear_curve = polyfit(timelag, position, 1);   % ���
speed = linear_curve(1);
if params.DEBUG == 1
    clf;
    figure(3);
    plot(timelag, position, 'k*');  % ����timelag��position�Ĺ�ϵ
    hold on;
    tmp_y = polyval(linear_curve, timelag);
    plot(timelag, tmp_y, 'color','r', 'LineWidth',3);
%     title('wave celerity fitting');
    xlabel('time lag(s)');
    ylabel('distance(m)');
    
end



mid_id = round((range_id + ref_id) / 2);

end


% �ҵ�����������Ǹ����id�� �ͻ����ֵ
function timelag = getTimelag(ref, data, params) 
timelag = zeros(size(data, 2), 1);
max_cor_val_set = timelag;
for i = 1 : size(data, 2) % ��n���ź�
    [cor_mag, series_num] = xcorr(ref, data(:, i), 15, 'coeff'); %'coeff'����Ϊ��һ��������������õ���
    [max_cor, max_id] = max(cor_mag); % ���������ֵ
    timelag(i, :) = abs(series_num(max_id) * params.dt); % ���ֵ��Ӧ��ʱ���
    max_cor_val_set(i, :) = max_cor;
    if params.DEBUG == 1
        figure(32);%  �����ͼ�����32
        plot(series_num, cor_mag);
    end
end

end

% ��ȡ���ʵĹ��Ʒ�Χ
% ѡȡ��ԭ��


% ��ȡ���źŵĻ������׾���
function freq = getFreq(s1, s2, params)
    [Pxy, F] = cpsd(s1, s2,[], [], [], params.fs);
%     Pxy(Cxy<0.1) =0;
    mag = abs(Pxy);
    
    
    if params.DEBUG == 1
        figure(33);%  �����ͼ�����32
        plot(F, mag);
        title('��������');
    end
    id = find(F >= min(params.fB) ...
             & F <= max(params.fB));
    
    validMag = mag(id, :);
    validF = F(id, 1);
    freq = validMag'* validF / sum(validMag);
end





