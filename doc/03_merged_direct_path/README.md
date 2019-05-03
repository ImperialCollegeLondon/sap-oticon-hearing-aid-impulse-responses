# Merged direct-path database

This database contains hearing aid head-related impulse responses which are cropped so that measurements on the horizontal plane only contain the direct-path impulse response. Measurements from 3 different chair rotations are interleaved to give a higher angular resolution than in '02_calibrated' database.  It contains the following directories:
````
mat: matlab .mat files containing the data  
doc: documentation
graphics: plots visualising the impulse responses prior to cropping to include only the direct path
````

## mat
Data in this directory is derived from the '02_calibrated' database. Source code is publically available on [GitHub](https://github.com/ImperialCollegeLondon/sap-oticon-hearing-aid-impulse-responses). No further calibration is applied. Measurements are cropped to include only the first 10.7 milliseconds and measurements for different chair rotations are interleaved to give higher resolution sampling around 3 elevations. At elevation ±45 degrees, the azimuth resolution is 30 degrees.  At elevation 0 degrees, the azimuth resolution is 7.5 degrees.

For elevations other that 0 degrees the first 10.7 milliseconds includes a significant reflection from either the floor or ceiling. Since this reflection has the same azimuth angle as the true direct path wavefront the interleaved responses are consistent within each elevation. However, care should be taken in how this data is analysed since there is an elevation dependence which is caused by the environment, rather than the individual.

N.B. other than as described above, these are hearing aid *head-related* impulse responses and so do not contain room reflections.

Each .mat file contains the following variables where only `ha_hrir` varies between files.
````matlab
ha_hrir               % subject-specific measurements of hearing aid head-related impulse response
                      % [nSamples nMic=6 nDOA=73]

fs = 44100            % sample rate in Hz

% second dimension of ha_hrir corresponds to microphone channels where...
refChannelLeft = 1    % index of "reference" microphone for left ear (i.e. front left)
refChannelRight = 2   % index of "reference" microphone for right ear (i.e. front right)
channelsLeft = [1 3]  % indices of all microphones at left ear
channelsRight = [2 4] % indices of all microphones at right ear

% third dimension of ha_hrir corresponds to directions of arrival which are sorted in ascending order
% by elevation [-45 0 45 90] and within each elevation by azimuth in interval [0, 360)
doa_az_deg            % azimuth values in degrees
doa_el_deg            % elevation values in degrees
doa_unit_vec          % directions expressed as cartesian unit vectors [3, nDOA=73]
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
coordinates_system.pdf                           % X is front, Y is left, Z is up. Positive azimuth and elevation indicated.
ha_on_hats_calibrated.pdf                        % left ear view with microphone channels labeled and numbered  
speaker_layout_schematic_merged_direct_path.pdf  % directions of loudspeakers in degrees
````
