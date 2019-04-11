::Script by Shadow256 inspired by TeconMoon's WiiVC Injector Script v2.3.6
Setlocal enabledelayedexpansion
echo on
chcp 65001
title TeconMoon's WiiVC Injector Script

IF EXIST TOOLS\Storage\WiiInjectScript.ini\*.* (
	rmdir /s /q TOOLS\Storage\WiiInjectScript.ini
)
IF not EXIST TOOLS\Storage\WiiInjectScript.ini copy nul TOOLS\Storage\WiiInjectScript.ini
IF EXIST TOOLS\Storage\blacklist_ids.txt\*.* (
	rmdir /s /q TOOLS\Storage\blacklist_ids.txt
)
IF NOT EXIST TOOLS\Storage\blacklist_ids.txt copy nul TOOLS\Storage\blacklist_ids.txt
IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
)
IF NOT EXIST SOURCE_FILES\*.* (
	del /q SOURCE_FILES 2>nul
	mkdir SOURCE_FILES
)

::Check for Java 8
set jver=0
for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k%%l%%m"
if %jver% LSS 180000 goto:javafail

echo Légende des réponses possibles pour les questions: O=oui, n=non, J=ne plus jamais demander >con
echo D'autres types de réponses peuvent être demandées parfois mais elle seront explicitées lors de la question. >con
echo.>con

::initialise path variables
TOOLS\gnuwin32\bin\grep.exe -m 1 "enter_sources" <TOOLS\Storage\WiiInjectScript.ini | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p ini_enter_sources=<templogs\tempvar.txt
IF /i not "%ini_enter_sources%"=="j" (
	set /p enter_sources=Souhaitez-vous entrer les sources des différents fichiers manuellement? (O/n/J^): >con
)
IF NOT "%enter_sources%"=="" set enter_sources=%enter_sources:~0,1%
IF /i "%enter_sources%"=="j" echo enter_sources=j>>TOOLS\Storage\WiiInjectScript.ini
IF /i NOT "%enter_sources%"=="o" (
	IF EXIST SOURCE_FILES\disc2.iso set gcd2_source=SOURCE_FILES\disc2.iso
	IF EXIST SOURCE_FILES\disc2.gcm set gcd2_source=SOURCE_FILES\disc2.gcm
	IF EXIST SOURCE_FILES\game.iso (
		set game_source=SOURCE_FILES\game.iso
		goto:skip_define_game_path
	)
	IF EXIST SOURCE_FILES\game.wdf (
		set game_source=SOURCE_FILES\game.wdf 
		goto:skip_define_game_path
	)
	IF EXIST SOURCE_FILES\game.wia (
		set game_source=SOURCE_FILES\game.wia
		goto:skip_define_game_path
	)
	IF EXIST SOURCE_FILES\game.ciso (
		set game_source=SOURCE_FILES\game.ciso
		goto:skip_define_game_path
	)
	IF EXIST SOURCE_FILES\game.wbi (
		set game_source=SOURCE_FILES\game.wbi
		goto:skip_define_game_path
	)
	IF EXIST SOURCE_FILES\game.wbfs (
		set game_source=SOURCE_FILES\game.wbfs
		goto:skip_define_game_path
	)
	IF EXIST SOURCE_FILES\game.gcm (
		set game_source=SOURCE_FILES\game.gcm
		goto:skip_define_game_path
	)
	IF EXIST SOURCE_FILES\game.wad (
		set game_source=SOURCE_FILES\game.wad
		goto:skip_define_game_path
	)
	IF EXIST SOURCE_FILES\boot.dol (
		set game_source=SOURCE_FILES\boot.dol
		goto:skip_define_game_path
	)
)
:define_game_source
IF /i "%enter_sources%"=="o" (
	echo Vous allez devoir sélectionner  le jeu ou le homebrew à injecter. Si vous fermez la fenêtre qui s'ouvrira sans sélectionner de fichier, vous pourrez encore créer une Wiivc Chan Booter ou un forwader non autoboot de Nintendont. >con
	pause >con
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers de jeu compatibles (*.gcm;*.iso;*.dol;*.wad;*.ciso;*.wbfs;*.wdf;*.wia;*.wbi)|*.gcm;*.iso;*.dol;*.wad;*.ciso;*.wbfs;*.wdf;*.wia;*.wbi|" "Sélection du jeu" "templogs\tempvar.txt"
	set /p game_source=<templogs\tempvar.txt
)
IF NOT "%game_source%"=="" (
	set "game_source=%game_source:"=%"
) else (
	IF /i "%enter_sources%"=="o" (
		goto:images_path
	) else (
		goto:start_cleanup
	)
)
IF NOT EXIST "%game_source%" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set game_source=
	goto:define_game_source
)
IF EXIST "%game_source%\*.*" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set game_source=
	goto:define_game_source
)
:skip_define_game_path
set "game_ext=%game_source:~-4,1%"
IF NOT "%game_ext%"=="." (
	set "game_ext=%game_source:~-4,4%"
) else (
	set "game_ext=%game_source:~-3,3%"
)
IF /i NOT "%enter_sources%"=="o" (
	goto:start_cleanup
)
:images_path
:test_iconTex
IF EXIST "SOURCE_FILES\iconTex.*" (
	for %%f in (SOURCE_FILES\iconTex.*) do (
		set "iconTex_source=%%f"
		goto:test_bootTvTex
	) 
)
:define_iconTex
echo Vous allez devoir sélectionner l'icône du jeu (taille d'image de 128x128). Si vous fermez la fenêtre qui s'ouvrira sans sélectionner de fichier, un icône par défaut sera copié. >con
pause >con
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers d\'image standard (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection de l\'icône du jeu" "templogs\tempvar.txt"
set /p iconTex_source=<templogs\tempvar.txt
IF NOT "%iconTex_source%"=="" (
	set "iconTex_source=%iconTex_source:"=%"
) else (
	goto:test_bootTvTex
)
IF NOT EXIST "%iconTex_source%" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set iconTex_source=
	goto:define_iconTex
) 
IF EXIST "%iconTex_source%\*.*" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set iconTex_source=
	goto:define_iconTex
) else (
	set "img_ext=%iconTex_source:~-3,3%"
)
TOOLS\ImageMagick\convert.exe "%iconTex_source%" SOURCE_FILES\iconTex.png
set default_icontex=Y
:test_bootTvTex
IF EXIST SOURCE_FILES\bootTvTex.* (
	for %%f in (SOURCE_FILES\bootTvTex.*) do (
		set "bootTvTex_source=%%f"
		goto:test_bootDrcTex
	)
)
:define_bootTvTex
echo Vous allez devoir sélectionner la banière TV du jeu (taille d'image de 1280x720). Si vous fermez la fenêtre qui s'ouvrira sans sélectionner de fichier, une banière TV par défaut sera copiée. >con
pause >con
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers d\'image standard (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection de la banière TV du jeu" "templogs\tempvar.txt"
set /p bootTvTex_source=<templogs\tempvar.txt
IF NOT "%bootTvTex_source%"=="" (
	set "bootTvTex_source=%bootTvTex_source:"=%"
) else (
	goto:test_bootDrcTex
)
IF NOT EXIST "%bootTvTex_source%" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set bootTvTex_source=
	goto:define_bootTvTex
)
IF EXIST "%bootTvTex_source%\*.*" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set bootTvTex_source=
	goto:define_bootTvTex
) else (
	set img_ext=%bootTvTex_source:~-3,3%
)
TOOLS\ImageMagick\convert.exe "%bootTvTex_source%" SOURCE_FILES\bootTvTex.png
set default_boottvtex=Y
:test_bootDrcTex
IF EXIST SOURCE_FILES\bootDrcTex.* (
	for %%f in (SOURCE_FILES\bootDrcTex.*) do (
		set "bootDrcTex_source=%%f"
		goto:test_bootLogoTex
	)
)
:define_bootDrcTex
echo Vous allez devoir sélectionner la banière Gamepad du jeu (taille d'image de 854x480), Fermez la fenêtre qui s'ouvrira si aucune. >con
pause >con
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers d\'image standard (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection de la banière Gamepad du jeu" "templogs\tempvar.txt"
set /p bootDrcTex_source=<templogs\tempvar.txt
IF NOT "%bootDrcTex_source%"=="" (
	set "bootDrcTex_source=%bootDrcTex_source:"=%"
) else (
	goto:test_bootLogoTex
)
IF NOT EXIST "%bootDrcTex_source%" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set bootDrcTex_source=
	goto:define_bootDrcTex
)
IF EXIST "%bootDrcTex_source%\*.*" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set bootDrcTex_source=
	goto:define_bootDrcTex
) else (
	set img_ext=%bootDrcTex_source:~-3,3%
)
TOOLS\ImageMagick\convert.exe "%bootDrcTex_source%" SOURCE_FILES\bootDrcTex.png
set default_bootdrctex=Y
:test_bootLogoTex
IF EXIST SOURCE_FILES\bootLogoTex.* (
	for %%f in (SOURCE_FILES\bootLogoTex.*) do (
		set "bootLogoTex_source=%%f
		goto:test_bootSound
	)
)
:define_bootLogoTex
echo Vous allez devoir sélectionner le logo de l'éditeur du jeu (taille d'image de 170x42), Fermez la fenêtre qui s'ouvrira si aucun. >con
pause >con
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers d\'image standard (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection du logo du jeu" "templogs\tempvar.txt"
set /p bootLogoTex_source=<templogs\tempvar.txt
IF NOT "%bootLogoTex_source%"=="" (
	set "bootLogoTex_source=%bootLogoTex_source:"=%"
) else (
	goto:test_bootSound
)
IF NOT EXIST "%bootLogoTex_source%" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set bootLogoTex_source=
	goto:define_bootLogoTex
)
IF EXIST "%bootLogoTex_source%\*.*" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set bootLogoTex_source=
	goto:define_bootLogoTex
) else (
	set img_ext=%bootLogoTex_source:~-3,3%
)
TOOLS\ImageMagick\convert.exe "%bootLogoTex_source%" SOURCE_FILES\bootLogoTex.png
set default_bootlogotex=Y
:test_bootSound
IF EXIST SOURCE_FILES\bootSound.wav (
	set bootSound_source=SOURCE_FILES\bootSound.wav
	goto:start_cleanup
)
IF EXIST SOURCE_FILES\bootSound.btsnd (
	set bootSound_source=SOURCE_FILES\bootSound.btsnd
	goto:start_cleanup
)
:define_bootSound
echo Vous allez devoir sélectionner le son de démarrage du jeu (6 secondes maximum), Fermez la fenêtre qui s'ouvrira si aucun. >con
pause >con
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier audio (*.wav;*.btsnd)|*.wav;*.btsnd|" "Sélection du bootsound du jeu" "templogs\tempvar.txt"
set /p bootSound_source=<templogs\tempvar.txt
IF NOT "%bootSound_source%"=="" (
	set "bootSound_source=%bootSound_source:"=%"
) else (
	goto:start_cleanup
)
IF NOT EXIST "%bootSound_source%" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set bootSound_source=
	goto:define_bootSound
)
IF EXIST "%bootSound_source%\*.*" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	set bootSound_source=
	goto:define_bootSound
) else (
	set "img_ext=%bootSound_source:~-4,1%"
)
IF "%img_ext%"=="." (
	set "img_ext=%bootSound_source:~-3,3%"
) else (
	set "img_ext=%bootSound_source:~-5,5%"
)
copy /V "%bootSound_source%" SOURCE_FILES\bootSound.%img_ext%
set default_bootsound=Y

:start_cleanup
::Cleanup existing WORKINGDIR if it exists
echo Nettoyage des répertoires résiduels... >con
IF EXIST WORKINGDIR (
	rmdir /s /q WORKINGDIR
)
IF EXIST temp (
	rmdir /s /q temp
)
IF EXIST SOURCE_FILES\temp (
	rmdir /s /q SOURCE_FILES\temp
)
IF EXIST SOURCE_FILES\wadtemp (
	rmdir /s /q SOURCE_FILES\wadtemp
)
IF EXIST ISOBUILDTEMP (
	rmdir /s /q ISOBUILDTEMP
)
IF EXIST templogs (
	rmdir /s /q templogs
)
IF EXIST getexttypepatcher.txt (
	del /q getexttypepatcher.txt
)
echo Effectué. >con
echo.>con

mkdir templogs
TOOLS\gnuwin32\bin\grep.exe -m 1 "url_compatibility" <TOOLS\Storage\WiiInjectScript.ini | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p ini_url_compatibility=<templogs\tempvar.txt
IF /i not "%ini_url_compatibility%"=="j" (
	set /p url_compatibility=Voulez-vous ouvrir la page permettant de vérifier la liste des jeux compatibles avec l'injection (jeux Wii uniquement^)? (O/n/J^): >con
)
IF NOT "%url_compatibility%"=="" set url_compatibility=%url_compatibility:~0,1%
IF /i "%url_compatibility%"=="j" echo url_compatibility=j>>TOOLS\Storage\WiiInjectScript.ini
IF /i "%url_compatibility%"=="o" (
	TOOLS\web\wii_compatibility_list.url
	pause >con
)
TOOLS\gnuwin32\bin\grep.exe -m 1 "url_templates" <TOOLS\Storage\WiiInjectScript.ini | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p ini_url_templates=<templogs\tempvar.txt
IF /i not "%ini_url_templates%"=="j" set /p url_templates=Voulez-vous ouvrir la page permettant de télécharger des templates (images et bootsound)? (O/n/J): >con
IF NOT "%url_templates%"=="" set url_templates=%url_templates:~0,1%
IF /i "%url_templates%"=="j" echo url_templates=j>>TOOLS\Storage\WiiInjectScript.ini
IF /i "%url_templates%"=="o" (
	TOOLS\web\images_templates.url
	pause >con
)

