
if not exist Temp mkdir Temp
cd Temp
if not exist patch mkdir patch
cd ..

if not exist %2 mkdir %2



set TosPath=%1
set RootPath=%cd%
set TempPath=%cd%\Temp
set ExtractPath=%cd%\extract
set ExportPath=%cd%\%2
set ToolsPath=%cd%\tools

::===== ipf file Copy
xcopy /y /s %TosPath%\patch\*.ipf %TempPath%\patch\*.ipf

::===== Save Pached list
cd %TosPath%\patch
dir /od /b > %RootPath%\ipflist_patch.txt


cd %RootPath%
for /f %%a in (ipflist_patch.txt) do (
	cd %RootPath%
	echo F|xcopy /y "%TosPath%\patch\%%a" "%TempPath%\patch\%%a"
	%ToolsPath%\ipf_unpack\ipf_unpack.exe %TempPath%\patch\%%a decrypt
	%ToolsPath%\ipf_unpack\ipf_unpack.exe %TempPath%\patch\%%a extract %3
)
	
xcopy /y /s "%ExtractPath%\*.%3" "%ExportPath%\*.%3"

cd %ExportPath%
git add --all
git commit -m "%2 Patch All .%3 files"
git push


::====== temp data clear
cd %RootPath%
del /s /q Temp
del /s /q extract
pause