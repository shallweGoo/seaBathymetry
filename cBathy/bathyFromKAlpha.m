function bathy = bathyFromKAlpha(bathy)
%
%  bathy = bathyFromKAlpha(bathy);
%  
% final step in BWLite to take multi-frequency estimates of bathymetry
% and find a best solution for each tomographic location using skill
% and error weightings

%ƥ����ѵģ�fB,k����


% a global flag -- shudder -- to turn the deep water fix OFF
% easy so that this can be tested at some time TBD
global CBATHYDoNotDeepWater



OPTIONS = statset('nlinfit');   % nlinfit options
OPTIONS.MaxIter = 30; %����������
OPTIONS.TolX = 1e-10; %%%1e-3;l
OPTIONS.Display = 'iter';
OPTIONS.Display = 'off';

g = 9.81; % gravity, it's the law!
ri = [0:0.01:1]';       % create a hanning filter for later interp
ai = (1 - cos( pi*(0.5 + 0.5*ri) ).^2);

if( CBATHYDoNotDeepWater ) %�����ǳˮ�ı�־λ
else
    %%lines 18-24, create sensitivity vectors gammaiBar and mu
    % find the dispersion sensitivity, mu.  This will used to interp into
    % gammi, mu, below.
    gammai = [0.0: 0.01: 1]; %100����
    gammaiBar = (gammai(1:end-1)+gammai(2:end))/2;
    foo = gammai.*atanh(gammai);
    dFoodGamma = diff(foo)./diff(gammai);
    mu = dFoodGamma./tanh(gammaiBar);
end

params = bathy.params;
nFreqs = size(bathy.fDependent.fB, 3); %��3ά�����ݵ�size��ѡ��nkeep��fB��nkeep��argus02.m����ָ���ˣ�Ҳ������Ҫ���������ݵ�.m�ļ�����Ū����Щ����
x = bathy.xm;     % ����Ҫ���Ƶĵ��x����
y = bathy.ym;     % for ease of writing
xMin = min(x);    
xMax = max(x);
X = repmat(x, [size(y,2), 1, nFreqs]);  %ym��xm��fBά��һ������
Y = repmat(y', [1, size(x,2), nFreqs]); %ym��xm��fBά��һ�����󣬶�Ӧxy����������Ϳ�����

% loop through all points, doing nlinfit solution for h.  Note that the init
% values of nan are returned unless solution is successful.


%��ÿ��x��ѯy
for ix = 1: length(x)
    for iy = 1: length(y)
        kappa = 1 + (bathy.params.kappa0-1)*(x(ix) - xMin)/ ...
             (xMax - xMin);
        % find range-based weights, Wmi to contribute to total weight
        dxmi = X - x(ix); %ÿһ��Ԫ�ض���ȥx(ix)
        dymi = Y - y(iy); %ÿһ��Ԫ�ض���ȥy(iy)
        r = sqrt((dxmi/(params.Lx*kappa)).^2 + (dymi/(params.Ly*kappa)).^2); %��������
        Wmi = interp1(ri,ai,r,'linear*',0);  % sample normalized weights  �õ�����Ȩ�ز���

        %�ҵ�����Ȩ�ز���Wmi���� > 0�� ���ֵ����Ҫ�� �� hTemp��Ϊnan�� ����
        id = find((Wmi > 0) & ...
                  (bathy.fDependent.skill>params.QTOL) & ...
                   (~isnan(bathy.fDependent.hTemp)));
        if(length(id)>params.minValsForBathyEst)  %���ֵΪ4              % just need two
            f = bathy.fDependent.fB(id);
            k = bathy.fDependent.k(id);
            kErr = bathy.fDependent.kErr(id);
            s = bathy.fDependent.skill(id); % ��϶�
            l = bathy.fDependent.lam1(id); %����ֵ
%             % find dispersion sensitivity
             gamma = 4*pi*pi*f.*f./(g.*k);  %w^2/(gk) = tanh(gk) = gamma;
            if( CBATHYDoNotDeepWater )
                w = Wmi(id).*l.*s./(eps+k);    % weights depend on skill and variance (lam) % Ȩ�������������ģ�Ȩ��Wmi*����ֵlambda*��϶�/����k
            else
                wMu = 1./interp1(gammaiBar, mu, gamma);
                w = Wmi(id).*wMu.*l.*s./(eps+k);    % weights depend on skill and variance (lam)
            end

            hInit = bathy.fDependent.hTemp(id)'*s / sum(s);  %hInit = ����fDependent.hTemp(id)�ó�����
            [h,resid,jacob] =nlinfit([f, w], k.*w, ...
                'kInvertDepthModel',hInit, OPTIONS);  %hʹ��kInvertDepthModel���������ϳ�����
            if (~isnan(h))      % some value returned %�������н���Ļ�����Ҫ����һЩ������
                % ���95%������������
                hErr = bathyCI(resid,jacob, w);		 % get limits not bounds
                kModel = kInvertDepthModel(h, [f, w]);  %��Ȩ��ϳ���kMode
                J = sqrt(sum(kModel.*k.*w)/(eps+sum(w.^2))); % skill ������϶�
                if ((J~=0) && (h>=params.MINDEPTH))
                    bathy.fCombined.h(iy,ix) = h;   %��Ȩ������h
                    bathy.fCombined.hErr(iy,ix) = hErr; %����h���
                    bathy.fCombined.J(iy,ix) = J;
                end
            end
        end  % default h, hErr to nan if no successful solution.
    end	%iy
end	% ix

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