::Convert images to PNGs if they exist (To prevent possible errors in the user provided image)
:convert_bootTvTex
IF NOT EXIST "SOURCE_FILES\bootTvTex.png" (
	for %%f in (SOURCE_FILES\bootTvTex.*) do (
		TOOLS\ImageMagick\convert.exe %%f SOURCE_FILES\bootTvTex.png
		IF EXIST "SOURCE_FILES\bootTvTex.png" (
			set default_boottvtex=Y
			goto:convert_iconTex
		)
	)
)
:convert_iconTex
IF NOT EXIST "SOURCE_FILES\iconTex.png" (
	for %%f in (SOURCE_FILES\iconTex.*) do (
		TOOLS\ImageMagick\convert.exe %%f SOURCE_FILES\iconTex.png
		IF EXIST "SOURCE_FILES\iconTex.png" (
			set default_icontex=Y
			goto:convert_bootDrcTex
		)
	)
)
:convert_bootDrcTex
IF NOT EXIST "SOURCE_FILES\bootDrcTex.png" (
	for %%f in (SOURCE_FILES\bootDrcTex.*) do (
		TOOLS\ImageMagick\convert.exe %%f SOURCE_FILES\bootDrcTex.png
		IF EXIST "SOURCE_FILES\bootDrcTex.png" (
			set default_bootdrctex=Y
			goto:convert_bootLogoTex
		)
	)
)
:convert_bootLogoTex
IF NOT EXIST "SOURCE_FILES\bootLogoTex.png" (
	for %%f in (SOURCE_FILES\bootLogoTex.*) do (
		TOOLS\ImageMagick\convert.exe %%f SOURCE_FILES\bootLogoTex.png
		IF EXIST "SOURCE_FILES\bootLogoTex.png" (
			set default_bootlogotex=Y
			goto:set_preset_meta_vars
		)
	)
)

::Set preset meta variables
:set_preset_meta_vars
set BASEFOLDER="Rhythm Heaven Fever [VAKE01]"
:savedrandom
set SAVEDRANDOM=%random:~-1%%random:~-1%%random:~-1%%random:~-1%
TOOLS\gnuwin32\bin\grep.exe -m 1 "%SAVEDRANDOM%" <TOOLS\Storage\blacklist_ids.txt >templogs\tempvar.txt
set /p blacklist_id_verif=<templogs\tempvar.txt
IF NOT "%blacklist_id_verif%"=="" (
	set blacklist_id_verif=
	goto:savedrandom
)

::Check that all necessary source files exist
:check_game_sources
IF /i "%game_ext%"=="gcm" (
	set gamefile=game.gcm
	TOOLS\Wit\wit.exe DUMP "%game_source%" >templogs\dump.txt
	IF /i NOT "%gcd2_source_set%"=="Y" (
		IF "%gcd2_source%"=="" (
			set /p gcd2_source=Entrez le chemin du disque 2 de votre jeu Gamecube, laissez vide si aucun: >con
			set gcd2_source_set=Y
			IF "!gcd2_source!"=="*" (
				%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier de jeu Gamecube (*.gcm;*.iso)|*.gcm;*.iso|" "Sélection du disque 2 Gamecube du jeu" "templogs\tempvar.txt"
				set /p gcd2_source=<templogs\tempvar.txt
			)
		)
	)
	goto:skipiso
)
IF /i "%game_ext%"=="dol" (
	set gamefile=boot.dol
	set gametype=Homebrew
	goto:skipiso
)
IF /i "%game_ext%"=="wbfs" (
	set gamefile=game.wbfs
	set special_wii_format=wbfs
	TOOLS\Wit\wit.exe DUMP "%game_source%" >templogs\dump.txt
	goto:skipiso
)
IF /i "%game_ext%"=="wdf" (
	set gamefile=game.iso
	set special_wii_format=wdf
	TOOLS\Wit\wit.exe DUMP "%game_source%" >templogs\dump.txt
	goto:skipiso
)
IF /i "%game_ext%"=="wia" (
	set gamefile=game.iso
	set special_wii_format=wia
	TOOLS\Wit\wit.exe DUMP "%game_source%" >templogs\dump.txt
	goto:skipiso
)
IF /i "%game_ext%"=="ciso" (
	set gamefile=game.iso
	set special_wii_format=ciso
	TOOLS\Wit\wit.exe DUMP "%game_source%" >templogs\dump.txt
	goto:skipiso
)
IF /i "%game_ext%"=="wbi" (
	set gamefile=game.iso
	set special_wii_format=wbi
	TOOLS\Wit\wit.exe DUMP "%game_source%" >templogs\dump.txt
	goto:skipiso
)
IF /i "%game_ext%"=="wad" (
	set gamefile=game.wad
	set gametype=Wiiware
	set chanbooter=O
	TOOLS\Sharpii\Sharpii.exe WAD -i "%game_source%" | TOOLS\gnuwin32\bin\grep.exe "Title ID: " | TOOLS\gnuwin32\bin\grep.exe -v "Full Title ID:" | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 > templogs\id.txt
	set /p chanbooterid=<templogs\id.txt
	del /Q templogs\id.txt
	goto:wad_prep
)
IF /i "%game_ext%"=="iso" (
	set gamefile=game.iso
	set special_wii_format=iso
	TOOLS\Wit\wit.exe DUMP "%game_source%" >templogs\dump.txt
	goto:skipiso
)
set /p chanbooter=Voulez-vous créer une chaîne Wiivc Chan Booter? (O/n^): >con
IF NOT "%chanbooter%"=="" set chanbooter=%chanbooter:~0,1%
IF /i NOT "%chanbooter%"=="o" goto:create_nintendont_channel
:define_chanbooterid
set gamefile=boot.dol
set gametype=Wiiware
set /p chanbooterid=Quel sera l'ID de la chaîne Wii à lancer (si vide, la valeur sera OHBC^)? (4 chiffres ou/et lettres^): >con
IF "%chanbooterid%"=="" (
	set chanbooterid=OHBC
) else (
	call TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat chanbooterid
)
call TOOLS\Storage\functions\strlen.bat nb "%chanbooterid%"
IF NOT "%nb%"=="4" (
	echo Une Wiivc Chan Booter doit contenir exactement 4 lettres ou/et chiffres. Recommencez. >con
	set chanbooterid=
	set nb=
	goto:define_chanbooterid
)
set i=0
:check_chars_chanbooterid
IF %i% LEQ 3 (
	set check_chars_chanbooterid=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9) do (
		IF "!chanbooterid:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_chanbooterid=1
			goto:check_chars_chanbooterid
		)
	)
	IF "!check_chars_chanbooterid!"=="0" (
		echo Un caractère non autorisé a été saisie dans l'ID de la Wiivc Chan Booter. Recommencez. >con
		set chanbooterid=
		goto:define_chanbooterid
	)
)
goto:skip_wad_prep
:wad_prep
set chanbooterid=%chanbooterid:~1,5%
:skip_wad_prep
set WIITITLEID=%chanbooterid%
set /p chanbooter43=Voulez-vous forcer l'affichage de la Wiivc Chan Booter en 4/3? (O/n^): >con
IF NOT "%chanbooter43%"=="" set "chanbooter43=%chanbooter43:~0,1%"
goto:skipiso
:create_nintendont_channel
set /p createnintendontchannel=Voulez-vous créer une chaîne contenant seulement le forwarder pour Nintendont? (O/n): >con
IF NOT "%createnintendontchannel%"=="" set createnintendontchannel=%createnintendontchannel:~0,1%
IF /i "%createnintendontchannel%"=="o" (
	set game_source=SOURCE_FILES\boot.dol
	set gamefile=boot.dol
	set gametype=Homebrew
	copy /v TOOLS\Storage\nintendontFor.dol SOURCE_FILES\boot.dol
	IF "%bootSound_source%"=="" (
		set gc_bootsound=Y
		copy /v TOOLS\templates\GC_bootSound.wav SOURCE_FILES\bootSound.wav
	)
	goto:skipiso
)
goto:NOPE.AVI
:skipiso

::generate Title ID and preparing necessary files
IF NOT "%gametype%"=="Homebrew" (
	IF NOT "%gametype%"=="Wiiware" (
		TOOLS\gnuwin32\bin\grep.exe "File & disc type:" <templogs\dump.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^& -f 2 > templogs\dump2.txt
		set /p gametype=<templogs\dump2.txt
	)
)
IF "%gametype%"=="" goto:gamenotsupported
IF /i "%gametype%"=="  GameCube" (
	set url_repository=https://github.com/cucholix/wiivc-bis/raw/master/gcn/image/
	TOOLS\gnuwin32\bin\grep.exe "Disc & part IDs:" <templogs\dump.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^= -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^, -f 1 > templogs\dump2.txt
	set /p WIITITLEID=<templogs\dump2.txt
	IF "%gamefile%"=="game.iso" (
		set special_wii_format=
		set gamefile=game.gcm
		IF /i NOT "%gcd2_source_set%"=="Y" (
			IF "%gcd2_source%"=="" (
				:define_gcd2_source
				set /p gcd2_source=Entrez le chemin du disque 2 de votre jeu Gamecube, laissez vide si aucun: >con
				IF "!gcd2_source!"=="*" (
					%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier de jeu Gamecube (*.gcm;*.iso)|*.gcm;*.iso|" "Sélection du disque 2 Gamecube du jeu" "templogs\tempvar.txt"
					set /p gcd2_source=<templogs\tempvar.txt
				)
			)
		)
		IF "%bootSound_source%"=="" (
			set gc_bootsound=Y
			copy /V TOOLS\templates\GC_bootSound.wav SOURCE_FILES\bootSound.wav
			set bootsound_source=SOURCE_FILES\bootsound.wav
		)
	)
)
IF /i "%gametype%"=="  GameCube" (
	IF NOT "%gcd2_source%"=="" set "gcd2_source=%gcd2_source:"=%"
)
:check_gcd2_sources
IF /i "%gametype%"=="  GameCube" (
	IF NOT "%gcd2_source%"=="" (
		IF EXIST "%gcd2_source%" (
			IF EXIST "%gcd2_source%\*.*" (
				echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
				set gcd2_source=
				goto:define_gcd2_source
			)
			TOOLS\Wit\wit.exe DUMP "%gcd2_source%" >templogs\dump_gcd2.txt
			TOOLS\gnuwin32\bin\grep.exe "File & disc type:" <templogs\dump_gcd2.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^& -f 2 > templogs\dump2.txt
			set /p gametype_gcd2=<templogs\dump2.txt
		) else (
			echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
			set gcd2_source=
			goto:define_gcd2_source
		)
	)
)
IF /i "%gametype%"=="  GameCube" (
	IF NOT "%gcd2_source%"=="" (
		IF /i NOT "%gametype_gcd2%"=="  GameCube" (
			goto:gamenotsupported_gcd2
		)
	) 
)
:test_custommain
IF /i "%gametype%"=="  GameCube" (
	IF EXIST SOURCE_FILES\main.dol (
		set custommain_source=SOURCE_FILES\main.dol
		goto:skip_custommain
	)
	:define_custommain
	IF /i "%enter_sources%"=="o" (
		echo Vous allez devoir sélectionner un fichier pour qu'il remplace le forwarder de Nintendont par défaut (jeu Gamecube uniquement^), Fermez la fenêtre qui s'ouvrira si aucun. >con
		pause >con
		%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers d\'homebrew Wii (*.dol)|*.dol|" "Sélection du fichier personnalisé de Nintendont du jeu" "templogs\tempvar.txt"
		set /p custommain_source=<templogs\tempvar.txt
	)
	)
IF /i "%gametype%"=="  GameCube" (
	IF /i "%enter_sources%"=="o" (
			IF NOT "%custommain_source%"=="" (
			set "custommain_source=%custommain_source:"=%"
		) else (
			goto:skip_custommain
		)
	)
)
IF /i "%gametype%"=="  GameCube" (
	IF /i "%enter_sources%"=="o" (
		IF NOT EXIST "%custommain_source%" (
			echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
			set custommain_source=
			goto:define_custommain
		)
	)
)
IF /i "%gametype%"=="  GameCube" (
	IF /i "%enter_sources%"=="o" (
		IF EXIST "%custommain_source%\*.*" (
			echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
			set custommain_source=
			goto:define_custommain
		)
	)
)
IF /i "%gametype%"=="  GameCube" (
	IF /i "%enter_sources%"=="o" (
		copy /V "%custommain_source%" SOURCE_FILES\main.dol
		set default_custommain=Y
	)
)
:skip_custommain

IF /i "%gametype%"=="Wiiware" set url_repository=https://github.com/cucholix/wiivc-bis/raw/master/wiiware/image/
IF /i "%gametype%"=="  Wii" (
	set url_repository=https://github.com/cucholix/wiivc-bis/raw/master/wii/image/
	TOOLS\gnuwin32\bin\grep.exe "Disc & part IDs:" <templogs\dump.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^= -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^, -f 1 > templogs\dump2.txt
	set /p WIITITLEID=<templogs\dump2.txt
)
:test_cheats
IF /i "%gametype%"=="  Wii" (
	IF EXIST SOURCE_FILES\game.gct (
		set cheats_source=SOURCE_FILES\game.gct
		goto:skip_cheats
	)
	:define_cheats
	IF /i "%enter_sources%"=="o" (
		echo Vous allez devoir sélectionner le fichier de cheats au format gct du jeu (jeux Wii uniquement^), Fermez la fenêtre qui s'ouvrira si aucun. >con
		pause >con
		%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers cheats (*.gct)|*.gct|" "Sélection du fichier de cheats du jeu" "templogs\tempvar.txt"
		set /p cheats_source=<templogs\tempvar.txt
	)
)
IF /i "%gametype%"=="  Wii" (
	IF /i "%enter_sources%"=="o" (
		IF NOT "%cheats_source%"=="" (
			set "cheats_source=%cheats_source:"=%"
		) else (
			goto:skip_cheats
		)
	)
)
IF /i "%gametype%"=="  Wii" (
	IF /i "%enter_sources%"=="o" (
		IF NOT EXIST "%cheats_source%" (
			echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
			set cheats_source=
			goto:define_cheats
		)
	)
)
IF /i "%gametype%"=="  Wii" (
	IF /i "%enter_sources%"=="o" (
		IF EXIST "%cheats_source%\*.*" (
			echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
			set cheats_source=
			goto:define_cheats
		)
	)
)
IF /i "%gametype%"=="  Wii" (
	IF /i "%enter_sources%"=="o" (
		copy /V "%cheats_source%" SOURCE_FILES\game.gct
		set default_cheats=Y
	)
)
:skip_cheats

