% clc
% close all;

Fs = 2;
N = 601;
n = 0:N-1;
t = n / Fs;
noise = sin(2*pi*0.7*t);
x = 2*sin(2*pi*0.2*(t-1));
% x =20*rand(1,N);
y = 2*sin(2*pi*0.2*t);%��������ں�����ƽ��ʱ�䲻�ᳬ��T/2��y����x
% y2 = rand(1,N);
% y = zeros(2,N);
% y(1,:) = y1;
% y(2,:) = y2; 
% 
% sum_xy = x;
 %�ȷ�����x,����x = sin(2*pi*0.2*(t+1))��y =sin(2*pi*0.2*t)����ʱ���Ϊ��
% [m,n] = correlationCalc(x,y,1/Fs)
% corr(x',y','type','Pearson')



%% fft����
close all;
Fs = 4;

n = 0:N-1;
t = n / Fs;
s1 = data_final(:, 29128);
s2 = data_final(:, 29936);
N = length(s1);
% s2 = row_timestack(300, :);
G1 = fft(double(s1))';
df = Fs / N; 
dt = 1 / Fs;
f = [0 : df : 1 / (2 * dt) - df];
% figure
% plot(f, abs(G1(:, 1 : length(f))), 'b');
% title('�˲��ź�Ƶ��ͼ');

