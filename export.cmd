
xcopy "D:\TreeOfSavior Test\data\*.ipf" "D:\IPF_Export\data_copy" /y
::xcopy /y "D:\IPF_Export\test_ipf\*.ipf" "D:\IPF_Export\data_copy"

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