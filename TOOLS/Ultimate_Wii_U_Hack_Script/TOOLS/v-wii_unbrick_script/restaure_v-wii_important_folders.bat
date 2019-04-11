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
echo Ce script va restaurer les fichiers importants de la v-wii.
echo Notez que la restauration peut prendre du temps (environ 20 minutes).
echo Si la V-wii est déjà brickée, vous devrez récupérer ces fichiers sur une Wii U européenne sur laquelle la V-wii fonctionne correctement pour pouvoir les restaurer.
echo.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers vwus (*.vwus)|*.vwus|" "Sélection du fichier de restauration" "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" (
	TOOLS\7zip\7za.exe x -y -sccUTF-8 "%filepath%" -o"save_v-wii" -r
) else (
	echo Restauration annulée.
	pause
	goto:endscript
)
IF NOT EXIST save_v-wii\vol\storage_slccmpt01\title\00000001\00000002\content\00000022.app (
	echo Le fichier de restauration ne semble pas correct, restauration annulée.
	goto:endscript
)
IF NOT EXIST save_v-wii\vol\storage_slccmpt01\title\00000001\00000002\content\00000023.app (
	echo Le fichier de restauration ne semble pas correct, restauration annulée.
	goto:endscript
)
IF NOT EXIST save_v-wii\vol\storage_slccmpt01\title\00000001\00000050\content\*.* (
	echo Le fichier de restauration ne semble pas correct, restauration annulée.
	goto:endscript
)
IF NOT EXIST save_v-wii\vol\storage_slccmpt01\title\00000001\00000050\data\*.* (
	echo Le fichier de restauration ne semble pas correct, restauration annulée.
	goto:endscript
)
set /p custom_ip=Entrez l'adresse IP de votre Wii U: 
chcp 850 >nul
TOOLS\Wupclient\restaure_v-wii_important_folders.exe %custom_ip%
chcp 65001 >nul
echo.
echo Fichiers restaurés.
:endscript
pause
rmdir /s /q save_v-wii
rmdir /s /q templogs
endlocal