::Script by Shadow256
setlocal
@echo off
chcp 65001 >nul
title Injectiine
:Menu
::Check for Java 8
set jver=0
for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k%%l%%m"
if %jver% LSS 180000 goto:javafail
:define_action_choice
cd /d "%script_path%"
cls
title Injectiine
echo ::::::::::::::::::::::::: >con
echo ::Bienvenue dans Injectiine:: >con
echo ::::::::::::::::::::::::: >con
echo.>con
echo Sélectionnez une console: >con
echo 1: NES? >con
echo 2: SNES? >con
echo 3: N64? >con
echo 4: GBA? >con
echo 5: NDS? >con
echo N'importe quel autre choix: Revenir au menu précédent? >con
echo.>con
set /p CHOICE=[Votre choix:] >con
if "%CHOICE%"=="1" GOTO:NES
if "%CHOICE%"=="2" GOTO:SNES
if "%CHOICE%"=="3" GOTO:N64
if "%CHOICE%"=="4" GOTO:GBA
if "%CHOICE%"=="5" GOTO:NDS
GOTO:end_script

:NES
call path_define.bat
cd CONSOLES
cd NES
call NES.bat
echo.>con
set CHOICE=
goto:define_action_choice

:SNES
call path_define.bat
cd CONSOLES
cd SNES
call SNES.bat
echo.>con
set CHOICE=
goto:define_action_choice

:N64
call path_define.bat
cd CONSOLES
cd N64
call N64.bat
echo.>con
set CHOICE=
goto:define_action_choice

:GBA
call path_define.bat
cd CONSOLES
cd GBA
call GBA.bat
echo.>con
set CHOICE=
goto:define_action_choice

:NDS
call path_define.bat
cd CONSOLES
cd NDS
call NDS.bat
echo.>con
set CHOICE=
goto:define_action_choice

:javafail
echo JAVA 8 n'est pas détecté, installez la dernière version de Java: HTTPS://JAVA.COM>con
echo Si vous avez déjà installé JAVA 8, redémarrez votre ordinateur.>con
echo.>con
Pause>con
goto:endscript
:end_script
endlocal