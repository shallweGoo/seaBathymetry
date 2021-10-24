%画图专用测试，专治各种画图

figure;
s1 = double(row_timestack(300,:))/max(double(row_timestack(300,:)));
plot(s1,'b');
hold on;
s2 = afterFilt(300,:)/max(double(afterFilt(300,:)));
plot(s2,'r');

% hold on;
% cmp = [zeros(1,99),part(300,:)];
% plot(cmp,'black');  

%%