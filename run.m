% Main script to create published database(s) of hearing aid impulse
% responses.
%
% This script must be edited with the appropriate paths for the user's
% system. The required input data are the '00_raw' measurements published 
% with DOI 10.5281/zenodo.2660782.
% To avoid possible overwriting of data, the output directory must not already exist.
% A new copy of the '00_raw' database is created which is then the data
% from which all other databases are derived
%
% Alastair Moore, October 2018

% Change these paths according to your needs
IN_RAW_DIR = '~/path_to_input_00_raw_dir';
OUT_ROOT_DIR = sprintf('~/path_to_generated_databases/%s',datestr(now,'yyyymmdd_HHMMSS'));

% the required functions are in subdirectories with respect to this script
% to avoid potential clashes make sure only default and local functions are
% on the path
fprintf('\n*\n*\n* This script restores the default matlab path. Proceed with caution.\n*\n*\n\n');
if isequal(input('Press y to continue...\n','s'),'y')
    % setup
    restoredefaultpath
    addpath('src');
    addpath('src/dependencies/voicebox');
    addpath('src/dependencies/elobes');
    
    % path validation
    check_input_dir_exists(IN_RAW_DIR,true);        %error if not present
    check_input_dir_exists(OUT_ROOT_DIR,false);     %error if present
    check_output_dir_exists(OUT_ROOT_DIR);          %creates empty folder
    
    % main directory used for derivative databases
    raw_db_dir = fullfile(OUT_ROOT_DIR,'00_raw');
    
    % Each function below generates a different database version.
    % Each takes 2 input arguments:
    %   in_dir: the path to the raw database
    %  out_dir: the output path to the created database
    
    % Combine original measurement data with documentation 
    make_00_raw_db(IN_RAW_DIR,raw_db_dir)
    
    % Extract the data used for published study
    make_01_original_study_db(raw_db_dir,fullfile(OUT_ROOT_DIR,'01_original_study'));
    
    % Perform a standard calibration
    cal_db_dir = fullfile(OUT_ROOT_DIR,'02_default_calibrated');
    make_02_default_calibrated_db(raw_db_dir,cal_db_dir);
    
    % Extract the direct path from calibrated response and merge to form high resolution database 
    make_03_merged_direct_path_db(cal_db_dir,fullfile(OUT_ROOT_DIR,'03_merged_direct_path'));
end
