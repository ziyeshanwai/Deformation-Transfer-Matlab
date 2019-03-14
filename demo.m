close all;
clc;
clear all;
addpath('./1. BasicModules/kd_tree');
addpath('./1. BasicModules');
addpath('./2. Non_rigid_registration');
dbstop if error
%  distcomp.feature( 'LocalUseMpiexec', false )
%% Example

source_file_dir =  'D:\\Blendshape-Animation\\Transfered\\Caidonghao\\Actor\\Tri\\Face\\AlignedBlendshapes\\';
target_file_dir = 'D:\\Blendshape-Animation\\Transfered\\Caidonghao\\Charactor\\Tri\\Face\\NeutralPose\\';
output_dir = "D:\\Origin_Deformaion_transfer\\Caidonghao2sister\\";
Soure_file_name_1 = "base.obj";
Source_file_name_2 = "flex_039.obj";
target_file_name = "sister-face.obj";
delete("DF_reg_phase2.mat");
delete('Face_ICIP_corres.mat');
Face_Marker_path = "D:\\Blendshape-Animation\\Transfered\\Caidonghao\\Face_Marker.mat";
if ~exist('VS','var')
    [VS, FS, NS] = read_obj_file(source_file_dir+Soure_file_name_1);
    [VS2, FS2, NS2] = read_obj_file(source_file_dir+Source_file_name_2);
    [VT, FT, NT] = read_obj_file(target_file_dir+target_file_name);    
end

marker = init_marker(VS, FS, VT, FT, Face_Marker_path);
% step1: 非刚体对齐
[ VS_Reg, VT_Reg ] = non_rigid_registration(VS, FS, VT, FT, 1.0, 0.01, [1 500 3000 5000], marker, 'DF_reg_phase2.mat');
% step2: 建立对应关系
corres = build_correspondence(VS_Reg, FS, VT_Reg, FT, 10, 0.05, 'Face_ICIP_corres.mat');
% step3: 形变迁移
[ x, nx ] = deformation_transfer(VS, FS, VT, FT, VS2, FS2, corres);
write_obj_file(x, FT, nx, output_dir+Source_file_name_2);

fprintf('End of demo..\n');
% system('pause');

clear VS VT S_factor T_factor FS FT NS NT maker;