figure
plot(t(1:100), s1(1:100)', 'r');
hold on;
plot(t(1:100), s2(1:100)', 'k');
title('ʱ��ͼ');

figure;
s3 = data(:, 29128);
G3 = fft(detrend(double(s3)))';
figure
plot(f, abs(G3(:, 1 : length(f))), 'b');
title('origal signal in frequency domain distribution');
hold on;
plot(f, abs(G1(:, 1 : length(f))), 'k');

%%
% plot(1: N, s1, 'g');
% plot(f, abs(G(:, 1 : length(f))), 'b');
id1 = int64(0.7 / df) + 1;
id2 = N + 2 - id1; 
G(:, id1) = 0;
G(:, id2) = 0;
plot(1: N, abs(G(:)), 'r');
s2 = ifft(G);
figure(100)
plot(1:N, s2, 'g');
hold on;
plot(1:N, x, 'r');
%% ��һ��Ϊ����ƽ������Ժ͹�����
% [Cxy,F] = mscohere(x,y,hamming(100),80,100,Fs);
% subplot(2,1,1);
% plot(F,Cxy)
% title('Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% grid

% [Pxy,F] = cpsd(x,x,hamming(100),80,100,Fs);
% % [Pxy,F] = cpsd(x,x,[],[],[],Fs);
% %     Pxy(Cxy<0.1) =0;
% mag = abs(Pxy);
% plot(F,mag);





%% ��һ���ǲ���ȥֱ���������鿴����Ч�����ֱ���������ȥֱ�������������ԣ�����Ƶ��ͼ�͹������ϻ���

    dir_ind = num2str(18);
    col_num = num2str(100);

    %timestack_foldPath = "F:\workSpace\matlabWork\corNeed_imgResult\"+"�任��ͼƬ"+dir_ind+"��ش���\"+"�任��ͼƬ"+dir_ind+"ʱ���ջ\";
    timestack_foldPath = "F:\workSpace\matlabWork\corNeed_imgResult\"+"�任��ͼƬ"+dir_ind+"��ش���\"+"�任��ͼƬ"+dir_ind+"��ͨ�˲�\";
    real_file = timestack_foldPath + "col" + col_num;
    load(real_file);

   cr = 300; %choose row ��ѡ������

    
   row = double(afterFilt);
   x = row(cr,:);

   Fs = 2;
   %ȥֱ������
   x1 = clrDc(x,1); %detrend����̫��
   x2 = clrDc(x,2);
   x3 = clrDc(x,3);
   
%    fftAnalysis(x1,Fs);
%    fftAnalysis(x2,Fs);
%    fftAnalysis(x3,Fs);
   clf;
   figure(41);
   plot(x,'k');
   hold on;
   plot(x1,'r');
   hold on;
   plot(x2,'g');
   hold on;
   plot(x3,'b');
%    hold on;
%    plot(afterFilt(cr,:),'b*');
   
    [Pxy,F] = cpsd(x,x,[],[],[],Fs); %δ��ȥֱ��������ǰ��Ƶ�ʷ���
    mag = abs(Pxy);
    
    [Pxy1,F1] = cpsd(x1,x1,[],[],[],Fs);
    mag1 = abs(Pxy1);
    
    [Pxy2,F2] = cpsd(x2,x2,[],[],[],Fs);
    mag2 = abs(Pxy2);

    [Pxy3,F3] = cpsd(x3,x3,[],[],[],Fs);
    mag3 = abs(Pxy3);
    
    
    [Pxy4,F4] = cpsd(afterFilt(cr,:),afterFilt(cr,:),[],[],[],Fs);
    mag4 = abs(Pxy4);
    
    figure(42);
    plot(F1,mag1,'r')
    hold on;
    plot(F2,mag2,'g');
    hold on;
    plot(F3,mag3,'b');
    hold on;
%     plot(F, mag, 'k');
%     hold on;
    plot(F4, mag4, 'y');
    
%%    
% ����ؼ���

% [a,timelag]=correlationCalc(x,y,1/Fs);%y����x�����ʱʱ��Ϊ��
% timelag

% figure(1);
% plot(timelag,a);

% 
% figure(2);
% plot(t,x,'b',t,y,'r');


%fft
% s1 = afterFilt(300,100:1000);
% s2 = picInfo.afterFilter{300,200};
% figure(1);
% s1_fft = fftAnalysis(s1,Fs);
% figure(2);
% s2_fft = fftAnalysis(s2,Fs);


%filter
% myFilter = load('bpFilter0.05_0.5Fs2.mat');

% myFilter = load(".\filter_mat\0.05_0.5_fs4_bp2.mat");
% 
% sum_xy1 = [sum_xy,zeros(1,length(myFilter.bpfilter))];
% after_xy = filter(myFilter.bpfilter,1,sum_xy1);
% % after_xy = filter(myFilter.test,1,sum_xy);
% % figure,plot(t,x,'b',t,sum_xy,'r',t,after_xy(length(myFilter.bpfilter)/2+1:N+length(myFilter.bpfilter)/2),'black');
% after_xy = after_xy(floor(length(myFilter.bpfilter)/2)+1:N+floor(length(myFilter.bpfilter)/2));
% figure(1),plot(t,x,'b',t,after_xy,'black');


%

% row_timestack = double(row_timestack);
% testSignal = row_timestack(300,:);
 [Pxy,F] = cpsd(testSignal,testSignal,[],[],[],Fs);
%     Pxy(Cxy<0.1) =0;
mag = abs(Pxy);
figure;
plot(F,mag);


% ForMidPoint_f(after_xy,after_xy,cpsdVar)
%% �����˲�֮��ԭ���ź�ʱ���Ƿ��֮ǰ��ͬ
% test_signal1 = x + noise;
% test_signal1 = [test_signal1,zeros(1,101)];
% test_signal1 = filter(myFilter.test,1,test_signal1);
% test_signal1 = test_signal1(52:N+51);
% % test_signal1 = detrend(double(test_signal1)/255);
% 
%     
% test_signal2 = y + noise;
% test_signal2 = [test_signal2,zeros(1,101)];
% test_signal2 = filter(myFilter.test,1,test_signal2);  
% test_signal2 = test_signal2(52:N+51);
% % test_signal2 = detrend(double(test_signal2)/255);
% 
% 
% [~,timelag1] = correlationCalc(test_signal1,test_signal2,1/Fs)

%%

% 
% [max,timelag2] = correlationCalc(x,y,1/Fs)
% c = 5.6;
% g = 9.8;
% f = 0.2;
% (c/2/pi/f)*atanh(2*pi*c*f/g)




%%
  tmp = imread("F:/workSpace/matlabWork/imgResult/orthImg/finalOrth_1603524600000.jpg");
  tmp = insertShape(tmp,'Line',[20 1 20 401],'LineWidth',1,'Color','r');
  tmp = insertShape(tmp,'Line',[120 1 120 401],'LineWidth',1,'Color','r');
  imshow(tmp);
  
%%
  fixedtime = seaDepth(:,500);%�ֱ���Ϊ0.2m��Ϊ200
  fixedtime = fixedtime(400:end); %�ֱ���Ϊ0.2mʱ��Ϊ180
  t_cor = interpolation.seaDepth(:,500);
  t_cor = t_cor(400:end); %�ֱ���Ϊ0.2mʱ��Ϊ180
  plot(fixedtime,'r');
  hold on;
  plot(t_cor,'b');
%%
  load('F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ2��ش���\���ս��\fixedTime3s_det&nor(100_1500)_psd(0.05_0.2).mat')
  fixedtime_20cm_tmp = seaDepth(:,500);
  fixedtime_20cm_tmp = fixedtime_20cm_tmp(450:end);
  load('F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ2��ش���\���ս��\t_cor_det&nor(100_1500)_psd(0.05_0.2).mat')
   interpolation.seaDepth = seaDepth;
    for i = 1:picInfo.col
        interpolation.total_x = 1:picInfo.row;
        interpolation.now_y  = interpolation.seaDepth(:,i)';
        interpolation.temp = interpolation.now_y;
        interpolation.insert_x = find(isnan(interpolation.now_y));
        interpolation.terminate_x = find(~isnan(interpolation.now_y),1,'last');
        interpolation.first_x = find(~isnan(interpolation.now_y),1,'first');
        interpolation.insert_x_idx = find(interpolation.insert_x>=interpolation.first_x & interpolation.insert_x <= interpolation.terminate_x);
        interpolation.insert_x = interpolation.insert_x(interpolation.insert_x_idx);
        interpolation.total_x(interpolation.insert_x) =[];
        interpolation.now_y(interpolation.insert_x) = [];
        interpolation.insert_y = interp1(interpolation.total_x,interpolation.now_y,interpolation.insert_x,'nearest');
        interpolation.temp(interpolation.insert_x) = interpolation.insert_y;
        interpolation.seaDepth(:,i) = interpolation.temp;
    end
   t_cor_20cm_tmp = interpolation.seaDepth(:,500);
   t_cor_20cm_tmp = t_cor_20cm_tmp(450:end);
   
   
   %%%% �ֱ��ʲ�ͬʱ��Ҫת��
   fixedtime_20cm_tmp_len = length(fixedtime_20cm_tmp);
   idx = 1;
   fixedtime_20cm = zeros(1,length(1:5:fixedtime_20cm_tmp_len));
   for i = 1:5:fixedtime_20cm_tmp_len
      fixedtime_20cm(idx) = fixedtime_20cm_tmp(i);
      idx=idx+1;
   end
   
   
   t_cor_20cm_tmp_len = length(t_cor_20cm_tmp);
   idx = 1;
   t_cor_20cm = zeros(1,length(1:5:t_cor_20cm_tmp_len));
   for i = 1:5:t_cor_20cm_tmp_len
      t_cor_20cm(idx) = t_cor_20cm_tmp(i);
      idx=idx+1;
   end
   
   
   %%%%%%
   %%
   load('F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ3��ش���\���ս��\fixedTime3s_det&nor(100_1500)_psd(0.05_0.2).mat')
   fixedtime_50cm_tmp = seaDepth(:,200);
   fixedtime_50cm_tmp = fixedtime_50cm_tmp(180:end);
   load('F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ3��ش���\���ս��\t_cor_det&nor(100_1500)_psd(0.05_0.2).mat');
  interpolation.seaDepth = seaDepth;
    for i = 1:picInfo.col
        interpolation.total_x = 1:picInfo.row;
        interpolation.now_y  = interpolation.seaDepth(:,i)';
        interpolation.temp = interpolation.now_y;
        interpolation.insert_x = find(isnan(interpolation.now_y));
        interpolation.terminate_x = find(~isnan(interpolation.now_y),1,'last');
        interpolation.first_x = find(~isnan(interpolation.now_y),1,'first');
        interpolation.insert_x_idx = find(interpolation.insert_x>=interpolation.first_x & interpolation.insert_x <= interpolation.terminate_x);
        interpolation.insert_x = interpolation.insert_x(interpolation.insert_x_idx);
        interpolation.total_x(interpolation.insert_x) =[];
        interpolation.now_y(interpolation.insert_x) = [];
        interpolation.insert_y = interp1(interpolation.total_x,interpolation.now_y,interpolation.insert_x,'nearest');
        interpolation.temp(interpolation.insert_x) = interpolation.insert_y;
        interpolation.seaDepth(:,i) = interpolation.temp;
    end
   t_cor_50cm_tmp = interpolation.seaDepth(:,200);
   t_cor_50cm_tmp = t_cor_50cm_tmp(180:end);
   
   
   
   %%% �ֱ��ʲ�ͬʱ��Ҫת��
   fixedtime_50cm_tmp_len = length(fixedtime_50cm_tmp);
   idx = 1;
   fixedtime_50cm = zeros(1,length(1:2:fixedtime_50cm_tmp_len));
   for i = 1:2:fixedtime_50cm_tmp_len
      fixedtime_50cm(idx) = fixedtime_50cm_tmp(i);
      idx=idx+1;
   end
   
   
   t_cor_50cm_tmp_len = length(t_cor_50cm_tmp);
   idx = 1;
   t_cor_50cm = zeros(1,length(1:2:t_cor_50cm_tmp_len));
   for i = 1:2:t_cor_50cm_tmp_len
      t_cor_50cm(idx) = t_cor_50cm_tmp(i);
      idx=idx+1;
   end
   
   %%
   
   
   figure(1);
   plot(t_cor_20cm,'k');
   hold on;
   plot(t_cor_50cm,'g');
   legend("t\_cor\_20cm","t\_cor\_50cm");
   figure(2);
   plot(fixedtime_20cm,'k');
   hold on;
   plot(fixedtime_50cm,'g');
   legend("fixedtime\_20cm","fixedtime\_50cm");
   
   
   %%
   s1 = picInfo.afterFilter{200,100};
   s2 = picInfo.afterFilter{195,100};
   len = 1:501;
   plot(len,s1,'r',len,s2,'b');
   
   
   
   %%
    for j = i:-1:i-PredictRange+1 %�ӱ���ʼ������ؿ�ʼ�������Ƴ̶�
    %         for j = i:-1:1 %�ӱ���ʼ������ؿ�ʼ�������Ƴ̶�  
            cor_val(i-j+1) = corr(timeStack_org(i,:)',timeStack_fixedTime(j,:)','type','Pearson'); %������źż��㻥���
    end
    plot(cor_val);
   
   %% ��ͼ����
%    img_path = 'F:\workSpace\matlabWork\corNeed_imgResult\�任��ͼƬ18\';
   eval('phantom4');
   img_path = params.final_path;
   time_stack = plotTimeStack(img_path, 100);
   
   
%% 
close all;
imagesc(time_stack);
colormap(gray)


set(gca,'XTick',[0:100:params.N]);
set(gca,'xticklabel',[0 : 100 : params.N] / params.fs);
set(gca,'YTick',[0:50:params.N]);
set(gca,'yticklabel',[0: 50: params.N] .* 0.5);


set(gca,'YDir','reverse'); 
% ylim([100 400])
xlabel('time(s)');
ylabel('cross shore(m)');
% ����Ӧ��ʱ��ͼ��Ƶ��ͼ


%%

close all;
imagesc(time_stack);
colormap(gray)



set(gca,'XTick',[0:100:params.N]);
set(gca,'xticklabel',[0 : 100 : params.N] / params.fs);
set(gca,'YTick',[0:50:params.N]);
set(gca,'yticklabel',[0: 50: params.N] .* 0.5);

line([0, params.N], [254, 254],'Color','yellow','LineWidth', 2);
line([0, params.N], [298, 298],'Color','green','LineWidth', 2);
line([0, params.N], [300, 300],'Color','red','LineWidth', 2);

set(gca,'YDir','reverse'); 
% ylim([100 400])
xlabel('time(s)');
ylabel('cross shore(m)');
legend('134m','149m','150m');
% ����Ӧ��ʱ��ͼ��Ƶ��ͼ

Fs = 4;
N = params.N;
n = 0:N-1;
t = n / Fs;
s1 = data_final(:, 15100); % 
% xyz(14191, :);
% s2 = data_final(:, 15201); % 140
s2 = data_final(:, 15201);
% xyz(15201, :);

% s2 = row_timestack(300, :);
G1 = fft(detrend(double(s1)))';
df = Fs / N; 
dt = 1 / Fs;
f = [0 : df : 1 / (2 * dt) - df];
figure
plot(f, abs(G1(:, 1 : length(f))), 'b');

title('�˲��ź�Ƶ��ͼ');

figure

plot_args.point_end = 100;
plot_args.point_begin = 1;
point_begin = 1;
plot(t(plot_args.point_begin : plot_args.point_end), s1(plot_args.point_begin :plot_args.point_end)', 'g');
hold on;
plot(t(plot_args.point_begin : plot_args.point_end), s2(plot_args.point_begin :plot_args.point_end)', 'r');
% set(gca,'XTick',[0:10:100]);
% set(gca,'YTick',[0:50:600]);

xlabel('time(s)');
ylabel('pixel intensity');
legend('149m','150m');


% title('pixel intensity fluctuation trend');

s3 = data(:, 29128);
G3 = fft(detrend(double(s3)))';



figure
plot(f, abs(G3(:, 1 : length(f))), 'k');
% title('Frequency distribution of signal after main frequency extraction');


hold on;
s4 = data_final(:, 29128); % 
G4 = fft(detrend(double(s4)))';
df = Fs / N; 
dt = 1 / Fs;
f = [0 : df : 1 / (2 * dt) - df];
plot(f, abs(G4(:, 1 : length(f))),'color','r', 'linewidth', 2);
xlabel('frequency(Hz)');
ylabel('Fourier transform value');
set(gca,'FontSize',30);
legend('origin signal','maximum correlation');

%% ���㻥��ص�ͼ
correlationCalc(s1, s2, 1/Fs);


%% ���̶�ʱ��Ļ���ص�ͼ���ȹ̶���һ��timestack, Ȼ��������timestack����м���
dbstop if all error  % �������
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
params.DEBUG = 1;
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

%






%% ����һ���Ļ�ͼ
plot_cor = flipud(cor);
plot_cor(:, 1: 61) = 0;
cmap = colormap( 'jet' );
colormap( flipud( cmap ) );
pcolor(plot_cor);
shading flat;
caxis([-1 1]); %������ȵ���ʾ��Χ
axis equal;
axis tight;
xlabel('cross shore (m)');
ylabel('distance(m)');
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







   