::Script by Shadow256
setlocal
chcp 65001 >nul
echo Ce script va empêcher la mise à jour firmware de la console en supprimant le dossier "/vol/storage_mlc01/sys/update".
echo.
pause
IF NOT EXIST TOOLS\Wupclient\update copy nul TOOLS\Wupclient\update
cd TOOLS\Wupclient\
set /p custom_ip=Entrez l'adresse IP de votre Wii U: 
chcp 850 >nul
stop_maj_wiiu.exe %custom_ip%
chcp 65001 >nul
cd ..\..
echo.
echo Mise à jour bloquée.
pause
endlocal