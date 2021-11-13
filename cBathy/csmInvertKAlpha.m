% �����f��G��xyz���������(xm,ym)���õ��������뵽��������еĶ�ֻ��һ��(xm,ym)
function fDependent = ...
    csmInvertKAlpha(f, G, xyz, xm, ym, params, kappa)
%


% fCombined = ...
%   csmInvertKAlpha(f, G, xyz, xm, ym, params, kappa)
%
% estimate wavennumber components from cross spectral matrix CSM
% using local nolinear model for any provided subset of Fourier values
% at any location, xm, ym.    
%
% Input
%   f   frequencies of input Fourier coefficients, Nf x 1
%   G, Fourier coeffients from a tiles worth of pixels, Nxy x 1 (complex)
%   xyz, pixel locations (Nxy of them; z column is not required
%   xm, ym, single location for this analysis
%   params, parameters structure for analysis (from SETTINGS files)
%   kappa, spatially-variable samping domain scaling
% Outputs:
%   fDependent: small structure of results with the following fields, each
%   of length nKeep (one for each frequency)
%       - fB,       - analysed frequencies
%       - k a h,    - wavenumber, alpha, depth
%       - kEst aEst hEst - errors in wavenumber, alpha and depth
%       - skill dof, - skill and degrees of freedom

% 03/07/10 - Holman fix to catch edge error where a tomographic point
%   an extrapolation region can get poor estimates with low error
%   because only a very few pixels are fit well.  Fix is to require
%   nGood pixels (likely > 3) and to have max(deltax) and max(deltay)
%   at least wavelengthFraction of the expected wavelength.
% 09/01/11 - Holman rewrite to finally get rid of tiling and analyze a
%   single location only
% 12/05/11 - Holman major change to base on EOFs rather than direct from CSM

%% %%  1. constants and parameters

clear fDependent
g=9.81;                         % 'g'
minNeededPixels = 6;            % to avoid edge anomalies�����й�������Ҫ���ٵĵ㣬��ֹ�߽�����
minLFraction = 0.5;             % min fract of wavelength to span ��С�������

OPTIONS = statset('nlinfit');   % fit options (���ѡ��)����������ϣ���С���˷���
OPTIONS.MaxIter = 50;  %����������
OPTIONS.TolFun = 1e-6; %%%1e-6;  %Ԥ��ֵ��ʵ�ʣ��۲⣩ֵ <TolFunʱֹͣ������ֹͣ������ͨ���۲�ֵȥ���һ����������λ�ĺ���

Nxy = size(xyz,1);   %tile����ĵ������С������Nxy���ͻᱨ��
if Nxy<minNeededPixels          % too few points, bail out
    if( cBDebug( params ) )
        fprintf('Inadequate data to analyze tile, [x,y] = [%d, %d]\n', xm, ym)
    end
    fDependent.k = nan(1,params.nKeep);
    return
end

%�����˲����Ĺ������
ri = [0:0.01:1]';       % create a hanning filter for later interp�����캺���˲����������,�����н�����Ϊ��֮��Ĳ�ֵ
ai = (1 - cos( pi*(0.5 + 0.5*ri) ).^2); % pi/2~ pi ,�����˲�������ѧ���ʽ�����˸о������¿���
% ��ͼ��֪��ai��ʲô������
% figure(90);
% plot(ri,ai);
% close(90);
%% %% 2. find basic csm for all fB frequencies, sort by total coh^2 into preferred
%% %% order and keep only nKeep frequencies
%��μ��㺣������ص���Ƶ�ʣ�������EOF(��Ƶ������)�ּ���
%1�������ض�Ƶ�ʷ�Χ�Ľ����ף�Ϊ������ʽ���������Ϊ  C(:,:,i) = G(id,:)'*G(id,:) / length(id)
%2�����㽻���׾���ĺͣ��Ժ͵Ĵ�С��ȷ��Ƶ�ʵ�Ȩ�أ�sum��Ȩ�س�����


fB = params.fB;
nKeep = params.nKeep;
for i = 1: length(fB)
    % find the f's that match  f������Ҫ����fB�����Զ������ҵ�ƥ��
   %Ѱ��f��fB�е����ƥ�䣬ʵ����ͨ��fft(����˵��fsƵ�ʲ���)�任������f��û�к�fBһһ��Ӧ,
   %���Բ������ƥ�䣬ɸѡ���������f�㣬f��ʵ�ʲ���������    
   
    id = find(abs(fB(i)-f) < (fB(2)-fB(1))/2);                                          
    % pull out the fft data and do the cross
    % spectrum,����ʱ�����м��㽻���ף�G���Ѿ�����ɸѡ�ĸ���Ҷ�任,����Ǹ���Ҷ�任��Э�������ı�ʾ����
    % G(id,:)Ϊid*�������ص�������һ��������ô���������ʽ�����������һ��nums(�������ص�)*nums(�������ص�)�Ľ����׾���i�ĺ���Ϊ�ڼ���fB
    C(:,:,i) = G(id,:)'* G(id,:) / length(id);   % pos 2nd leads 1st.   ѡ���ض�Ƶ��f�����е�,���н����׵ļ���. ���ǹ��ڸ���Ƶ�ʼ�Ļ�������,
    
end

% create the coherence squared for all the potential frequence bands
% Ϊ����Ƶ�ε�ƽ���������ȡǰnKeep�����ֵ,�����������ɣ��������׾����ֵ�����ڸ�Ƶ���µ�������
% C�����������ض�Ƶ���µĽ����׾��󣬵�������ÿһ�����һ��Ƶ���µ����������е�Ľ����׾���
% coh2����˼�ǽ�ÿ��Ƶ�ʶ�Ӧ�Ļ������׵�ֵ��ӣ����squeeze��һ���������������ʱCΪN*N*18;��ôcoh2���ֵ����18*1��һ����������ÿ�ж�Ӧһ��Ƶ�ʡ�
coh2 = squeeze(sum(sum(abs(C)))/(size(xyz,1)*(size(xyz,1)-1))); % sum(sum(abs(c)))Ϊÿ��Ƶ�ʵ�f���������㣩�ϵķ�ֵ����ܺͣ�/N*(N-1),�����ʲô��ʽ��Ҫ���Ժ����ⲿ��


[~, coh2Sortid] = sort(coh2, 1, 'descend');  % sort by coh2 ������ֵ��������,coh2Sortid������ԭ��������ֵ�����������CEOF��ԭ���
fs = fB(coh2Sortid(1:nKeep));         % keep only the nKeep most coherent��ѡnKeep������ɵ�Ƶ��
fDependent.fB = fs;                   % ѡ����fB����ɷ�ֵ����ǰnKeepƵ��
C = C(:,:,coh2Sortid(1:nKeep));       % ditto ͬ�ϣ�ѡ��������ص�һЩƵ��

% report frequencies we keep
% formatStr = repmat('%.3f ', 1, nKeep);
% fprintf(['Frequencies [' formatStr '] Hertz\n'], fs);

%% %%  3. Find lags and weightings.  NOTE that we no longer rotate
%% coordinates to a user cross-shore orientation.  The user is now
%% responsible for providing cross-shore oriented coord system.

xy = xyz(:,1:2); %xy����  (xp,yp)�ĸ�������,����x_m,y_m
% find lags xym and pixels for weighting
dxmi = xy(:,1) - repmat(xm, Nxy, 1); %�õ���������xm�ľ���
dymi = xy(:,2) - repmat(ym, Nxy, 1); %�õ���������ym�ľ���
r = sqrt((dxmi/(params.Lx*kappa)).^2 + (dymi/(params.Ly*kappa)).^2);  %��ϸ�鿴���ĵ��Ǹ�����,�;����й�
Wmi = interp1(ri,ai,r,'linear*',0);  % sample normalized weights ,   ���Բ�ֵ���õ��˺���Ȩ�غ�����gamma��WmiΪ����ֵf(x),rΪ������x ��[Wmi]����������¼��ÿ�����Ȩ��,����������v��Ȩ��
%����plotһ������һ��                                     
% plot(r,Wmi,'*');

% find span of data in x and y to determine if sufficient
maxDx = max(max(repmat(xy(:,1),1,Nxy) - repmat(xy(:,1)',Nxy,1))); %�ҳ�����x��Χ�����ж������Χ�Ƿ�����Ҫ��
maxDy = max(max(repmat(xy(:,2),1,Nxy) - repmat(xy(:,2)',Nxy,1))); %�ҳ�����y��Χ

% calculate the distance from every point to every other point

%% %%  4. loop through frequencies from most to least coherent.  For each
%% f, find the csm, then the first EOF.  If sufficiently coherent, fit to
%% find the k, alpha and scalar phase (no lasting value).
% �öγ���Ѱ��f����Ӧ��k��alpha����λ�����ĵ�3����ʽ��


% starting search seed for alpha (should this be ZERO after rotation?)
% ��ת֮��Ӧ��Ϊ0��
seedAlpha = params.offshoreRadCCWFromx; %���Ĵ�������ɣ�Ĭ��ֵΪ0��Ϊ����Ѱalpha��seed,��x��ļнǣ���ת֮��Ĭ��Ϊ0��

for i = 1:nKeep         % frequency loop  �������������n��Ƶ�ʵ�ѭ����Ѱ����֮ƥ���k Alpha Phi
    % prepare nlinfit params.  Note that k is radial wavenumber
    kmin = (2*pi*fs(i))^2/g; % smallest  and largest wavenumber   ��С����k = (2*pi*f)^2/g?? ����������ˮ�ķ�Χ(w^2 = gk)
    kmax = 2*pi*fs(i)/sqrt(g*params.MINDEPTH);      %tanh��̩��չ��Ϊ�����tanhx= x+o(x)�������Сֵ��ֱ��ָ����,��argus02a.m��������ļ�����
    LExpect = minLFraction*4*pi/(kmin+kmax);     % expected scale from mean k. ���Ʋ���L�Ĳ�����Χ*Lƽ������) = 0.5*L(ƽ������)
    LB_UB = [kmin seedAlpha-pi/2;kmax seedAlpha+pi/2];
    % LB_UB = [kmin seedAlpha-pi/2   �ڶ��в���Ϊ���ǣ���x��ļнǰ�,��-90~90֮��
    %          kmax seedAlpha+pi/2]; //seedAlphaĬ��Ϊ0
    % ��֪�����������ʲô��
    OPTIONS.TolX = min([kmin/1000, pi/180/1000]); % min([kmin/1000,pi/180/1000]); ��֪�������ڸ��������С��������С���˵Ĳ�������
    statset(OPTIONS);
    warning off stats:nlinfit:IterationLimitExceeded

    % info for depth subsequent h error estimation
    hiimax = g*(1/fs(i)^2)/(2*pi)/2;  % deepest allowable = L0/2   %L0 = g*T^2/(2*pi)ͬ��Ҳ������ɫɢ��ϵ���������(tanh(kh) == 1)�����Եõ�������
    hii = [params.MINDEPTH : .1 : hiimax]'; % find k for full range of h %ö�����п��ܵ�h��
    
    %ȷ����ˮ��ķ�Χ��Ȼ���ٽ���k�Ĺ��ƣ���ʱֻ�Ǵ�ŵķ�Χ���ƣ��������ƥ��
    %ά�ȸ��������Ƶ�ˮ��hii����ͬ�ģ���ÿ��ˮ���Ӧ
    kii = dispsol(hii, fs(i),0); %�ú�����������ö��h����f����ƥ�䣬�õ���Ӧ���ܵ�k����ʱkΪ����

    % pull out csm
    %�������׾����н���eof����
    Cij = C(:,:,i); % C�������ÿһ���Ӧ�Ķ���һ��f
    [v,d] = eig(Cij); % ������������������ֵ��dΪ����ֵ�ĶԽ�, 48*48, vΪ��Ӧ����������,������
    lam = real(diag(d));  % order eigenvalues and remove teeny imag component  (lam������ֵ),ȡ����ĶԽ���Ԫ�ز�ȡʵ������ʱlamΪһ��������
    [lam1, lamInd] = max(lam);  % �������ֵ���ֵ������ֵ����
    

    lam1Norm = lam1/sum(lam)*length(lam);  % as ratio to uniform eigenvalues  %length(��������Ǹ�ά��)
    
    v = v(:,lamInd);           % chose only dominant EOF,ֻѡ���������Ǹ�����������Ӧ���������������ɷַ�����֪ʶ��v�ǹ۲�ֵ�Ļ��׾���Ķ�Ӧ������ֵ
    w = abs(v).*Wmi;           % final weights for fitting. ���յ�Ȩ�غ�����������������ֵ*����������
    
    % check if sufficient data quality and xy span
    % ��Щ���ݶ��ǹ���ֵ
    % 1��Э������������ֵҪ����params.minLam
    % 2�������X��ΧҪ���������Ĳ���ֵ����һ��������Χ����й��ƣ�
    % 3�������Y��ΧҪ���������Ĳ���ֵ����һ��������Χ����й��ƣ�
    % ��һ�������Ͼ�ֱ�ӽ����һ��������������Ϊnan
    if ~((lam1Norm>params.minLam) && (maxDx>LExpect) && (maxDy>LExpect))  
        kAlphaPhi = [nan nan nan];
        ex = kAlphaPhi;
        skill = nan;
    else
        try
            % do nonlinear fit on surviving data 
            %���з��������
            
            % v�ǹ����׾����������ֵ��Ӧ����������
            % xy����xm,ymΪ�е������㣬��һ����x���ڶ�����y
            % LB_UB�ǹ涨�õ�һ����������Χ�������������治�Ϸ��Ĳ�������
            
            kAlphaPhiInit = findKAlphaPhiInit(v, xy, LB_UB, params);  %���������Ѿ�ѡ�õ�v��xy��LB_UB����k��Alpha��Phi������ֵ�ĳ�ʼֵ���ã����������kx,ky��alpha��kx,ky�н��㣬phi��һ����ֵĹ�ʽ�������
            
            
            % [xy w]��predictCSMģ�ͣ������������룬xyΪ���꣬w =abs(v).*wmi������wmi�Ǻ����˲���Ȩ��
            % [real(v); imag(v)]��predictCSMģ�ͣ���������������ֱ�Ϊ�������ֵ��Ӧ����������v��ʵ�����鲿
            % predictCSMģ�ͺ���
            % kAlphaPhiInit Ҫ��ϵ���������k��Alpha��Phi�ĳ�ʼֵ
            % OPTIONS ��ѡ��
            [kAlphaPhi,resid,jacob] = nlinfit([xy w], [real(v); imag(v)],...
                           'predictCSM', kAlphaPhiInit, OPTIONS);  % ��predictCSM����ȥ���������ݣ�kAlphaPhiInit�ǳ�ʼֵ,predictCSM�ķ���ֵΪq,Ҳ���ǹ�ʽ��3����q
                                                                   % ��q��ģ��ȥ�����[xy w]Ϊ������,[real(v);imag(v)]Ϊ�������һ�����ݣ����õ������ϵ�k��Alpha��phi
            
            % check if outside acceptable limits
            % (����ж��ǽ��б����ж�)����ϳ��������ݲ�����������ֵ�Ĺ��ƣ����Ծ�Ҫthrow
            if ((kAlphaPhi(1)<LB_UB(1,1)) || (kAlphaPhi(1)>LB_UB(2,1)) ...
                    || (kAlphaPhi(2)<LB_UB(1,2)) || (kAlphaPhi(2)>LB_UB(2,2)))
                error; 
            end
            
            % get predictions then skill
            % �ù۲�ֵ����ϳ�����kAlphaPhiȥ�õ�һ��Ԥ��ֵ����ʱȨ�ز�û�г��Ϻ����˲���
            vPred = predictCSM(kAlphaPhi, [xy abs(v)]);   % �õ���ϳ�kAlphaPhi,��û�о��������˲���w��Ȩ����v�����ó�һ��Ԥ��ֵ
            vPred = vPred(1:end/2) + sqrt(-1)*vPred(1+end/2:end); % ת��Ϊ������
            skill = 1 - norm(vPred-v)^2/norm(v-mean(v))^2; % can be neg. ��϶ȣ������ɸ�,����빫ʽ����.md
            
            if( cBDebug( params, 'DOPLOTPHASETILE' ))
                figure(i); clf
                plotPhaseTile(xy,v,vPred) %������xyΪ�������꣬vΪʵ��ֵ��oberserve��,vPredΪ���ֵ
                drawnow;
                fprintf('frequency %d of %d, normalized lambda %.1f\n  ', i, nKeep, lam1Norm)
            end

            % get confidence limits
            % ������ģ�͵������������
            % ��ù��Ƴ����Ĳ�����95%���������䣬����Ϊ��ϳ����Ĳ������в������Ÿ�Ⱦ���
            ex = nlparci(real(0 * kAlphaPhi), resid, jacob); % get limits not bounds  95% ����������, ͳ�Ʒ����, �������, help nlparci �鿴�����÷�,
            ex = real(ex(:,2)); % get limit, not bounds
            
        catch   % nlinfit failed with fatal errors, adding bogus
            kAlphaPhi = [nan nan nan];
            ex = kAlphaPhi;
            skill = nan;
            lam1 = nan;
        end % try
    end

    % store results
    %������
    fDependent.k(i) = kAlphaPhi(1); 
    fDependent.a(i) = kAlphaPhi(2);
    fDependent.dof(i) = sum(w/(eps+max(w)));  %���ɶȴ�����,eps��������ת��Ϊ���������ȣ�1+eps = 1.00
    fDependent.skill(i) = skill;
    fDependent.lam1(i) = lam1;
    fDependent.kErr(i) = ex(1);
    fDependent.aErr(i) = ex(2);
    
    % rough estimate of depth from linear dispersion
    if ~isnan(kAlphaPhi(1))  %���k != nan,˵����ֵ����ô������kiiΪ�����꣬hii�����Ӧ��ֵ�ĵط���ֵ
        fDependent.hTemp(i) = interp1(kii,hii, kAlphaPhi(1));   % h�ĳ�ʼֵΪkAlphaPhi(1)��Ӧ��h, h�ǲ�ֵ�������
        dhiidkii = diff(hii)./diff(kii);
        fDependent.hTempErr(i) = ...
            sqrt((interp1(kii(2:end),dhiidkii, kAlphaPhi(1))).^2.* ...
                    (ex(1).^2));
    else
        fDependent.hTemp(i) = nan;
        fDependent.hTempErr(i) = nan;
    end
end  % frequency loop

if( cBDebug( params, 'DOPLOTPHASETILE' ))
    fDependent
    input('Hit enter to continue ');
end

%
%   Copyright (C) 2017  Coastal Imaging Research Network
%                       and Oregon State University

%    This program is free software: you can redistribute it and/or  
%    modify it under the terms of the GNU General Public License as 
%    published by the Free Software Foundation, version 3 of the 
%    License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see
%                                <http://www.gnu.org/licenses/>.

% CIRN: https://coastal-imaging-research-network.github.io/
% CIL:  http://cil-www.coas.oregonstate.edu
%
%key cBathy
%

