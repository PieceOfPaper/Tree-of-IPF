
if not exist data_copy mkdir data_copy

xcopy "%1\data\*.ipf" ".\data_copy" /y

cd data_copy
dir /b > ..\filelist.txt
cd ..

pause

for /F %%a in (filelist.txt) do (
	.\ipf_unpack.exe .\data_copy\%%a decrypt
	.\ipf_unpack.exe .\data_copy\%%a extract
)

pause

del "D:\IPF_Export\data_copy\*.ipf"