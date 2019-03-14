close all;
clc;
clear all;
addpath('./1. BasicModules/kd_tree');
addpath('./1. BasicModules');
addpath('./2. Non_rigid_registration');
%  distcomp.feature( 'LocalUseMpiexec', false )
dbstop if error
% to_convert_files = string({'default.obj', 'FB_AU06_CheekRaiser_L_BT.obj', 'FB_AU06_CheekRaiser_R_BT.obj', 'FB_AU07_LidTightener_L_BT.obj', 'FB_AU07_LidTightener_R_BT.obj', 'FB_AU09_NoseWrinkler_BT.obj', 'FB_AU10_LowLipRaiserUpLip_M_BT.obj', 'FB_AU10_LowLipRaiser_Half_M_BT.obj', 'FB_AU10_LowLipRaiser_In_M_BT.obj', 'FB_AU10_LowLipRaiser_In_M_BT_Backup.obj', 'FB_AU10_LowLipRaiser_L_BT.obj', 'FB_AU10_LowLipRaiser_M_BT.obj', 'FB_AU10_LowLipRaiser_M_BTBackup.obj', 'FB_AU10_LowLipRaiser_Out_L_BT.obj', 'FB_AU10_LowLipRaiser_Out_M_BT.obj', 'FB_AU10_UpLipRaiser_L_BT.obj', 'FB_AU10_UpLipRaiser_M_BT.obj', 'FB_AU10_UpLipRaiser_R_BT.obj', 'FB_AU10_UpLipRaiser_Sticky_M_BT.obj', 'FB_AU12_LipCornerPuller_BT.obj', 'FB_AU12_LipCornerPuller_Closed_BT.obj', 'FB_AU12_LipCornerPuller_L_BT.obj', 'FB_AU12_LipCornerPuller_L_Closed_BT.obj', 'FB_AU12_LipCornerPuller_R_Closed_BT.obj', 'FB_AU13_CheekPuffer_BT.obj', 'FB_AU14_DimplerStretch_BT.obj', 'FB_AU14_Dimpler_L_BT.obj', 'FB_AU14_Dimpler_R_BT.obj', 'FB_AU15_LipCornerDepressor_BT.obj', 'FB_AU15_LipCornerDepressor_L_BT.obj', 'FB_AU15_LipCornerDepressor_R_BT.obj', 'FB_AU17_ChinRaiser_BT.obj', 'FB_AU18_LipPuckerer_BT.obj', 'FB_AU18_LipPuckerer_Raiser_BT.obj', 'FB_AU20_LipStretcher_BT.obj', 'FB_AU20_LipStretcher_L_BT.obj', 'FB_AU20_LipStretcher_R_BT.obj', 'FB_AU22_LipFunneler_BT.obj', 'FB_AU23_LipTightener_BT.obj', 'FB_AU25_LowLipPart_L_BT.obj', 'FB_AU25_LowLipPart_M_BT.obj', 'FB_AU25_LowLipPart_M_Sticky_BT.obj', 'FB_AU26_JawBack_BT.obj', 'FB_AU26_JawDropBack_BT.obj', 'FB_AU26_JawDrop_BT.obj', 'FB_AU26_JawDrop_Closed_BT.obj', 'FB_AU26_JawSide_L_BT.obj', 'FB_AU26_JawSide_R_BT.obj', 'FB_AU26_JawThrust_BT.obj', 'FB_AU27_MouthStretch_BT.obj', 'FB_AU28_LowLipSuck_BT.obj', 'FB_AU28_UpLipSuck_BT.obj', 'FB_AU99_LipCheekRaiser_L_BT.obj', 'FB_AU99_LipCheekRaiser_L_BT1.obj', 'FB_AU99_LipCheekRaiser_R_BT.obj', 'FB_AU99_LipCheekRaiser_R_BT1.obj'});
%% Example
% to_convert_files = string({'base.obj', 'flex_000.obj', 'flex_001.obj', 'flex_002.obj', 'flex_003.obj', 'flex_004.obj', 'flex_005.obj', 'flex_006.obj', 'flex_007.obj', 'flex_008.obj', 'flex_009.obj', 'flex_010.obj', 'flex_011.obj', 'flex_012.obj', 'flex_013.obj', 'flex_014.obj', 'flex_015.obj', 'flex_016.obj', 'flex_017.obj', 'flex_018.obj', 'flex_019.obj', 'flex_020.obj', 'flex_021.obj', 'flex_022.obj', 'flex_023.obj', 'flex_024.obj', 'flex_025.obj', 'flex_026.obj', 'flex_027.obj', 'flex_028.obj', 'flex_029.obj', 'flex_030.obj', 'flex_031.obj', 'flex_032.obj', 'flex_033.obj', 'flex_034.obj', 'flex_035.obj', 'flex_036.obj', 'flex_037.obj', 'flex_038.obj', 'flex_039.obj', 'flex_040.obj', 'flex_041.obj', 'flex_042.obj', 'flex_043.obj', 'flex_044.obj', 'flex_045.obj', 'flex_046.obj', 'flex_047.obj', 'flex_048.obj', 'flex_049.obj'});
source_file_path = 'D:\\Blendshape-Animation\\Transfered\\Caidonghao\\Actor\\Tri\\Face\\AlignedBlendshapes';
File = dir(fullfile(source_file_path, '*.obj'));  
to_convert_files = {File.name}'; 
file_name1 = "base.obj";
target_name = 'D:\\Blendshape-Animation\\Transfered\\Caidonghao\\Charactor\\Tri\\Face\\NeutralPose';
target_filename = 'sister-face.obj';
output_dir = 'D:\\Origin_Deformaion_transfer\\Caidonghao2sister';
delete('DF_reg_phase2.mat');
delete('Face_ICIP_corres.mat');
for i=1:length(to_convert_files)
    file_name2 = to_convert_files(i);
    name = file_name2{1};
    [VS, FS, NS] = read_obj_file(source_file_path + "\\" + file_name1);
    [VS2, FS2, NS2] = read_obj_file(source_file_path + "\\" + file_name2);
    [VT, FT, NT] = read_obj_file(target_name + "\\" + target_filename); 
    marker = init_marker(VS, FS, VT, FT, 'D:\\Blendshape-Animation\\Transfered\\Caidonghao\\Face_Marker.mat');
%     delete('DF_reg_phase2.mat');
    [ VS_Reg, VT_Reg, S_factor,T_factor] = non_rigid_registration(VS, FS, VT, FT, 1.0, 0.01, [1 500 3000 5000], marker, 'DF_reg_phase2.mat');
    corres = build_correspondence(VS_Reg, FS, VT_Reg, FT, 80, 0.05, 'Face_ICIP_corres.mat');
    [ x, nx ] = deformation_transfer(VS, FS, VT, FT, VS2, FS2, corres);
    write_obj_file(x, FT, nx, output_dir + "\\" + name);
    fprintf('write %s / %s\n', output_dir, name);
    close all;
end
