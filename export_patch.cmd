
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



::===== ipf file Copy
xcopy /y /s "%TosPath%\patch\*.ipf" "%TempPath%\patch\*.ipf" /EXCLUDE:%RootPath%\ipflist_patched.txt
cd %TempPath%\patch
dir /od /b > %RootPath%\ipflist_patch.txt


::===== Save Pached list
cd %TosPath%\patch
dir /od /b > %RootPath%\ipflist_patched.txt


cd %RootPath%
for /f %%a in (ipflist_patch.txt) do (
	cd %RootPath%
	
	::===== Decrypt & Extract
	%RootPath%\ipf_unpack.exe %TempPath%\patch\%%a decrypt
	%RootPath%\ipf_unpack.exe %TempPath%\patch\%%a extract ies xml lua dds xac png jpg tga imctree effect skn xsd xsm xsmtime wmove bin fx fxdb ttf export lma xpm fdp fev h txt lst mp3 pathengine
	
	::===== Copy to Export Path
	xcopy /y /s "%ExtractPath%" "%ExportPath%"
	
	::===== Delete Temp file
	cd %RootPath%
	::del /s /q Temp
	del /s /q extract
	
	::===== Commit & Push
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