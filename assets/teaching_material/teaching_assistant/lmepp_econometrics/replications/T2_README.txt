REPLICATION TUTORIAL 2 - DORN AND ZWEIMUELLER (2021)
"Migration and Labor Market Integration in Europe", Journal of Economic
Perspectives 35(2): 49-76. https://doi.org/10.1257/jep.35.2.49

Files on this page
  replication_2.pdf  slides of the tutorial
  T2_exercises.do    demonstration (Part 1) and exercises (Part 2)

SETUP (10 minutes, internet needed once)
1. Create a folder called Replication_T2 in a location whose full path has
   NO SPACES (e.g. C:/teaching/Replication_T2 or ~/teaching/Replication_T2).
   The authors' do-files use unquoted paths: a space breaks them.
2. Paper: download it from the AEA (link above).
3. Replication archive: go to https://ddorn.net/data.htm, entry P11, and
   download Dorn-Zweimueller-MigrationEU-FileArchive.zip.
   Unzip it INSIDE Replication_T2. You get the folder FinalDataPackage/
   with Readme.pdf and the subfolders do/, dta/, pdf/.
   Do not rename it and do not modify any file in it.
4. Put T2_exercises.do in Replication_T2 and change ONE line, the path:
       global root "C:/path/to/Replication_T2"
5. Run Section 0 once: it installs the user-written packages the authors'
   code needs, if missing (labutil, spmap, palettes, colrspace).
6. Run the rest section by section.

The folder should look like this:
  Replication_T2/
      FinalDataPackage/        the authors' archive, as downloaded
          Readme.pdf  do/  dta/  pdf/
      T2_exercises.do
      output/                  created by the do-file

WHY WE DO NOT RUN master.do
master.do must be edited (its global main is empty as released) and calls
setup.do, which does not install the packages it lists. T2_exercises.do sets
the global main and runs the same do-files in the same order, except the four
that need EU-SILC microdata (not public). Nothing in the archive is edited.

NOTES
- Running the authors' code overwrites their figures in FinalDataPackage/pdf
  and writes intermediate files in FinalDataPackage/dta. T2_exercises.do
  copies the original figures to output/authors_pdf first.
- Fig4.do opens the Data Editor while it runs: close it.
- Tested with Stata 19 on the archive dated May 2021.
- Data source: please cite Dorn and Zweimueller (2021), as the authors' Readme asks.
