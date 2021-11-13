%%% ��������
params.station_str = 'phantom4';    % �ز���Դƽ̨����
params.img_path = 'H:/imgResult/filt/';
params.final_path = 'H:/imgResult/orthImg/';
params.img_name = string(ls(params.img_path));
params.img_name = params.img_name(3:end);
%%%%%
params.fs = 4;                      % ����Ƶ��
params.N = length(params.img_name); % ��Ƶͼ�񳤶�
params.dxm = 0.5;                   % local����ϵ x�����ֱ���
params.dym = 0.5;                   % local����ϵ y�����ֱ���
params.prm = params.dxm;
params.dist = 1;                    % ��������
params.fix_time = 3;                % �̶�ʱ��Ϊ3s
% params.pred_range = [10 40];      % �������Ʒ�Χ
% params.pred_k = 1;

params.xy_min_max = [0 300 0 100];  % local����ϵ xy��ķ�Χ��12��Ԫ����x�ᣬ34��y��

params.xy_range = params.xy_min_max;
params.xy_want = params.xy_min_max;

params.df = params.fs / params.N;          % fft����ÿ����������Ӧ��Ƶ�ʼ��������˵����fs/N;
params.dt = 1 / params.fs;          % delta t�����������
params.t = 0 : params.dt : (params.N - 1) * params.dt; % ����Ҳ�������ã��Զ�����
params.f = 0 : params.df : (1 / (2 * params.dt) - params.df );
% params.tideFunction = 'cBathyTide';  % ��λУ���ĺ���У��

%%%%%%%   �㷨����   %%%%%%%
params.MINDEPTH = 0.25;             % ��ʼ����С�����Ϊ��ʼֵ
params.minValsForBathyEst = 4;      % f_k�Եĸ���

params.QTOL = 0.5;                  % ��϶ȵ������ֵ˵��������ϣ�Ҫreject
params.minLam = 10;                 % min normalized eigenvalue to proceed ���е���С��һ������ֵ
params.Lx = 3*params.dxm;           % �����ѡ��,X���ϵ�
params.Ly = 3*params.dym;           % �����ѡ��,Y���ϵ�
params.kappa0 = 2;                  % �������ӣ��밶ԽԶ�����ҪԽ��
params.DECIMATE = 1;                % decimate pixels to reduce work load. ���������Լ��ٹ������ı�־λ
params.maxNPix = 80;                % max num pixels per tile (decimate excess) ÿ��������������80�����ص�

% ѡ��Ҫ������Ƶ�ʷ�Χ
params.fB = [1/18: 1/50: 1/2];		% ö�ٿ��ܵ�Ƶ��ֵ
params.nKeep = 7;                   % ������ҪƵ�ʵĸ���
params.dfB = mean(diff(params.fB)); % dfBs


% �Ƿ���debug����
params.DEBUG = 0;
params.debug.production = 0;            % 1������0�ر�
params.debug.DOPLOTSTACKANDPHASEMAPS = 1;  % ����Ƶ�ʶ�Ӧ����λͼ
params.debug.DOSHOWPROGRESS = 1;		  % ����ͼչʾ
params.debug.DOPLOTPHASETILE = 1;		  % ÿ�����ص��eof���
params.debug.TRANSECTX = 200;		  % ��ͼѡ�����x��Ľض��棬���Ϊx����ֵ
params.debug.TRANSECTY = 200;		  % ��ͼѡ�����y��Ľض��棬���Ϊy����ֵ

% default offshore wave angle.  For search seeds.
params.offshoreRadCCWFromx = 0;