function[idc_map,doa_az_deg,doa_el_deg] = fcn_20181011_04_doa_merge_map(doa_az_deg,doa_el_deg,chair_rot_deg)

% doa_az_deg = [...
%     [0:15].*(360/16),...
%     [(0:5) .* (360/6)]+30,...
%     [(0:5) .* (360/6)]+30,...
%     0,...
%     ];
% doa_el_deg = [...
%     zeros(1,16),...
%     -45 * ones(1,6),...
%      45 * ones(1,6),...
%     90,...
%     ];
% chair_rot_deg = [0 -15 -30];

%el_list = unique(doa_el_deg,'stable');

cat_az = [];
cat_el = [];
for irot = 1:length(chair_rot_deg)
    cat_az = cat(2,cat_az,doa_az_deg-chair_rot_deg(irot));
    cat_el = cat(2,cat_el,doa_el_deg);
end

cat_az(cat_az>=360) = cat_az(cat_az>=360)-360;

doa_unit_vec = [...
    cosd(cat_az).*cosd(cat_el);...
    sind(cat_az).*cosd(cat_el);...
    sind(cat_el)].';

[~,doa_select] = unique(doa_unit_vec,'rows','stable');

% sort
[~,isort] = sortrows([cat_el(doa_select).',cat_az(doa_select).']);

% remove unneeded entries
ioffgrid = find(abs(cat_el(doa_select(isort)))==45 & rem(cat_az(doa_select(isort)),30)~=0);
isort(ioffgrid) = [];

% final map
idc_map = doa_select(isort);

% apply to doas
doa_az_deg = cat_az(idc_map);
doa_el_deg = cat_el(idc_map);




