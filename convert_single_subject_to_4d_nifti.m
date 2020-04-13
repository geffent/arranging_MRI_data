
clear
clc

subjectID = '2017';
subjectFolder = strcat('Z:\OCD_RS\patients\2017\resting_state\t2star_epi_2D_rest_0011');

% read all .nii files in subjectFolder
subjectFiles = dir(fullfile(subjectFolder, '*.nii'));
% secret MatLab sauce
fileNames = {subjectFiles.name};
for i = 1:numel(fileNames)
    fileNames{i} = fullfile(subjectFolder, fileNames{i});
end

outputFileName = fullfile('Z:\OCD_RS\conn_analysis3\', subjectID, ...
    'functional', strcat('4d_', subjectID, '.nii'));
% last argument is the TR, here 2.3
spm_file_merge(fileNames, outputFileName, spm_type('int16'), 2.3)
