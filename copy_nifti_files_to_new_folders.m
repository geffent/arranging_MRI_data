
sourceDir = 'Z:\OCD_RS\conn_ascending';
destinationDir = 'Z:\OCD_RS\conn_ascending_hope';

% get the names of all subject folders
subjectFolders = {dir(sourceDir).name};

for i = 3:numel(subjectFolders)

    subjectID = subjectFolders{i};

    fprintf('Subject %s \n', subjectID)

    % COPY FUNCTIONAL .NII FILE TO DESTINATION FOLDER

    funcSource = fullfile(sourceDir, subjectID, 'functional');
    funcDestination = fullfile(destinationDir, subjectID, 'functional');
    
    if ~exist(funcDestination, 'dir')
        mkdir(funcDestination)
    end
    
    funcFile = fullfile(funcSource, strcat('4d_', subjectID, '.nii'));
    copyfile(funcFile, funcDestination);
 
    
    % COPY ANATOMICAL FILE TO DESTINATION FOLDER

    anatSource = fullfile(sourceDir, subjectID, 'anatomical');
    anatDestination = fullfile(destinationDir, subjectID, 'anatomical');
    
    if ~exist(anatDestination, 'dir')
        mkdir(anatDestination)
    end
    
    anatFiles = {dir(anatSource).name};
    anatPattern = ~cellfun(@isempty, regexp(anatFiles, '^s.*nii$', 'match', 'once'));
    match = anatFiles(anatPattern);
    anatFile = fullfile(anatSource, match{1});
    
    copyfile(anatFile, anatDestination);

end