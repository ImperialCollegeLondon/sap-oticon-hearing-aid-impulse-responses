# Study database

This database contains the hearing aid head-related impulse responses used for the analaysis and listening tests reported in "Personalized signal-independent beamforming for binaural hearing aids". It contains the following directories:
````
mat: matlab .mat files containing the data  
doc: documentation  
````

## mat
The .mat files were generated according to the procedure outlined in "Personalized signal-independent beamforming for binaural hearing aids". Source code is publically available on [GitHub](https://github.com/ImperialCollegeLondon/sap-oticon-hearing-aid-impulse-responses). For each subject in the database there is a "full" HRIR and a "direct" HRIR where the difference is the time after which the response is cropped. The former is used to simulate reverberant sources while the latter is used to design beamformers with 'anechoic' steering vectors. Each .mat file contains the following variables where only `hrir` varies between files. N.B. hrir is used here in the generic sense irrespective of whether it contains room reflections or not.

Each .mat file contains the following variables
````matlab
hrir                  % the subject-specific measurement [nSamples nMic=4 nDOA=16]
fs = 44100            % sample rate in Hz

% second dimension of hrir corresponds to microphone channels where...
refChanLeft = 1       % index of "reference" microphone for left ear (i.e. front left)
refChanRight = 2      % index of "reference" microphone for right ear (i.e. front right)
channelsLeft = [1 3]  % indices of all microphones at left ear
channelsRight = [2 4] % indices of all microphones at right ear

% third dimension of hrir corresponds to directions of arrival which are...
doa_az_deg            % azimuth values in degrees: (0:15) .* (360/16)
doa_el_deg            % elevation values in degrees: zeros(1,16)
doa_unit_vec          % directions expressed as cartesian unit vectors [3, nDOA=16]
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
in_ear_valid:         % boolean indicating that the impulse responses measured for the InEarLeft and InEarRight microphones is valid. For this database the InEar signals are not used so it is redundant.
````

## doc
````matlab
coordinates_system.pdf              % X is front, Y is left, Z is up. Positive azimuth and elevation indicated.
ha_on_hats_study.pdf                % left ear view with microphone channels labeled and numbered  
speaker_layout_schematic_study.pdf  % directions of loudspeakers in degrees
````
