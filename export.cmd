
if not exist Temp mkdir Temp
cd Temp
if not exist data mkdir data
cd ..

if not exist %2 mkdir %2




set TosPath=%1
set RootPath=%cd%
set TempPath=%cd%\Temp
set ExtractPath=%cd%\extract
set ExportPath=%cd%\%2
set ToolsPath=%cd%\tools




for /f %%a in (ipflist_data.txt) do (
	cd %RootPath%
	echo F|xcopy /y %TosPath%\data\%%a %TempPath%\data\%%a
	%ToolsPath%\ipf_unpack\ipf_unpack.exe %TempPath%\data\%%a decrypt
	%ToolsPath%\ipf_unpack\ipf_unpack.exe %TempPath%\data\%%a extract ies xml lua dds xac png jpg tga imctree effect skn xsd xsm xsmtime wmove bin fx fxdb ttf export lma xpm fdp fev h txt lst mp3 pathengine atlas skel json 3dworld
	
	xcopy /y /s %ExtractPath% %ExportPath%
	
	cd %RootPath%
	del /s /q Temp
	del /s /q extract
	
	cd %ExportPath%
	git add --all
	git commit -m "%2 Data %%a"
	git push
)


::====== temp data clear
cd %RootPath%
del /s /q Temp
del /s /q extract
pause