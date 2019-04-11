::Script by Shadow256
echo on
chcp 65001 > nul
cd ..
IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
)
IF NOT EXIST Files\*.* (
	del /q Files 2>nul
	mkdir Files
)
::initialise path variables
IF "%choice%"=="1" (
	IF EXIST "Files\*.nes" GOTO:images_path
	%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichiers de jeu Nes (*.nes)|*.nes|" "Sélection du jeu Nes" "templogs\tempvar.txt"
	set /p game_source=<templogs\tempvar.txt
	set game_ext=nes
)
IF "%choice%"=="2" (
	IF EXIST "Files\*.sfc" GOTO:images_path
	IF EXIST "Files\*.smc" GOTO:images_path
	%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichiers de jeu SNes (*.smc;*.sfc)|*.smc;*.sfc|" "Sélection du jeu Supernes" "templogs\tempvar.txt"
	set /p game_source=<templogs\tempvar.txt
	set game_ext=sfc
)
IF "%choice%"=="3" (
	IF EXIST "Files\*.z64" GOTO:images_path
	IF EXIST "Files\*.n64" GOTO:images_path
	IF EXIST "Files\*.v64" GOTO:images_path
	%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichiers de jeu N64 (*.z64;*.n64;*.v64)|*.z64;*.n64;*.v64|" "Sélection du jeu Nintendo 64" "templogs\tempvar.txt"
	set /p game_source=<templogs\tempvar.txt
)
IF "%choice%"=="3" (
	set game_ext=%game_source:~-3,3%
)
IF "%choice%"=="4" (
	IF EXIST "Files\*.gba" GOTO:images_path
	%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichiers de jeu GBA (*.gba)|*.gba|" "Sélection du jeu Gameboy Advance" "templogs\tempvar.txt"
	set /p game_source=<templogs\tempvar.txt
	set game_ext=gba
)
IF "%choice%"=="5" (
	IF EXIST "Files\*.nds" GOTO:images_path
	IF EXIST "Files\*.srl" GOTO:images_path
	%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichiers de jeu NDS (*.nds;*.srl)|*.nds;*.srl|" "Sélection du jeu Nintendo DS" "templogs\tempvar.txt"
	set /p game_source=<templogs\tempvar.txt
	set game_ext=nds
)
IF NOT "%game_source%"=="" (
	set "game_source=%game_source:"=%"
) else (
	echo La source du jeu ne peut être vide. >con
	pause >con
	set game_ext=
	goto:define_game_source
)
IF NOT EXIST "%game_source%" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	pause >con
	set game_source=
	set game_ext=
	goto:define_game_source
)
IF EXIST "%game_source%\*.*" (
	echo Le fichier n'existe pas. Entrez un chemin vers un fichier existant. >con
	pause >con
	set game_source=
	set game_ext=
	goto:define_game_source
)
copy "%game_source%" Files\rom.%game_ext%
:images_path
:test_iconTex
IF EXIST "Files\iconTex.*" (
	for %%f in (Files\iconTex.*) do (
		set "iconTex_source=%%f"
		goto:test_bootTvTex
	) 
)
:define_iconTex
echo Vous allez devoir sélectionner l'icône du jeu (taille d'image de 128x128). Si vous fermez la fenêtre qui s'ouvrira sans sélectionner de fichier, un icône par défaut sera copié. >con
pause >con
	%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichiers d\'image standard (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection de l\'icône du jeu" "templogs\tempvar.txt"
	set /p iconTex_source=<templogs\tempvar.txt