del /q templogs\dump2.txt
IF /i NOT "%gametype%"=="Homebrew" (
	set url_repository=%url_repository%%WIITITLEID%/
	set /p online_images=Souhaitez-vous tenter de télécharger les images pour votre jeu? (O/n^): >con
)
IF NOT "%online_images%"=="" set online_images=%online_images:~0,1%
IF /i "%online_images%"=="o" (
	TOOLS\gnuwin32\bin\wget.exe --no-check-certificate --spider -o templogs\wget_test.txt -S %url_repository%
	TOOLS\gnuwin32\bin\grep.exe "Status: 200 OK" <templogs\wget_test.txt >templogs\wget_test2.txt
	set /p wget_test=<templogs\wget_test2.txt
	del /q templogs\wget*.txt
)
IF /i "%online_images%"=="o" (
	IF NOT "%wget_test%"=="" (
		echo Le jeu a été trouvé sur le repository, le téléchargement des fichiers va avoir lieu. >con
		TOOLS\gnuwin32\bin\wget.exe --no-check-certificate -o templogs\wget_dl.txt -S -O SOURCE_FILES\bootTvTex.png %url_repository%bootTvTex.png
		TOOLS\gnuwin32\bin\wget.exe --no-check-certificate -o templogs\wget_dl.txt -S -O SOURCE_FILES\iconTex.png %url_repository%iconTex.png
		IF EXIST "SOURCE_FILES\bootTvTex.png" set default_boottvtex=Y
		IF EXIST "SOURCE_FILES\iconTex.png" set default_icontex=Y
	) else (
		echo Le jeu n'a pas été trouvé sur le repository, les fichiers  d'images sources vont être utilisées. >con
	)
)
title TeconMoon's WiiVC Injector Script
IF NOT EXIST "SOURCE_FILES\bootTVTex.png" (
	set default_boottvtex=Y
	echo Aucun fichier bootTVTex trouvé dans le dossier SOURCE_FILES, une image par défaut va être utilisée. >con
	copy /v TOOLS\templates\bootTVTex.png SOURCE_FILES\bootTVTex.png
)
IF NOT EXIST "SOURCE_FILES\iconTex.png" (
	set default_icontex=Y
	echo Aucun fichier iconTex.png trouvé dans le dossier SOURCE_FILES, une image par défaut va être utilisée. >con
	copy /v TOOLS\templates\iconTex.png SOURCE_FILES\iconTex.png
)
IF NOT EXIST "SOURCE_FILES\bootDrcTex.png" (
	set default_bootdrctex=Y
)
IF NOT EXIST "SOURCE_FILES\bootLogoTex.png" (
	set default_bootlogotex=Y
)
IF NOT EXIST "SOURCE_FILES\bootSound.wav" (
	IF NOT EXIST "SOURCE_FILES\bootSound.btsnd" (
		set default_bootsound=Y
	)
)

::Check if PNGs are actually PNGs and not renamed JPGs (Rename optional ones if invalid)
ver > nul
TOOLS\Storage\pngcheck.exe -q SOURCE_FILES\bootTVTex.png
if %errorlevel% GTR 0 (set valid1=INVALID) else (set valid1=VALID)
ver > nul
TOOLS\Storage\pngcheck.exe -q SOURCE_FILES\iconTex.png
if %errorlevel% GTR 0 (set valid2=INVALID) else (set valid2=VALID)
IF "%valid1%"=="INVALID" goto:invalidpng
IF "%valid2%"=="INVALID" goto:invalidpng
ver > nul
IF EXIST "SOURCE_FILES\bootDrcTex.png" TOOLS\Storage\pngcheck.exe -q SOURCE_FILES\bootDrcTex.png
IF EXIST "SOURCE_FILES\bootDrcTex.png" if %errorlevel% GTR 0 (echo Le fichier optionnel bootDrcTex.png est invalide, le fichier sera renommé avec l'extention .bad pour éviter les conflits pendant le script...>con) & (ren SOURCE_FILES\bootDrcTex.png bootDrcTex.png.bad)
IF EXIST "SOURCE_FILES\bootDrcTex.png" ver > nul & echo.>con
IF EXIST "SOURCE_FILES\bootLogoTex.png" TOOLS\Storage\pngcheck.exe -q SOURCE_FILES\bootLogoTex.png
IF EXIST "SOURCE_FILES\bootLogoTex.png" if %errorlevel% GTR 0 (echo Le fichier optionnel bootLogoTex.png est invalide, le fichier sera renommé avec l'extention .bad pour éviter les conflits pendant le script...>con) & (ren SOURCE_FILES\bootLogoTex.png bootLogoTex.png.bad)
IF EXIST "SOURCE_FILES\bootLogoTex.png" ver > nul & echo.>con

::Flag for if Title Key is wrong
goto:redoskip
:redokey
del /q TOOLS\Storage\BASETITLEKEY
echo.>con
echo La Title Key est incorrecte, réessayez.>con
echo.>con

::Check that Title IDs, Keys, etc already exist
:redoskip
set BASETITLEID=00050000101B0700
IF NOT EXIST "TOOLS\Storage\BASETITLEKEY" set /p BASETITLEKEY=Entrez ou copiez-collez la eShop Title Key pour Rhythm Heaven Fever [USA] (ne sera pas redemandée à l'avenir): >con
IF NOT EXIST "TOOLS\Storage\BASETITLEKEY" echo %BASETITLEKEY:~0,32%>TOOLS\Storage\BASETITLEKEY
set /p BASETITLEKEY=<TOOLS\Storage\BASETITLEKEY
if not "%BASETITLEKEY:~0,4%"=="04ea" goto:redokey
IF EXIST "TOOLS\NUSPacker\encryptKeyWith" goto:keyexist
echo.>con
set /p WiiUCommon=Entrez ou copiez-collez la Wii U Common Key (ne sera pas redemandée à l'avenir): >con
echo %WiiUCommon:~0,32%>TOOLS\NUSPacker\encryptKeyWith
echo http://ccs.cdn.wup.shop.nintendo.net/ccs/download>TOOLS\JNUSTool\config
echo %WiiUCommon:~0,32%>>TOOLS\JNUSTool\config
echo https://tagaya.wup.shop.nintendo.net/tagaya/versionlist/EUR/EU/latest_version>>TOOLS\JNUSTool\config
echo https://tagaya-wup.cdn.nintendo.net/tagaya/versionlist/EUR/EU/list/%d.versionlist>>TOOLS\JNUSTool\config
:keyexist

::Set ID/Key variables and check them
IF NOT EXIST TOOLS\c2w\starbuck_key.txt (set ancast=0000) else (set /p ancast=<TOOLS\c2w\starbuck_key.txt)
set /p WiiUCommon=<TOOLS\NUSPacker\encryptKeyWith
if not "%WiiUCommon:~0,4%"=="D7B0" (
	del TOOLS\NUSPacker\encryptKeyWith
	del TOOLS\JNUSTool\config
	echo.>con
	echo La Wii U Common Key est incorrecte, réessayez>con
	echo.>con
	goto:redoskip
)
echo.>con


::Prompt user for variables
echo Meta Variables: >con
:LineQuestion
echo Combien de lignes votre nom de jeu utilisera? >con
set /p LINEDECIDE=[1/2:] >con
echo.>con
IF "%LINEDECIDE%"=="1" GOTO:LINE1
IF "%LINEDECIDE%"=="2" GOTO:LINE2
GOTO:LINEQUESTION

:LINE1
echo Entrez le nom du jeu. >con
set /p GAMENAME=[Nom du jeu:] >con
call TOOLS\Storage\functions\strlen.bat nb "%GAMENAME%"
IF %nb% EQU 0 (
	echo Le nom du jeu ne peut être vide. Réessayez. >con
	goto:LINE1
)
IF %nb% GTR 32 (
	echo Le Nombre de caractère saisie doit être de 32 caractères maximum. Réessayez. >con
	set GAMENAME=
	goto:LINE1
)
set i=0
:check_chars_GAMENAME
IF %i% LSS %nb% (
	set check_chars_GAMENAME=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 - _ ^& à â é è ê ë î ï ô ö ù û ü ç æ œ € ° © ¤) do (
		IF "!GAMENAME:~%i%,1!"==" " (
			set /a i+=1
			set check_chars_GAMENAME=1
			goto:check_chars_GAMENAME
		)
		IF "!GAMENAME:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_GAMENAME=1
			goto:check_chars_GAMENAME
		)
	)
	IF "!check_chars_GAMENAME!"=="0" (
		echo Un caractère non autorisé a été saisie dans le titre du jeu. Recommencez. >con
		set GAMENAME=
		goto:LINE1
	)
)
echo.>con
call TOOLS\Storage\functions\replace_chars.bat GAMENAME_xml "%GAMENAME%" %nb%
GOTO:RestOfParameters

:LINE2
echo Entrez une version courte du nom du jeu. >con
set /p GAMENAME=[Nom cours du jeu:] >con
call TOOLS\Storage\functions\strlen.bat nb "%GAMENAME%"
IF %nb% EQU 0 (
	echo Le nom du jeu ne peut être vide. Réessayez. >con
	goto:LINE2
)
IF %nb% GTR 32 (
	echo Le Nombre de caractère saisie doit être de 32 caractères maximum. Réessayez. >con
	set GAMENAME=
	goto:LINE2
)
set i=0
:check_chars_GAMENAME0
IF %i% LSS %nb% (
	set check_chars_GAMENAME=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 - _ ^& à â é è ê ë î ï ô ö ù û ü ç æ œ € ° © ¤) do (
		IF "!GAMENAME:~%i%,1!"==" " (
			set /a i+=1
			set check_chars_GAMENAME=1
			goto:check_chars_GAMENAME0
		)
		IF "!GAMENAME:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_GAMENAME=1
			goto:check_chars_GAMENAME0
		)
	)
	IF "!check_chars_GAMENAME!"=="0" (
		echo Un caractère non autorisé a été saisie dans le titre du jeu. Recommencez. >con
		set GAMENAME=
		goto:LINE2
	)
)
echo.>con
call TOOLS\Storage\functions\replace_chars.bat GAMENAME_xml "%GAMENAME%" %nb%

:define_GAMENAME1
echo Entrez la première ligne du nom du jeu. >con
set /p GAMENAME1=[Ligne 1 du nom du jeu:] >con
call TOOLS\Storage\functions\strlen.bat nb "%GAMENAME1%"
IF %nb% EQU 0 (
	echo La première ligne du nom du jeu ne peut être vide. Réessayez. >con
	goto:define_GAMENAME1
)
IF %nb% GTR 32 (
	echo Le Nombre de caractère saisie doit être de 32 caractères maximum. Réessayez. >con
	set GAMENAME1=
	goto:define_GAMENAME1
)
set i=0
:check_chars_GAMENAME1
IF %i% LSS %nb% (
	set check_chars_GAMENAME1=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 - _ ^& à â é è ê ë î ï ô ö ù û ü ç æ œ € ° © ¤) do (
		IF "!GAMENAME1:~%i%,1!"==" " (
			set /a i+=1
			set check_chars_GAMENAME1=1
			goto:check_chars_GAMENAME1
		)
		IF "!GAMENAME1:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_GAMENAME1=1
			goto:check_chars_GAMENAME1
		)
	)
	IF "!check_chars_GAMENAME1!"=="0" (
		echo Un caractère non autorisé a été saisie dans la première ligne du nom du jeu. Recommencez. >con
		set GAMENAME1=
		goto:define_GAMENAME1
	)
)
echo.>con
call TOOLS\Storage\functions\replace_chars.bat GAMENAME1_xml "%GAMENAME1%" %nb%

:define_GAMENAME2
echo Entrez la seconde ligne du nom du jeu. >con
set /p GAMENAME2=[Ligne 2 du nom du jeu:] >con
call TOOLS\Storage\functions\strlen.bat nb "%GAMENAME2%"
IF %nb% EQU 0 (
	echo La seconde ligne du nom du jeu ne peut être vide. Réessayez. >con
	goto:define_GAMENAME2
)
IF %nb% GTR 32 (
	echo Le Nombre de caractère saisie doit être de 32 caractères maximum. Réessayez. >con
	set GAMENAME2=
	goto:define_GAMENAME2
)
set i=0
:check_chars_GAMENAME2
IF %i% LSS %nb% (
	set check_chars_GAMENAME2=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 - _ ^& à â é è ê ë î ï ô ö ù û ü ç æ œ € ° © ¤) do (
		IF "!GAMENAME2:~%i%,1!"==" " (
			set /a i+=1
			set check_chars_GAMENAME2=1
			goto:check_chars_GAMENAME2
		)
		IF "!GAMENAME2:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_GAMENAME2=1
			goto:check_chars_GAMENAME2
		)
	)
	IF "!check_chars_GAMENAME2!"=="0" (
		echo Un caractère non autorisé a été saisie dans la seconde ligne du nom du jeu. Recommencez. >con
		set GAMENAME2=
		goto:define_GAMENAME2
	)
)
echo.>con
call TOOLS\Storage\functions\replace_chars.bat GAMENAME2_xml "%GAMENAME2%" %nb%

