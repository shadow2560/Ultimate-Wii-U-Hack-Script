Setlocal enabledelayedexpansion
echo on
::Script by Shadow256
chcp 65001 >nul
IF NOT EXIST ..\templogs\*.* (
	del /q ..\templogs 2>nul
	mkdir ..\templogs
)
IF "%uwuhs_launch%"=="Y" (
	set base_path=..\..
) else (
	set base_path=.
)
:define_filename
set /p filename=Entrez le nom de la sauvegarde: >con
IF "%filename%"=="" (
	echo Le nom de la sauvegarde ne peut être vide. >con
	goto:define_filename
) else (
	set filename=%filename:"=%
)
call functions\strlen.bat nb "%filename%"
set i=0
:check_chars_filename
IF %i% LSS %nb% (
	set check_chars_filename=0
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!filename:~%i%,1!"=="%%z" (
			echo Un caractère non autorisé a été saisie dans le nom de la sauvegarde. >con
			set filename=
			goto:define_filename
		)
	)
	set /a i+=1
	goto:check_chars_filename
)
%windir%\system32\wscript.exe //Nologo functions\select_dir.vbs "..\templogs\tempvar.txt"
set /p filepath=<..\templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
set filepath=%filepath:\\=\%
echo Sauvegarde en cours... >con
IF NOT EXIST ..\KEY_SAVES mkdir ..\KEY_SAVES
IF NOT EXIST ..\KEY_SAVES\CONSOLES mkdir ..\KEY_SAVES\CONSOLES
IF NOT EXIST ..\KEY_SAVES\CONSOLES\GBA mkdir ..\KEY_SAVES\CONSOLES\GBA
IF NOT EXIST ..\KEY_SAVES\CONSOLES\GBA\JNUSTool mkdir ..\KEY_SAVES\CONSOLES\GBA\JNUSTool
IF NOT EXIST ..\KEY_SAVES\CONSOLES\GBA\NUSPacker mkdir ..\KEY_SAVES\CONSOLES\GBA\NUSPacker
copy /v CONSOLES\GBA\*.txt ..\KEY_SAVES\CONSOLES\GBA
move CONSOLES\GBA\JNUSTool\JNUSTool.jar CONSOLES\GBA\JNUSTool.jar
%windir%\System32\Robocopy.exe CONSOLES\GBA\JNUSTool\ ..\KEY_SAVES\CONSOLES\GBA\JNUSTool\ /e
move CONSOLES\GBA\JNUSTool.jar CONSOLES\GBA\JNUSTool\JNUSTool.jar
copy /V CONSOLES\GBA\NUSPacker\encryptKeyWith ..\KEY_SAVES\CONSOLES\GBA\NUSPacker\encryptKeyWith
IF NOT EXIST ..\KEY_SAVES\CONSOLES\N64 mkdir ..\KEY_SAVES\CONSOLES\N64
IF NOT EXIST ..\KEY_SAVES\CONSOLES\N64\INIs mkdir ..\KEY_SAVES\CONSOLES\N64\INIs
IF NOT EXIST ..\KEY_SAVES\CONSOLES\N64\JNUSTool mkdir ..\KEY_SAVES\CONSOLES\N64\JNUSTool
IF NOT EXIST ..\KEY_SAVES\CONSOLES\N64\NUSPacker mkdir ..\KEY_SAVES\CONSOLES\N64\NUSPacker
copy /v CONSOLES\N64\*.txt ..\KEY_SAVES\CONSOLES\N64
%windir%\System32\Robocopy.exe CONSOLES\N64\INIs\ ..\KEY_SAVES\CONSOLES\N64\INIs\ /e
move CONSOLES\N64\JNUSTool\JNUSTool.jar CONSOLES\N64\JNUSTool.jar
%windir%\System32\Robocopy.exe CONSOLES\N64\JNUSTool\ ..\KEY_SAVES\CONSOLES\N64\JNUSTool\ /e
move CONSOLES\N64\JNUSTool.jar CONSOLES\N64\JNUSTool\JNUSTool.jar
copy /V CONSOLES\N64\NUSPacker\encryptKeyWith ..\KEY_SAVES\CONSOLES\N64\NUSPacker\encryptKeyWith
IF NOT EXIST ..\KEY_SAVES\CONSOLES\NDS mkdir ..\KEY_SAVES\CONSOLES\NDS
IF NOT EXIST ..\KEY_SAVES\CONSOLES\NDS\JNUSTool mkdir ..\KEY_SAVES\CONSOLES\NDS\JNUSTool
IF NOT EXIST ..\KEY_SAVES\CONSOLES\NDS\NUSPacker mkdir ..\KEY_SAVES\CONSOLES\NDS\NUSPacker
copy /v CONSOLES\NDS\*.txt ..\KEY_SAVES\CONSOLES\NDS
move CONSOLES\NDS\JNUSTool\JNUSTool.jar CONSOLES\NDS\JNUSTool.jar
%windir%\System32\Robocopy.exe CONSOLES\NDS\JNUSTool\ ..\KEY_SAVES\CONSOLES\NDS\JNUSTool\ /e
move CONSOLES\NDS\JNUSTool.jar CONSOLES\NDS\JNUSTool\JNUSTool.jar
copy /V CONSOLES\NDS\NUSPacker\encryptKeyWith ..\KEY_SAVES\CONSOLES\NDS\NUSPacker\encryptKeyWith
IF NOT EXIST ..\KEY_SAVES\CONSOLES\NES mkdir ..\KEY_SAVES\CONSOLES\NES
IF NOT EXIST ..\KEY_SAVES\CONSOLES\NES\JNUSTool mkdir ..\KEY_SAVES\CONSOLES\NES\JNUSTool
IF NOT EXIST ..\KEY_SAVES\CONSOLES\NES\NUSPacker mkdir ..\KEY_SAVES\CONSOLES\NES\NUSPacker
copy /v CONSOLES\NES\*.txt ..\KEY_SAVES\CONSOLES\NES
move CONSOLES\NES\JNUSTool\JNUSTool.jar CONSOLES\NES\JNUSTool.jar
%windir%\System32\Robocopy.exe CONSOLES\NES\JNUSTool\ ..\KEY_SAVES\CONSOLES\NES\JNUSTool\ /e
move CONSOLES\NES\JNUSTool.jar CONSOLES\NES\JNUSTool\JNUSTool.jar
copy /V CONSOLES\NES\NUSPacker\encryptKeyWith ..\KEY_SAVES\CONSOLES\NES\NUSPacker\encryptKeyWith
IF NOT EXIST ..\KEY_SAVES\CONSOLES\SNES mkdir ..\KEY_SAVES\CONSOLES\SNES
IF NOT EXIST ..\KEY_SAVES\CONSOLES\SNES\JNUSTool mkdir ..\KEY_SAVES\CONSOLES\SNES\JNUSTool
IF NOT EXIST ..\KEY_SAVES\CONSOLES\SNES\NUSPacker mkdir ..\KEY_SAVES\CONSOLES\SNES\NUSPacker
copy /v CONSOLES\SNES\*.txt ..\KEY_SAVES\CONSOLES\SNES
move CONSOLES\SNES\JNUSTool\JNUSTool.jar CONSOLES\SNES\JNUSTool.jar
%windir%\System32\Robocopy.exe CONSOLES\SNES\JNUSTool\ ..\KEY_SAVES\CONSOLES\SNES\JNUSTool\ /e
move CONSOLES\SNES\JNUSTool.jar CONSOLES\SNES\JNUSTool\JNUSTool.jar
copy /V CONSOLES\SNES\NUSPacker\encryptKeyWith ..\KEY_SAVES\CONSOLES\SNES\NUSPacker\encryptKeyWith
copy /V blacklist_ids.txt ..\KEY_SAVES\blacklist_ids.txt
cd ..\KEY_SAVES
IF NOT "%filepath%"=="" (
	..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "%filepath%%filename%".ijctn  -r
) else (
	..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "..\%base_path%\%filename%".ijctn  -r
)
cd ..
echo Sauvegarde des fichiers de configurations terminée. >con
rmdir /s /q KEY_SAVES
rmdir /s /q templogs
pause >con
cd "%~dp0"
endlocal