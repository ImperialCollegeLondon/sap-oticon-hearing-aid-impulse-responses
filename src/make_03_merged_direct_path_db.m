function[] = make_03_merged_direct_path_db(in_dir,out_dir)

path_to_doc = fullfile('doc','03_merged_direct_path');

fprintf('Creating merged direct path db\n');

% create folder structure by copying documentation to output directory
copyfile(path_to_doc,out_dir);

% generate the data itself
postProcessMergedDirect(in_dir, out_dir);