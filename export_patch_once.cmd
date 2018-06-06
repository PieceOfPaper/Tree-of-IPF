
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


set list=ies xml lua dds xac png jpg tga imctree effect skn xsd xsm xsmtime wmove bin fx fxdb ttf export lma xpm fdp fev h txt lst mp3


echo F|xcopy /y "%TosPath%\patch\%3" "%TempPath%\patch\%3"
.\ipf_unpack.exe %TempPath%\patch\%3 decrypt

for %%a in (%list%) do (
	cd %RootPath%
	.\ipf_unpack.exe %TempPath%\patch\%3 extract %%a
	
	xcopy /y /s "%ExtractPath%" "%ExportPath%"
	
	del /s /q extract
	
	cd %ExportPath%
	git add --all
	git commit -m "%3 %%a"
)


::====== temp data clear
cd %RootPath%
del /s /q Temp
del /s /q extract
pause