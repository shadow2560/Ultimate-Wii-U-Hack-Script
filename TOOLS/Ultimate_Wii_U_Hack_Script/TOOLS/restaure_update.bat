::Script by Shadow256
setlocal
chcp 65001 >nul
echo Ce script va autoriser la mise à jour firmware de la console en créant le dossier "/vol/storage_mlc01/sys/update".
echo.
pause
set /p custom_ip=Entrez l'adresse IP de votre Wii U: 
chcp 850 >nul
TOOLS\Wupclient\restaure_maj_wiiu.exe %custom_ip%
chcp 65001 >nul
echo.
echo Mise à jour autorisée.
pause
endlocal