% 过滤掉一些不是特别相关的

% 输入参数：
% pic_info:整个的timestack信息
% params:参数
% r,c:对r行c列的信号进行处理
function signal = filterNotCorFreq(pic_info, params)

% 一些参数赋值
nKeep = params.nKeep;   % 需要保留的nKeep个频率分量
fB = params.fB;         % fB 枚举的可能频率值
dfB = params.dfB;       % dfB 可能的频率值
df = params.df;         % fft里面每个横坐标点对应的频率间隔，简单来说就是fs/N;
dt = params.dt;
f = [0 : df : 1 / (2 * dt) - df];   % fft 实际频率取值区间

max_x = pic_info.row * pic_info.prm;
min_x = 0;
max_y = pic_info.col * pic_info.prm;
min_y = 0;


G = fft(detrend(pic_info.afterFilter))

for x_id = 1 : pic_info.row
    % 步长计算公式，kappa<= kappa0，kappa0 = 2,离岸越远可以选的范围就越大
    kappa = 1 + (params.kappa0 - 1) * (x_id * pic_info.prm - min_x) / (max_x - min_x);   

    for y_id = 1 : pic_info.col
        
        
    end

    
end

end





% function ff