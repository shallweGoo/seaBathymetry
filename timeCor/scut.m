%% ���ű�����scut��ҵ���Ļ�ͼ

%%
load('data_final.mat');
load('data_struct.mat');
addpath(genpath('algoV1'));
addpath(genpath('algoV2'));
addpath(genpath('common'));

%% ����Ҷ�任Ƶ��ֲ�ͼ
eval('phantom4');
addpath('./algoV2/makeTimeStack');
data_lowpass = lowPassFliter(data, params);
Fs = params.fs;
N = params.N;
n = 0:N-1;
t = n / Fs;
% s1 = data_final(:, 15100); % 
% s2 = data_final(:, 15201); % 140

% xyz(14191, :);

% s2 = data_final(:, 15201);
% xyz(15201, :);
s1 = data(:, 15100); % 
s2 = data_lowpass(:, 15201); %

G1 = fft(detrend(double(s1)))';
G2 = fft(double(s2))';
df = Fs / N; 
dt = 1 / Fs;
f = [0 : df : 1 / (2 * dt) - df];
% figure
% plot(f, abs(G1(:, 1 : length(f))), 'b');

% title('�˲��ź�Ƶ��ͼ');

% plot_args.point_end = 100;
% plot_args.point_begin = 1;
% point_begin = 1;
% plot(t(plot_args.point_begin : plot_args.point_end), s1(plot_args.point_begin :plot_args.point_end)', 'g');
% hold on;
% plot(t(plot_args.point_begin : plot_args.point_end), s2(plot_args.point_begin :plot_args.point_end)', 'r');
% set(gca,'XTick',[0:10:100]);
% set(gca,'YTick',[0:50:600]);
% 
% xlabel('time(s)');
% ylabel('pixel intensity');
% legend('149m','150m');


% title('pixel intensity fluctuation trend');

s3 = data(:, 29128);
G3 = fft(detrend(double(s3)))';

figure
plot(f, abs(G1(:, 1 : length(f))), 'color', 'k','linewidth', 5);
% title('Frequency distribution of signal after main frequency extraction');


hold on;
s4 = data_final(:, 29128); % 
G4 = fft(detrend(double(s4)))';
df = Fs / N; 
dt = 1 / Fs;
f = [0 : df : 1 / (2 * dt) - df];
plot(f, abs(G2(:, 1 : length(f))),'color','r', 'linewidth', 2);
xlabel('Ƶ��(Hz)');
ylabel('����Ҷ�任��ֵ');
set(gca,'FontSize',15);
legend('ԭ�ź�','�˲��ź�');

close all;

%% ʱ���ջ��ͼ��timestack.jpg��
eval('phantom4');
img_path = params.final_path;
time_stack = plotTimeStack(img_path, 100);
close all;
imagesc(time_stack);
colormap(gray)


set(gca,'XTick',[0:100:params.N]);
set(gca,'xticklabel',[0 : 100 : params.N] / params.fs);
set(gca,'YTick',[0:50:params.N]);
set(gca,'yticklabel',[0: 50: params.N] .* 0.5);


set(gca,'YDir','reverse'); 
% ylim([100 400])
xlabel('����ʱ��(s)','FontSize',15);
ylabel('�簶����(m)','FontSize',15);
%% �ҵ���ѹ��Ʒ�Χ(timeCor_range.jpg)
% part1
station_str = 'phantom4';
% ִ�в���ע��
eval(station_str);
x = xyz(:, 1);
y = xyz(:, 2);
z = xyz(:, 3);
longshore = 100;
one_long_shore_id = find(y == longshore);
cross_shore_x = x(one_long_shore_id, :);
cor_num = 60;
one_long_shore_data = data_final(:, one_long_shore_id);
cor = nan(cor_num, max(cross_shore_x) - min(cross_shore_x) + 1);
params.DEBUG = 0;
for cross_shore = min(cross_shore_x) : params.dist : max(cross_shore_x)

% for cross_shore = 150 : 150
    ref_id = find(cross_shore_x == cross_shore); % �ҵ����ڵ�����
    ref = one_long_shore_data(:, ref_id);
    data_set = one_long_shore_data(:, 1 : (ref_id - 1));
%         range_id = getSuitRange1(ref, ref_id, data_set, params); % version1����ȡ����������Ǹ�ֵ����������Ϊrange_id��û�ж��źŽ���ɸѡ���õ���
    [range_id, cor(:, cross_shore - min(cross_shore_x) + 1)] = getSuitRange2(ref(1: end - params.fix_time / params.dt), data_set(1 + params.fix_time / params.dt : end, :), params);
    [mid_id, speed, f] = getMidSpeedFreq(ref, ref_id, data_set, params, range_id);% ��ȡ����ص�һ��
    disp(['progress:' num2str((cross_shore - min(cross_shore_x)) / (max(cross_shore_x) - min(cross_shore_x))* 100) '% completed']);
end

%% part2
plot_cor = flipud(cor);
plot_cor(:, 1: 61) = 0;
cmap = colormap( 'jet' );
colormap( flipud( cmap ) );
pcolor(plot_cor);
shading flat;
caxis([-1 1]); %������ȵ���ʾ��Χ
axis equal;
axis tight;
xlabel('�簶����(m)','FontSize',15);
ylabel('��Ŀ������(m)','FontSize',15);
cor_val = colorbar('peer', gca);
set(gca,'ydir','reverse');
% set(gca,'yticklabel',[60: -1 : 1]);
set(get(cor_val,'title'),'string', 'cor');

hold on;
% �ҵ�ÿ�����ֵ
for i = 61 : size(cor, 2)
    cor_struct.col = cor(:, i);
    [~, cor_struct.max_id] = max(cor_struct.col);
    cor_struct.max_point(i - 60, :) = [cor_struct.max_id, i];
end

plot(cor_struct.max_point(:,2), size(cor, 1) - cor_struct.max_point(:,1),'LineWidth', 2, 'color','w');

%% ��˹ƽ���˲�����ProcessFromVideo/paperImage.m�У�
%% �ٽ����ص�
%% �Ա�ͼ
close all;
imagesc(time_stack);
colormap(gray)



set(gca,'XTick',[0:100:params.N]);
set(gca,'xticklabel',[0 : 100 : params.N] / params.fs);
set(gca,'YTick',[0:50:params.N]);
set(gca,'yticklabel',[0: 50: params.N] .* 0.5);

line([0, params.N], [254, 254],'Color','g','LineWidth', 2);
line([0, params.N], [298, 298],'Color','b','LineWidth', 2);
line([0, params.N], [300, 300],'Color','red','LineWidth', 2);

set(gca,'YDir','reverse'); 
% ylim([100 400])
xlabel('ʱ��(s)');
ylabel('�簶����(m)');
legend('134m','149m','150m');

%% �Ա�ͼ2

figure
Fs = params.fs;
N = params.N;
n = 0:N-1;
t = n / Fs;
s1 = data_final(:, 15100); % 
% xyz(14191, :);
% s2 = data_final(:, 15201); % 140
s2 = data_final(:, 15201);

figure

plot_args.point_end = 100;
plot_args.point_begin = 1;
point_begin = 1;
plot(t(plot_args.point_begin : plot_args.point_end), s1(plot_args.point_begin :plot_args.point_end)','color', 'b','linewidth',3);
hold on;
plot(t(plot_args.point_begin : plot_args.point_end), s2(plot_args.point_begin :plot_args.point_end)' ,'color', 'r','linewidth',3);
% set(gca,'XTick',[0:10:100]);
% set(gca,'YTick',[0:50:600]);

xlabel('ʱ��(s)','FontSize',15);
ylabel('����ǿ��','FontSize',15);
legend('149m','150m');




