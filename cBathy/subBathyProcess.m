function [fDep, camUsed] = subBathyProcess( f, G, xyz, cam, xm, ym, params, kappa )

%% subBathyProcess -- extract region from full bathy stack, process
%
%  [fDep,camUsed] = subBathyProcess( f, G, xyz, cam, xm, ym, params, kappa )
%
%  f, G, xyz, cam are the full arryms. 
%  xm,ym is the desired analysis point.
%  params is the parameter structure
%  kappa is the cross-shore variable sample domain scaling factor for this
%       position
%
% ����������forѭ������ʱxm,ym��һ���㣬�Ƕ�һ�������


%% first extract sub region

%�ռ䷶Χ���ƺ������õ�һ����Χ�����G,XYZ,camUsed,����camera�������õ���Χ�ڵ���Щ����
[subG, subXYZ, camUsed] = spatialLimitBathy( G, xyz, cam, xm, ym, params, kappa );  % ���Ի�õ�ǰ(xm,ym)������Ŀռ�


if( cBDebug( params, 'DOSHOWPROGRESS' )) %����л�ͼ������裬��չʾ
    figure(21);
    foo = findobj('tag','pixDots'); % tidy up old locations %����ɵ�λ��
    if ~isempty(foo)
        delete(foo)
    end
    foo = findobj('tag','xmDot');
    if ~isempty(foo)
        delete(foo)
    end
    hp1 = plot(subXYZ(:,1), subXYZ(:,2), 'r.', 'tag', 'pixDots');
    hp2 = plot(xm, ym, 'g.', 'tag', 'xmDot');
end


%% anything to process?

%���GΪ�յĻ�,���ò���Ϊ��Ч������ֱ�ӷ���
if isempty(subG) 
	fDep.k = nan(params.nKeep,1); %����һ��4*1��������
	camUsed = -1;
	return;
end

%% now process!

fDep = csmInvertKAlpha( f, subG, subXYZ, xm, ym, params, kappa );

%% how simple!

 

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

