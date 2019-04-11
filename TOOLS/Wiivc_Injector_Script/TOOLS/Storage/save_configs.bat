::Script by Shadow256
Setlocal enabledelayedexpansion
echo on
chcp 65001 >nul

IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
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
call TOOLS\Storage\functions\strlen.bat nb "%filename%"
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
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
set filepath=%filepath:\\=\%
echo Sauvegarde en cours... >con
IF NOT EXIST KEY_SAVES mkdir KEY_SAVES
IF NOT EXIST KEY_SAVES\TOOLS mkdir KEY_SAVES\TOOLS
IF NOT EXIST KEY_SAVES\TOOLS\c2w mkdir KEY_SAVES\TOOLS\c2w
copy /V TOOLS\c2w\starbuck_key.txt KEY_SAVES\TOOLS\c2w\starbuck_key.txt
IF NOT EXIST KEY_SAVES\TOOLS\JNUSTool mkdir KEY_SAVES\TOOLS\JNUSTool
%windir%\System32\Robocopy.exe TOOLS\JNUSTool\0005001010004000 KEY_SAVES\TOOLS\JNUSTool\0005001010004000\ /MIR
%windir%\System32\Robocopy.exe TOOLS\JNUSTool\0005001010004001 KEY_SAVES\TOOLS\JNUSTool\0005001010004001\ /MIR
%windir%\System32\Robocopy.exe "TOOLS\JNUSTool\Rhythm Heaven Fever [VAKE01]" "KEY_SAVES\TOOLS\JNUSTool\Rhythm Heaven Fever [VAKE01]" /MIR
copy /V TOOLS\JNUSTool\config KEY_SAVES\TOOLS\JNUSTool\config
IF NOT EXIST KEY_SAVES\TOOLS\NUSPacker mkdir KEY_SAVES\TOOLS\NUSPacker
copy /V TOOLS\NUSPacker\encryptKeyWith KEY_SAVES\TOOLS\NUSPacker\encryptKeyWith
IF NOT EXIST KEY_SAVES\TOOLS\Storage mkdir KEY_SAVES\TOOLS\Storage
copy /V TOOLS\Storage\BASETITLEKEY KEY_SAVES\TOOLS\Storage\BASETITLEKEY
copy /V TOOLS\Storage\blacklist_ids.txt KEY_SAVES\TOOLS\Storage\blacklist_ids.txt
copy /v TOOLS\Storage\WiiInjectScript.ini KEY_SAVES\TOOLS\Storage\WiiInjectScript.ini
cd KEY_SAVES
IF NOT "%filepath%"=="" (
	..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "%filepath%%filename%".wvcis  -r
) else (
	..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "..\%base_path%\%filename%".wvcis  -r
)
cd ..
echo Sauvegarde des fichiers de configurations terminée. >con
rmdir /s /q KEY_SAVES
rmdir /s /q templogs
pause >con
endlocal