:RestOfParameters
:define_PUBTITLE
set /p PUBTITLE=Entrez l'éditeur du jeu, peut être vide: >con
IF "%PUBTITLE%"=="" goto:define_parentalcontrol
call TOOLS\Storage\functions\strlen.bat nb "%PUBTITLE%"
IF %nb% GTR 32 (
	echo Le Nombre de caractère saisie doit être de 32 caractères maximum. Réessayez. >con
	set PUBTITLE=
	goto:define_PUBTITLE
)
set i=0
:check_chars_PUBTITLE
IF %i% LSS %nb% (
	set check_chars_PUBTITLE=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 - _ ^& à â é è ê ë î ï ô ö ù û ü ç æ œ € ° © ¤) do (
		IF "!PUBTITLE:~%i%,1!"==" " (
			set /a i+=1
			set check_chars_PUBTITLE=1
			goto:check_chars_PUBTITLE
		)
		IF "!PUBTITLE:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_PUBTITLE=1
			goto:check_chars_PUBTITLE
		)
	)
	IF "!check_chars_PUBTITLE!"=="0" (
		echo Un caractère non autorisé a été saisie dans l'éditeur du jeu. Recommencez. >con
		set PUBTITLE=
		goto:define_PUBTITLE
	)
)
call TOOLS\Storage\functions\replace_chars.bat PUBTITLE_xml "%PUBTITLE%" %nb%
:define_parentalcontrol
set /p parentalcontrol=Entrez un âge minimum pour le blocage du contrôle parental, peut être vide? (chiffres de 1 à 18): >con
IF "%parentalcontrol%"=="" goto:skip_parentalcontrol
call TOOLS\Storage\functions\strlen.bat nb "%parentalcontrol%"
IF %nb% GTR 2 (
	echo Le Nombre de caractère saisie doit être de 2 caractères maximum. Réessayez. >con
	set parentalcontrol=
	goto:define_parentalcontrol
)
set i=0
:check_chars_parentalcontrol
IF %i% LSS %nb% (
	set check_chars_parentalcontrol=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!parentalcontrol:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_parentalcontrol=1
			goto:check_chars_parentalcontrol
		)
	)
	IF "!check_chars_parentalcontrol!"=="0" (
		echo Un caractère non autorisé a été saisie dans lecontrôle parental du jeu. Recommencez. >con
		set parentalcontrol=
		goto:define_parentalcontrol
	)
)
IF "!parentalcontrol!:~0,1!"=="0" set parentalcontrol=%parentalcontrol:~1,1%
IF %parentalcontrol% GTR 18 (
	echo Le contrôle parental ne peut aller que jusqu'à 18. Réessayez. >con
	set parentalcontrol=
	goto:define_parentalcontrol
)
:set_pc_cero
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (18 17 15 12 0) do (
		IF %%f EQU %%g (
			set pc_cero=%%f
			goto:set_pc_esrb
		)
	)
)
:set_pc_esrb
IF %parentalcontrol% LSS 3 (
	set pc_esrb=3
	goto:set_pc_usk
)
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (17 13 10 6 3) do (
		IF %%f EQU %%g (
			set pc_esrb=%%f
			goto:set_pc_usk
		)
	)
)
:set_pc_usk
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (18 16 12 6 0) do (
		IF %%f EQU %%g (
			set pc_usk=%%f
			goto:set_pc_pegi_gen
		)
	)
)
:set_pc_pegi_gen
IF %parentalcontrol% LSS 3 (
	set pc_pegi_gen=3
	goto:set_pc_pegi_prt
)
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (18 16 12 7 3) do (
		IF %%f EQU %%g (
			set pc_pegi_gen=%%f
			goto:set_pc_pegi_prt
		)
	)
)
:set_pc_pegi_prt
IF %parentalcontrol% LSS 4 (
	set pc_pegi_prt=4
	goto:set_pc_pegi_bbfc
)
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (18 16 12 6 4) do (
		IF %%f EQU %%g (
			set pc_pegi_prt=%%f
			goto:set_pc_pegi_bbfc
		)
	)
)
:set_pc_pegi_bbfc
IF %parentalcontrol% LSS 3 (
	set pc_pegi_bbfc=3
	goto:set_pc_cob
)
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (18 16 15 12 8 7 4 3) do (
		IF %%f EQU %%g (
			set pc_pegi_bbfc=%%f
			goto:set_pc_cob
		)
	)
)
:set_pc_cob
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (18 15 13 8 0) do (
		IF %%f EQU %%g (
			set pc_cob=%%f
			goto:set_pc_grb
		)
	)
)
:set_pc_grb
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (18 15 12 0) do (
		IF %%f EQU %%g (
			set pc_grb=%%f
			goto:set_pc_cgsrr
		)
	)
)
:set_pc_cgsrr
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (18 12 6 0) do (
		IF %%f EQU %%g (
			set pc_cgsrr=%%f
			goto:set_pc_oflc
		)
	)
)
:set_pc_oflc
FOR /l %%f in (%parentalcontrol%, -1, 0) do (
	FOR %%g in (15 13 8 0) do (
		IF %%f EQU %%g (
			set pc_oflc=%%f
			goto:skip_parentalcontrol
		)
	)
)
:skip_parentalcontrol
IF /i NOT "%default_gamefile%"=="Y" (
	IF "%game_source:~0,12%"=="SOURCE_FILES" (
		IF /i "%chanbooter%"=="o" (
			IF "%gamefile%"=="game.wad" set /p delsources=Voulez-vous supprimer  les fichiers source du jeu pendant le script? (O/n^): >con
		) else (
			IF /i NOT "%createnintendontchannel%"=="o" set /p delsources=Voulez-vous supprimer  les fichiers source du jeu pendant le script? (O/n^): >con
		)
	)
)
IF NOT "%delsource%"=="" set delsource=%delsource:~0,1%
IF /i "%createnintendontchannel%"=="o" set delsources=O
IF "%gamefile%"=="game.wad" (
	set /p wadgetexttypepatcher=Voulez-vous utiliser "GetExtTypePatcher", utiles pour les vieux jeux Wiiwares (les Wiimotes ne fonctionneront plus sur ce jeu avec ce patch^) (inutile de l'utiliser pour les homebrews^)? (O/n^): >con
)
IF NOT "%wadgetexttypepatcher%"=="" set wadgetexttypepatcher=%wadgetexttypepatcher:~0,1%
IF /i "%wadgetexttypepatcher%"=="o" (
	set DRC_USE=65537
	goto:setup_gamepad
)
IF /i NOT "%wadgetexttypepatcher%"=="" goto:setup_controler
IF "%gamefile%"=="game.gcm" (
	echo.>con
	IF EXIST SOURCE_FILES\main.dol set /p custommain=Fichier main.dol détecté, voulez-vous qu'il remplace le loader de Nintendont par défaut? (O/n^): >con
)
IF NOT "%custommain%"=="" set custommain=%custommain:~0,1%
IF /i "%custommain%"=="o" goto:skipgcmoptions
IF "%gamefile%"=="game.gcm" set /p autoboot=Voulez-vous que le jeu boot automatiquement? Cela nécessitera d'avoir un fichier nincfg.bin existant à la racine de votre carte SD. (O/n): >con
IF NOT "%autoboot%"=="" set autoboot=%autoboot:~0,1%
IF /i "%autoboot%"=="o" (
	echo.>con
	echo Voulez-vous forcer l'affichage de Nintendont en 4/3? Même si les options "Force Widescreen" et "WiiU Widescreen" sont activées>con
	set /p aspectratio=dans votre fichier  nincfg.bin, elles ne seront pas prisent en compte. (O/n^): >con
)
IF NOT "%aspectratio%"=="" set aspectratio=%aspectratio:~0,1%
IF /i "%aspectratio%"=="o" goto:skipgcmoptions
IF /i "%autoboot%"=="o" (
	echo.>con
	set /p nintendont_force_wiiu_widescreen=Voulez-vous forcer uniquement l'option Wii U Widescreen de Nintendont, utile si vous avez un jeu utilisant des cheats lui permettant d'être en widescreen? Cette option sera forcée sur on et l'option Widescreen sera forcée sur off, quelque soit la configuration du fichier nincfg.bin. (O/n^): >con
)
IF NOT "%nintendont_force_wiiu_widescreen%"=="" set nintendont_force_wiiu_widescreen=%nintendont_force_wiiu_widescreen:~0,1%
:skipgcmoptions
echo.>con
:setup_controler
TOOLS\gnuwin32\bin\grep.exe -m 1 "CLASSICDECIDE" <TOOLS\Storage\WiiInjectScript.ini | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p ini_CLASSICDECIDE=<templogs\tempvar.txt
IF /I not "%ini_CLASSICDECIDE%"=="j" (
	echo ATTENTION: Emuler les manettes avec  le GamePad ne fonctionne pas pour un bon nombre de jeux.>con
	set /p CLASSICDECIDE=Voulez-vous utiliser le GamePad? (O/n/J^): >con
)
IF NOT "%CLASSICDECIDE%"=="" set CLASSICDECIDE=%CLASSICDECIDE:~0,1%
IF /i "%CLASSICDECIDE%"=="j" echo CLASSICDECIDE=j>>TOOLS\Storage\WiiInjectScript.ini
IF /i "%CLASSICDECIDE%"=="o" (
	set DRC_USE=65537
) else (
	set DRC_USE=1
)
IF /i "%createnintendontchannel%"=="o" goto:skipcontrolprompt
IF "%gamefile%"=="game.gcm" goto:skipcontrolprompt
IF "%DRC_USE%"=="65537" set /p REMOTEEMU=Voulez-vous émuler la télécommande Wii à la place du Classic Controller? (O/n): >con
IF NOT "%REMOTEEMU%"=="" set REMOTEEMU=%REMOTEEMU:~0,1%
IF /i "%REMOTEEMU%"=="n" (
	:setup_gamepad
	set /p ZLZRswap=Voulez-vous swaper les boutons L ^& R  avec ZL ^& ZR? (O/n^): >con
	set /p instantcc=Voulez-vous utiliser le patch "-instantcc" avec nfs2iso2nfs? (O/n^): >con
	IF /i "%chanbooter%"=="o" goto:skipcontrolprompt
	IF NOT "%gamefile%"=="boot.dol" set /p getexttypepatcher=Voulez-vous utiliser "GetExtTypePatcher", utiles pour les vieux jeux Wii (les Wiimotes ne fonctionneront plus sur ce jeu avec ce patch^)? (O/n^): >con
)
IF NOT "%ZLZRswap%"=="" set ZLZRswap=%ZLZRswap:~0,1%
IF NOT "%instantcc%"=="" set instantcc=%instantcc:~0,1%
IF NOT "%getexttypepatcher%"=="" set getexttypepatcher=%getexttypepatcher:~0,1%
IF /i "%REMOTEEMU%"=="o" (
	set /p REMOTEEMUPATCH=Utiliser l'émulation verticale ou horizontale de la télécommande Wii? (V/h^): >con
	set /p nocc=Voulez-vous utiliser le patch "nocc" avec nfs2iso2nfs? (O/n^): >con
)
IF NOT "%REMOTEEMUPATCH%"=="" set REMOTEEMUPATCH=%REMOTEEMUPATCH:~0,1%
IF NOT "%nocc%"=="" set nocc=%nocc:~0,1%
:skipcontrolprompt
echo.>con
IF "%gamefile%"=="boot.dol" (
	IF /i NOT "%createnintendontchannel%"=="o" goto:setoverclockandotherstuff
)
IF "%gamefile%"=="game.wad" goto:setoverclockandotherstuff
goto:skipoverclockstuff
:setoverclockandotherstuff
echo Voulez-vous activer l'option Wii Remote passthrough?>con
IF /i "%chanbooter%"=="o" echo ATTENTION: Cette option n'est à activer que pour les homebrews, pas pour les Wiiwares. >con
set /p passcheck=Si vous ne le faites pas, les télécommandes Wii ne pouront pas être utilisée en même temps que le GamePad. (O/n^): >con
IF NOT "%passcheck%"=="" set passcheck=%passcheck:~0,1%
IF /i "%passcheck%"=="o" set passpatch= -passthrough
echo.>con
echo Voulez-vous appliquer le patch à  cafe2wii pour votre homebrew? Cela débloquera la vitesse du processeur de la Wii VC.>con
IF "%gamefile%"=="game.wad" echo ATTENTION: N'utilisez pas cela pour les Wiiwares car cela plantera probablement. Activez cela seulement avec les homebrew qui le supporte.>con
set /p overclock=ATTENTION: Cela peut faire planter votre homebrew s'il ne supporte pas cette fonction. (O/n): >con
IF NOT "%overclock%"=="" set overclock=%overclock:~0,1%
echo.>con
IF /i NOT "%overclock%"=="o" goto:skipoverclockstuff
:recheckancast
IF NOT "%ancast:~0,4%"=="B5D8" (echo.>con) & (set /p ancast=Entrez ou copiez-collez la Wii U Starbuck Ancast Key (ne sera pas redemandée à l'avenir^): >con)
IF NOT "%ancast:~0,4%"=="B5D8" (echo.>con) & (echo La Wii U Starbuck Ancast Key est incorrecte, réessayez.>con) & (goto:recheckancast)
echo %ancast:~0,32%>TOOLS\c2w\starbuck_key.txt
echo.>con
IF /i "%overclock%"=="o" set /p c2wpatches=Voulez-vous utiliser l'option "-iop2x" pour l'overclock, à activer uniquement si vous savez se que vous faites? (O/n): >con
IF NOT "%c2wpatches%"=="" set c2wpatches=%c2wpatches:~0,1%
IF /i "%c2wpatches%"=="o" set c2wpatches=-iop2x
:skipoverclockstuff
IF /i "%gametype%"=="  Wii" (
	set /p wiivideopatch=Voulez-vous patcher le mode vidéo de votre jeu Wii avec Wii-vmc pendant l'injection? (O/n^): >con
	IF EXIST SOURCE_FILES\game.gct (
		echo Un fichier game.gct a été détecté, souhaitez-vous vraiment l'intégrer au jeu? >con
		echo Notez que cela peut ne pas fonctionner et les codes seront toujours actifs sur cette version du jeu. >con
		set /p cheatspatch=Confirmez-vous le patch du jeu avec les codes? (O/n^): >con
	)
	set /p dont_trim=Souhaitez-vous que le jeu ne soit pas trimé ou scrubé pendant la conversion, à activer seulement en cas de problèmes? (O/n^): >con
)
IF NOT "%wiivideopatch%"=="" set wiivideopatch=%wiivideopatch:~0,1%
IF NOT "%cheatspatch%"=="" set cheatspatch=%cheatspatch:~0,1%
IF NOT "%dont_trim%"=="" set dont_trim=%dont_trim:~0,1%
echo Souhaitez-vous spécifier un meta title ID manuellement?>con
set /p TITLEDECIDE=Si vous ne le faites pas, il sera définie au hasard. (O/n): >con
IF NOT "%TITLEDECIDE%"=="" set TITLEDECIDE=%TITLEDECIDE:~0,1%
:define_SAVEDRANDOM
IF /i "%TITLEDECIDE%"=="o" set /p SAVEDRANDOM=Entrez les 4-digit meta title ID que vous voulez utiliser. Ne doit être que des valeurs HEXA (0-F): >con
IF /i "%TITLEDECIDE%"=="o" call TOOLS\Storage\functions\strlen.bat nb "%SAVEDRANDOM%"
IF /i "%TITLEDECIDE%"=="o" (
	IF NOT "%nb%"=="4" (
		echo Le meta title ID doit absolument contenir 4 caractères HEXA. Recommencez. >con
		set nb=
		set SAVEDRANDOM=
		goto:define_SAVEDRANDOM
	)
	CALL TOOLS\Storage\functions\CONV_VAR_to_min.bat SAVEDRANDOM
)
set i=0
:check_chars_SAVEDRANDOM
IF %i% LEQ 3 (
	set check_chars_SAVEDRANDOM=0
	FOR %%z in (a b c d e f 0 1 2 3 4 5 6 7 8 9) do (
		IF "!SAVEDRANDOM:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_SAVEDRANDOM=1
			goto:check_chars_SAVEDRANDOM
		)
	)
	IF "!check_chars_SAVEDRANDOM!"=="0" (
		echo Un caractère non autorisé a été saisie dans le meta title ID. Recommencez. >con
		set SAVEDRANDOM=
		goto:define_SAVEDRANDOM
	)
)
IF /i "%TITLEDECIDE%"=="o" (
	TOOLS\gnuwin32\bin\grep.exe -m 1 "%SAVEDRANDOM%" <TOOLS\Storage\blacklist_ids.txt >templogs\tempvar.txt
	set /p blacklist_id_verif=<templogs\tempvar.txt
)
IF NOT "%blacklist_id_verif%"=="" (
	echo Cet ID est dans la blacklist, impossible de l'utiliser de nouveau. Veuillez en utiliser un autre. >con
	set blacklist_id_verif=
	set SAVEDRANDOM=
	goto:define_SAVEDRANDOM
)
IF /i "%TITLEDECIDE%"=="o" CALL TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat SAVEDRANDOM
IF /i NOT "%chanbooter%"=="o" (
	IF "%gamefile%"=="boot.dol" set WIITITLEID=%SAVEDRANDOM%
)
echo.>con
IF EXIST SOURCE_FILES\bootSound.wav set /p AUDIOPROMPT=Bootsound détecté, souhaitez-vous qu'il boucle? (O/n): >con
IF NOT "%AUDIOPROMPT%"=="" set AUDIOPROMPT=%AUDIOPROMPT:~0,1%
IF /i "%AUDIOPROMPT%"=="n" set LOOP=-noLoop
IF EXIST SOURCE_FILES\bootSound.wav echo.>con
Setlocal disabledelayedexpansion

::JNUSTool - download the necessary source files
cd TOOLS\JNUSTool
IF NOT EXIST 0005001010004000\code\deint.txt goto:downloadjnus
IF NOT EXIST 0005001010004000\code\font.bin goto:downloadjnus
IF NOT EXIST 0005001010004001\code\c2w.img goto:downloadjnus
IF NOT EXIST 0005001010004001\code\boot.bin goto:downloadjnus
IF NOT EXIST 0005001010004001\code\dmcu.d.hex goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\code\cos.xml goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\code\frisbiiU.rpx goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\code\fw.img goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\code\fw.tmd goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\code\htk.bin goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\code\nn_hai_user.rpl goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\content\assets\shaders\cafe\banner.gsh goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\content\assets\shaders\cafe\fade.gsh goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\meta\bootMovie.h264 goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\meta\bootLogoTex.tga goto:downloadjnus
IF NOT EXIST %BASEFOLDER%\meta\bootSound.btsnd goto:downloadjnus
(echo Les téléchargements avec JNUSTool ont été passés, les fichiers existent déjà...>con) & (goto:skipjnus)
:downloadjnus
echo Vérification de la connexion internet...>con
ver > nul
%windir%\system32\PING.EXE google.com
if %errorlevel% GTR 0 goto:netfail
echo Téléchargement des fichiers de base  nécessaires avec JNUSTool...>con
java -jar JNUSTool.jar 0005001010004000 -file /code/deint.txt
java -jar JNUSTool.jar 0005001010004000 -file /code/font.bin
java -jar JNUSTool.jar 0005001010004001 -file /code/c2w.img
java -jar JNUSTool.jar 0005001010004001 -file /code/boot.bin
java -jar JNUSTool.jar 0005001010004001 -file /code/dmcu.d.hex
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /code/cos.xml
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /code/frisbiiU.rpx
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /code/fw.img
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /code/fw.tmd
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /code/htk.bin
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /code/nn_hai_user.rpl
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /content/assets/.*
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /meta/bootMovie.h264
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /meta/bootLogoTex.tga
java -jar JNUSTool.jar %BASETITLEID% %BASETITLEKEY% -file /meta/bootSound.btsnd
echo Terminé!>con
echo.>con
:skipjnus
echo Copie des fichiers de bases de  JNUSTool dans le répertoire de travail...>con
%windir%\System32\Robocopy.exe %BASEFOLDER% ..\..\WORKINGDIR\ /MIR
IF /i "%overclock%"=="o" (
	%windir%\System32\Robocopy.exe 0005001010004000 ..\..\WORKINGDIR\ *.* /s
	%windir%\System32\Robocopy.exe 0005001010004001 ..\..\WORKINGDIR\ *.* /s
)
cd ..\..\
IF /i NOT "%overclock%"=="o" goto:skipoverclockpatching
echo Patch c2w.img...>con
cd TOOLS\c2w
copy /V "..\..\WORKINGDIR\code\c2w.img" "c2w.img"
c2w_patcher.exe %c2wpatches% -nc
del /q c2w.img
move "c2p.img" "..\..\WORKINGDIR\code\c2w.img"
cd ..\..\
:skipoverclockpatching
IF NOT EXIST WORKINGDIR goto:robofail
echo Terminé!>con
echo.>con

::app.xml generation based on 4-digit random code
echo Génération du fichier app.xml...>con
cd WORKINGDIR\code
echo ^<?xml version="1.0" encoding="utf-8"?^>>app.xml
echo ^<app type="complex" access="777"^>>>app.xml
echo   ^<version type="unsignedInt" length="4"^>16^</version^>>>app.xml
echo   ^<os_version type="hexBinary" length="8"^>000500101000400A^</os_version^>>>app.xml
echo   ^<title_id type="hexBinary" length="8"^>0005000010%SAVEDRANDOM%FF^</title_id^>>>app.xml
echo   ^<title_version type="hexBinary" length="2"^>0000^</title_version^>>>app.xml
echo   ^<sdk_version type="unsignedInt" length="4"^>21204^</sdk_version^>>>app.xml
echo   ^<app_type type="hexBinary" length="4"^>8000002E^</app_type^>>>app.xml
echo   ^<group_id type="hexBinary" length="4"^>0000%SAVEDRANDOM%^</group_id^>>>app.xml
echo   ^<os_mask type="hexBinary" length="32"^>0000000000000000000000000000000000000000000000000000000000000000^</os_mask^>>>app.xml
echo   ^<common_id type="hexBinary" length="8"^>0000000000000000^</common_id^>>>app.xml
echo ^</app^>>>app.xml
cd ..\..\
echo Terminé! >con
echo.>con

::meta.xml generation based on Wii Title ID / 4-digit random code
echo Génération du fichier meta.xml...>con
cd WORKINGDIR\meta
echo ^<?xml version="1.0" encoding="utf-8"?^>>meta.xml
echo ^<menu type="complex" access="777"^>>>meta.xml
echo   ^<version type="unsignedInt" length="4"^>33^</version^>>>meta.xml
echo   ^<product_code type="string" length="32"^>WUP-N-%WIITITLEID:~0,4%^</product_code^>>>meta.xml
echo   ^<content_platform type="string" length="32"^>WUP^</content_platform^>>>meta.xml
echo   ^<company_code type="string" length="8"^>0001^</company_code^>>>meta.xml
echo   ^<mastering_date type="string" length="32"^>^</mastering_date^>>>meta.xml
echo   ^<logo_type type="unsignedInt" length="4"^>0^</logo_type^>>>meta.xml
echo   ^<app_launch_type type="hexBinary" length="4"^>00000000^</app_launch_type^>>>meta.xml
echo   ^<invisible_flag type="hexBinary" length="4"^>00000000^</invisible_flag^>>>meta.xml
echo   ^<no_managed_flag type="hexBinary" length="4"^>00000000^</no_managed_flag^>>>meta.xml
echo   ^<no_event_log type="hexBinary" length="4"^>00000002^</no_event_log^>>>meta.xml
echo   ^<no_icon_database type="hexBinary" length="4"^>00000000^</no_icon_database^>>>meta.xml
echo   ^<launching_flag type="hexBinary" length="4"^>00000004^</launching_flag^>>>meta.xml
echo   ^<install_flag type="hexBinary" length="4"^>00000000^</install_flag^>>>meta.xml
echo   ^<closing_msg type="unsignedInt" length="4"^>0^</closing_msg^>>>meta.xml
echo   ^<title_version type="unsignedInt" length="4"^>0^</title_version^>>>meta.xml
echo   ^<title_id type="hexBinary" length="8"^>0005000010%SAVEDRANDOM%FF^</title_id^>>>meta.xml
echo   ^<group_id type="hexBinary" length="4"^>0000%SAVEDRANDOM%^</group_id^>>>meta.xml
echo   ^<boss_id type="hexBinary" length="8"^>0000000000000000^</boss_id^>>>meta.xml
echo   ^<os_version type="hexBinary" length="8"^>000500101000400A^</os_version^>>>meta.xml
echo   ^<app_size type="hexBinary" length="8"^>0000000000000000^</app_size^>>>meta.xml
echo   ^<common_save_size type="hexBinary" length="8"^>0000000000000000^</common_save_size^>>>meta.xml
echo   ^<account_save_size type="hexBinary" length="8"^>0000000000000000^</account_save_size^>>>meta.xml
echo   ^<common_boss_size type="hexBinary" length="8"^>0000000000000000^</common_boss_size^>>>meta.xml
echo   ^<account_boss_size type="hexBinary" length="8"^>0000000000000000^</account_boss_size^>>>meta.xml
echo   ^<save_no_rollback type="unsignedInt" length="4"^>0^</save_no_rollback^>>>meta.xml
echo   ^<join_game_id type="hexBinary" length="4"^>00000000^</join_game_id^>>>meta.xml
echo   ^<join_game_mode_mask type="hexBinary" length="8"^>0000000000000000^</join_game_mode_mask^>>>meta.xml
echo   ^<bg_daemon_enable type="unsignedInt" length="4"^>0^</bg_daemon_enable^>>>meta.xml
echo   ^<olv_accesskey type="unsignedInt" length="4"^>3921400692^</olv_accesskey^>>>meta.xml
echo   ^<wood_tin type="unsignedInt" length="4"^>0^</wood_tin^>>>meta.xml
echo   ^<e_manual type="unsignedInt" length="4"^>0^</e_manual^>>>meta.xml
echo   ^<e_manual_version type="unsignedInt" length="4"^>0^</e_manual_version^>>>meta.xml
echo   ^<region type="hexBinary" length="4"^>00000002^</region^>>>meta.xml
IF "%parentalcontrol%"=="" (
	echo   ^<pc_cero type="unsignedInt" length="4"^>128^</pc_cero^>>>meta.xml
	echo   ^<pc_esrb type="unsignedInt" length="4"^>128^</pc_esrb^>>>meta.xml
	echo   ^<pc_bbfc type="unsignedInt" length="4"^>192^</pc_bbfc^>>>meta.xml
	echo   ^<pc_usk type="unsignedInt" length="4"^>128^</pc_usk^>>>meta.xml
	echo   ^<pc_pegi_gen type="unsignedInt" length="4"^>128^</pc_pegi_gen^>>>meta.xml
	echo   ^<pc_pegi_fin type="unsignedInt" length="4"^>192^</pc_pegi_fin^>>>meta.xml
	echo   ^<pc_pegi_prt type="unsignedInt" length="4"^>128^</pc_pegi_prt^>>>meta.xml
	echo   ^<pc_pegi_bbfc type="unsignedInt" length="4"^>128^</pc_pegi_bbfc^>>>meta.xml
	echo   ^<pc_cob type="unsignedInt" length="4"^>128^</pc_cob^>>>meta.xml
	echo   ^<pc_grb type="unsignedInt" length="4"^>128^</pc_grb^>>>meta.xml
	echo   ^<pc_cgsrr type="unsignedInt" length="4"^>128^</pc_cgsrr^>>>meta.xml
	echo   ^<pc_oflc type="unsignedInt" length="4"^>128^</pc_oflc^>>>meta.xml
) else (
	echo   ^<pc_cero type="unsignedInt" length="4"^>%pc_cero%^</pc_cero^>>>meta.xml
	echo   ^<pc_esrb type="unsignedInt" length="4"^>%pc_esrb%^</pc_esrb^>>>meta.xml
	echo   ^<pc_bbfc type="unsignedInt" length="4"^>192^</pc_bbfc^>>>meta.xml
	echo   ^<pc_usk type="unsignedInt" length="4"^>%pc_usk%^</pc_usk^>>>meta.xml
	echo   ^<pc_pegi_gen type="unsignedInt" length="4"^>%pc_pegi_gen%^</pc_pegi_gen^>>>meta.xml
	echo   ^<pc_pegi_fin type="unsignedInt" length="4"^>192^</pc_pegi_fin^>>>meta.xml
	echo   ^<pc_pegi_prt type="unsignedInt" length="4"^>%pc_pegi_prt%^</pc_pegi_prt^>>>meta.xml
	echo   ^<pc_pegi_bbfc type="unsignedInt" length="4"^>%pc_pegi_bbfc%^</pc_pegi_bbfc^>>>meta.xml
	echo   ^<pc_cob type="unsignedInt" length="4"^>%pc_cob%^</pc_cob^>>>meta.xml
	echo   ^<pc_grb type="unsignedInt" length="4"^>%pc_grb%^</pc_grb^>>>meta.xml
	echo   ^<pc_cgsrr type="unsignedInt" length="4"^>%pc_cgsrr%^</pc_cgsrr^>>>meta.xml
	echo   ^<pc_oflc type="unsignedInt" length="4"^>%pc_oflc%^</pc_oflc^>>>meta.xml
)
echo   ^<pc_reserved0 type="unsignedInt" length="4"^>192^</pc_reserved0^>>>meta.xml
echo   ^<pc_reserved1 type="unsignedInt" length="4"^>192^</pc_reserved1^>>>meta.xml
echo   ^<pc_reserved2 type="unsignedInt" length="4"^>192^</pc_reserved2^>>>meta.xml
echo   ^<pc_reserved3 type="unsignedInt" length="4"^>192^</pc_reserved3^>>>meta.xml
echo   ^<ext_dev_nunchaku type="unsignedInt" length="4"^>0^</ext_dev_nunchaku^>>>meta.xml
echo   ^<ext_dev_classic type="unsignedInt" length="4"^>0^</ext_dev_classic^>>>meta.xml
echo   ^<ext_dev_urcc type="unsignedInt" length="4"^>0^</ext_dev_urcc^>>>meta.xml
echo   ^<ext_dev_board type="unsignedInt" length="4"^>0^</ext_dev_board^>>>meta.xml
echo   ^<ext_dev_usb_keyboard type="unsignedInt" length="4"^>0^</ext_dev_usb_keyboard^>>>meta.xml
echo   ^<ext_dev_etc type="unsignedInt" length="4"^>0^</ext_dev_etc^>>>meta.xml
echo   ^<ext_dev_etc_name type="string" length="512"^>^</ext_dev_etc_name^>>>meta.xml
echo   ^<eula_version type="unsignedInt" length="4"^>0^</eula_version^>>>meta.xml
echo   ^<drc_use type="unsignedInt" length="4"^>%DRC_USE%^</drc_use^>>>meta.xml
echo   ^<network_use type="unsignedInt" length="4"^>0^</network_use^>>>meta.xml
echo   ^<online_account_use type="unsignedInt" length="4"^>0^</online_account_use^>>>meta.xml
echo   ^<direct_boot type="unsignedInt" length="4"^>0^</direct_boot^>>>meta.xml
echo   ^<reserved_flag0 type="hexBinary" length="4"^>00010001^</reserved_flag0^>>>meta.xml
echo   ^<reserved_flag1 type="hexBinary" length="4"^>00080023^</reserved_flag1^>>>meta.xml
echo   ^<reserved_flag2 type="hexBinary" length="4"^>53583445^</reserved_flag2^>>>meta.xml
echo   ^<reserved_flag3 type="hexBinary" length="4"^>00000000^</reserved_flag3^>>>meta.xml
echo   ^<reserved_flag4 type="hexBinary" length="4"^>00000000^</reserved_flag4^>>>meta.xml
echo   ^<reserved_flag5 type="hexBinary" length="4"^>00000000^</reserved_flag5^>>>meta.xml
echo   ^<reserved_flag6 type="hexBinary" length="4"^>00000003^</reserved_flag6^>>>meta.xml
echo   ^<reserved_flag7 type="hexBinary" length="4"^>00000005^</reserved_flag7^>>>meta.xml
IF %LINEDECIDE%==2 (
echo   ^<longname_ja type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_ja^>>>meta.xml
echo   ^<longname_en type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_en^>>>meta.xml
echo   ^<longname_fr type="string" length="512"^>%GAMENAME1%_xml>>meta.xml
echo %GAMENAME2_xml%^</longname_fr^>>>meta.xml
echo   ^<longname_de type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_de^>>>meta.xml
echo   ^<longname_it type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_it^>>>meta.xml
echo   ^<longname_es type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_es^>>>meta.xml
echo   ^<longname_zhs type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_zhs^>>>meta.xml
echo   ^<longname_ko type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_ko^>>>meta.xml
echo   ^<longname_nl type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_nl^>>>meta.xml
echo   ^<longname_pt type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_pt^>>>meta.xml
echo   ^<longname_ru type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_ru^>>>meta.xml
echo   ^<longname_zht type="string" length="512"^>%GAMENAME1_xml%>>meta.xml
echo %GAMENAME2_xml%^</longname_zht^>>>meta.xml
)
IF "%LINEDECIDE%"=="1" (
echo   ^<longname_ja type="string" length="512"^>%GAMENAME_xml%^</longname_ja^>>>meta.xml
echo   ^<longname_en type="string" length="512"^>%GAMENAME_xml%^</longname_en^>>>meta.xml
echo   ^<longname_fr type="string" length="512"^>%GAMENAME_xml%^</longname_fr^>>>meta.xml
echo   ^<longname_de type="string" length="512"^>%GAMENAME_xml%^</longname_de^>>>meta.xml
echo   ^<longname_it type="string" length="512"^>%GAMENAME_xml%^</longname_it^>>>meta.xml
echo   ^<longname_es type="string" length="512"^>%GAMENAME_xml%^</longname_es^>>>meta.xml
echo   ^<longname_zhs type="string" length="512"^>%GAMENAME_xml%^</longname_zhs^>>>meta.xml
echo   ^<longname_ko type="string" length="512"^>%GAMENAME_xml%^</longname_ko^>>>meta.xml
echo   ^<longname_nl type="string" length="512"^>%GAMENAME_xml%^</longname_nl^>>>meta.xml
echo   ^<longname_pt type="string" length="512"^>%GAMENAME_xml%^</longname_pt^>>>meta.xml
echo   ^<longname_ru type="string" length="512"^>%GAMENAME_xml%^</longname_ru^>>>meta.xml
echo   ^<longname_zht type="string" length="512"^>%GAMENAME_xml%^</longname_zht^>>>meta.xml
)
echo   ^<shortname_ja type="string" length="256"^>%GAMENAME_xml%^</shortname_ja^>>>meta.xml
echo   ^<shortname_en type="string" length="256"^>%GAMENAME_xml%^</shortname_en^>>>meta.xml
echo   ^<shortname_fr type="string" length="256"^>%GAMENAME_xml%^</shortname_fr^>>>meta.xml
echo   ^<shortname_de type="string" length="256"^>%GAMENAME_xml%^</shortname_de^>>>meta.xml
echo   ^<shortname_it type="string" length="256"^>%GAMENAME_xml%^</shortname_it^>>>meta.xml
echo   ^<shortname_es type="string" length="256"^>%GAMENAME_xml%^</shortname_es^>>>meta.xml
echo   ^<shortname_zhs type="string" length="256"^>%GAMENAME_xml%^</shortname_zhs^>>>meta.xml
echo   ^<shortname_ko type="string" length="256"^>%GAMENAME_xml%^</shortname_ko^>>>meta.xml
echo   ^<shortname_nl type="string" length="256"^>%GAMENAME_xml%^</shortname_nl^>>>meta.xml
echo   ^<shortname_pt type="string" length="256"^>%GAMENAME_xml%^</shortname_pt^>>>meta.xml
echo   ^<shortname_ru type="string" length="256"^>%GAMENAME_xml%^</shortname_ru^>>>meta.xml
echo   ^<shortname_zht type="string" length="256"^>%GAMENAME_xml%^</shortname_zht^>>>meta.xml
echo   ^<publisher_ja type="string" length="256"^>%PUBTITLE_xml%^</publisher_ja^>>>meta.xml
echo   ^<publisher_en type="string" length="256"^>%PUBTITLE_xml%^</publisher_en^>>>meta.xml
echo   ^<publisher_fr type="string" length="256"^>%PUBTITLE_xml%^</publisher_fr^>>>meta.xml
echo   ^<publisher_de type="string" length="256"^>%PUBTITLE_xml%^</publisher_de^>>>meta.xml
echo   ^<publisher_it type="string" length="256"^>%PUBTITLE_xml%^</publisher_it^>>>meta.xml
echo   ^<publisher_es type="string" length="256"^>%PUBTITLE_xml%^</publisher_es^>>>meta.xml
echo   ^<publisher_zhs type="string" length="256"^>%PUBTITLE_xml%^</publisher_zhs^>>>meta.xml
echo   ^<publisher_ko type="string" length="256"^>%PUBTITLE_xml%^</publisher_ko^>>>meta.xml
echo   ^<publisher_nl type="string" length="256"^>%PUBTITLE_xml%^</publisher_nl^>>>meta.xml
echo   ^<publisher_pt type="string" length="256"^>%PUBTITLE_xml%^</publisher_pt^>>>meta.xml
echo   ^<publisher_ru type="string" length="256"^>%PUBTITLE_xml%^</publisher_ru^>>>meta.xml
echo   ^<publisher_zht type="string" length="256"^>%PUBTITLE_xml%^</publisher_zht^>>>meta.xml
echo   ^<add_on_unique_id0 type="hexBinary" length="4"^>00000000^</add_on_unique_id0^>>>meta.xml
echo   ^<add_on_unique_id1 type="hexBinary" length="4"^>00000000^</add_on_unique_id1^>>>meta.xml
echo   ^<add_on_unique_id2 type="hexBinary" length="4"^>00000000^</add_on_unique_id2^>>>meta.xml
echo   ^<add_on_unique_id3 type="hexBinary" length="4"^>00000000^</add_on_unique_id3^>>>meta.xml
echo   ^<add_on_unique_id4 type="hexBinary" length="4"^>00000000^</add_on_unique_id4^>>>meta.xml
echo   ^<add_on_unique_id5 type="hexBinary" length="4"^>00000000^</add_on_unique_id5^>>>meta.xml
echo   ^<add_on_unique_id6 type="hexBinary" length="4"^>00000000^</add_on_unique_id6^>>>meta.xml
echo   ^<add_on_unique_id7 type="hexBinary" length="4"^>00000000^</add_on_unique_id7^>>>meta.xml
echo   ^<add_on_unique_id8 type="hexBinary" length="4"^>00000000^</add_on_unique_id8^>>>meta.xml
echo   ^<add_on_unique_id9 type="hexBinary" length="4"^>00000000^</add_on_unique_id9^>>>meta.xml
echo   ^<add_on_unique_id10 type="hexBinary" length="4"^>00000000^</add_on_unique_id10^>>>meta.xml
echo   ^<add_on_unique_id11 type="hexBinary" length="4"^>00000000^</add_on_unique_id11^>>>meta.xml
echo   ^<add_on_unique_id12 type="hexBinary" length="4"^>00000000^</add_on_unique_id12^>>>meta.xml
echo   ^<add_on_unique_id13 type="hexBinary" length="4"^>00000000^</add_on_unique_id13^>>>meta.xml
echo   ^<add_on_unique_id14 type="hexBinary" length="4"^>00000000^</add_on_unique_id14^>>>meta.xml
echo   ^<add_on_unique_id15 type="hexBinary" length="4"^>00000000^</add_on_unique_id15^>>>meta.xml
echo   ^<add_on_unique_id16 type="hexBinary" length="4"^>00000000^</add_on_unique_id16^>>>meta.xml
echo   ^<add_on_unique_id17 type="hexBinary" length="4"^>00000000^</add_on_unique_id17^>>>meta.xml
echo   ^<add_on_unique_id18 type="hexBinary" length="4"^>00000000^</add_on_unique_id18^>>>meta.xml
echo   ^<add_on_unique_id19 type="hexBinary" length="4"^>00000000^</add_on_unique_id19^>>>meta.xml
echo   ^<add_on_unique_id20 type="hexBinary" length="4"^>00000000^</add_on_unique_id20^>>>meta.xml
echo   ^<add_on_unique_id21 type="hexBinary" length="4"^>00000000^</add_on_unique_id21^>>>meta.xml
echo   ^<add_on_unique_id22 type="hexBinary" length="4"^>00000000^</add_on_unique_id22^>>>meta.xml
echo   ^<add_on_unique_id23 type="hexBinary" length="4"^>00000000^</add_on_unique_id23^>>>meta.xml
echo   ^<add_on_unique_id24 type="hexBinary" length="4"^>00000000^</add_on_unique_id24^>>>meta.xml
echo   ^<add_on_unique_id25 type="hexBinary" length="4"^>00000000^</add_on_unique_id25^>>>meta.xml
echo   ^<add_on_unique_id26 type="hexBinary" length="4"^>00000000^</add_on_unique_id26^>>>meta.xml
echo   ^<add_on_unique_id27 type="hexBinary" length="4"^>00000000^</add_on_unique_id27^>>>meta.xml
echo   ^<add_on_unique_id28 type="hexBinary" length="4"^>00000000^</add_on_unique_id28^>>>meta.xml
echo   ^<add_on_unique_id29 type="hexBinary" length="4"^>00000000^</add_on_unique_id29^>>>meta.xml
echo   ^<add_on_unique_id30 type="hexBinary" length="4"^>00000000^</add_on_unique_id30^>>>meta.xml
echo   ^<add_on_unique_id31 type="hexBinary" length="4"^>00000000^</add_on_unique_id31^>>>meta.xml
echo ^</menu^>>>meta.xml
cd ..\..\
echo Terminé!>con
echo.>con

::Convert source PNGs to TGA
echo Convertion des fichiers images sources au format TGA...>con
cd TOOLS\png2tga
png2tgacmd.exe -i .\..\..\SOURCE_FILES\iconTex.png -o .\..\..\WORKINGDIR\meta --width=128 --height=128 --tga-bpp=32 --tga-compression=none
png2tgacmd.exe -i .\..\..\SOURCE_FILES\bootTvTex.png -o .\..\..\WORKINGDIR\meta --width=1280 --height=720 --tga-bpp=24 --tga-compression=none
IF NOT EXIST "..\..\SOURCE_FILES\bootDrcTex.png" (copy /V "..\..\SOURCE_FILES\bootTvTex.png" "..\..\SOURCE_FILES\bootDrcTex.png")
png2tgacmd.exe -i .\..\..\SOURCE_FILES\bootDrcTex.png -o .\..\..\WORKINGDIR\meta --width=854 --height=480 --tga-bpp=24 --tga-compression=none
IF EXIST "..\..\SOURCE_FILES\bootLogoTex.png" png2tgacmd.exe -i .\..\..\SOURCE_FILES\bootLogoTex.png -o .\..\..\WORKINGDIR\meta --width=170 --height=42 --tga-bpp=32 --tga-compression=none
title TeconMoon's WiiVC Injector Script
cd ..\..\
echo Terminé!>con
echo.>con

:: Use sox and wav2btsnd to convert the source wav file to the necessary btsnd file, or copy a user created one
IF EXIST "SOURCE_FILES\bootSound.btsnd" (
	echo Copie du fichier btsnd inclu par l'utilisateur dans le répertoire de travail...>con
	del "WORKINGDIR\meta\bootSound.btsnd"
	copy /V "SOURCE_FILES\bootSound.btsnd" "WORKINGDIR\meta\bootSound.btsnd"
	echo Terminé!>con
	echo.>con
	goto:skipsound
)
IF EXIST "SOURCE_FILES\bootSound.wav" goto:convertbootsound
goto:skipsound
:convertbootsound
echo Convertion du fichier wav inclu par l'utilisateur vers le format btsnd...>con
del "WORKINGDIR\meta\bootSound.btsnd"
mkdir TEMP
TOOLS\sox\sox.exe .\SOURCE_FILES\bootSound.wav -b 16 .\TEMP\bootSound_prep.wav channels 2 rate 48k trim 0 6
java -jar TOOLS\Storage\wav2btsnd.jar -in .\TEMP\bootSound_prep.wav -out .\WORKINGDIR\meta\bootSound.btsnd %LOOP%
rmdir /s /q TEMP
echo Terminé!>con
echo.>con
:skipsound

::Check that code and meta folders contain the necessary contents
echo Vérification des dossiers code et meta ...>con
::Auto-generated after JNUSTool downloads
IF NOT EXIST WORKINGDIR\code\app.xml goto:metafail
IF NOT EXIST WORKINGDIR\meta\meta.xml goto:metafail
::Downloaded by JNUSTool
IF NOT EXIST WORKINGDIR\code\cos.xml goto:metafail
IF NOT EXIST WORKINGDIR\code\frisbiiU.rpx goto:metafail
IF NOT EXIST WORKINGDIR\code\fw.img goto:metafail
IF NOT EXIST WORKINGDIR\code\fw.tmd goto:metafail
IF NOT EXIST WORKINGDIR\code\htk.bin goto:metafail
IF NOT EXIST WORKINGDIR\code\nn_hai_user.rpl goto:metafail
IF NOT EXIST WORKINGDIR\content\assets\shaders\cafe\banner.gsh goto:metafail
IF NOT EXIST WORKINGDIR\content\assets\shaders\cafe\fade.gsh goto:metafail
IF NOT EXIST WORKINGDIR\meta\bootLogoTex.tga goto:metafail
IF NOT EXIST WORKINGDIR\meta\bootMovie.h264 goto:metafail
::Converted from user provided files, optionally bootSound.btsnd
IF NOT EXIST WORKINGDIR\meta\bootSound.btsnd goto:metafail
IF NOT EXIST WORKINGDIR\meta\bootTvTex.tga goto:metafail
IF NOT EXIST WORKINGDIR\meta\bootDrcTex.tga goto:metafail
IF NOT EXIST WORKINGDIR\meta\iconTex.tga goto:metafail
echo Terminé!>con
echo.>con

::WIT - prepare the game file and extract the ticket/TMD afterwards
IF "%gamefile%"=="game.wad" (
	IF /i "%wadgetexttypepatcher%"=="o" (
		goto:wadstuff
	) else (
		goto:chanbooterstuff
	)
)
if /i "%chanbooter%"=="o" goto:chanbootstuff
IF "%gamefile%"=="game.gcm" goto:gcmstuff
IF "%gamefile%"=="boot.dol" goto:dolstuff
goto:isostuff
:gcmstuff
echo Préparation du jeu Gamecube et du forwader de Nintendont.>con
%windir%\System32\Robocopy.exe TOOLS\HOMEBREWBASE TEMP /MIR
copy /V "%game_source%" TEMP\files\game.iso
IF NOT "%gcd2_source%"=="" copy /V "%gcd2_source%" TEMP\files\disc2.iso
IF /i "%aspectratio%"=="o" (echo Forçage de l'aspect ratio de  Nintendont...>con) & (copy /V TOOLS\Storage\nintendont43.dol TEMP\sys\main.dol)
IF "%nintendont_force_wiiu_widescreen%"=="o" (echo Remplacement du forwarder de  Nintendont par la version wiiu_widescreen_only...>con) & (copy /V TOOLS\Storage\nintendont_wiiu_fullscreen_only.dol TEMP\sys\main.dol)
IF /i "%autoboot%"=="n" (echo Remplacement du forwarder de  Nintendont par la version non-autobootable...>con) & (copy /V TOOLS\Storage\nintendontFor.dol TEMP\sys\main.dol)
IF /i "%custommain%"=="o" (echo Remplacement du forwarder de Nintendont par le fichier main.dol inclu par l'utilisateur...>con) & (copy /V SOURCE_FILES\main.dol TEMP\sys\main.dol)
echo Terminé! >con
echo.>con
goto:repackISO
:dolstuff
echo Préparation de l'injection du homebrew...>con
%windir%\System32\Robocopy.exe TOOLS\HOMEBREWBASE TEMP /MIR
copy /V "%game_source%" TEMP\sys\main.dol
echo Terminé! >con
echo.>con
goto:repackISO
:wadstuff
echo Patch du fichier game.wad grâce à GetExtTypePatcher...>con
TOOLS\Sharpii\Sharpii.exe WAD -u "%game_source%" SOURCE_FILES\wadtemp -cid -lots
copy /v log.txt templogs\log1.txt
for %%f in (SOURCE_FILES\wadtemp\*.app) do (
	TOOLS\Storage\GetExtTypePatcher.exe %%f -nc >templogs\getexttypepatcher1.txt
	TOOLS\gnuwin32\bin\grep.exe "Wrote back into dol" <templogs\getexttypepatcher1.txt >templogs\getexttypepatcher2.txt
	set /p getextpatch=<templogs\getexttypepatcher2.txt
	TOOLS\gnuwin32\bin\tail.exe <templogs\getexttypepatcher1.txt >>templogs\getexttypepatcher.txt
)
IF "%getextpatch%"=="Wrote back into dol" (
	set getextpatch=Y
)
IF "%getextpatch%"=="Y" (
	IF "%uwuhs_launch%"=="Y" (
		set packed_dir=..\..\Packed
	) else (
		set packed_dir=Packed
	)
	IF NOT EXIST %packed_dir%\*.* (
		del /q %packed_dir% 2>nul
		mkdir %packed_dir%
	)
)
IF /i "%getextpatch%"=="y" TOOLS\Sharpii\sharpii.exe WAD -p SOURCE_FILES\wadtemp %packed_dir%\game_patched.wad -f -lots
rmdir /s/q SOURCE_FILES\wadtemp
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\log1.txt >templogs\count.txt
set /p count=<templogs\count.txt
set /a count+=2
echo Terminé!>con
echo.>con
:chanbootstuff
echo Préparation des fichiers pour créer une Wiivc Chan Booter...>con
%windir%\System32\Robocopy.exe TOOLS\HOMEBREWBASE TEMP /MIR
del /Q TEMP\sys\main.dol
if /i "%chanbooter43%"=="o" (
	copy /V "TOOLS\wiivc_chan_booter\43.dol" "TEMP\sys\main.dol"
) else (
	copy /V "TOOLS\wiivc_chan_booter\classic.dol" "TEMP\sys\main.dol"
)
echo %chanbooterid%>TEMP\files\title.txt"
echo Terminé!>con
echo.>con
goto:repackISO
:isostuff
::Converting specials formats of Wii games to iso
IF not "%special_wii_format%"=="" (
	IF NOT "%special_wii_format%"=="iso" (
		echo Convertion %special_wii_format% en ISO...>con
		IF /i "%dont_trim%"=="o" (
			TOOLS\wit\wit.exe copy "%game_source%" -d SOURCE_FILES\game.iso --raw -I
		) else (
			TOOLS\wit\wit.exe copy "%game_source%" -d SOURCE_FILES\game.iso -I
		)
		echo Terminé! >con
		echo.>con
	)
)
IF "%special_wii_format%"=="iso" (
	IF /i "%wit_iso_first_error%"=="y" (
		echo Convertion %special_wii_format% en ISO...>con
		IF EXIST SOURCE_FILES\game2.iso (
			IF /i "%dont_trim%"=="o" (
				TOOLS\wit\wit.exe copy "SOURCE_FILES\game2.iso" -d SOURCE_FILES\game.iso --raw -I
			) else (
				TOOLS\wit\wit.exe copy "SOURCE_FILES\game2.iso" -d SOURCE_FILES\game.iso -I
			)
		) else (
			IF /i "%dont_trim%"=="o" (
				TOOLS\wit\wit.exe copy "%game_source%" -d SOURCE_FILES\game.iso --raw -I
			) else (
				TOOLS\wit\wit.exe copy "%game_source%" -d SOURCE_FILES\game.iso -I
			)
		)
	echo Terminé! >con
	echo.>con
	)
)
echo Extraction du fichier  game.iso...>con
IF NOT EXIST SOURCE_FILES\game.iso (
	IF /i "%dont_trim%"=="o" (
		TOOLS\wit\wit.exe extract "%game_source%" --DEST TEMP --psel raw -vv1
	) else (
		TOOLS\wit\wit.exe extract "%game_source%" --DEST TEMP --psel data -vv1
	)
) else (
	IF /i "%dont_trim%"=="o" (
		TOOLS\wit\wit.exe extract "SOURCE_FILES\game.iso" --DEST TEMP --psel raw -vv1
	) else (
		TOOLS\wit\wit.exe extract "SOURCE_FILES\game.iso" --DEST TEMP --psel data -vv1
	)
)
IF not "%special_wii_format%"=="" (
	IF NOT "%special_wii_format%"=="iso" (
		del /q "SOURCE_FILES\game.iso"
	)
)
IF /i "%wit_iso_first_error%"=="y" (
	del /q SOURCE_FILES\game.iso
	IF EXIST SOURCE_FILES\game2.iso move SOURCE_FILES\game2.iso SOURCE_FILES\game.iso
)
IF /i "%wiivideopatch%"=="o" TOOLS\wii-vmc\wii-vmc.exe temp\sys\main.dol >con
IF /i "%getexttypepatcher%"=="o" (
	TOOLS\Storage\GetExtTypePatcher.exe temp\sys\main.dol -nc >templogs\getexttypepatcher.txt
	copy /v log.txt templogs\log1.txt
	TOOLS\gnuwin32\bin\grep.exe "Wrote back into dol" <templogs\getexttypepatcher.txt >templogs\getexttypepatcher2.txt
	set /p getextpatch=<templogs\getexttypepatcher2.txt
)
IF /i "%getexttypepatcher%"=="o" (
	IF NOT "%getextpatch%"=="" (
		set getextpatch=Y
	) else (
		set getextpatch="n"
	)
	TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\log1.txt >templogs\count.txt
	set /p count=<templogs\count.txt
	set /a count+=2
)
IF /i "%cheatspatch%"=="O" (
	move SOURCE_FILES\game.gct SOURCE_FILES\%WIITITLEID%.gct
	TOOLS\WIT\wstrt.exe patch temp\sys\main.dol --add-section SOURCE_FILES\%WIITITLEID%.gct
	move SOURCE_FILES\%WIITITLEID%.gct SOURCE_FILES\game.gct
)
echo Terminé!>con
echo.>con

:repackISO
echo Préparation du jeu pour la convertion NFS...>con
IF /i "%dont_trim%"=="o" (
	TOOLS\wit\wit.exe copy TEMP --DEST ISOBUILDTEMP\game.iso -ovv --raw --links --iso
) else (
	TOOLS\wit\wit.exe copy TEMP --DEST ISOBUILDTEMP\game.iso -ovv --links --iso
)
IF NOT EXIST ISOBUILDTEMP\game.iso goto:WITfail
echo Terminé!>con
echo.>con
IF /i "%delsources%"=="o" (
	echo Suppression du jeu du dossier SOURCE_FILES... >con
	cd SOURCE_FILES
	mkdir temp
	move bootTvTex.* temp
	move iconTex.* temp
	move bootDrcTex.* temp
	move bootLogoTex.* temp
	move bootSound.* temp
	IF EXIST game.gct move game.gct temp\
	IF EXIST main.dol move main.dol temp\
	IF "%gamefile%"=="game.wad" (
		IF /i "%wadgetexttypepatcher%"=="o" move game_patched.wad temp\
	)
	del /Q *.*
	cd temp
	move *.* ..
	cd ..
	rmdir /s/q temp
	cd ..
	echo Terminé!>con
	echo.>con
)
echo Extraction des fichiers Ticket et TMD...>con
rmdir /s /q TEMP
TOOLS\wit\wit.exe extract ISOBUILDTEMP\game.iso --psel data --files +tmd.bin --files +ticket.bin --dest TIKTEMP -vv1
copy /V TIKTEMP\tmd.bin WORKINGDIR\code\rvlt.tmd
copy /V TIKTEMP\ticket.bin WORKINGDIR\code\rvlt.tik
rmdir /s /q TIKTEMP
echo Terminé!>con
echo.>con

::Set flags for NFS2ISO2NFS patches
set nfspatch=
IF /i "%REMOTEEMU%"=="o" (
	IF /i "%REMOTEEMUPATCH%"=="h" (
		set nfspatch= -horizontal
	) else (
		set nfspatch= -wiimote
	)
)
IF /i "%ZLZRswap%"=="o" set nfspatch= -lrpatch
IF /i "%instantcc%"=="o" set nfspatch=%nfspatch% -instantcc
IF /i "%nocc%"=="o" set nfspatch=%nfspatch% -nocc

::nfs2iso2nfs - Convert the prepared ISO to NFS files
echo Convertion NFS avec Nfs2iso2nfs...>con
cd WORKINGDIR\content
IF "%gamefile%"=="game.gcm" ..\..\TOOLS\Storage\nfs2iso2nfs.exe -enc -homebrew -passthrough -iso "..\..\ISOBUILDTEMP\game.iso"
IF "%gamefile%"=="boot.dol" (
	IF /i "%createnintendontchannel%"=="o" (
		..\..\TOOLS\Storage\nfs2iso2nfs.exe -enc -homebrew -passthrough -iso "..\..\ISOBUILDTEMP\game.iso"
	) else (
		..\..\TOOLS\Storage\nfs2iso2nfs.exe -enc -homebrew%passpatch%%nfspatch% -iso "..\..\ISOBUILDTEMP\game.iso"
	)
)
IF "%gamefile%"=="game.wad" ..\..\TOOLS\Storage\nfs2iso2nfs.exe -enc -homebrew%passpatch%%nfspatch% -iso "..\..\ISOBUILDTEMP\game.iso"
IF "%gamefile%"=="game.iso" ..\..\TOOLS\Storage\nfs2iso2nfs.exe -enc%nfspatch% -iso "..\..\ISOBUILDTEMP\game.iso"
rmdir /s /q ..\..\ISOBUILDTEMP
IF NOT EXIST hif_000000.nfs goto:nfsfail
cd ..\..\
echo Terminé!>con
echo.>con

::NUSPacker - Pack the games into an installable archive
echo Préparation du répertoire d'installation du jeu...>con
cd TOOLS\NUSPacker
IF "%uwuhs_launch%"=="Y" (
	set packed_dir=..\..\..\..\Packed
) else (
	set packed_dir=..\..\Packed
)
IF NOT EXIST %packed_dir%\*.* (
	del /q %packed_dir% 2>nul
	mkdir %packed_dir%
)
java -jar NUSPacker.jar -in ..\..\WORKINGDIR -out "%packed_dir%\WUP-N-%WIITITLEID:~0,4%_0005000010%SAVEDRANDOM%FF"
rmdir /s /q tmp
rmdir /s /q output
IF NOT EXIST "%Packed_dir%\WUP-N-%WIITITLEID:~0,4%_0005000010%SAVEDRANDOM%FF" goto:unspecifiederror
cd ..\..\
echo Terminé!>con
echo.>con
goto:success

:unspecifiederror
echo NUSPACKER n'a pas réussi à créer le jeu.>con
echo Vous pouvez poster le log sur le sujet de Logic-sunrise pour avoir de l'aide.>con
echo.>con
pause>con
goto:endscript

:NOPE.AVI
reg import TOOLS\Storage\ShowFileExt.reg
echo Vous n'avez pas remplie le chemin du jeu donc certains fichiers requis sont manquants. Si vous ne souhaitez pas remplir de chemin de jeu, vérifiez que votre répertoire SOURCE_FILES contienne au moins:>con
echo.>con
echo game.gcm pour un jeu GameCube, game.iso/game.wbfs/game.wdf/game.wia/game.ciso/game.wbi pour un jeu Wii, boot.dol pour un Homebrew, ou game.wad pour un Wiiwares/v-wii forwarder.>con
echo.>con
Pause>con
goto:endscript

:gamenotsupported
IF /i NOT "%error_check_disc%"=="Y" (
	echo Une erreur c'est produite lors de l'analyse du type de jeu, une autre méthode va être tentée. >con
	echo Le fichier de jeu va être copié dans le dossier "SOURCE_FILES", veuillez patienter... >con
	IF /i "%game_ext%"=="iso" (
		set error_check_disc=Y
		copy /V "%game_source%" SOURCE_FILES\game.%game_ext%
		set game_source=SOURCE_FILES\game.iso
	)
	IF /i "%game_ext%"=="gcm" (
		set error_check_disc=Y
		set game_ext=iso
		copy /V "%game_source%" SOURCE_FILES\game.iso
		set game_source=SOURCE_FILES\game.iso
	)
	IF /i "%game_ext%"=="wbfs" (
		set error_check_disc=Y
		set game_ext=iso
		TOOLS\Storage\wbfs_file.exe "%game_source%" convert SOURCE_FILES\game.iso
		set game_source=SOURCE_FILES\game.iso
	)
	IF /i "%game_ext%"=="wdf" (
		set error_check_disc=Y
		copy /V "%game_source%" SOURCE_FILES\game.%game_ext%
		set game_source=SOURCE_FILES\game.wdf
	)
	IF /i "%game_ext%"=="wia" (
		set error_check_disc=Y
		copy /V "%game_source%" SOURCE_FILES\game.%game_ext%
		set game_source=SOURCE_FILES\game.wia
	)
	IF /i "%game_ext%"=="ciso" (
		set error_check_disc=Y
		copy /V "%game_source%" SOURCE_FILES\game.%game_ext%
		set game_source=SOURCE_FILES\game.ciso
	)
	IF /i "%game_ext%"=="wbi" (
		set error_check_disc=Y
		copy /V "%game_source%" SOURCE_FILES\game.%game_ext%
		set game_source=SOURCE_FILES\game.wbi
	)
	set default_gamefile=Y
	echo Terminé. >con
	echo.>con
	goto:check_game_sources
)
reg import TOOLS\Storage\ShowFileExt.reg
echo Le jeu que vous essayez d'injecter n'est pas supporté par ce script, veuillez retélécharger ou refaire le dump de votre jeu puis réessayez.>con
echo.>con
echo Si cela ne fonctionne toujours pas, vous pouvez poster le log sur le sujet de Logic-sunrise pour avoir de l'aide.>con
echo.>con
Pause>con
goto:endscript

:gamenotsupported_gcd2
IF /i NOT "%error_check_disc2%"=="Y" (
	IF NOT "%gametype_gcd2%"=="  Wii" (
		echo Une erreur c'est produite lors de l'analyse du type de jeu pour le disque 2 Gamecube, une autre méthode va être tentée. >con
		echo Le fichier de jeu va être copié dans le dossier "SOURCE_FILES", veuillez patienter... >con
		copy /V "%gcd2_source%" SOURCE_FILES\disc2.iso
		set gcd2_source=SOURCE_FILES\disc2.iso
		set default_gcd2file=Y
		echo Terminé. >con
		echo.>con
		goto:check_gcd2_sources
	)
)
reg import TOOLS\Storage\ShowFileExt.reg
echo Le second disque de votre jeu Gamecube ne semble pas être un jeu Gamecube, il n'est peut-être pas compatible avec le script ou le fichier est peut-être corrompu.>con
echo Vous pouvez tentez de retélécharger ou de refaire le dump de ce disque puis de réessayer.
echo.>con
echo Si cela ne fonctionne toujours pas, vous pouvez poster le log sur le sujet de Logic-sunrise pour avoir de l'aide.>con
echo.>con
Pause>con
goto:endscript

:metafail
echo Des fichiers sont manquants dans les répertoires meta et/ou code, la conversion ne peut se poursuivre.>con
echo Vous pouvez poster le log sur le sujet de Logic-sunrise pour avoir de l'aide.>con
echo.>con
Pause>con
goto:endscript

:nfsfail
cd ..\..\
echo NFS2ISO2NFS a échoué pendant la conversion, le script ne peut se poursuivre. Cette erreur est souvent liée à un manque d'espace libre sur la partition sur laquelle est exécutée le script.>con
echo Vous pouvez poster le log sur le sujet de Logic-sunrise pour avoir de l'aide.>con
echo.>con
Pause>con
goto:endscript

:invalidpng
echo Vos fichiers PNG ne sont pas valides. Ils doivent être au format PNG et non être des fichiers JPG renommés en PNG.>con
echo Resauvegardez vos fichiers au format  PNG avec MS PAINT ou un autre éditeur d'images.>con
echo.>con
echo Fichiers requis:>con
echo bootTvTex.png: %valid1%>con
echo iconTex.png: %valid2%>con
echo.>con
Pause>con
goto:endscript

:WITfail
IF "%special_wii_format%"=="iso" (
	IF /i NOT "%wit_iso_first_error%"=="y" (
		set wit_iso_first_error=Y
		echo Une erreur c'est produite pendant la tentative de réempactage, une autre méthode va être tentée. >con
		rmdir /s /q TEMP
		IF EXIST SOURCE_FILES\game.iso move SOURCE_FILES\game.iso SOURCE_FILES\game2.iso
		goto:isostuff
	)
)
echo WIT à échoué pendant le réempactage de vos fichiers. La source de votre jeu est probablement mauvaise.>con
echo Un dump clean d'un ISO est recommandé.>con
echo.>con
Pause>con
goto:endscript

:robofail
echo ROBOCOPY à échoué pendant la création des répertoires de base du script.>con
echo Vous pouvez poster le log sur le sujet de Logic-sunrise pour avoir de l'aide.>con
echo.>con
Pause>con
goto:endscript

:netfail
echo Le ping de GOOGLE à échoué, vérifiez votre connexion internet et essayez à nouveau.>con
echo.>con
Pause>con
goto:endscript

:javafail
echo JAVA 8 n'est pas détecté, installez la dernière version de Java: HTTPS://JAVA.COM>con
echo Si vous avez déjà installé JAVA 8, redémarrez votre ordinateur.>con
echo.>con
Pause>con
goto:endscript

:success
CALL TOOLS\Storage\functions\CONV_VAR_to_min.bat SAVEDRANDOM
echo %SAVEDRANDOM%>>TOOLS\Storage\blacklist_ids.txt
CALL TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat SAVEDRANDOM
echo Succès! Votre jeu "%GAMENAME%" a été enregistré sous le nom suivant:>con
echo WUP-N-%WIITITLEID:~0,4%_0005000010%SAVEDRANDOM%FF>con
echo dans le répertoire "Packed" du script. >con
IF "%gamefile%"=="game.wad" (
	IF /i "%wadgetexttypepatcher%"=="o" (
		IF /i "%getextpatch%"=="Y" (
			echo.>con
			echo Le nouveau fichier wad doit être installé sur la nand de la v-wii pour que le patch de GetExtTypePatcher soit pris en compte. Si vous avez déjà ce jeu installé sur votre nand v-wii, désinstallez-le et installez celui-ci. Le fichier se trouve dans le répertoire "Packed" et est nommé "game_patched.wad".>con
			echo Notez qu'avec ce wad modifié, les Wiimotes ne fonctionneront pas.>con
		)
	)
)
IF /i "%getexttypepatcher%"=="o" (
	IF /i "%getextpatch%"=="Y" (
		echo Le jeu a bien été patché avec GetExtTypePatcher. Notez que les Wiimotes ne fonctionneront pas avec ce jeu à cause du patch.>con
	)
)
IF /i "%overclock%"=="o" (
	echo.>con
	echo Le jeu patché avec cafe2wii doit être installé sur la NAND et lancé en utilisant sign_c2w_patcher>con
)
echo.>con
echo Installez le jeu avec WUP INSTALLER GX2 et les SIG PATCHES activées.>con
echo Les SIG PATCHES sont requis pour exécuter le jeu.>con
echo.>con
Pause>con
IF /i "%getexttypepatcher%"=="O" (
	TOOLS\gnuwin32\bin\tail.exe -n+%count% <log.txt >templogs\log2.txt
	TOOLS\gnuwin32\bin\tail.exe -q -n+0 templogs\log1.txt templogs\getexttypepatcher.txt templogs\log2.txt >log.txt
)
IF /i "%wadgetexttypepatcher%"=="O" (
	TOOLS\gnuwin32\bin\tail.exe -n+%count% <log.txt >templogs\log2.txt
	TOOLS\gnuwin32\bin\tail.exe -q -n+0 templogs\log1.txt templogs\getexttypepatcher.txt templogs\log2.txt >log.txt
)

:endscript
IF EXIST templogs\getexttypepatcher.txt (
	cd templogs
	move getexttypepatcher.txt ..
	cd ..
)
::Cleanup
echo Nettoyage...>con
IF EXIST WORKINGDIR (
	rmdir /s /q WORKINGDIR
)
IF EXIST temp (
	rmdir /s /q temp
)
IF EXIST SOURCE_FILES\temp (
	rmdir /s /q SOURCE_FILES\temp
)
IF EXIST SOURCE_FILES\wadtemp (
	rmdir /s /q SOURCE_FILES\wadtemp
)
IF EXIST ISOBUILDTEMP (
	rmdir /s /q ISOBUILDTEMP
)
IF EXIST templogs (
	rmdir /s /q templogs
)
IF EXIST "SOURCE_FILES\bootSound.btsnd" del /q "SOURCE_FILES\bootSound.wav"
IF /i "%gc_bootsound%"=="Y" del /q SOURCE_FILES\bootsound.wav
IF /i "%default_gamefile%"=="Y" (
	del /q SOURCE_FILES\game.%game_ext%
)
IF /i "%default_gcd2file%"=="Y" (
	del /q SOURCE_FILES\disc2.iso
)
IF /i "%default_boottvtex%"=="Y" (
	del /q SOURCE_FILES\bootTvTex.png
)
IF /i "%default_icontex%"=="Y" (
	del /q SOURCE_FILES\iconTex.png
)
IF /i "%default_bootdrctex%"=="Y" (
	del /q SOURCE_FILES\bootDrcTex.png
)
IF /i "%default_bootlogotex%"=="Y" (
	del /q SOURCE_FILES\bootLogoTex.png
)
IF /i "%default_bootsound%"=="Y" (
	del /q SOURCE_FILES\bootsound.wav
	del /q SOURCE_FILES\bootsound.btsnd
)
IF /i "%default_cheats%"=="Y" (
	del /q SOURCE_FILES\game.gct
)
IF /i "%default_custommain%"=="Y" (
	del /q SOURCE_FILES\main.dol
)
echo Terminé!>con
echo.>con
endlocal