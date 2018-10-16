# Calibrated database

This database contains the following directories

````
mat: matlab .mat files containing the data  
doc: documentation
graphics: plots visualising the effect of calibratation on horizontal plane measurements
````

Data in this directory is derived from the `00_raw' database. Source code is publically available on [GitHub](https://github.com/ImperialCollegeLondon/sap-oticon-hearing-aid-impulse-responses). The calibration applies scalar gain correction and time delay compensation.

Gain: Matches the A-weighted sensitivity of each microphone (6 gain terms) and each loudspeaker (29 gain terms).
Delay: Compensates for time of flight differences from each loudspeaker to the centre of the sphere (29 delay terms). Also compensates for offset of each subject from the centre of the sphere (2 delay terms expands to 29x3 terms).


Each .mat file contains the following variables where only `ha_hrir` varies between files.

````matlab
% subject-specific measurements of hearing aid room impulse response  [nSamples nMic=6 nDOA=29]
ha_hrir               % chair in initial position with subject facing forwards
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

The documentation gives diagrams of the [hearing aid setup for the left ear](doc/ha_on_hats_calibrated.pdf) and the [coordinates system](doc/coordinates_system.pdf).