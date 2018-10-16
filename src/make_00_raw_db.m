function[] = make_00_raw_db(in_dir,out_dir)

path_to_doc = fullfile('doc','00_raw');

fprintf('Creating original study db\n');

% create folder structure by copying documentation to output directory
copyfile(path_to_doc,out_dir);

% copy the data itself
copyfile(in_dir, fullfile(out_dir,'mat'))