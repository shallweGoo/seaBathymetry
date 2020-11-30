%输入c1->c2坐标系的旋转矩阵，按照该公式所得到的是c2->c1的旋转角
%可以将结果取负号得到c1->c2的旋转角

function [yaw,pitch,roll] = Rotate2Euler(Rotate)
    yaw = atan(Rotate(2,1)/Rotate(1,1))*180/pi;
    pitch = asin(-Rotate(3,1))*180/pi;
    roll = atan(Rotate(3,2)/Rotate(3,3))*180/pi;
end

