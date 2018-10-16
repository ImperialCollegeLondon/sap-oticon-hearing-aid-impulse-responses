function[] = make_02_default_calibrated_db(in_dir,out_dir)

path_to_doc = fullfile('doc','02_default_calibrated');

fprintf('Creating calibrated db\n');

% create folder structure by copying documentation to output directory
copyfile(path_to_doc,out_dir);

% generate the data itself
postProcessCalibrated(in_dir,out_dir);
