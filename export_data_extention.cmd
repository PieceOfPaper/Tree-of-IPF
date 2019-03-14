
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

::===== ipf file Copy
echo F|xcopy /y /s %TosPath%\data\%3.ipf %TempPath%\data\%3.ipf


cd %RootPath%
%ToolsPath%\ipf_unpack\ipf_unpack.exe %TempPath%\data\%3.ipf decrypt
%ToolsPath%\ipf_unpack\ipf_unpack.exe %TempPath%\data\%3.ipf extract %4
	
echo F|xcopy /y /s "%ExtractPath%\*.%4" "%ExportPath%\*.%4"

cd %ExportPath%
git add --all
git commit -m "%2 %3 %4 files"
git push


::====== temp data clear
cd %RootPath%
del /s /q Temp
del /s /q extract
pause