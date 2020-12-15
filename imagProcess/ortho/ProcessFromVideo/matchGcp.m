function [outputArg1,outputArg2] = matchGcp(gcpInfo,cmPara,mode)
%calcRotateMatrix 根据第一帧的控制点来匹配接下来帧的控制点
%

% 输入参数介绍
% gcpInfo包括两个信息gcpInfo(1)为gcp在uv中的坐标，gcpInfo(2)为gcp在自定义坐标系下的坐标
    
% cmPara为相机参数
    

% ***mode为拟采用的每帧gcp匹配模式
% ***mode1为 CRIN 的阈值匹配，非线性拟合（优化）得到外参
% ***mode2为 自己做的模板匹配

    if nargin < 2
        %默认为CRIN阈值匹配
        mode = 1;
    end
    
    switch mode
        case 1
            
        
        
        case 2
        
                    
        
        otherwise
            error("happened confliction because unsituable mode");
            
            
    end
    



end

