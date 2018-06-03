
if not exist Temp mkdir Temp
cd Temp
if not exist data_copy mkdir data_copy
if not exist patch_copy mkdir patch_copy
cd ..

set RootPath=%cd%



::====== data copy
if exist patch_exclude.txt echo none >%RootPath%\Temp\filelist.txt
if not exist patch_exclude.txt (
	xcopy /y "%1\data\*.ipf" ".\Temp\data_copy"

	cd %RootPath%\Temp\data_copy
	dir /b > %RootPath%\Temp\filelist.txt
	cd %RootPath%
)
pause



::====== patch copy
if exist patch_exclude.txt xcopy /y "%1\patch\*.ipf" "%RootPath%\Temp\patch_copy" /exclude:patch_exclude.txt
if not exist patch_exclude.txt xcopy /y "%1\patch\*.ipf" "%RootPath%\Temp\patch_copy"
pause

cd %1\patch\
dir /b /od > %RootPath%\Temp\patchlist_all.txt
cd %RootPath%
pause

cd %RootPath%\Temp\patch_copy
dir /b /od > %RootPath%\Temp\patchlist.txt
cd %RootPath%
pause



::====== data extract
for /f %%a in (%RootPath%\Temp\filelist.txt) do .\ipf_unpack.exe %RootPath%\Temp\data_copy\%%a decrypt
for /f %%a in (%RootPath%\Temp\filelist.txt) do .\ipf_unpack.exe %RootPath%\Temp\data_copy\%%a extract xml lua dds xac png jpg tga imctree effect skn xsd xsm xsmtime wmove bin fx fxdb ttf export lma xpm fdp fev h txt lst mp3

::====== patch extract
for /f %%a in (%RootPath%\Temp\patchlist.txt) do .\ipf_unpack.exe %RootPath%\Temp\patch_copy\%%a decrypt
for /f %%a in (%RootPath%\Temp\patchlist.txt) do .\ipf_unpack.exe %RootPath%\Temp\patch_copy\%%a extract xml lua dds xac png jpg tga imctree effect skn xsd xsm xsmtime wmove bin fx fxdb ttf export lma xpm fdp fev h txt lst mp3



::====== ies -> csv
dir %cd%\extract /s /b \*.ies > %RootPath%\Temp\ies_files.txt
for /f %%a in (%RootPath%\Temp\ies_files.txt) do (
	if %%~xa==.ies (
		cd %%~da%%~pa
		echo F|xcopy /y %%~na.ies %%~na.csv
		del %%~na.ies
	)
)
cd %RootPath%
pause



::====== temp data clear
echo F|xcopy /y %RootPath%\Temp\patchlist_all.txt %RootPath%\patch_exclude.txt

cd Temp

cd data_copy
echo Y|del *.*
cd ..
rmdir data_copy

cd patch_copy
echo Y|del *.*
cd ..
rmdir patch_copy

echo Y|del *.*
cd ..
rmdir Temp
pause