IF NOT "%iconTex_source%"=="" (
	set "iconTex_source=%iconTex_source:"=%"
) else (
	copy /v Tools\templates\iconTex.png Files
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
TOOLS\ImageMagick\convert.exe "%iconTex_source%" Files\iconTex.png
set default_icontex=Y
:test_bootTvTex
IF EXIST Files\bootTvTex.* (
	for %%f in (Files\bootTvTex.*) do (
		set "bootTvTex_source=%%f"
		goto:test_bootDrcTex
	)
)
:define_bootTvTex
echo Vous allez devoir sélectionner la banière TV du jeu (taille d'image de 1280x720). Si vous fermez la fenêtre qui s'ouvrira sans sélectionner de fichier, une banière TV par défaut sera copiée. >con
pause >con
%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichiers d\'image standard (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection de la banière TV du jeu" "templogs\tempvar.txt"
set /p bootTvTex_source=<templogs\tempvar.txt
IF NOT "%bootTvTex_source%"=="" (
	set "bootTvTex_source=%bootTvTex_source:"=%"
) else (
	copy /v Tools\templates\bootTvTex.png Files
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
TOOLS\ImageMagick\convert.exe "%bootTvTex_source%" Files\bootTvTex.png
set default_boottvtex=Y
:test_bootDrcTex
IF EXIST Files\bootDrcTex.* (
	for %%f in (Files\bootDrcTex.*) do (
		set "bootDrcTex_source=%%f"
		goto:test_bootLogoTex
	)
)
:define_bootDrcTex
echo Vous allez devoir sélectionner la banière Gamepad du jeu (taille d'image de 854x480), Fermez la fenêtre qui s'ouvrira si aucune. >con
pause >con
%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichiers d\'image standard (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection de la banière Gamepad du jeu" "templogs\tempvar.txt"
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
TOOLS\ImageMagick\convert.exe "%bootDrcTex_source%" Files\bootDrcTex.png
set default_bootdrctex=Y
:test_bootLogoTex
IF EXIST Files\bootLogoTex.* (
	for %%f in (Files\bootLogoTex.*) do (
		set "bootLogoTex_source=%%f
		goto:test_bootSound
	)
)
:define_bootLogoTex
echo Vous allez devoir sélectionner le logo de l'éditeur du jeu (taille d'image de 170x42), Fermez la fenêtre qui s'ouvrira si aucun. >con
pause >con
%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichiers d\'image standard (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif|Tous les fichiers (*.*)|*.*|" "Sélection du logo du jeu" "templogs\tempvar.txt"
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
TOOLS\ImageMagick\convert.exe "%bootLogoTex_source%" Files\bootLogoTex.png
set default_bootlogotex=Y
:test_bootSound
IF EXIST Files\bootSound.wav (
	set bootSound_source=Files\bootSound.wav
	goto:convert_bootTvTex
)
IF EXIST Files\bootSound.btsnd (
	set bootSound_source=Files\bootSound.btsnd
	goto:convert_bootTvTex
)
:define_bootSound
echo Vous allez devoir sélectionner le son de démarrage du jeu (6 secondes maximum), Fermez la fenêtre qui s'ouvrira si aucun. >con
pause >con
%windir%\system32\wscript.exe //Nologo TOOLS\functions\open_file.vbs "" "Fichier audio (*.wav;*.btsnd)|*.wav;*.btsnd|" "Sélection du bootsound du jeu" "templogs\tempvar.txt"
set /p bootSound_source=<templogs\tempvar.txt
IF NOT "%bootSound_source%"=="" (
	set "bootSound_source=%bootSound_source:"=%"
) else (
	goto:convert_bootTvTex
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
copy /V "%bootSound_source%" Files\bootSound.%img_ext%

:convert_bootTvTex
IF NOT EXIST "Files\bootTvTex.png" (
	for %%f in (Files\bootTvTex.*) do (
		TOOLS\ImageMagick\convert.exe %%f Files\bootTvTex.png
		IF EXIST "Files\bootTvTex.png" (
			set default_boottvtex=Y
			goto:convert_iconTex
		)
	)
)
:convert_iconTex
IF NOT EXIST "Files\iconTex.png" (
	for %%f in (Files\iconTex.*) do (
		TOOLS\ImageMagick\convert.exe %%f Files\iconTex.png
		IF EXIST "Files\iconTex.png" (
			set default_icontex=Y
			goto:convert_bootDrcTex
		)
	)
)
:convert_bootDrcTex
IF NOT EXIST "Files\bootDrcTex.png" (
	for %%f in (Files\bootDrcTex.*) do (
		TOOLS\ImageMagick\convert.exe %%f Files\bootDrcTex.png
		IF EXIST "Files\bootDrcTex.png" (
			set default_bootdrctex=Y
			goto:convert_bootLogoTex
		)
	)
)
:convert_bootLogoTex
IF NOT EXIST "Files\bootLogoTex.png" (
	for %%f in (Files\bootLogoTex.*) do (
		TOOLS\ImageMagick\convert.exe %%f Files\bootLogoTex.png
		IF EXIST "Files\bootLogoTex.png" (
			set default_bootlogotex=Y
			goto:end_script
		)
	)
)
:end_script
rmdir /q /s templogs
cd Tools