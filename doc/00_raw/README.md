# Raw database

This database contains the as-measured hearing aid head-related impulse responses and calibration measurements reported in "Personalized signal-independent beamforming for binaural hearing aids". It contains the following directories:
````
mat: matlab .mat files containing the data   
doc: documentation  
````

## mat
The subject_%02d.mat files in this database provide the measured impulse responses without post processing so that other researchers are able to investigate alternative calibration/compensation methods according to their intended application. N.B. hrir is used here in the generic sense - all measurements in this database *do* contain room reflections.

Each .mat file contains the following variables
````matlab
% hearing aid head-related impulse reponses when worn by subject
% dimensions [nSamples nMic=6 nDOA=29]
% dimension 1 sample values with respect to time with sample rate given in fs in Hz
% dimension 2 arranged as given in mic_channel_names
% dimension 3 arranged as given in elevation: doa_elevation_deg, azimuth: doa_azimuth_deg

ha_hrir_0             % the subject-specific measurement with chair oriented towards the front loudspeaker
ha_hrir_n15           % chair rotated through yaw rotation of -15 degrees (i.e. towards the subject's right)
ha_hrir_n30           % chair rotated through yaw rotation of -30 degrees (i.e. towards the subject's right)

% metadata associated with hearing aid head-related impulse reponses
fs = 44100
mic_channel_names = {'FrontLeft', 'BackLeft', 'InEarLeft', 'FrontRight', 'BackRight', 'InEarRight'}
doa_elevation_deg = [...
    zeros(1,16),...
    -45 * ones(1,6),...
    45 * ones(1,6),...
    90,...
    ];
doa_azimuth_deg = [...
    [0:15].*(360/16),...
    [(0:5) .* (360/6)]+30,...
    [(0:5) .* (360/6)]+30,...
    0,...
    ];

% environment conditions immediately before the measurement
temperature          % temperature [degrees celcius]
humidity             % relative humidity [%]

% calibration measurements, made at the start of each measurement session (i.e. not unique per individual)
% without the chair being present with fields
omni_reference        % G.R.A.S. reference microphone [nSamples nMic=1 nDOA=29]
left_ha               % left microphones only [nSamples nMic=3 nDOA=29]
                      % with channel names mic_channel_names{1:3}
right_ha              % right microphones only [nSamples nMic=3 nDOA=29]
                      % with channel names: mic_channel_names{4:6}
temperature           % temperature [degrees celcius]
humidity              % relative humidity [%]
````

The file `metadata.csv` contains the following fields

````matlab
subj_id               % numerical identifier 
gender                % subject gender - m: male,  f: female,  x: mannequin
circumference         % measured from forehead, around back of head, above ears in cm
front_arc             % measured from right front microphone around front of head to left front microphone in cm
width                 % measured between sides of head (not including ears) in cm
depth                 % measured from forehead to back of head in cm
height                % measured from chin to top of head in cm
SI_test               % boolean indicating that the subject took part in the speech intelligibitlity test
in_ear_valid          % boolean indicating that the impulse responses measured for the InEarLeft and InEarRight microphones is valid. For subject 40 clipping of the recorded sweeps was observed, therefore this data should not be used. For simplicty of post processing the data is retained in the raw database and should be set to NaNs where appropriate.
````

## doc
````matlab
coordinates_system.pdf            % X is front, Y is left, Z is up. Positive azimuth and elevation indicated.
ha_on_hats_raw.pdf                % left ear view with microphone channels labeled and numbered  
speaker_layout_schematic_raw.pdf  % directions of loudspeakers in degrees
````
