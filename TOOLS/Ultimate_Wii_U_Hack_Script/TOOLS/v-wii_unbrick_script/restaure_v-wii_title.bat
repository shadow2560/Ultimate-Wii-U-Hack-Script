::Script by Shadow256
chcp 65001 >nul
IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
)
IF NOT EXIST save_v-wii\*.* (
	del /q save_v-wii 2>nul
	mkdir save_v-wii
)
Setlocal
echo Ce script va restaurer un titre de la v-wii.
echo Notez que la restauration peut prendre du temps.
echo.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers vwust (*.vwust)|*.vwust|" "Sélection du fichier de restauration" "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
set title_name=%filepath:~-14,8%
IF NOT "%filepath%"=="" (
	TOOLS\7zip\7za.exe x -y -sccUTF-8 "%filepath%" -o"save_v-wii\titles" -r
) else (
	echo Restauration annulée.
	pause
	goto:endscript
)
IF NOT EXIST save_v-wii\titles\vol\storage_slccmpt01\title\00000001\%title_name% (
	echo Le fichier de restauration ne semble pas correct, restauration annulée.
	goto:endscript
)
set /p custom_ip=Entrez l'adresse IP de votre Wii U: 
chcp 850 >nul
TOOLS\Wupclient\restaure_v-wii_title.exe %custom_ip% "%title_name%"
chcp 65001 >nul
echo.
echo Titre restaurés.
:endscript
pause
rmdir /s /q save_v-wii
rmdir /s /q templogs
endlocal