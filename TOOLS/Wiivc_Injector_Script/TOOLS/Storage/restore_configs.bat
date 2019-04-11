::Script by Shadow256
setlocal
echo on
chcp 65001 >nul
IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
)
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers wvcis (*.wvcis)|*.wvcis|" "Sélection du fichier de restauration" "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" (
	TOOLS\7zip\7za.exe x -y -sccUTF-8 "%filepath%" -o"." -r
	echo Restauration terminée. >con
) else (
	echo Restauration annulée. >con
)
rmdir /s /q templogs
pause >con
endlocal