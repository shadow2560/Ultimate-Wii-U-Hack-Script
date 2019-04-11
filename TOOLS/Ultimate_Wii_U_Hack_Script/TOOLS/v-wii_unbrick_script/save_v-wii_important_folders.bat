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
echo Ce script va sauvegarder les fichiers importants de la v-wii.
echo Notez que la sauvegarde peut prendre du temps (environ 20 minutes).
echo Si la V-wii est déjà brickée, vous devrez récupérer ces fichiers sur une Wii U européenne sur laquelle la V-wii fonctionne correctement pour pouvoir les restaurer ensuite.
echo.
pause
:define_filename
set /p filename=Entrez le nom de la sauvegarde: 
IF "%filename%"=="" (
	echo Le nom de la sauvegarde ne peut être vide.
	goto:define_filename
) else (
	set filename=%filename:"=%
)
call TOOLS\Storage\functions\strlen.bat nb "%filename%"
set i=0
:check_chars_filename
IF %i% LSS %nb% (
	set check_chars_filename=0
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!filename:~%i%,1!"=="%%z" (
			echo Un caractère non autorisé a été saisie dans le nom de la sauvegarde.
			set filename=
			goto:define_filename
		)
	)
	set /a i+=1
	goto:check_chars_filename
)
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
set filepath=%filepath:\\=\%
set /p custom_ip=Entrez l'adresse IP de votre Wii U: 
chcp 850 >nul
TOOLS\Wupclient\save_v-wii_important_folders.exe %custom_ip%
chcp 65001 >nul
IF NOT EXIST save_v-wii\vol\storage_slccmpt01\title\00000001\00000002\content\00000022.app (
	echo Un problème est survenu durant la sauvegarde, la sauvegarde est annulée.
	goto:endscript
)
IF NOT EXIST save_v-wii\vol\storage_slccmpt01\title\00000001\00000002\content\00000023.app (
	echo Un problème est survenu durant la sauvegarde, la sauvegarde est annulée.
	goto:endscript
)
IF NOT EXIST save_v-wii\vol\storage_slccmpt01\title\00000001\00000050\content\*.* (
	echo Un problème est survenu durant la sauvegarde, la sauvegarde est annulée.
	goto:endscript
)
IF NOT EXIST save_v-wii\vol\storage_slccmpt01\title\00000001\00000050\data\*.* (
	echo Un problème est survenu durant la sauvegarde, la sauvegarde est annulée.
	goto:endscript
)
cd save_v-wii
IF NOT "%filepath%"=="" (
	..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "%filepath%%filename%".vwus  -r
) else (
	..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "..\%base_path%\%filename%".vwus  -r
)
cd ..
echo.
echo Fichiers sauvegardés.
:endscript
pause
rmdir /s /q save_v-wii
rmdir /s /q templogs
endlocal