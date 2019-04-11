::Script by Shadow256
setlocal
chcp 65001 >nul
IF EXIST ..\Files (
	rmdir /s /q ..\Files
	mkdir ..\Files
)
IF EXIST png2tga\*.png del /q png2tga\*.png
IF EXIST ..\log.txt del /q log.txt
IF EXIST blacklist_ids.txt del /q blacklist_ids.txt
IF EXIST ..\templogs rmdir /s /q ..\templogs
cd CONSOLES
cd GBA
move JNUSTool\JNUSTool.jar JNUSTool.jar
rmdir /s /q JNUSTool
mkdir JNUSTool\
move JNUSTool.jar JNUSTool\JNUSTool.jar
IF EXIST NUSPacker\encryptKeyWith del /q NUSPacker\encryptKeyWith
IF EXIST *.txt del /q *.txt
IF EXIST WORKINGDIR rmdir /s /q WORKINGDIR
IF EXIST temp rmdir /s /q temp
cd ..
cd N64
move JNUSTool\JNUSTool.jar JNUSTool.jar
rmdir /s /q JNUSTool
mkdir JNUSTool\
move JNUSTool.jar JNUSTool\JNUSTool.jar
IF EXIST NUSPacker\encryptKeyWith del /q NUSPacker\encryptKeyWith
IF EXIST *.txt del /q *.txt
IF EXIST WORKINGDIR rmdir /s /q WORKINGDIR
IF EXIST temp rmdir /s /q temp
cd ..
cd NDS
move JNUSTool\JNUSTool.jar JNUSTool.jar
rmdir /s /q JNUSTool
mkdir JNUSTool\
move JNUSTool.jar JNUSTool\JNUSTool.jar
IF EXIST NUSPacker\encryptKeyWith del /q NUSPacker\encryptKeyWith
IF EXIST *.txt del /q *.txt
IF EXIST WORKINGDIR rmdir /s /q WORKINGDIR
IF EXIST temp rmdir /s /q temp
cd ..
cd NES
move JNUSTool\JNUSTool.jar JNUSTool.jar
rmdir /s /q JNUSTool
mkdir JNUSTool\
move JNUSTool.jar JNUSTool\JNUSTool.jar
IF EXIST NUSPacker\encryptKeyWith del /q NUSPacker\encryptKeyWith
IF EXIST *.txt del /q *.txt
IF EXIST WORKINGDIR rmdir /s /q WORKINGDIR
IF EXIST temp rmdir /s /q temp
cd ..
cd SNES
move JNUSTool\JNUSTool.jar JNUSTool.jar
rmdir /s /q JNUSTool
mkdir JNUSTool\
move JNUSTool.jar JNUSTool\JNUSTool.jar
IF EXIST NUSPacker\encryptKeyWith del /q NUSPacker\encryptKeyWith
IF EXIST *.txt del /q *.txt
IF EXIST WORKINGDIR rmdir /s /q WORKINGDIR
IF EXIST temp rmdir /s /q temp

cd ..
cd ..
cd 7zip
IF EXIST *.srl del /q *.srl
IF EXIST *.zip del /q *.zip
cd ..
echo Remise à zéro du script effectuée.
pause
cd "%~dp0"
endlocal