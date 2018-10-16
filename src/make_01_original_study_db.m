function[] = make_01_original_study_db(in_dir,out_dir)

path_to_doc = fullfile('doc','01_original_study');

fprintf('Creating original study db\n');

% create folder structure by copying documentation to output directory
copyfile(path_to_doc,out_dir);

% generate the data itself
postProcessStudy(in_dir, out_dir)