REPLICATION TUTORIAL 1 - AUTOR AND DORN (2009)
"This Job is 'Getting Old': Measuring Changes in Job Opportunities Using
Occupational Age Structure", American Economic Review: Papers and Proceedings
99(2): 45-51. https://doi.org/10.1257/aer.99.2.45

Files on this page
  Replication Tutorial 1 - Autor and Dorn (2009).pdf    slides of the tutorial
  T1_exercises.do    demonstration (Part 1) and exercises (Part 2)

SETUP (5 minutes)
1. Create a folder called Replication_T1 (not inside OneDrive/iCloud).
2. Paper: download it from the AEA (link above) or the authors' version from
   https://www.ddorn.net/papers/Autor-Dorn-ThisJobIsGettingOld.pdf
3. Replication archive: go to https://ddorn.net/data.htm, entry P1, and
   download Autor-Dorn-ThisJobIsGettingOld-FileArchive.zip.
   Unzip it INSIDE Replication_T1. You get the folder Public-Release-Data/
   with Readme.pdf and the subfolders do/, dta/, log/, tab-fig/.
   Do not rename it and do not modify any file in it.
4. Put T1_exercises.do in Replication_T1 and change ONE line, the path:
       global root "C:/path/to/Replication_T1"
5. Run the do-file section by section (select, then Ctrl+D / Cmd+Shift+D).

The folder should look like this:
  Replication_T1/
      Public-Release-Data/     the authors' archive, as downloaded
          Readme.pdf  do/  dta/  log/  tab-fig/
      T1_exercises.do
      output/                  created by the do-file

WHY NOTHING ELSE CHANGES
The authors' do-files use paths relative to their do/ folder (use ../dta/...,
log using ../log/...). T1_exercises.do moves into Public-Release-Data/do,
runs them as they are, and comes back. All our own code (and every fix)
lives in T1_exercises.do: the authors' files are never edited.

NOTES
- Tested with Stata 19 on the archive dated 12 November 2014.
- "set memory 300m" in the authors' files is ignored by Stata 12 and later:
  Stata prints a note, not an error.
- On macOS, unzipping may also create a __MACOSX folder: ignore it.
- Data source: please cite Autor and Dorn (2009), as the authors' Readme asks.
