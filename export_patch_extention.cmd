
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



echo F|xcopy /y "%TosPath%\patch\*.ipf" "%TempPath%\patch\*.ipf"

cd %TempPath%\patch
dir /s /b > %RootPath%\ipflist_patch.txt

pause

for /f %%a in (ipflist_patch.txt) do (
	cd %RootPath%
	echo F|xcopy /y "%TosPath%\patch\%%a" "%TempPath%\patch\%%a"
	%RootPath%\ipf_unpack.exe %TempPath%\patch\%%a decrypt
	%RootPath%\ipf_unpack.exe %TempPath%\patch\%%a extract %3
	
	xcopy /y /s "%ExtractPath%" "%ExportPath%"
	
	cd %RootPath%
	del /s /q Temp
	del /s /q extract
	
	cd %ExportPath%
	git add --all
	git commit -m "Patch %%a"
	git push
)


::====== temp data clear
cd %RootPath%
del /s /q Temp
del /s /q extract
pause