# OTIMP: The Oticon-Imperial hearing aid impulse response database
This repository contains code for post-processing a database of impulse response measurements made in collaboration between the Speech and Audio Processing Lab at Imperial College London and Oticon A/S in Copenhagen. The raw measurements and resulting database are published as DOI [10.5281/zenodo.2660782](https://doi.org/10.5281/zenodo.2660782). This code is published with DOI [10.5281/zenodo.2662516](https://doi.org/10.5281/zenodo.2662516).

The code provided here is used to generate processed versions which are suitable for various applications. A single matlab script, `run.m`, contains paths which should be edited according to your local installation and can be configured to determine which post-processed versions of the database should be created.

If you use the database in its published form or modify this code to obtain an alternative version, we kindly ask that you cite

>A.H. Moore, J.M. de Haan, M.S. Pedersen, P.A. Naylor, D.M. Brookes and J. Jensen (2019) _Personalized signal-independent beamforming for binaural hearing aids_, J. Acoustical Society of America doi:10.1121/1.5102173

Alastair H Moore, October 2018

This work was supported by the Engineering and Physical Sciences Research Council [grant number EP/M026698/1].

````
Version history

0.1.0       2018-10-31       Provisional pre-release to support manuscript review
0.2.0       2019-05-03       First public release
                             - Added DOIs and provisional citation
                             - Improved documentation
1.0.0       2019-05-07       Version used for v1.0.0 database release on Zenodo
                             - Updated README title to match database name
                             - Added DOI for code
````