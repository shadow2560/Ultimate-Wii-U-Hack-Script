::Script by Shadow256
echo on
setlocal
chcp 65001 >nul
IF NOT EXIST ..\templogs\*.* (
	del /q ..\templogs 2>nul
	mkdir ..\templogs
)
%windir%\system32\wscript.exe //Nologo functions\open_file.vbs "" "Fichiers ijctn (*.ijctn)|*.ijctn|" "Sélection du fichier de restauration" "..\templogs\tempvar.txt"
set /p filepath=<..\templogs\tempvar.txt
IF NOT "%filepath%"=="" (
	7zip\7za.exe x -y -sccUTF-8 "%filepath%" -o"." -r
	echo Restauration terminée. >con
) else (
	echo Restauration annulée. >con
)
rmdir /s /q ..\templogs
pause >con
cd "%~dp0"
endlocal