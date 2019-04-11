::Script by Shadow256
@echo off
::MODE con:cols=140 lines=70
chcp 1252 >nul
cls
title Injectiine
set script_path=%~dp0
%script_path:~0,1%:
cd "%script_path%\Tools"
mkdir ..\test
IF %errorlevel% NEQ 0 (
	echo Le script se trouve dans un répertoire nécessitant les privilèges administrateur pour être écrit. Veuillez relancer le script avec les privilèges administrateur en faisant un clique droit dessus et en sélectionnant "Exécuter en tant qu'administrateur".
	goto:end_script
)
rmdir /s /q ..\test
echo Avant de continuer, vérifiez ceci car le script pourrait ne pas fonctionner si ce paramètre est mal réglé:
echo - Faire un clique droit sur la barre de titre ou le raccourci "alt+espace" et cliquer sur "Propriétés".
echo - Aller dans l'onglet "Polices", choisir la police "Lucida Console" et cliquer sur "OK".
echo.
echo Si tout est bon, le script devrait fonctionner correctement.
echo Si le script se ferme immédiatement après ceci, cela veut dire que la police que vous avez sélectionné n'est pas compatible avec l'encodage de caractères UTF-8.
pause
Menu.bat
:end_script
pause
exit