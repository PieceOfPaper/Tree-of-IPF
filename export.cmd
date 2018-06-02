
if not exist data_copy mkdir data_copy
if not exist Temp mkdir Temp

set RootPath=%cd%

::====== data copy
xcopy /y "%1\*.ipf" ".\data_copy"
::pause

cd data_copy
dir /b > ..\Temp\filelist.txt
cd ..
::pause


::====== data extract
for /f %%a in (.\Temp\filelist.txt) do (
	.\ipf_unpack.exe .\data_copy\%%a decrypt
	.\ipf_unpack.exe .\data_copy\%%a extract
)
::pause


::====== ies -> csv
dir %cd%\extract /s /b \*.ies > .\Temp\ies_files.txt
for /f %%a in (.\Temp\ies_files.txt) do (
	if %%~xa==.ies (
		cd D:%%~pa
		::if exist D:%%~pa%%~na.csv del D:%%~pa%%~na.csv
		echo F|xcopy /y %%~na.ies %%~na.csv
		::ren D:%%~pa%%~na.ies D:%%~pa%%~na.csv
		del %%~na.ies
	)
)
cd %RootPath%
pause

::====== temp data clear
cd data_copy
echo Y|del *.*
cd ..

cd Temp
echo Y|del *.*
cd ..

rmdir data_copy
rmdir Temp
pause