%%% 参数输入
params.station_str = 'phantom4';    % 素材来源平台名称
% params.data_save_path = 'F:/workSpace/matlabWork/seaBathymetry/errorCalculate/data/2Hz_1m_100_300/';
% params.img_path = 'H:/imgResult/filt/';
% params.final_path = 'H:/imgResult/orthImg/';
% params.img_path = 'H:/stitchData/1/resImg/';
% params.xy_min_max = [0 300 0 100];  % local坐标系 xy轴的范围，12个元素是x轴，34是y轴
%%% sticth %%%
% params.data_save_path = 'F:/workSpace/matlabWork/seaBathymetry/errorCalculate/data/stitch/';
% params.img_path = 'H:/stitchData/1/left/';
% params.final_path = 'H:/stitchData/1/filterImg/';
params.data_save_path = 'F:/workSpace/matlabWork/seaBathymetry/errorCalculate/data/stitchNoGcp/';
params.img_path = 'H:/stitchData/3/left/';
params.final_path = 'H:/stitchData/3/resImg/';


params.xy_min_max = [0 200 0 100];  % local坐标系 xy轴的范围，12个元素是x轴，34是y轴
%%% stitch %%%
params.img_name = string(ls(params.img_path));
params.img_name = params.img_name(3:end);
params.final_name = string(ls(params.final_path));
params.final_name = params.final_name(3:end);
params.tideFunction = 'cBathyTide';  % tide level function for evel 潮位
%%%%%
params.fs = 2;                      % 采样频率
params.N = length(params.final_name); % 视频图像长度
params.dxm = 1;                   % local坐标系 x轴距离分辨率
params.dym = 1;                   % local坐标系 y轴距离分辨率
params.prm = params.dxm;
params.dist = 1;                    %%% Notice: timeCor cBathy 反演分辨率实际都以此为主 %%%
params.fix_time = 3;                % 固定时间为3s
% params.pred_range = [10 40];      % 波长估计范围
% params.pred_k = 1;



params.xy_range = params.xy_min_max;
params.xy_want = params.xy_min_max;

params.df = params.fs / params.N;          % fft里面每个横坐标点对应的频率间隔，简单来说就是fs/N;
params.dt = 1 / params.fs;          % delta t，这项不用设置
params.t = 0 : params.dt : (params.N - 1) * params.dt; % 这项也不用设置，自动计算
params.f = 0 : params.df : (1 / (2 * params.dt) - params.df );
% params.tideFunction = 'cBathyTide';  % 潮位校正的函数校正

%%%%%%%   算法参数   %%%%%%%
params.MINDEPTH = 0.25;             % 初始化最小深度作为初始值
params.minValsForBathyEst = 4;      % f_k对的个数

params.QTOL = 0.5;                  % 拟合度低于这个值说明不够拟合，要reject
params.minLam = 10;                 % min normalized eigenvalue to proceed 进行的最小归一化特征值
params.Lx = 4*params.dxm;           % 区域的选择,X轴上的
params.Ly = 4*params.dym;           % 区域的选择,Y轴上的
params.kappa0 = 2;                  % 增长因子，离岸越远区域就要越大
params.DECIMATE = 1;                % decimate pixels to reduce work load. 减少像素以减少工作量的标志位
params.maxNPix = 80;                % max num pixels per tile (decimate excess) 每块区域中最多存在80个像素点

% 选择要分析的频率范围
params.fB = [1/18: 1/50: 1/4];		% 枚举可能的频率值
params.nKeep = 4;                   % 保留主要频率的个数
params.dfB = mean(diff(params.fB)); % dfBs


% 是否开启debug功能
params.DEBUG = 0;                       % 分析互相关选项
params.debug.production = 0;            % 1开启，0关闭
params.debug.DOPLOTSTACKANDPHASEMAPS = 0;  % 画出频率对应的相位图
params.debug.DOSHOWPROGRESS = 0;		  % 过程图展示
params.debug.DOPLOTPHASETILE = 0;		  % 每个像素点的eof结果
params.debug.TRANSECTX = 0;		  % 画图选项，画出x轴的截断面，这个为x坐标值
params.debug.TRANSECTY = 0;		  % 画图选项，画出y轴的截断面，这个为y坐标值

% default offshore wave angle.  For search seeds.
params.offshoreRadCCWFromx = 0;