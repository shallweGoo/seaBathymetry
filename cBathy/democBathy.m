% This is an example m-file to demonstrate how to run cBathy and display
% results.  It uses a supplied example data set and does not make
% assumptions about CIL conventions or databases.

clear
% dbstop if all error  % �������
% addpath(genpath('./my_data'));

% Do a single cBathy analysis, returning the bathy structure (which you
% would normally save somewhere) and displaying the results.  

% stationStr = 'argus02a';
% stackName = 'testStack102210Duck';



% stationStr = 'mavicPro';
% stackName = '2020_10_24_group5';
stationStr = 'phantom4';
stackName = 'data_struct';

bathy = analyzeSingleBathyRunNotCIL(stackName, stationStr);
bathy.params.debug.production = 0;
plotBathyCollect(bathy)
%%
save('F:/workSpace/matlabWork/seaBathymetry/cbathy.mat','bathy');

%% �Ա����ݵĲ����õ�
% Now compare this result with a supplied example CRAB survey from three
% days prior.
CRABpn = '19-Oct-2010FRFGridded.mat';
load(CRABpn)
figure(1); clf
subplot(121)
imagesc(xm,ym,zi); grid on; caxis([-8 1])
axis xy; xlabel('x (m)'); ylabel('y (m)'); title(['CRAB, ' CRABpn])

% remove results with HErr greater than a threshold and plot cBathy results
subplot(122)
h2 = bathy.fCombined.h;
threshErr = 1.0;
h2(bathy.fCombined.hErr>threshErr) = nan;
imagesc(bathy.xm,bathy.ym,-h2); grid on
caxis([-8 1])
axis xy; xlabel('x (m)'); ylabel('y (m)'); 
title(['cBathy, ' datestr(epoch2Matlab(str2num(bathy.epoch)))])

% Finally, try turning on the debug feature and test it using guidance from
% the user manual.  This is done by setting params.debug.production to 0.
% You may want to change some of the debug options.  You then simply repeat

% the analyzeSingleBathyNotCIL commands.

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


