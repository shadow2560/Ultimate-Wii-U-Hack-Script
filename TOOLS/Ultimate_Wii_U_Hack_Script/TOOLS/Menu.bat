::Script by Shadow256
@echo off
setlocal
chcp 65001 >nul
set script_path=%~dp0
%script_path:~0,1%:
cd "%script_path%\.."
mkdir test
IF %errorlevel% NEQ 0 (
	echo Le script se trouve dans un répertoire nécessitant les privilèges administrateur pour être écrit. Veuillez relancer le script avec les privilèges administrateur en faisant un clique droit dessus et en sélectionnant "Exécuter en tant qu'administrateur".
	goto:write_error
)
rmdir /s /q test
IF "%uwuhs_launch%"=="Y" (
set gen_log_path=..\..
) else (
set gen_log_path=.
)
IF EXIST %gen_log_path%\log.txt del /q %gen_log_path%\log.txt
:define_action_choice
set action_choice=
cls
title Ultimate Wii U Hack Script
echo :::::::::::::::::::::::::::::::::::::
echo ::Ultimate Wii U Hack Script::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Préparer une carte SD pour le hack Wii U?
echo.
echo 2: Lancer un serveur local pour exécuter l'exploit navigateur?
echo.
echo 3: Installer Java?
echo.
echo 4: Débricker la V-wii (Wii U européenne) (plus d'infos dans la documentation) (nécessite de lancer Wup_server sur la console)?
echo.
echo 5: Empêcher les mises à jour du firmware (nécessite de lancer Wup_server sur la console)?
echo.
echo 6: Autoriser les mises à jour du firmware (nécessite de lancer Wup_server sur la console)?
echo.
echo 7: Merger les fichiers créés par Wii U Nand Dumper en un seul fichier de dump complet pour la partition MLC?
echo.
echo 8: Extraire les fichiers du dump complet de la partition MLC?
echo.
echo 9: Ouvrir la page permettant de me faire une donation?
echo.
echo 0: Lancer la documentation (recommandé)?
echo.
IF "%uwuhs_launch%"=="Y" (
	echo N'importe quelle autre lettre: Revenir au menu précédent?
) else (
	echo N'importe quelle autre lettre: Quitter sans rien faire?
)
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="1" goto:prepare_sd_script
IF "%action_choice%"=="2" goto:launch_web_exploit_script
IF "%action_choice%"=="3" goto:install_required_script
IF "%action_choice%"=="4" goto:unbrick_v-wii
IF "%action_choice%"=="5" goto:stop_update
IF "%action_choice%"=="6" goto:restaure_update
IF "%action_choice%"=="7" goto:merge_mlc
IF "%action_choice%"=="8" goto:extract_mlc
IF "%action_choice%"=="0" goto:launch_doc
IF "%action_choice%"=="9" (
	set action_choice=
	cls
	start https://www.paypal.me/shadow256
	goto:define_action_choice
)
goto:end_script

:prepare_sd_script
set action_choice=
echo.
cls
call TOOLS\prepare_sd_wii_u.bat > %gen_log_path%\log.txt 2>&1
@echo off
goto:define_action_choice
:launch_web_exploit_script
set action_choice=
echo.
cls
call TOOLS\web_exploit.bat
@echo off
goto:define_action_choice
:install_required_script
set action_choice=
echo.
cls
call TOOLS\install_required.bat
@echo off
goto:define_action_choice
:unbrick_v-wii
set action_choice=
echo.
cls
call TOOLS\menu_v-wii_unbrick.bat
@echo off
goto:define_action_choice
:stop_update
set action_choice=
echo.
cls
call TOOLS\stop_update.bat
@echo off
goto:define_action_choice
:restaure_update
set action_choice=
echo.
cls
call TOOLS\restaure_update.bat
@echo off
goto:define_action_choice
:merge_mlc
set action_choice=
cls
call TOOLS\merge_mlc.bat
@echo off
echo.
goto:define_action_choice
:extract_mlc
set action_choice=
cls
call TOOLS\extract_mlc.bat
@echo off
echo.
goto:define_action_choice
:launch_doc
set action_choice=
echo.
cls
IF "%uwuhs_launch%"=="Y" (
	start ..\..\DOC\index.html
) else (
	start DOC\index.html
)
goto:define_action_choice
:write_error
pause
exit
:end_script
IF "%uwuhs_launch%"=="Y" (
	cd ..
	endlocal
) else (
	endlocal
	exit
)