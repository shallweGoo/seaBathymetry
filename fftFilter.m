%% ȥ���ź��е��ض�Ƶ�ʵ��ź�
% ���������
% ori_singal: Դ�ź�
% ff ��Ҫ��ȥ��Ƶ�ʣ�Ϊһ������
% params ��������

% ����� �����˲�֮����ź�
function filter_signal = fftFilter(ori_singal, ff, params)
 
% ���������params�õ���һЩ
    fs = params.fs;
    N = length(ori_singal); % ���������
    n = 0 : N - 1;          % ����ʱ��Ĺ���
    t = n / fs;             % ����ʱ��
%
    df = fs / N;            % df
    dt = 1 / fs;            % dt

    G = fft(detrend(double(ori_singal)));   %ȥֱ��
%     figure(1)
%     plot(n*df, abs(G), 'r');
%     hold on;
    filter_mid = N / 2 + 1;
    for i = 1 : length(ff)
        need_filter_f = ff(i);
        need_filter_pos = uint32(need_filter_f / df + 1);
        G(need_filter_pos, :) = 0;
        G(2 * filter_mid - need_filter_pos, :) = 0;
%         plot(n * df, abs(G), 'b');
    end
    filter_signal = ifft(G);

%     figure(100)
%     plot(t, filter_signal, 'r');
%     hold on;
%     plot(t, signal_filter, 'b');

end

