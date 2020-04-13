
% for both conditions, process 3d .nii files
process_3d_nii('patients')
process_3d_nii('probands')


function process_3d_nii(group)

    dataPath = 'Z:\OCD_RS\';

    % combine different strings into the correct path
    groupPath = fullfile(dataPath, group);
    % get all subfolders of the directory referenced by groupPath
    subjectFolders = dir(groupPath);
    % convert the variable subjectFolders from a struct to a cell
    % in order to be able to index into it aka to iterated over it easily
    subjectFolders = {subjectFolders.name}; 
    
    % get all relevant .nii file names for one subject at a time
    for i=3:numel(subjectFolders)
        % start from 3 (and not 1) because 1 is '.' and 2 is '..'
        
        fprintf('Processing %s ...\n', subjectFolders{i})
        abortCondition = 0;
        
        subjectFolder = fullfile(groupPath, subjectFolders{i}, 'resting_state');
        restingFolders = {dir(subjectFolder).name};

        if isempty(restingFolders) || numel(restingFolders) == 2
            fprintf('Did not find functional data for %s, skipping\n', subjectFolders{i})
            continue
        end

        ismatch = ~cellfun(@isempty, regexp(restingFolders, ...
            '^t2star_epi_2D_rest_\d{4}$', 'match', 'once'));
        
        for match = restingFolders(ismatch)'                       
            niftiFolder = match{1};
            subjectFiles = dir(fullfile(subjectFolder, match{1}, '*.nii'));
            fileNames = {subjectFiles.name};
        end
        
        if numel(fileNames) == 0
            fprintf('Found no files for %s \n', subjectFolders{i})
            continue
        end

        try
            for k = 1:numel(fileNames)
                fileNames{k} = fullfile(subjectFolder, niftiFolder, fileNames{k});
            end
            
            outputFileName = fullfile('Z:\OCD_RS\conn_analysis3', subjectFolders{i}, ...
                'functional', strcat('4d_', subjectFolders{i}, '.nii'));
            spm_file_merge(fileNames, outputFileName, spm_type('int16'), 2.3)
            
        catch
           fprintf('Failed to process %s, skipping\n', subjectFolders{i}) 
        end
        
    end
end