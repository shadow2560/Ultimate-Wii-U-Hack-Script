::Script by Shadow256
chcp 65001 >nul
IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
)
Setlocal enabledelayedexpansion
echo Ce script va extraire les fichiers d'un dump complet de la partition MLC (format .bin ou .img supporté).
echo Vous aurez également besoin d'un fichier de dump de l'OTP de votre console (généralement nommé "otp.bin") pour que l'extraction fonctionne. Vous pouvez obtenir ce fichier simplement avec l'homebrew Wii U Nand Dumper.
echo Si le noms du fichier de dump MLC contient des espaces, le script le renommera en remplaçant ceux-ci par des "_" pour que l'extraction puisse fonctionner. Si nécessaire, le fichier du dump OTP sera copié à côté du dump MLC et cette copie sera supprimée en fin de script. Si le script se termine corectement, le noms du fichier du dump MLC original sera restauré, même si la procédure d'extraction échoue donc il ne faut pas interompre le script.
echo Le chemin du dossier pour l'extraction ne devra pas contenir d'espaces, le script s'arrêtera s'il en contient.
echo Notez que l'extraction du fichier peut prendre plus ou moins de temps selon votre matériel.
echo.
echo Attention: Veuillez extraire le fichier sur une partition formatée en EXTFAT ou en NTFS car certains fichiers pourraient faire plus de 4 GB.
echo Attention: Vous devez disposer d'assez d'espace libre à l'emplacement où l'extraction sera faite (32 GO maximum nécessaires).
echo.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers de dump compatibles (*.bin;*.img)|*.bin;*.img|" "Sélection du fichier de dump MLC" "templogs\tempvar.txt"
set /p mlc_filepath=<templogs\tempvar.txt
IF "%mlc_filepath%"=="" (
	echo Vous devez sélectionner un fichier de dump MLC, l'extraction est annulée.
	goto:endscript
)
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers de dump OTP (*.bin)|*.bin|" "Sélection du fichier de dump OTP" "templogs\tempvar.txt"
set /p otp_filepath=<templogs\tempvar.txt
IF "%otp_filepath%"=="" (
	echo Vous devez sélectionner un fichier de dump OTP, l'extraction est annulée.
	goto:endscript
)
echo.
echo Vous allez devoir sélectionner le dossier où seront extraits les fichiers.
echo.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p save_filepath=<templogs\tempvar.txt
IF NOT "%save_filepath%"=="" (
	set save_filepath=%save_filepath%\
) else (
	echo Vous devez sélectionner un dossier vers lequel extraire les fichiers, l'extraction est annulée.
	goto:endscript
)
set save_filepath=%save_filepath:\\=\%
call TOOLS\Storage\functions\strlen.bat nb "%save_filepath%"
set i=1
:check_chars_filepath
IF %i% NEQ %nb% (
	IF "!save_filepath:~-%i%,1!"==" " (
		echo Le chemin pour l'extraction contient des espaces, le script ne peut pas continuer.
		goto:endscript
	) else (
		set /a i+=1
		goto:check_chars_filepath
	)
)
set i=1
:extract_mlc_path
IF NOT "!mlc_filepath:~-%i%,1!"=="\" (
	set /a i+=1
	goto:extract_mlc_path
)
set /a i-=1
set mlc_file_name=!mlc_filepath:~-%i%,%i%!
set mlc_file_name_temp=%mlc_file_name: =_%
IF NOT "%mlc_file_name%"=="%mlc_file_name_temp%" (
	set rename_mlc=Y
)
set mlc_filepath=!mlc_filepath:~0,-%i%!
set i=1
:extract_otp_path
IF NOT "!otp_filepath:~-%i%,1!"=="\" (
	set /a i+=1
	goto:extract_otp_path
)
set /a i-=1
set otp_file_name=!otp_file_path:~-%i%,%i%!
set otp_file_name_temp=%otp_file_name: =_%
set otp_filepath_temp=!otp_filepath:~0,-%i%!
IF NOT "%otp_filepath_temp%"=="%mlc_filepath%" (
	set copy_otp=Y
	goto:skip_otp_rename
)
IF NOT "%otp_file_name%"=="%otp_file_name_temp%" set rename_otp=Y
:skip_otp_rename
IF "%rename_mlc%"=="Y" move "%mlc_filepath%%mlc_file_name%" "%mlc_filepath%%mlc_file_name_temp%"
IF "%rename_otp%"=="Y" (
	move "%otp_filepath%%otp_file_name%" "%otp_filepath%%otp_file_name_temp%"
	set otp_filepath=%otp_filepath%%otp_file_name_temp%
)
IF "%copy_otp%"=="Y" (
	copy "%otp_filepath%" "%mlc_filepath%otp.bin"
	set otp_filepath=%mlc_filepath%otp.bin
)
cd >templogs\tempvar.txt
set /p current_dir=<templogs\tempvar.txt
%mlc_filepath:~0,1%:
cd "%mlc_filepath%"
echo.
echo Extraction des fichiers en cours...
"%current_dir%\TOOLS\wfs-extract\wfs-extract.exe" --input %mlc_file_name_temp% --output %save_filepath% --otp %otp_filepath% --mlc
IF %errorlevel% NEQ 0 (
	echo Une erreur s'est produite pendant la tentative d'extraction des fichiers.
	echo Vérifiez que vous avez assez d'espace libre à l'endroit où vous souhaitez sauvegarder le fichier et vérifiez que cet endroit se trouve bien sur une partition supportant les fichiers volumineux ^(EXTFAT, NTFS^).
	echo Vérifiez également que le fichier "otp" ainsi que le dump de la partition MLC soient corrects.
	%current_dir:~0,1%:
	cd "%current_dir%"
	goto:endscript
)
echo.
echo Extraction terminée avec succès.
%current_dir:~0,1%:
cd "%current_dir%"
:endscript
pause
IF "%rename_mlc%"=="Y" move "%mlc_filepath%%mlc_file_name_temp%" "%mlc_filepath%%mlc_file_name%"
IF "%rename_otp%"=="Y" move "%mlc_filepath%%otp_file_name_temp%" "%mlc_filepath%%otp_file_name%"
IF "%copy_otp%"=="Y" del /q "%mlc_filepath%otp.bin%"
rmdir /s /q templogs
endlocal