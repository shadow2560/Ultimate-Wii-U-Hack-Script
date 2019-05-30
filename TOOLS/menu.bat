@echo off
chcp 65001 >nul
set uwuhs_launch=Y
:define_action_choice
cls
title Shadow256 Ultimate Wii U Hack Script
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Wii U Hack Script::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Lancer Wiivc Injector Script
echo 2: Lancer Injectiine
echo 3: Autres fonctions
echo 0: Lancer la documentation (recommandé)?
echo.
echo N'importe quelle autre lettre: Quitter sans rien faire?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="0" goto:launch_doc
IF "%action_choice%"=="1" goto:wiivc_injector
IF "%action_choice%"=="2" goto:injectiine
IF "%action_choice%"=="3" goto:others
goto:end_script
:wiivc_injector
echo.
cls
call Wiivc_Injector_Script\TOOLS\Storage\Menu.bat
set action_choice=
goto:define_action_choice
:injectiine
echo.
cls
call Injectiine\TOOLS\Menu.bat
set action_choice=
goto:define_action_choice
:others
echo.
cls
call Ultimate_Wii_U_Hack_Script\TOOLS\Menu.bat
set action_choice=
goto:define_action_choice
:launch_doc
set action_choice=
echo.
cls
start ..\DOC\index.html
goto:define_action_choice
:end_script
exit