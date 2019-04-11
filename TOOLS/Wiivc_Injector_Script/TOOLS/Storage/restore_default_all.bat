::Script by Shadow256
setlocal
chcp 65001 >nul
IF EXIST SOURCE_FILES (
	rmdir /s /q SOURCE_FILES
	mkdir SOURCE_FILES
)
IF EXIST TOOLS\Storage\BASETITLEKEY del /q TOOLS\Storage\BASETITLEKEY
IF EXIST TOOLS\Storage\blacklist_ids.txt del /q TOOLS\Storage\blacklist_ids.txt
IF EXIST TOOLS\Storage\WiiInjectScript.ini del /q TOOLS\Storage\WiiInjectScript.ini
IF EXIST templogs rmdir /s /q templogs
IF EXIST TOOLS\c2w\starbuck_key.txt del /q TOOLS\c2w\starbuck_key.txt
IF EXIST TOOLS\JNUSTool\0005001010004000 rmdir /s /q TOOLS\JNUSTool\0005001010004000
IF EXIST TOOLS\JNUSTool\0005001010004001 rmdir /s /q TOOLS\JNUSTool\0005001010004001
IF EXIST "TOOLS\JNUSTool\Rhythm Heaven Fever [VAKE01]" rmdir /s /q "TOOLS\JNUSTool\Rhythm Heaven Fever [VAKE01]"
IF EXIST TOOLS\JNUSTool\config del /q TOOLS\JNUSTool\config
IF EXIST TOOLS\NUSPacker\encryptKeyWith del /q TOOLS\NUSPacker\encryptKeyWith
IF EXIST WORKINGDIR rmdir /s /q WORKINGDIR
IF EXIST temp rmdir /s /q temp
IF EXIST ISOBUILDTEMP rmdir /s /q ISOBUILDTEMP
IF EXIST getexttypepatcher.txt del /q getexttypepatcher.txt
IF EXIST log.txt del /q log.txt
echo Remise à zéro du script effectuée.
pause
endlocal