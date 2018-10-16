# Study database

This database contains the following directories

````
mat: matlab .mat files containing the data  
doc: documentation  
````

The .mat files were generated according to the procedure outlined in [paper ref]. Source code is publically available on [GitHub](https://github.com/ImperialCollegeLondon/sap-oticon-hearing-aid-impulse-responses). For each subject in the database there is a "full" HRIR and a "direct" HRIR where the difference is the time after which the response is cropped. Each .mat file contains the following variables where only `hrir` varies between files.

````matlab
hrir                  % the subject-specific measurement [nSamples nMic=4 nDOA=16]
fs = 44100            % sample rate in Hz

% second dimension of hrir corresponds to microphone channels where...
refChannelLeft = 1    % index of "reference" microphone for left ear (i.e. front left)
refChannelRight = 2   % index of "reference" microphone for right ear (i.e. front right)
channelsLeft = [1 3]  % indices of all microphones at left ear
channelsRight = [2 4] % indices of all microphones at right ear

% third dimension of hrir corresponds to directions of arrival which are...
doa_az_deg            % azimuth values in degrees: (0:15) .* (360/16)
doa_el_deg            % elevation values in degrees: zeros(1,16)
doa_unit_vec          % directions expressed as cartesian unit vectors [3, nDOA=16]
````

The documentation gives diagrams of the [hearing aid setup for the left ear](doc/ha_on_hats_study.pdf) and the [coordinates system](doc/coordinates_system.pdf).