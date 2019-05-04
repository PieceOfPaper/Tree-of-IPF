
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
xcopy /y /s %TosPath%\patch\*.ipf %TempPath%\patch\*.ipf /EXCLUDE:%ExportPath%\ipflist_patched.txt
cd %TempPath%\patch
dir /od /b > %ExportPath%\ipflist_patch.txt


::===== Save Pached list
cd %TosPath%\patch
dir /od /b > %ExportPath%\ipflist_patched.txt


cd %ExportPath%
for /f %%a in (ipflist_patch.txt) do (
	cd %RootPath%
	
	::===== Decrypt & Extract
	%ToolsPath%\ipf_unpack\ipf_unpack.exe %TempPath%\patch\%%a decrypt
	%ToolsPath%\ipf_unpack\ipf_unpack.exe %TempPath%\patch\%%a extract ies xml lua dds xac png jpg tga imctree effect skn xsd xsm xsmtime wmove bin fx fxdb ttf export lma xpm fdp fev h txt lst mp3 pathengine atlas skel json 3deffect 3dprop 3drender 3dworld 3dzone pathengine tok colmesh
	
	::===== Copy to Export Path
	xcopy /y /s %ExtractPath% %ExportPath%
	
	::===== Delete Temp file
	cd %RootPath%
	::del /s /q Temp
	del /s /q extract
	
	::===== Create File List
	cd %ExportPath%
	dir /a /s /b > filelist.txt
	
	::===== Commit & Push
	cd %ExportPath%
	git add --all
	git commit -m "%2 Patch %%a"
	git push
)

::===== music file Copy & Commit & Push
cd %ExportPath%
if not exist bgm mkdir bgm
xcopy /y /s %TosPath%\release\bgm\*.* %ExportPath%\bgm\*.*
dir /a /s /b > filelist.txt
git add --all
git commit -m "%2 bgm update"
git push


::====== temp data clear
cd %RootPath%
del /s /q Temp
del /s /q extract
pause