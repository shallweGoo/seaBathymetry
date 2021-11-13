%%% Site-specific Inputs
params.stationStr = 'argus02a';
params.dxm = 10;                    % analysis domain spacing in x
params.dym = 25;                    % analysis domain spacing in y
params.xyMinMax = [80 500 0 1000];   % min, max of x, then y  
                                    % default to [] for cBathy to choose  
                                    %Ĭ�ϵõ�x��43���㣬y��41����
params.tideFunction = 'cBathyTide';  % tide level function for evel ��λ

%%%%%%%   Power user settings from here down   %%%%%%%
params.MINDEPTH = 0.25;             % for initialization and final QC����ʼ����С�����Ϊ��ʼֵ
params.minValsForBathyEst = 4;      % min num f-k pairs for bathy est. ��С������(f-k)��

params.QTOL = 0.5;                  % reject skill below this in csm  �������ֵ��Ҫreject
params.minLam = 10;                 % min normalized eigenvalue to proceed ���е���С��һ������ֵ
params.Lx = 3*params.dxm;           % tomographic domain smoothing �����ѡ��,X���ϵ�
params.Ly = 3*params.dym;           % �����ѡ��,Y���ϵ�
params.kappa0 = 2;                  % �������ӣ��밶ԽԶ�����ҪԽ��
params.DECIMATE = 1;                % decimate pixels to reduce work load. ���������Լ��ٹ������ı�־λ
params.maxNPix = 80;                % max num pixels per tile (decimate excess) ÿ��������������80�����ص�

% f-domain etc.
params.fB = [1/18: 1/50: 1/4];		% frequencies for analysis (~40 dof) 10��Ƶ��ֵ��ѡ
params.nKeep = 4;                   % number of frequencies to keep  Ҫά��nKeep��Ƶ����Ϊ��ѡ

% debugging options  debugѡ��
params.debug.production = 0;            %���Ӧ�����ܿ��أ�Ϊ1��debug
params.debug.DOPLOTSTACKANDPHASEMAPS = 1;  % top level debug of phase %����Ƶ�ʶ�Ӧ����λͼ�Ŀ���
params.debug.DOSHOWPROGRESS = 1;		  % show progress of tiles
params.debug.DOPLOTPHASETILE = 1;		  % observed and EOF results per pt
params.debug.TRANSECTX = 200;		  % for plotStacksAndPhaseMaps ��ͼѡ��
params.debug.TRANSECTY = 900;		  % for plotStacksAndPhaseMaps

% default offshore wave angle.  For search seeds.
params.offshoreRadCCWFromx = 0;

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
% key cBathy
%

