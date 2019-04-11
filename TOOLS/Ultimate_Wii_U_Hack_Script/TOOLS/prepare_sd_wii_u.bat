Setlocal enabledelayedexpansion
echo on
::Script by Shadow256
chcp 65001 >nul

IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
)
::cd >templogs\tempvar.txt
::set /p path_fat32format=<templogs\tempvar.txt
::set path_fat32format=%path_fat32format%\TOOLS\fat32format\fat32format.exe
::reg.exe ADD "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%path_fat32format%" /t REG_SZ /d "RUNASADMIN" /f
echo Ce script va vous permettre de préparer une carte SD pour le hack Wii U en y installant les outils importants. >con
echo Pendant le script, les droits administrateur seront demandé.
echo.>con
echo ATTENTION: Si vous décidez de formater votre carte SD, toutes les données de celle-ci seront perdues. Sauvegardez les données importante avant de formater.>con
echo ATTENTION: Choisissez bien la lettre du volume qui correspond à votre carte SD car aucune vérification ne pourra être faites à ce niveau là. >con
echo ATTENTION: Le hack de la v-wii, l'utilisation de Haxchi ou l'utilisation de CBHC peuvent occasionner des domages à votre console s'ils ne sont pas utilisés correctement. Si vous ne savez pas comment vous en servir, veuillez choisir de lancer la page d'information sur se qui peut être copié lorse que le script le proposera, vous y trouverez des liens vers des informations sur ces sujets. >con
echo.>con
echo Je ne pourrais être tenu pour responsable de quelque domage que se soit lié à l'utilisation de ce script ou des outils qu'il contient. >con
echo.>con
echo.>con
pause >con
:define_volume_letter
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
IF "%tempcount%"=="0" (
	echo Aucun disque compatible trouvé. Veuillez insérer votre carte SD puis relancez le script. >con
	echo Le script va maintenant s'arrêté. >con
	goto:endscript
)
echo. >con
echo Liste des disques: >con
:list_volumes
IF "%tempcount%"=="0" goto:set_volume_letter
TOOLS\gnuwin32\bin\tail.exe -%tempcount% <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\head.exe -1 >con
set /a tempcount-=1
goto:list_volumes
:set_volume_letter
echo.>con
echo.>con
set /p volume_letter=Entrez la lettre du volume de la SD que vous souhaitez utiliser: >con
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	echo La lettre de lecteur ne peut être vide. Réessayez. >con
	goto:define_volume_letter
)
set volume_letter=%volume_letter:~0,1%
set nb=1
CALL TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat volume_letter
set i=0
:check_chars_volume_letter
IF %i% LSS %nb% (
	set check_chars_volume_letter=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
		IF "!volume_letter:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_volume_letter=1
			goto:check_chars_volume_letter
		)
	)
	IF "!check_chars_volume_letter!"=="0" (
		echo Un caractère non autorisé a été saisie dans la lettre du lecteur. Recommencez. >con
		set volume_letter=
		goto:define_volume_letter
	)
)
IF NOT EXIST "%volume_letter%:\" (
	echo Ce volume n'existe pas. Recommencez. >con
	set volume_letter=
	goto:define_volume_letter
)
TOOLS\gnuwin32\bin\grep.exe "Lettre volume=%volume_letter%" <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p temp_volume_letter=<templogs\tempvar.txt
IF NOT "%volume_letter%"=="%temp_volume_letter%" (
	echo Cette lettre de volume n'est pas dans la liste. Recommencez. >con
	goto:define_volume_letter
)
set /p format_choice=Souhaitez-vous formaté la SD (volume "%volume_letter%")? (O/n): >con
IF NOT "%format_choice%"=="" set format_choice=%format_choice:~0,1%
:define_format_clusters
IF /i "%format_choice%"=="o" (
	echo Définissez le nombre de clusters que vous souhaitez utiliser: >con
	echo.>con
	echo 1: 64K (recommandé^) >con
	echo 2: 32K >con
	echo 0: Annule l'oppération de formatage >con
	echo.>con
	set /p format_clusters=Quelle taille de clusters voulez-vous utiliser? (1/2/0^): >con
) else (
	goto:copy_to_sd
)
call TOOLS\Storage\functions\strlen.bat nb "%format_clusters%"
IF %nb% EQU 0 (
	echo Le nombre de clusters ne peut être vide. Réessayez. >con
	goto:define_format_clusters
)
set format_clusters=%format_clusters:~0,1%
set i=0
:check_chars_format_clusters
IF %i% LSS %nb% (
	set check_chars_format_clusters=0
	FOR %%z in (0 1 2) do (
		IF "!format_clusters:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_format_clusters=1
			goto:check_chars_format_clusters
		)
	)
	IF "!check_chars_format_clusters!"=="0" (
		echo Un caractère non autorisé a été saisie dans le nombre de clusters. Recommencez. >con
		set format_clusters=
		goto:define_format_clusters
	)
)
:format_conditions
IF "%format_clusters%"=="0" goto:copy_to_sd
IF "%format_clusters%"=="1" TOOLS\fat32format\fat32format.exe -q -c128 %volume_letter%
IF "%format_clusters%"=="2" TOOLS\fat32format\fat32format.exe -q -c64 %volume_letter%
::SET "__COMPAT_LAYER="
echo.>con
::echo ATTENTION: N'appuyez sur une touche qu'une fois la fenêtre de formatage fermée.>con
::pause >con
::set /p check_uac=<templogs\tempvar.txt
::IF NOT "%check_uac%"=="UAC_OK" (
::echo La demande d'élévation n'a pas été acceptée, le formatage est annulé. >con
::echo.>con
::goto:copy_to_sd
::)
::check_error_format
::IF NOT EXIST "templogs\error_format.txt" goto:check_error_format >nul
::set /p ERRORLEVEL=<templogs\error_format.txt
echo.>con
IF "%ERRORLEVEL%"=="5" (
	echo La demande d'élévation n'a pas été acceptée, le formatage est annulé. >con
	::echo.>con
	goto:copy_to_sd
)
IF "%ERRORLEVEL%"=="32" (
	echo Le formatage n'a pas été effectué. >con
	echo Essayez d'éjecter proprement votre clé USB, réinsérez-là et relancez immédiatement ce script. >con
	echo Vous pouvez également essayer de fermer toutes les fenêtres de l'explorateur Windows avant le formatage, parfois cela règle le bug. >con
	echo.>con
	echo Le script va maintenant s'arrêter. >con
	goto:endscript
)
IF "%ERRORLEVEL%"=="2" (
	echo Le volume à formater n'existe pas. Vous avez peut-être débranché ou éjecté la carte SD durant ce script.>con
	echo.>con
	echo Le script va maintenant s'arrêter. >con
	goto:endscript
)
IF NOT "%ERRORLEVEL%"=="1" (
	IF NOT "%ERRORLEVEL%"=="0" (
		echo Une erreur inconue s'est produit pendant le formatage. >con
		echo.>con
		echo Le script va maintenant s'arrêter. >con
		goto:endscript
	)
)
IF "%ERRORLEVEL%"=="1" (
	echo Le formatage a été annulé par l'utilisateur. >con
)
IF "%ERRORLEVEL%"=="0" (
	echo Formatage effectué avec succès. >con
)
:copy_to_sd
set /p cancel_copy=Souhaitez-vous annuler la copie des différents fichiers vers votre SD (volume "%volume_letter%")? (O/n): >con
IF NOT "%cancel_copy%"=="" set cancel_copy=%cancel_copy:~0,1%
IF /i "%cancel_copy%"=="o" goto:endscript
set /p launch_manual=Souhaitez-vous lancer la page d'information sur se qui peut être copié (vivement conseillé)? (O/n): >con
IF NOT "%launch_manual%"=="" set launch_manual=%launch_manual:~0,1%
IF /i "%launch_manual%"=="o" (
	start DOC\files\sd_prepare.html
	pause >con
)
IF /i NOT "%format_choice%"=="o" (
	set /p del_files_dest_copy=Souhaitez-vous supprimer tous les répertoires et fichiers de la SD pendant la copie? (O/n^): >con
)
IF NOT "%del_files_dest_copy%"=="" set del_files_dest_copy=%del_files_dest_copy:~0,1%
set /p copy_wiiu_pack=Souhaitez-vous copier le pack pour le hack Wii U? (O/n): >con
IF /i NOT "%copy_wiiu_pack%"=="" set copy_wiiu_pack=%copy_wiiu_pack:~0,1%
set /p copy_vwii_pack=Souhaitez-vous copier le pack pour le hack V-Wii? (O/n): >con
IF /i NOT "%copy_vwii_pack%"=="" set copy_vwii_pack=%copy_vwii_pack:~0,1%
set /p copy_haxchi=Souhaitez-vous copier les fichiers nécessaires à l'installation d'Haxchi? (O/n): >con
IF /i NOT "%copy_haxchi%"=="" set copy_haxchi=%copy_haxchi:~0,1%
IF /i "%copy_haxchi%"=="o" (
	set propose_launch_doc=O
	echo ATTENTION: Veuillez bien vous renseigner sur la procédure à effectuer avant d'installer ou d'utiliser Haxchi. >con
	echo Vous pourez trouver un lien vers un tutoriel dans la documentation, il vous sera proposé de l'ouvrir après la copie des fichiers. >con
	echo ATTENTION: Si CBHC est déjà installé sur votre console, il est fortement recommandé de ne pas utiliser Haxchi et CBHC en même temps à moins de savoir se que vous faites. Surtout n'installez pas Haxchi par-dessus le jeu sur lequel est installé CBHC pour ne pas bricker la console. >con
	pause >con
)
set /p copy_cbhc=Souhaitez-vous copier les fichiers nécessaires à l'installation de CBHC? (O/n): >con
IF /i NOT "%copy_cbhc%"=="" set copy_cbhc=%copy_cbhc:~0,1%
IF /i "%copy_cbhc%"=="o" (
	set propose_launch_doc=O
	echo ATTENTION: Veuillez bien vous renseigner sur la procédure à effectuer avant d'installer ou d'utiliser CBHC. >con
	echo Vous pourez trouver un lien vers un tutoriel dans la documentation, il vous sera proposé de l'ouvrir après la copie des fichiers. >con
	echo.>con
	pause >con
	IF /i NOT "%copy_haxchi%"=="o" (
		echo Si vous n'avez pas déjà installé Haxchi sur votre console, il est recommandé en premier lieu de l'installer et de tester son bon fonctionnement avant d'installer CBHC. >con
		echo ATTENTION: Une fois CBHC installé, ne réinstallez ou ne désinstallez pas Haxchi sur le jeu sur lequel CBHC a été appliqué sous peine de brick. >con
		set /p copy_haxchi=Souhaitez-vous copier également l'installateur d'Haxchi? (O/n^): >con
	)
)
echo Copie en cours... >con
IF /i "%copy_wiiu_pack%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hack_wiiu %volume_letter%:\ /mir
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\mixed %volume_letter%:\ /e
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hbl %volume_letter%:\ /e
		set del_files_dest_copy=n
	) else (
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hack_wiiu %volume_letter%:\ /e
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\mixed %volume_letter%:\ /e
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hbl %volume_letter%:\ /e
	)
	del /Q /S "%volume_letter%:\games\.emptydir" >nul 2>&1
)
IF /i "%copy_vwii_pack%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hack_vwii %volume_letter%:\ /mir
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\mixed %volume_letter%:\ /e
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hbl %volume_letter%:\ /e
		set del_files_dest_copy=n
	) else (
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hack_vwii %volume_letter%:\ /e
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\mixed %volume_letter%:\ /e
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hbl %volume_letter%:\ /e
	)
	del /Q /S "%volume_letter%:\games\.emptydir" >nul 2>&1
	del /Q /S "%volume_letter%:\wbfs\.emptydir" >nul 2>&1
)
IF /i "%copy_haxchi%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\haxchi_cbhc\haxchi %volume_letter%:\ /mir
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hbl %volume_letter%:\ /e
		set del_files_dest_copy=n
	) else (
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\haxchi_cbhc\haxchi %volume_letter%:\ /e
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hbl %volume_letter%:\ /e
	)
)
IF /i "%copy_cbhc%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\haxchi_cbhc\cbhc %volume_letter%:\ /mir
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hbl %volume_letter%:\ /e
		set del_files_dest_copy=n
	) else (
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\haxchi_cbhc\cbhc %volume_letter%:\ /e
		%windir%\System32\Robocopy.exe TOOLS\sd_wiiu\hbl %volume_letter%:\ /e
	)
)
echo Copie terminée. >con
IF "%propose_launch_doc%"=="O" (
	echo Vous avez choisi de copier Haxchi ou CBHC. Si vous ne savez pas comment les utilisés ensuite, il est fortement conseillé de lancer la documentation. >con
	set /p launch_doc=Souhaitez-vous lancer la documentation? (O/n^): >con
)
IF NOT "%launch_doc%"=="" set launch_doc=%launch_doc:~0,1%
IF /i "%launch_doc%"=="o" (
	start DOC\index.html
)
:endscript
rmdir /s /q templogs
::reg.exe Delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%path_fat32format%" /f
pause >con
endlocal