% ���˵�һЩ�����ر���ص�

% ���������
% pic_info:������timestack��Ϣ
% params:����
% r,c:��r��c�е��źŽ��д���
function signal = filterNotCorFreq(pic_info, params)

% һЩ������ֵ
nKeep = params.nKeep;   % ��Ҫ������nKeep��Ƶ�ʷ���
fB = params.fB;         % fB ö�ٵĿ���Ƶ��ֵ
dfB = params.dfB;       % dfB ���ܵ�Ƶ��ֵ
df = params.df;         % fft����ÿ����������Ӧ��Ƶ�ʼ��������˵����fs/N;
dt = params.dt;
f = [0 : df : 1 / (2 * dt) - df];   % fft ʵ��Ƶ��ȡֵ����

max_x = pic_info.row * pic_info.prm;
min_x = 0;
max_y = pic_info.col * pic_info.prm;
min_y = 0;


G = fft(detrend(pic_info.afterFilter))

for x_id = 1 : pic_info.row
    % �������㹫ʽ��kappa<= kappa0��kappa0 = 2,�밶ԽԶ����ѡ�ķ�Χ��Խ��
    kappa = 1 + (params.kappa0 - 1) * (x_id * pic_info.prm - min_x) / (max_x - min_x);   

    for y_id = 1 : pic_info.col
        
        
    end

    
end

end





% function ff