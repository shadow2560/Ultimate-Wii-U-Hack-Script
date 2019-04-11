chcp 65001 > nul
::Script by Shadow256
echo Ce script installera Java 8 sur votre ordinateur.
echo.
echo Vous devez garder les options par défaut des assistants d'installation, cliquez simplement sur "next" ou sur "suivant".
echo.
pause
::msiexec /i TOOLS\required_install\python-2.7.14.msi ADDLOCAL=ALL
::msiexec /i TOOLS\required_install\capstone-3.0.5-rc2-python-win32.msi
::TOOLS\required_install\vc_redist.x86.exe
set jver=0
for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k%%l%%m"
if %jver% LSS 180000 TOOLS\required_install\jre-8u151-windows-i586.exe
echo Installation terminé, veuillez relancer le script pour que les modifications soient prises en compte.
echo.
pause
exit