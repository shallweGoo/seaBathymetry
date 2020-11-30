% 根据色散关系来计算水深,输入的为频率f和波速c和重力g
% 总而言之，波速快，频率低，周期大，深度就越深
function h = dispersionCalc(f,c)
    if(c == 0 || isinf(c) || isnan(c) ||  f == 0 || isnan(f)) 
        h = nan;
    else
        h = (c/2/pi/f)*atanh(2*pi*c*f/10);
    end
end

