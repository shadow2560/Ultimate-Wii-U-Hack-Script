::Script by Shadow256
chcp 65001 >nul
IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
)
Setlocal enabledelayedexpansion
echo Ce script va réunir les différentes parties de la partition MLC obtenu grâce à Wii U Nand Dumper en un seul fichier.
echo Notez que la création du fichier peut prendre plus ou moins de temps selon votre matériel.
echo.
echo Attention: Ne renommez pas les fichiers obtenus avec Wii U Nand Dumper car le script ne fonctionnera pas.
echo Attention: Veuillez sauvegarder le fichier sur une partition formatée en EXTFAT ou en NTFS car le fichier fera plus de 4 GB.
echo Attention: Vous devez disposer d'assez d'espace libre à l'emplacement où la sauvegarde sera faite pour créer ce fichier (environ 8 GB pour les Wii U 8 GO et environ 30 GB pour les Wii U 32 GO).
echo.
pause
echo.
echo Vous allez devoir sélectionner le dossier contenant les différentes parties de la partition MLC.
echo.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p mlc_files_path=<templogs\tempvar.txt
IF NOT "%mlc_files_path%"=="" (
	set mlc_files_path=%mlc_files_path%\
) else (
	echo Vous devez choisir un dossier dans lequel se trouve les différentes parties de la partition MLC, la sauvegarde est annulée.
	goto:endscript
)
set mlc_files_path=%mlc_files_path:\\=\%
IF NOT EXIST "%mlc_files_path%mlc.bin.part01" (
	echo Le dossier sélectionné ne semble pas contenir la sauvegarde de la partition MLC de Wii U Nand Dumper, la sauvegarde est annulé.
	goto:endscript
)
IF NOT EXIST "%mlc_files_path%mlc.bin.part05" (
	set nand_type=8
) else (
	set nand_type=32
)
set copy_cmd=copy /b "%mlc_files_path%mlc.bin.part01" +
IF "%nand_type%"=="8" (
	for %%z in (02 03 04) do (
		IF NOT EXIST "%mlc_files_path%mlc.bin.part%%z" (
			echo Le dossier sélectionné ne semble pas contenir la sauvegarde de la partition MLC de Wii U Nand Dumper, la sauvegarde est annulé.
			goto:endscript
		)
		set copy_cmd=!copy_cmd! "%mlc_files_path%mlc.bin.part%%z" +
	)
) else if "%nand_type%"=="32" (
	for %%z in (02 03 04 05 06 07 08 09 10 11 12 13 14 15) do (
		IF NOT EXIST "%mlc_files_path%mlc.bin.part%%z" (
			echo Le dossier sélectionné ne semble pas contenir la sauvegarde de la partition MLC de Wii U Nand Dumper, la sauvegarde est annulé.
			goto:endscript
		)
		set copy_cmd=!copy_cmd! "%mlc_files_path%mlc.bin.part%%z" +
	)
) else (
	echo Une erreur inconue s'est produite, la sauvegarde est annulée.
	goto:endscript
)
set copy_cmd=%copy_cmd:~0,-2%
echo.
:define_filename
set /p filename=Entrez le nom du fichier à créer: 
IF "%filename%"=="" (
	echo Le nom du fichier ne peut être vide, la sauvegarde est annulée.
	goto:endscript
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
echo.
echo Maintenant vous allez devoir sélectionner le dossier où sera sauvegardé le fichier réunifié.
echo.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p save_filepath=<templogs\tempvar.txt
IF NOT "%save_filepath%"=="" (
	set save_filepath=%save_filepath%\
) else (
	echo Vous devez sélectionner un dossier vers lequel sauvegarder le fichier, la sauvegarde est annulée.
	goto:endscript
)
set save_filepath=%save_filepath:\\=\%
set copy_cmd=%copy_cmd% "%save_filepath%%filename%.bin"
echo %copy_cmd%
pause
echo Création du fichier en cours...
%copy_cmd%
IF %errorlevel% NEQ 0 (
	echo Une erreur s'est produite pendant la tentative de création du fichier.
	echo Vérifiez que vous avez assez d'espace libre à l'endroit où vous souhaitez sauvegarder le fichier et vérifiez que cet endroit se trouve bien sur une partition supportant les fichiers volumineux ^(EXTFAT, NTFS^).
	goto:endscript
)
echo.
echo Fichier créé avec succès.
:endscript
pause
rmdir /s /q templogs
endlocal