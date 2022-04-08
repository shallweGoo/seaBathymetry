%% 结构体
run('F:/workSpace/matlabWork/seaBathymetry/bathyParams');
addpath(genpath('class'));
addpath(genpath('data'));
addpath(genpath('../timeCor/common'));
addpath(genpath('../timeCor/ProcessFromVideo/'));
fs = params.fs;
world.x = params.xy_min_max(3):  params.dist: params.xy_min_max(4);
world.y = params.xy_min_max(1):  params.dist: params.xy_min_max(2);


%% getGroundTruth
close all;
gt_path.path1 = 'F:/workSpace/matlabWork/数据/excel/total.txt';
gt_path.path2 = 'F:/workSpace/matlabWork/数据/excel/totalDEPTH.txt';
% o_llh = [22.5958634,114.8765426, 0.1]; % common
% mat_path = 'H:/imgResult/resMat/';
% ds_path =  'H:/imgResult/downSample/';

o_llh = [22.595411388888888 114.87636363888889 0.627]; %stitch
mat_path = 'H:/stitchData/1/';
ds_path =  'H:/stitchData/1/left/';
load([params.data_save_path 'bathy.mat']);
load([params.data_save_path 'data_struct.mat']);

tide = 0.4;
gt = getGroundTruth(gt_path, mat_path, ds_path, xyz, o_llh, bathy, tide);

%% plot three pic
close all;
cBathy = load([params.data_save_path 'cBathy.mat']);
plotGtTimeCBathy(world, gt, bathy.h_final, cBathy.bathy.fCombined.h', 30);
plotError(world, abs(gt-bathy.h_final), abs(gt-cBathy.bathy.fCombined.h'),30);
%%
target_col = [20, 60, 100];
plotThreeCrossShoreCurve(gt, bathy.h_final, cBathy.bathy.fCombined.h', target_col, 30);

%% error analyze

timeCorE = errorAnalyze(bathy.h_final, gt);
cBathyE = errorAnalyze(cBathy.bathy.fCombined.h', gt);
%% timeCol
disp('timeCorE Error:');    
timeCorE.rmse();
timeCorE.mse();
timeCorE.mae();
timeCorE.rmseCol(target_col(1));
timeCorE.rmseCol(target_col(2));
timeCorE.rmseCol(target_col(3));
timeCorE.mseCol(target_col(1));
timeCorE.mseCol(target_col(2));
timeCorE.mseCol(target_col(3));
timeCorE.maeCol(target_col(1));
timeCorE.maeCol(target_col(2));
timeCorE.maeCol(target_col(3));
%% cBathy
disp('cBathy Error: ')
cBathyE.rmse();
cBathyE.mse();
cBathyE.mae();
cBathyE.rmseCol(target_col(1));
cBathyE.rmseCol(target_col(2));
cBathyE.rmseCol(target_col(3));
cBathyE.mseCol(target_col(1));
cBathyE.mseCol(target_col(2));
cBathyE.mseCol(target_col(3));
cBathyE.maeCol(target_col(1));
cBathyE.maeCol(target_col(2));
cBathyE.maeCol(target_col(3));







