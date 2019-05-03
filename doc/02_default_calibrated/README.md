# Calibrated database

This database contains hearing aid room impulse responses with some basic calibration applied. It contains the following directories:
````
mat: matlab .mat files containing the data  
doc: documentation
graphics: plots visualising the effect of calibration on horizontal plane measurements
````

## mat
Data in this directory is derived from the '00_raw' database. Source code is publically available on [GitHub](https://github.com/ImperialCollegeLondon/sap-oticon-hearing-aid-impulse-responses). The calibration applies scalar gain correction and time delay compensation.

Gain: Matches the A-weighted sensitivity of each microphone (6 gain terms) and each loudspeaker (29 gain terms).
Delay: Compensates for time of flight differences from each loudspeaker to the centre of the sphere (29 delay terms). Also compensates for offset of each subject from the centre of the sphere (2 delay terms expands to 29x3 terms).

N.B. these are hearing aid *room* impulse responses and so contain all reflections from the room.

Each .mat file contains the following variables where only `ha_rir_x` varies between files. 
````matlab
% subject-specific measurements of hearing aid room impulse response  [nSamples nMic=6 nDOA=29]
ha_rir_0              % chair in initial position with subject facing forwards
ha_rir_n15            % chair rotated through -15 degrees yaw
ha_rir_n30            % chair rotated through -30 degrees yaw

fs = 44100            % sample rate in Hz

% second dimension of hrir corresponds to microphone channels where...
refChannelLeft = 1    % index of "reference" microphone for left ear (i.e. front left)
refChannelRight = 2   % index of "reference" microphone for right ear (i.e. front right)
channelsLeft = [1 3]  % indices of all microphones at left ear
channelsRight = [2 4] % indices of all microphones at right ear


% third dimension of hrir corresponds to directions of arrival which are...
doa_az_deg            % azimuth values in degrees
doa_el_deg            % elevation values in degrees
doa_unit_vec          % directions expressed as cartesian unit vectors [3, nDOA=29]
````

The file `metadata.csv` is copied directly from the raw database for convenience. It contains the following fields

````matlab
subj_id:              % numerical identifier 
gender:               % subject gender - m: male,  f: female,  x: mannequin
circumference:        % measured from forehead, around back of head, above ears in cm
front_arc:            % measured from right front microphone around front of head to left front microphone in cm
width:                % measured between sides of head (not including ears) in cm
depth:                % measured from forehead to back of head in cm
height:               % measured from chin to top of head in cm
SI_test:              % boolean indicating that the subject took part in the speech intelligibitlity test
in_ear_valid:         % boolean indicating that the impulse responses measured for the InEarLeft and InEarRight microphones is valid. For subject 40 clipping of the recorded sweeps was observed, therefore this data is unreliable and has been set NaNs.
````

## doc
````matlab
coordinates_system.pdf                   % X is front, Y is left, Z is up. Positive azimuth and elevation indicated.
ha_on_hats_calibrated.pdf                % left ear view with microphone channels labeled and numbered  
speaker_layout_schematic_calibrated.pdf  % directions of loudspeakers in degrees
````
