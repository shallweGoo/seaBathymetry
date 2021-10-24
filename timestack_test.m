clear;

%% 
Fs = 2;
N = 600;
n = 0:N-1;
t = n/Fs;
dt = mean(diff(t));
df = 1/(N*dt); 
f = 0: df: 1/(2*dt)-df;
fB = [1/18:1/50:1/4];
dfB = fB(2)-fB(1);
nKeep = 4;
%%%%%%%%%%%�����ļ�����%%%%%%%%
dir_ind = num2str(18);
col_num = num2str(100);

%timestack_foldPath = "F:\workSpace\matlabWork\corNeed_imgResult\"+"�任��ͼƬ"+dir_ind+"��ش���\"+"�任��ͼƬ"+dir_ind+"ʱ���ջ\";
timestack_foldPath = "F:\workSpace\matlabWork\corNeed_imgResult\"+"�任��ͼƬ"+dir_ind+"��ش���\"+"�任��ͼƬ"+dir_ind+"��ͨ�˲�\";
real_file = timestack_foldPath + "col" + col_num;
load(real_file);

% x1 = detrend(double(row_timestack(400,:))); 
% x2 = detrend(double(row_timestack(380,:)));

x1 = detrend(double(afterFilt(400,:))); 
x2 = detrend(double(afterFilt(380,:)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% y1 = detrend(smooth(x1,10));
% y2 = detrend(smooth(x2,10));

signal = [x1',x2'];


% figure(21);
% plot(t,y1,'r',t,y2,'b');


% figure(22);
% plot(t,detrend(x1),'r',t,detrend(x2),'b');
% corr(y1,y2,'type','Pearson')


%%
G = fft(signal);
init_G = G;
id = find((f >= (fB(1)-dfB/2)) & (f <= (fB(end)+dfB/2))); %��fft֮���G��ѡȡ��Ҫ��Ƶ�ʷ�Χ(1/18-dfB/2)~(1/4+dfB/2)
f = f(id); % ��fft��ȡ��Ҫ��Ƶ�ʷ�Χ
G = G(id,:);   %ѡȡ���Ƶ���ڵ�fft,��ʱG����f��Ҳ�ǵ���N��Ϊ������ģ�
G = G./abs(G);  % scale spectral results to 1. %��һ������Ҷ�仯��ȡֵ


%%
for i = 1: length(fB)
    % find the f's that match  f������Ҫ����fB�����Զ������ҵ�ƥ��
   %Ѱ��f��fB�е����ƥ�䣬ʵ����ͨ��fft(����˵��fsƵ�ʲ���)�任������f��û�к�fBһһ��Ӧ,
   %���Բ������ƥ�䣬ɸѡ���������f�㣬f��ʵ�ʲ���������    
   
    id = find(abs(fB(i)-f) < (fB(2)-fB(1))/2);                                          
    % pull out the fft data and do the cross spectrum
    % ����ʱ�����м��㽻���ף�G���Ѿ�����ɸѡ�ĸ���Ҷ�任
    % G(id,:)Ϊid*�������ص�������һ��������ô���������ʽ�����������һ��nums(�������ص�)*nums(�������ص�)�Ľ����׾���i�ĺ���Ϊ�ڼ���fB
    C(:,:,i) = G(id,:)'*G(id,:) / length(id);   % pos 2nd leads 1st.   ѡ���ض�Ƶ��f�����е�,���н����׵ļ���. ���ǹ��ڸ���Ƶ�ʼ�Ļ�������,
    
end

%coh2 = squeeze(sum(sum(abs(C)))/(size(xyz,1)*(size(xyz,1)-1))); % sum(sum(abs(c)))Ϊÿ��Ƶ�ʵ�f���������㣩�ϵķ�ֵ����ܺͣ�/N*(N-1),�����ʲô��ʽ��Ҫ���Ժ����ⲿ��
coh2 = squeeze(sum(sum(abs(C)))/2);

[~, coh2Sortid] = sort(coh2, 1, 'descend');  % sort by coh2 �����дӴ�С����,coh2Sortid������ԭ��������ֵ�Ӵ�С��������CEOF��ԭ���
f_coh = fB(coh2Sortid(1:nKeep));         % keep only the nKeep most coherent��ѡnKeep������ɵ�Ƶ��
C = C(:,:,coh2Sortid(1:nKeep));       % ditto ͬ�ϣ�ѡ��������ص�һЩƵ��


%��fs����f_n
f_n = (round(f_coh*N/Fs)+1);


filter_G = zeros(size(init_G,1),size(init_G,2));
%�����޹��źţ���ȡ��0;
for i = 1:nKeep
    
    filter_G(f_n,:) = init_G(f_n,:);
    filter_G(N-f_n+2,:)= init_G(N-f_n+2,:);
end

f_signal = ifft(filter_G);
f_x1 = f_signal(:,1);
f_x2 = f_signal(:,2);
figure(30);%�˲�֮����ź�
plot(t(1:100),f_x1(1:100),'r',t(1:100),f_x2(1:100),'b')

%% ���㻥���

[max_cor,delta_t] = correlationCalc(f_x1,f_x2,1/Fs)

%% ���㹦����

f = getRepresentativeFrequency(f_x1,f_x2,f_coh,Fs)



%% ����fft�任�������ź������ض�Ƶ��

%  fs_test = 2;
%  n = 0:1000-1;
%  t = n/fs_test;
%  a = sin(2*pi*0.004*t)+2*sin(2*pi*0.2*t);
%  b = fft(a);
%  figure(1);
%  plot(abs(b));
%  b(2) = 0;
%  b(1000) = 0;
%  figure(2);
%  plot(abs(b));
%  f_a = ifft(b);
%  fftAnalysis(f_a,fs_test);
%  fftAnalysis(a,fs_test);



