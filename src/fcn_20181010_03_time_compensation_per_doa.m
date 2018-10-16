function[comp] = fcn_20181010_03_time_compensation_per_doa(head_pos,chair_rot_deg,az_deg,el_deg)
% assumes plane wave (i.e. angle is independent of head_pos
% 

az_deg = az_deg - chair_rot_deg;
doa_vec = mysph2cart(deg2rad(az_deg(:)),deg2rad(90-el_deg(:)));

% project head_pos vector onto doa_vec
comp = doa_vec * head_pos.';


% %
% head_pos = [-0.5 0 0];
% chair_rot_deg = 0;
% az_deg = 0;
% el_deg = 0;
% 
% head_pos = [-0.5 0 0];
% chair_rot_deg = 0;
% az_deg = 180;
% el_deg = 0;
% 
% head_pos = [-0.5 0 0];
% chair_rot_deg = 0;
% az_deg = 90;
% el_deg = 0;
% 
% head_pos = [-0.5 0.5 0];
% chair_rot_deg = 0;
% az_deg = 45;
% el_deg = 0;
% 
% head_pos = [-0.5 -0.5 0];
% chair_rot_deg = 0;
% az_deg = 45;
% el_deg = 0;
