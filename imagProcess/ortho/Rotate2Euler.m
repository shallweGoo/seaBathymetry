%����c1->c2����ϵ����ת���󣬰��ոù�ʽ���õ�����c2->c1����ת��
%���Խ����ȡ���ŵõ�c1->c2����ת��

function eulerAngle = Rotate2Euler(Rotate)
    yaw = atan(Rotate(2,1)/Rotate(1,1))*180/pi;
    pitch = asin(-Rotate(3,1))*180/pi;
    roll = atan(Rotate(3,2)/Rotate(3,3))*180/pi;
    eulerAngle(1) = yaw;
    eulerAngle(2) = pitch;
    eulerAngle(3) = roll;
end

