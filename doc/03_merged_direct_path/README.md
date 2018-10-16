# Merged direct-path database

This database contains the following directories

````
mat: matlab .mat files containing the data  
doc: documentation
graphics: plots visualising the impulse responses
````

Data in this directory is derived from the `02_calibrated' database. Source code is publically available on [GitHub](https://github.com/ImperialCollegeLondon/sap-oticon-hearing-aid-impulse-responses). No further calibration is applied. Measurements are cropped to include only the first 10.7 milliseconds and measurements for different chair rotations are interleaved to give higher resolution sampling around 3 elevations. At elevation ±45 degrees, the azimuth resolution is 30 degrees.  At elevation 0 degrees, the azimuth resolution is 7.5 degrees.

N.B. For elevations other that 0 degrees the first 10.7 milliseconds includes a significant reflection from either the floor or ceiling. Since this reflection has the same azimuth angle as the true direct path wavefront the interleaved responses are consistent within each elevation. However, care should be taken in how this data is analsed since there is an elevation dependence which is caused by the environment, rather than the individual.


Each .mat file contains the following variables where only `ha_hrir` varies between files.

````matlab
ha_hrir               % subject-specific measurements of hearing aid head related impulse response
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

The documentation gives diagrams of the [hearing aid setup for the left ear](doc/ha_on_hats_calibrated.pdf) and the [coordinates system](doc/coordinates_system.pdf).