classdef errorAnalyze < handle
    properties
        src; % source
        tth; % truth
        row;
        col;
    end
    methods
        function obj = errorAnalyze(source, truth)
            [r, c] = size(source);
            [r0, c0] = size(truth);
            if r ~= r0 || c ~= c0
                error('wrong size for error analyze');
            end
            
            
            obj.src = source;
            obj.tth = truth;
            obj.row = r;
            obj.col = c;
        end
    
        
        function e = rmse(obj)
            valid_id = find(~isnan(obj.src) & ~isnan(obj.tth));
            e = sqrt(mean((obj.src(valid_id)-obj.tth(valid_id)).^2,'all'));
            disp(['rmse: ' num2str(e)]);
        end
        
        function e = rmseCol(obj, col)
            s_c = obj.src(:,col);
            t_c = obj.tth(:,col);
            valid_id = find(~isnan(s_c) & ~isnan(t_c));
            e = sqrt(mean((s_c(valid_id)-t_c(valid_id)).^2, 'all'));
            disp(['rmseCol: ' num2str(e)]);
        end
            
            
        
        
        
        function e = mae(obj)
            valid_id = find(~isnan(obj.src) & ~isnan(obj.tth));
            e = mean(abs(obj.src(valid_id)-obj.tth(valid_id)), 'all');
            disp(['mae: ' num2str(e)]);
        end
   
        function e = maeCol(obj, col)
            s_c = obj.src(:,col);
            t_c = obj.tth(:,col);
            valid_id = find(~isnan(s_c) & ~isnan(t_c));
            e = mean(abs(s_c(valid_id)-t_c(valid_id)), 'all');
            disp(['maeCol: ' num2str(e)]);
        end
        
        
        
        function e = mape(obj)
            valid_id = find(~isnan(obj.src) & ~isnan(obj.tth));
            e = mean(abs(obj.src(valid_id)-obj.tth(valid_id)./obj.tth((valid_id))), 'all');
            disp(['mape: ' num2str(e)]);
        end
        
        function e = mse(obj)
            valid_id = find(~isnan(obj.src) & ~isnan(obj.tth));
            e = sum((obj.src(valid_id)-obj.tth(valid_id)).^2, 'all')./length(valid_id);
            disp(['mse: ' num2str(e)]);
        end
        
        function e = mseCol(obj, col)
            s_c = obj.src(:,col);
            t_c = obj.tth(:,col);
            valid_id = find(~isnan(s_c) & ~isnan(t_c));
            e = sum((s_c(valid_id)-t_c(valid_id)).^2, 'all')./length(valid_id);
            disp(['mseCol: ' num2str(e)]);
        end
        
        
        
        function e = sse(obj)
            valid_id = find(~isnan(obj.src) & ~isnan(obj.tth));
            e = sum((obj.src(valid_id)-obj.tth(valid_id)).^2, 'all');
            disp(['rmseCol: ' num2str(e)]);
        end
        
    end
    
end