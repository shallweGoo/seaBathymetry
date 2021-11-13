%�ú����������Ǹ���xy�ͻ��������������ֵ����������v���Բ���k,����alpha,��λphi�ĳ�ʼֵ���й��ơ���ϸ��ʽ����3
function kAlphaPhiInit = findKAlphaPhiInit(v, xy, LB_UB, params)
%
%   kALphaPhiInit = findKAlphaInitPhi(v, xy, LB_UB, params);
%
%  find appropriate wavenumber and direction estimates, k and alpha
%  ���ݿռ�ṹEOF�����ʵĲ����ͷ���
%  based on the phase structure of the first EOF, v, at locations, xy.  
%  The estimate is done by modeling phase difference versus x and y
%  difference. dTheta = kx*dx + ky*dy.  This is done by extracting an x and 
%  y transect of phase and finding the median dPhasedx etc to remove phase
%  jumps.  This is done at multiple transects, taking the median of the
%  results. 

sliceFract = 0.1;   % define slices a this fraction nearest location
N = size(xy,1); %N�������ڵĵ���
n = floor(sliceFract*N);    %nΪ0.1N,���й��ƣ���y�ĳ߶��Ϸֿ飨���룩��k���й���

[~, ind] = sort(xy(:,2));       % sort everything in order of y  ��y��������Ĭ�ϴ�С��������,indΪ��С�����ԭ���������,�������Ϊ��һ����transect
x = xy(ind,1); %x����y��С�����˳������ 
phase = angle(v(ind)); %�����angle�������,ͬ���Ǿ��������˳��y�����С����

% find kx estimate at n longshore locations then find median
% �ҳ�������x�����ϵĲ���k,����һ�������ڵģ���������һЩ
% ��һ��xm,ym��������ҲҪ���зֿ飬����³���ԣ��ֿ�Ϊ10�ȷ�����
for i = 1: floor(N/n) %i��1��ÿ���飬N/n = 10����
    pick = [(i-1)*n+1: i*n];
    [xp, xpInd] = sort(x(pick)); %���Ѿ���y˳���źõ�x��������
    phz = phase(pick(xpInd)); 
    kx(i) = median(diff(phz(:))./diff(xp(:))); %��ʦ�����ģ�3-22�����ͣ�x����Ĳ�����������ת��Ϊ��λ�ڸ÷�����ݶ������㣬������ĳ������ֱ�ӵó��Ľ��ۣ���֪�����ĸ����ġ�
end
kx = median(kx); % kxȡ��������λ��,Ϊ��remove phase jumps.

% now find ky estimate at n cross-shore locations then find median
% �̶�x��y�������򣬵������ذ�����ķ����Ͻ��й���
[~, ind] = sort(xy(:,1));       % sort everything in order of x
y = xy(ind,2);
phase = angle(v(ind));
for i = 1: floor(N/n)
    pick = [(i-1)*n+1: i*n];
    [yp, ypInd] = sort(y(pick));
    phz = phase(pick(ypInd));
    ky(i) = median(diff(phz(:)) ./ diff(yp(:)));
end
ky = median(ky);%ditto ͬ�� 

kVec = kx+1i*ky;
k = abs(kVec);   %kҲ�Ǵ�kx�����ky������е��ӵ�
alpha = angle(kVec)-pi;     % switch by pi for 'coming from' angle (alpha��ֵ(wave direction) = k�ĽǶ�-pi)
%��ʱphase������ sort everything in order of x������ʹ��
phi = mean(rem(phase - kx*xy(:,1) - ky*xy(:,2), 2*pi));  %phi ��appropriate phase shift��Ϊ��(3)���Ǹ���ʽ  rem��ȡ��mod����˼��������ô���Ĳ��Ǻ����

%������������ķ�Χ��
if ((k<LB_UB(1,1)) || (k>LB_UB(2,1)))    % if not in expected range 
    k = dispsol(3.0, 0.1, 0);            % just guess a 0.1 Hz, h=3m value. ��k������Χ�ˣ�Ĭ��ֵ��Ϊ�����
end

kAlphaPhiInit = [k alpha phi]; % ��������(3)�е���������


% Copyright by Oregon State University, 2017
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: findKAlphaPhiInit.m 4 2016-02-11 00:35:38Z  $
%
% $Log: findKAlphaPhiInit.m,v $
% Revision 1.1  2012/09/24 23:20:22  stanley
% Initial revision
%
% Revision 1.1  2011/08/08 00:28:51  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
