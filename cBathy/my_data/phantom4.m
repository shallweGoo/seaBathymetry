%%% Site-specific Inputs
params.stationStr = 'phantom4';
params.dxm = 1;                    % analysis domain spacing in x
params.dym = 1;                    % analysis domain spacing in y
params.xyMinMax = [0 300 0 100];   % min, max of x, then y  
                                    % default to [] for cBathy to choose  
                                    
params.tideFunction = 'cBathyTide';  % tide level function for evel ��λ

%%%%%%%   Power user settings from here down   %%%%%%%
params.MINDEPTH = 0.25;             % for initialization and final QC����ʼ����С�����Ϊ��ʼֵ
params.minValsForBathyEst = 4;      % min num f-k pairs for bathy est. ��С������(f-k)��

params.QTOL = 0.5;                  % reject skill below this in csm  �������ֵ��Ҫreject
params.minLam = 10;                 % min normalized eigenvalue to proceed ���е���С��һ������ֵ
params.Lx = 4*params.dxm;           % tomographic domain smoothing �����ѡ��,X���ϵ�
params.Ly = 4*params.dym;           % �����ѡ��,Y���ϵ�
params.kappa0 = 2;                  % increase in smoothing at outer xm ,�������Ӱɣ�����x�����ӣ�Ҫ���Ƶ�����Ҫ����
params.DECIMATE = 1;                % decimate pixels to reduce work load. ���������Լ��ٹ������ı�־λ
params.maxNPix = 80;                % max num pixels per tile (decimate excess) ÿ��������������80�����ص�

% f-domain etc.
params.fB = [1/18: 1/50: 1/4];		% frequencies for analysis (~40 dof) 10��Ƶ��ֵ��ѡ
params.nKeep = 7;                   % number of frequencies to keep  Ҫά��nKeep��Ƶ����Ϊ��ѡ

% debugging options  debugѡ��
params.debug.production = 0;            %���Ӧ�����ܿ��أ�Ϊ1��debug
params.debug.DOPLOTSTACKANDPHASEMAPS = 1;  % top level debug of phase %����Ƶ�ʶ�Ӧ����λͼ�Ŀ���
params.debug.DOSHOWPROGRESS = 1;		  % show progress of tiles
params.debug.DOPLOTPHASETILE = 1;		  % observed and EOF results per pt
params.debug.TRANSECTX = 100;		  % for plotStacksAndPhaseMaps ��ͼѡ��
params.debug.TRANSECTY = 50;		  % for plotStacksAndPhaseMaps

% default offshore wave angle.  For search seeds.
params.offshoreRadCCWFromx = 0;


