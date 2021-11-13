function bathyErr = bathyCI(resid,J,w)
% 
% nlparci �ĸ��İ汾����ר���޸��Դ��� cBathy ����������Ⲣ���Ƕ�ƽ���͵ļ�Ȩ���ס� Ψһ�ı仯�Ǹ���Ȩ�� w �������ɶȵ�������
%   bathyErr = bathyCI(resid,J,w)
%
%  altered version of nlparci specifically modified to handle the bathy
%  estimation problem for cBathy and to account for the weighted
%  contribution to the sum of squares.  The only change is to reduce the
%  number of degrees of freedom depending on the weights, w.
%
%  Inputs:
%   resid   - Nx1 vector or prediction residuals from k-estimates
%   J       - Jacobian (both these are from nlinfit)
%   w       - weights used in weighted nlinfit
%  Output:
%   bathyErr - 95% confidence interval on depth estimate.
%
%  Scalped from nlparci for special case of single parameter (bathy)
%  estimation.  Holman, 2012.

alpha = 0.05;

n = sum(w)/max(w);  % Holman kludge
v = n-1;

% Calculate covariance matrix
[~,R] = qr(J,0);
Rinv = R\eye(size(R));
diag_info = sum(Rinv.*Rinv,2);

rmse = norm(resid) / sqrt(v);
se = sqrt(diag_info) * rmse;

% Calculate bathyError from t-stats.
bathyErr = se * tinv(1-alpha/2,v);


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

