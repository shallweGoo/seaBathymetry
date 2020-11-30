% ����ɫɢ��ϵ������ˮ��,�����ΪƵ��f�Ͳ���c������g
% �ܶ���֮�����ٿ죬Ƶ�ʵͣ����ڴ���Ⱦ�Խ��
function h = dispersionCalc(f,c)
    if(c == 0 || isinf(c) || isnan(c) ||  f == 0 || isnan(f)) 
        h = nan;
    else
        h = (c/2/pi/f)*atanh(2*pi*c*f/10);
    end
end

