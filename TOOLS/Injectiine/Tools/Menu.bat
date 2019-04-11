::Script by Shadow256
setlocal
@echo off
chcp 65001 >nul
set script_path=%~dp0
%script_path:~0,1%:
cd "%script_path%"
mkdir ..\test
IF %errorlevel% NEQ 0 (
	echo Le script se trouve dans un répertoire nécessitant les privilèges administrateur pour être écrit. Veuillez relancer le script avec les privilèges administrateur en faisant un clique droit dessus et en sélectionnant "Exécuter en tant qu'administrateur".
	goto:write_error
)
rmdir /s /q ..\test
IF "%uwuhs_launch%"=="Y" (
set gen_log_path=..\..\..
) else (
set gen_log_path=..
)
IF EXIST %gen_log_path%\log.txt del /q %gen_log_path%\log.txt
:define_action_choice
set action_choice=
cls
title Injectiine
echo :::::::::::::::::::::::::::::::::::::
echo ::Injectiine::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Injecter un jeu NES, SNES, N64, GBA ou NDS?
echo.
echo 2: Sauvegarder les fichiers de configurations du script?
echo.
echo 3: Restaurer les fichiers de configurations du script?
echo.
echo 4: Créer une blacklist basée sur les jeux installés sur votre Wii U (nécessite
echo une Wii U connectée sur le réseau local avec Mocha de lancé avec les paramètres par défaut)?
echo.
echo 5: Restaurer toutes les valeurs par défaut (dossier Files, blacklist, clés, fichiers téléchargé par Jnustool et configurations)?
echo.
IF "%uwuhs_launch%"=="Y" (
	echo N'importe quelle autre lettre: Revenir au menu précédent?
) else (
	echo N'importe quelle autre lettre: Quitter sans rien faire?
)
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="1" goto:inject_script
IF "%action_choice%"=="2" goto:save_script
IF "%action_choice%"=="3" goto:restore_script
IF "%action_choice%"=="4" goto:blacklist_script
IF "%action_choice%"=="5" goto:restore_default_all
goto:end_script
:inject_script
echo.
call Console_select.bat > %gen_log_path%\log.txt 2>&1
@echo off
set action_choice=
goto:define_action_choice
:save_script
echo.
call save_configs.bat > %gen_log_path%\log.txt 2>&1
@echo off
set action_choice=
goto:define_action_choice
:restore_script
echo.
call restore_configs.bat > %gen_log_path%\log.txt 2>&1
@echo off
set action_choice=
goto:define_action_choice
:blacklist_script
echo.
call blacklist_wiiu_instaled_titles.bat > %gen_log_path%\log.txt 2>&1
@echo off
set action_choice=
goto:define_action_choice
:restore_default_all
echo.
call restore_default_all.bat
@echo off
set action_choice=
goto:define_action_choice
:write_error
pause
exit
:end_script
IF "%uwuhs_launch%"=="Y" (
	cd ..\..
	endlocal
) else (
	endlocal
	exit
)