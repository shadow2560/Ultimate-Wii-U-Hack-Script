::Script by Shadow256
chcp 65001 >nul
IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
)
IF NOT EXIST save_v-wii\*.* (
	del /q save_v-wii 2>nul
	mkdir save_v-wii
)
Setlocal enabledelayedexpansion
IF "%uwuhs_launch%"=="Y" (
	set base_path=..\..
) else (
	set base_path=.
)
echo Ce script va sauvegarder puis, si vous le souhaitez, supprimer un titre de la v-wii.
echo Notez que la sauvegarde peut prendre du temps.
echo Le nom de la sauvegarde sera le numéro du titre à supprimer suivi de l'extention ".vwust". Ne pas renommer le fichier car la restauration ne fonctionnera plus.
echo Attention car ceci supprime des fichiers de la nand v-wii donc gardez bien les sauvegardes faites par ce script jusqu'à se que la v-wii refonctionne.
echo.
pause
:define_filename
set /p filename=Entrez le numéro du titre à supprimer (0-9, a-f) (8 caractères): 
IF "%filename%"=="" (
	echo Le numéro du titre ne peut être vide.
	goto:define_filename
) else (
	set filename=%filename:"=%
)
call TOOLS\Storage\functions\strlen.bat nb "%filename%"
IF %nb% NEQ 8 (
	echo Le numéro du titre doit avoir exactement 8 caractères.
	set filename=
	goto:define_filename
)
set i=0
:check_chars_filename
IF %i% LSS %nb% (
	set check_chars_filename=0
	FOR %%z in (a b c d e f 0 1 2 3 4 5 6 7 8 9) do (
		IF "!filename:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_filename=1
			goto:check_chars_filename
		)
	)
	IF "!check_chars_filename!"=="0" (
		echo Un caractère non autorisé a été saisie dans le titre v-wii. Recommencez.
		set filename=
		goto:define_filename
	)
)
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
set filepath=%filepath:\\=\%
echo.
set /p custom_ip=Entrez l'adresse IP de votre Wii U: 
chcp 850 >nul
TOOLS\Wupclient\save_v-wii_title.exe %custom_ip% %filename%
chcp 65001 >nul
IF NOT EXIST save_v-wii\titles\vol\storage_slccmpt01\title\00000001\%filename%\*.* (
	echo Un problème est survenu durant la sauvegarde, la sauvegarde est annulée.
	goto:endscript
)
cd save_v-wii\titles
IF NOT "%filepath%"=="" (
	..\..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "%filepath%%filename%".vwust  -r
) else (
	..\..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "..\..\%base_path%\%filename%".vwust  -r
)
cd ..\..
echo.
echo Titre v-wii sauvegardé.
echo Rappel: Ne renommer pas le fichier obtenu car sa restauration ne fonctionnera plus.
echo.
set /p delete_title=Souhaitez-vous vraiment supprimer le titre de la v-wii? (O/n): 
IF NOT "%delete_title%"=="" set delete_title=%delete_title:~0,1%
IF /i "%delete_title%"=="o" (
	echo Suppression du titre de la v-wii...
	chcp 850 >nul
TOOLS\Wupclient\del_v-wii_title.exe %custom_ip% %filename%
chcp 65001 >nul
echo Suppression effectuée.
)
:endscript
pause
rmdir /s /q save_v-wii
rmdir /s /q templogs
endlocal