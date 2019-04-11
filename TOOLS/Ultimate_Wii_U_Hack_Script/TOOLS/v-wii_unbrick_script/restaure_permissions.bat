::Script by Shadow256
chcp 65001 >nul
echo Ce script va restaurer les permissions des dossiers de la v-wii.
echo.
pause
set /p custom_ip=Entrez l'adresse IP de votre Wii U: 
chcp 850 >nul
TOOLS\Wupclient\restaure_permissions.exe %custom_ip%
chcp 65001 >nul
echo.
echo Permissions restaurés.
pause