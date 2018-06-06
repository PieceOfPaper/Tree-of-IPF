
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




for /f %%a in (ipflist_patch.txt) do (
	cd %RootPath%
	echo F|xcopy /y "%TosPath%\patch\%%a" "%TempPath%\patch\%%a"
	%RootPath%\ipf_unpack.exe %TempPath%\patch\%%a decrypt
	%RootPath%\ipf_unpack.exe %TempPath%\patch\%%a extract ies xml lua dds xac png jpg tga imctree effect skn xsd xsm xsmtime wmove bin fx fxdb ttf export lma xpm fdp fev h txt lst mp3
	
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