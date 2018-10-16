function [] = check_input_dir_exists( dir_path, should_exist )
%check_input_dir_exists throws an error if specified path does not exist

if nargin < 2 || isempty(should_exist)
    should_exist = true;
end

does_exist = isequal(exist(dir_path,'dir'),7);

if ~isequal(should_exist,does_exist)
    if does_exist
        error(['Input dir already exists: ' dir_path])
    else
        error(['Input dir does not exist: ' dir_path])
    end
end
