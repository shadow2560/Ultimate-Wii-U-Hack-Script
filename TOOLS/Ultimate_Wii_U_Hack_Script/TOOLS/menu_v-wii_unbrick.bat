::Script by Shadow256
@echo off
setlocal
chcp 65001 >nul
:define_action_choice
set action_choice=
cls
title V-wii Unbrick Script
echo :::::::::::::::::::::::::::::::::::::
echo ::V-wii Unbrick Script::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Sauvegarder les fichiers v-wii importants?
echo.
echo 2: Restaurer les fichiers v-wii importants?
echo.
echo  3: Restaurer les permissions du dossier "storage_slccmpt01"?
echo.
echo 4: Sauvegarder ou Supprimer un titre de la v-wii (attention, fonction risquée)?
echo.
echo 5: Restaurer un tittre sur la v-wii via une sauvegarde?
echo.
echo 0: Lancer la documentation (recommandé)?
echo.
echo N'importe quelle autre lettre: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="1" goto:save_v-wii
IF "%action_choice%"=="2" goto:restaure_v-wii
IF "%action_choice%"=="3" goto:restaure_permissions
IF "%action_choice%"=="4" goto:save_title
IF "%action_choice%"=="5" goto:restaure_title
IF "%action_choice%"=="0" goto:launch_doc
goto:end_script

:save_v-wii
set action_choice=
echo.
call TOOLS\v-wii_unbrick_script\save_v-wii_important_folders.bat
@echo off
goto:define_action_choice
:restaure_v-wii
set action_choice=
echo.
call TOOLS\v-wii_unbrick_script\restaure_v-wii_important_folders.bat
@echo off
goto:define_action_choice
:restaure_permissions
set action_choice=
echo.
call TOOLS\v-wii_unbrick_script\restaure_permissions.bat
@echo off
goto:define_action_choice
:save_title
set action_choice=
echo.
call TOOLS\v-wii_unbrick_script\del_v-wii_title.bat
@echo off
goto:define_action_choice
:restaure_title
set action_choice=
echo.
call TOOLS\v-wii_unbrick_script\restaure_v-wii_title.bat
@echo off
goto:define_action_choice
:launch_doc
set action_choice=
echo.
IF "%uwuhs_launch%"=="Y" (
	start ..\..\DOC\files\unbrick_v-wii.html
) else (
	start DOC\files\unbrick_v-wii.html
)
goto:define_action_choice
:end_script
endlocal