# Raw database

This database contains the original hearing aid head related impulse responses and calibration measurements reported in [paper ref]. It contains the following directories:

````
doc: documentation  
mat: matlab .mat files containing the data   
````

The subject_%02d.mat files in this database provide the measured impulse responses without post processing so that other researchers are able to investigate alternative calibrarion/compensation methods according to their intended application. Each .mat file contains the following variables

````matlab
% hearing aid head-related impulse reponses when worn by subject
% dimensions [nSamples nMic=6 nDOA=29]
% dimension 2 arranged as described in metadata.channel_names
% dimension 3 arranged as described in metadata.speaker_positions
ha_hrir_n0            % the subject-specific measurement with chair oriented towards the front loudspeaker
ha_hrir_n15           % chair rotated through yaw rotation of -15 degrees (i.e. towards the subject's left)
ha_hrir_n30           % chair rotated through yaw rotation of -30 degrees (i.e. towards the subject's left)

% environment conditions immediately before the measurement
temperature:          % temperature [degrees celcius]
humidity:             % relative humidity [%]

% calibration measurements, made at the start of each measurement session (i.e. not unique per individual)
% without the chair being present with fields
omni_reference:       % G.R.A.S. reference microphone [nSamples nMic=1 nDOA=29]
left_ha:              % left microphones only [nSamples nMic=3 nDOA=29]
                      % channel names metadata.channel_names(1:3)
right_ha:             % right microphones only [nSamples nMic=3 nDOA=29]
                      % channel names metadata.channel_names(4:6)
temperature:          % temperature [degrees celcius]
humidity:             % relative humidity [%]
````
