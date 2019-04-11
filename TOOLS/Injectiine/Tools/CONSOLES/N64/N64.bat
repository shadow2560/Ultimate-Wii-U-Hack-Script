Setlocal enabledelayedexpansion
echo on
chcp 65001 >nul
IF NOT EXIST ..\..\..\templogs\*.* (
	del /q ..\..\..\templogs 2>nul
	mkdir ..\..\..\templogs
)
IF EXIST ..\..\blacklist_ids.txt\*.* rmdir /s /q ..\..\blacklist_ids.txt
IF NOT EXIST ..\..\blacklist_ids.txt copy nul ..\..\blacklist_ids.txt
title Injectiine [N64]
cls
cd ..
cd ..
cd ..
cd Files

::Convert images to PNGs if they exist (To prevent possible errors in the user provided image)
:convert_bootTvTex
IF NOT EXIST "bootTvTex.png" (
	for %%f in (SOURCE_FILES\bootTvTex.*) do (
		..\..\ImageMagick\convert.exe %%f bootTvTex.png
		IF EXIST "bootTvTex.png" (
			del /q %%f
			goto:convert_iconTex
		)
	)
)
:convert_iconTex
IF NOT EXIST "iconTex.png" (
	for %%f in (SOURCE_FILES\iconTex.*) do (
		..\..\ImageMagick\convert.exe %%f iconTex.png
		IF EXIST "iconTex.png" (
			del /q %%f
			goto:convert_bootDrcTex
		)
	)
)
:convert_bootDrcTex
IF NOT EXIST "bootDrcTex.png" (
	for %%f in (SOURCE_FILES\bootDrcTex.*) do (
		..\..\ImageMagick\convert.exe %%f bootDrcTex.png
		IF EXIST "bootDrcTex.png" (
			del /q %%f
			goto:convert_bootLogoTex
		)
	)
)
:convert_bootLogoTex
IF NOT EXIST "bootLogoTex.png" (
	for %%f in (SOURCE_FILES\bootLogoTex.*) do (
		..\..\ImageMagick\convert.exe %%f bootLogoTex.png
		IF EXIST "bootLogoTex.png" (
			del /q %%f
			goto:begin_script
		)
	)
)

:begin_script
echo :::::::::::::::::::: >con
echo ::INJECTIINE [N64]:: >con
echo :::::::::::::::::::: >con
SLEEP 3

:: CHECK THAT FILES EXIST

IF NOT EXIST *.z64 GOTO:LastChanceOne

:Main
IF NOT EXIST bootTvTex.png GOTO:404ImagesNotFound
IF NOT EXIST iconTex.png GOTO:404ImagesNotFound

cd ..
cd Tools
cd CONSOLES
cd N64

:BASE
cls
echo Quelle base souhaitez-vous utiliser? >con
echo Excitebike 64 [USA]      (1) >con
echo Donkey Kong 64 [EUR]     (2) >con
echo Base via un dossier défini manuellement (3) >con
echo Télécharger une base en entrant son Title ID et sa Title Key (4) >con
echo.
set /p BASEDECIDE=[Votre choix:] >con
IF "%BASEDECIDE%"=="1" GOTO:EB
IF "%BASEDECIDE%"=="2" GOTO:DK
IF "%BASEDECIDE%"=="3" GOTO:BaseNotice
IF "%BASEDECIDE%"=="4" GOTO:EnterCommon
GOTO:BASE

:BaseNotice
cls
echo Choisissez votre base, incluant les répertoires code, content et meta. >con
echo.>con
pause >con
cd ..
cd ..
cd ..
%windir%\system32\wscript.exe //Nologo Tools\functions\select_dir.vbs "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
%windir%\System32\Robocopy.exe "%filepath%" Files\Base /e
cd Files
IF NOT EXIST Base (
	rmdir /s /q Base
	cd ..\Tools\CONSOLES\N64
	GOTO:BASE
)
IF NOT EXIST Base\code (
	rmdir /s /q Base
	cd ..\Tools\CONSOLES\N64
	GOTO:BASE
)
IF NOT EXIST Base\content (
	rmdir /s /q Base
	cd ..\Tools\CONSOLES\N64
	GOTO:BASE
)
IF NOT EXIST Base\meta (
	rmdir /s /q Base
	cd ..\Tools\CONSOLES\N64
	GOTO:BASE
)
cd ..
cd Tools
cd CONSOLES
cd N64
GOTO:EnterCommon

:: ENTERING KEYS

:WrongKeyDK
cls
echo La Title key n'est pas bonne. Réessayez. >con
SLEEP 2

:EnterKeyDK
cls

IF EXIST TitleKeyDK.txt goto:EnterCommon
echo Cette étape ne sera plus nécessaire la prochaine fois que vous lancerez Injectiine. >con
echo Entrez la title key pour Donkey Kong 64 (EUR): >con
set /p TITLEKEY=>con
echo %TITLEKEY:~0,32%>TitleKeyDK.txt
set /p TITLEKEY=<TitleKeyDK.txt
cls
IF "%TitleKEY:~0,4%"=="3229" (
	GOTO:EnterCommon
) ELSE (
	del /q TitleKeyDK.txt
	GOTO:WrongKeyDK
)

:WrongKeyEB
cls
echo La Title key n'est pas bonne. Réessayez. >con
SLEEP 2

:EnterKeyEB
cls

IF EXIST TitleKeyEB.txt goto:EnterCommon
echo Cette étape ne sera plus nécessaire la prochaine fois que vous lancerez Injectiine. >con
echo Entrez la title key pour Excitebike 64 (USA): >con
set /p TITLEKEY=>con
echo %TITLEKEY:~0,32%>TitleKeyEB.txt
set /p TITLEKEY=<TitleKeyEB.txt
cls
IF "%TitleKEY:~0,4%"=="2ee3" (
	GOTO:EnterCommon
) ELSE (
	del /q TitleKeyEB.txt
	GOTO:WrongKeyEB
)

:DK
set BASEPDC=NAAP
set BASEID=0005000010199300
set BASEFOLDER="Donkey Kong 64 [NAAP01]"
IF EXIST TitleKeyDK.txt (set /p TITLEKEY=<TitleKeyDK.txt) ELSE (GOTO:EnterKeyDK)
GOTO:EnterCommon

:EB
set BASEPDC=NATE
set BASEID=00050000101e6500
set BASEFOLDER="Excitebike 64 [NATE01]"
IF EXIST TitleKeyEB.txt (set /p TITLEKEY=<TitleKeyEB.txt) ELSE (GOTO:EnterKeyEB)
GOTO:EnterCommon

:WrongCommon
cls
echo La Wii U Common Key n'est pas bonne. Réessayez. >con
SLEEP 2

:EnterCommon
cls
IF EXIST NUSPacker/encryptKeyWith (
IF "%BASEDECIDE%"=="4" (
	GOTO:BaseDownload
	) else (
		GOTO:EnterParameters
	)
)
cd NUSPacker
echo Cette étape ne sera plus nécessaire la prochaine fois que vous lancerez Injectiine. >con
set /p COMMON=Entrez la Wii U Common Key: >con
echo %COMMON:~0,32%>encryptKeyWith
set /p COMMON=<encryptKeyWith
cls
cd ..
echo http://ccs.cdn.wup.shop.nintendo.net/ccs/download>JNUSTool\config
echo %COMMON:~0,32%>>JNUSTool\config
echo https://tagaya.wup.shop.nintendo.net/tagaya/versionlist/EUR/EU/latest_version>>JNUSTool\config
echo https://tagaya-wup.cdn.nintendo.net/tagaya/versionlist/EUR/EU/list/%d.versionlist>>JNUSTool\config
IF "%COMMON:~0,4%"=="D7B0" (
	IF "%BASEDECIDE%"=="4" (
	GOTO:BaseDownload
	) else (
		GOTO:EnterParameters
	)
) ELSE (
	del /q NUSPacker\encryptKeyWith
	GOTO:WrongCommon
)

:BaseDownload
Setlocal disabledelayedexpansion
IF EXIST "JNUSTool_temp" (
	del /q "JNUSTool_temp" 2>nul
	rmdir /s /q "JNUSTool_temp"
)
mkdir JNUSTool_temp
copy JNUSTool\JNUSTool.jar JNUSTool_temp\JNUSTool.jar
copy JNUSTool\config JNUSTool_temp\config
IF EXIST WORKDIR (
	del /q WORKDIR 2>nul
	rd /s /q WORKDIR
)
cd JNUSTool_temp
cls
echo ATTENTION: Vous avez choisi d'entrer le Title ID et la Title Key du jeu à télécharger manuellement. Si vous entrez de mauvaises informations, le script ou l'injection pourrait ne pas fonctionner correctement. >con
echo.>con
set /p custom_titleid=Entrez le Title ID du jeu à télécharger: >con
set /p custom_titlekey=Entrez la Title Key du jeu à télécharger: >con
echo Test de la connexion à Internet... >con
C:\windows\system32\PING.EXE google.com
if %errorlevel% GTR 0 goto:InternetSucks
echo Téléchargement des fichiers de base... >con
java -jar JNUSTool.jar %custom_titleid% %custom_titlekey% -file .*
echo Déplacement dans le répertoire de travail... >con
for /f "delims=" %%f In ('dir /ad/b') Do (
	%windir%\System32\Robocopy.exe "%%f" ..\WORKDIR\ /MIR
)
cd ..
IF NOT EXIST WORKDIR GOTO:ROBOFAIL
rmdir /s /q JNUSTool_temp
endlocal
cls
GOTO:EnterParameters

:: ENTER PARAMETERS

:EnterParameters
cls

:TITLEID
set TITLEID=%random:~-1%%random:~-1%%random:~-1%%random:~-1%
..\..\gnuwin32\bin\grep.exe -m 1 "%TITLEID%" <..\..\blacklist_ids.txt >..\..\..\templogs\tempvar.txt
set /p blacklist_id_verif=<..\..\..\templogs\tempvar.txt
IF NOT "%blacklist_id_verif%"=="" (
	set blacklist_id_verif=
	goto:TITLEID
)

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
call ..\..\functions\strlen.bat nb "%GAMENAME%"
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
call ..\..\functions\replace_chars.bat GAMENAME_xml "%GAMENAME%" %nb%
GOTO:RestOfParameters

:LINE2
echo Entrez une version courte du nom du jeu. >con
set /p GAMENAME=[Nom cours du jeu:] >con
call ..\..\functions\strlen.bat nb "%GAMENAME%"
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
call ..\..\functions\replace_chars.bat GAMENAME_xml "%GAMENAME%" %nb%

:define_GAMENAME1
echo Entrez la première ligne du nom du jeu. >con
set /p GAMENAME1=[Ligne 1 du nom du jeu:] >con
call ..\..\functions\strlen.bat nb "%GAMENAME1%"
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
call ..\..\functions\replace_chars.bat GAMENAME1_xml "%GAMENAME1%" %nb%

:define_GAMENAME2
echo Entrez la seconde ligne du nom du jeu. >con
set /p GAMENAME2=[Ligne 2 du nom du jeu:] >con
call ..\..\functions\strlen.bat nb "%GAMENAME2%"
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
call ..\..\functions\replace_chars.bat GAMENAME2_xml "%GAMENAME2%" %nb%

:RestOfParameters
echo Entrez un code produit à quatre chiffres ou lettres. >con
set /p PRODUCTCODE=[0-Z:] >con
call ..\..\functions\strlen.bat nb "%PRODUCTCODE%"
IF %nb% EQU 0 (
	echo La première ligne du code produit du jeu ne peut être vide. Réessayez. >con
	goto:RestOfParameters
)
IF %nb% NEQ 4 (
	echo Le Nombre de caractère saisie doit être de 4 caractères. Réessayez. >con
	set PRODUCTCODE=
	goto:RestOfParameters
)
call ..\..\functions\CONV_VAR_to_MAJ.bat PRODUCTCODE
set i=0
:check_chars_PRODUCTCODE
IF %i% LSS %nb% (
	set check_chars_PRODUCTCODE=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9) do (
		IF "!PRODUCTCODE:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_PRODUCTCODE=1
			goto:check_chars_PRODUCTCODE
		)
	)
	IF "!check_chars_PRODUCTCODE!"=="0" (
		echo Un caractère non autorisé a été saisie dans le code produit du jeu. Recommencez. >con
		set PRODUCTCODE=
		goto:RestOfParameters
	)
)
echo.>con

echo Souhaitez-vous entrer un title ID manuellement? >con
echo Si vous ne le faites pas, il sera défini au hasard. >con
set /p TITLEDECIDE=[O/N:] >con
echo.>con
:define_TITLEID
IF /i "%TITLEDECIDE%"=="o" (
echo Entrez les quatre chiffres ou lettres du meta title ID. Doit seulement être une valeur hexa-décimale. >con
set /p TITLEID=[0-F:] >con
)
IF /i "%TITLEDECIDE%"=="o" call ..\..\functions\strlen.bat nb "%TITLEID%"
IF /i "%TITLEDECIDE%"=="o" (
	IF NOT "%nb%"=="4" (
		echo Le meta title ID doit absolument contenir 4 caractères HEXA. Recommencez. >con
		set nb=
		set TITLEID=
		goto:define_TITLEID
	)
	CALL ..\..\functions\CONV_VAR_to_min.bat TITLEID
)
set i=0
:check_chars_TITLEID
IF %i% LEQ 3 (
	set check_chars_TITLEID=0
	FOR %%z in (a b c d e f 0 1 2 3 4 5 6 7 8 9) do (
		IF "!TITLEID:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_TITLEID=1
			goto:check_chars_TITLEID
		)
	)
	IF "!check_chars_TITLEID!"=="0" (
		echo Un caractère non autorisé a été saisie dans le meta title ID. Recommencez. >con
		set TITLEID=
		goto:define_TITLEID
	)
)
IF /i "%TITLEDECIDE%"=="o" (
	..\..\gnuwin32\bin\grep.exe -m 1 "%TITLEID%" <..\..\blacklist_ids.txt >..\..\..\templogs\tempvar.txt
	set /p blacklist_id_verif=<..\..\..\templogs\tempvar.txt
)
IF NOT "%blacklist_id_verif%"=="" (
	echo Cet ID est dans la blacklist, impossible de l'utiliser de nouveau. Veuillez en utiliser un autre. >con
	set blacklist_id_verif=
	set TITLEID=
	goto:define_TITLEID
)
IF /i "%TITLEDECIDE%"=="o" CALL ..\..\functions\CONV_VAR_to_MAJ.bat TITLEID

:PackPrompt
echo Souhaitez-vous préparer le jeu en utilisant NUSPacker? >con
echo Si vous ne le souhaitez pas, le jeu sera créé au format Loadiine. >con
set /p PACKDECIDE=[O/N:] >con
IF /i NOT "%PACKDECIDE%"=="o" (
	IF /i NOT "%PACKDECIDE%"=="n" (
GOTO:PackPrompt
	)
)

cls
echo Injectiine va maintenant procéder à l'injection N64. >con
echo Si vous n'acceptez pas cela, vous devrez entrer de nouveau les paramètres. >con
CHOICE /C ON >con
IF errorlevel 2 (
	set GAMENAME=
	set GAMENAME1=
	set GAMENAME2=
	set PRODUCTCODE=
	set LINEDECIDE=
	set TITLEDECIDE=
	set PACKDECIDE=
	goto:EnterParameters
)
IF errorlevel 1 goto:DownloadingStuff

:: DOWNLOADING AND MOVING STUFF

:DownloadingStuff
cls
IF %BASEDECIDE%==4 GOTO:CustomIniName
IF EXIST WORKDIR (
	del /q WORKDIR 2>nul
	rd /s /q WORKDIR
)
IF %BASEDECIDE%==3 GOTO:CopyBase
SLEEP 1
cd JNUSTool

IF NOT EXIST %BASEFOLDER% goto:JNUS_download
IF NOT EXIST %BASEFOLDER%\code goto:JNUS_download
IF NOT EXIST %BASEFOLDER%\content goto:JNUS_download
IF NOT EXIST %BASEFOLDER%\meta\Manual.bfma goto:JNUS_download
IF NOT EXIST %BASEFOLDER%\meta\bootMovie.h264 goto:JNUS_download
IF NOT EXIST %BASEFOLDER%\meta\bootLogoTex.tga goto:JNUS_download
IF NOT EXIST %BASEFOLDER%\meta\bootSound.btsnd goto:JNUS_download
GOTO:MovingStuff
:JNUS_download
echo Test de la connexion à Internet... >con
C:\windows\system32\PING.EXE google.com
if %errorlevel% GTR 0 goto:InternetSucks
echo Téléchargement des fichiers de base... >con
rmdir /s /q %BASEFOLDER%
java -jar JNUSTool.jar %BASEID% %TITLEKEY% -file .*

:MovingStuff
echo Déplacement dans le répertoire de travail... >con
%windir%\System32\Robocopy.exe %BASEFOLDER% ..\WORKDIR\ /MIR
cd ..
IF NOT EXIST WORKDIR GOTO:ROBOFAIL
goto:CustomIniName

:CopyBase
cls
echo Déplacement de la base dans le répertoire de travail... >con
%windir%\System32\Robocopy.exe ..\..\..\Files\Base WORKDIR\ /MIR
IF NOT EXIST WORKDIR GOTO:ROBOFAIL
rmdir /s /q ..\..\..\Files\Base
goto:CustomIniName

:CustomIniName
cd WORKDIR
cd content
IF NOT EXIST rom\*.* (
	cd ..
	cd ..
	goto:EnterCustomIni
) else (
	cd rom
)
for %%f in (*) do (
	set BASEINI=%%f
)
cd ..
cd ..
cd ..
cls
echo Souhaitez-vous définir un nom d'INI/ROM personnalisé? >con
echo Si vous ne le faites pas, celui de la base sera utilisé. >con
set /p INIDECIDE=[O/N:] >con
IF /i "%INIDECIDE%"=="o" (GOTO:EnterCustomIni)
IF /i "%INIDECIDE%"=="n" (GOTO:InjectingROM)
GOTO:CustomIniName

:EnterCustomIni
cls
echo Entrez un nom d'INI/ROM personnalisé. >con
echo FORMAT: UnxxxN.NNN >con
echo EXEMPLES: Unsme0.005, Undop0.599 >con
set /p BASEINI=[INI/ROM Name:] >con
GOTO:InjectingROM

:: INJECTING ROM
:InjectingROM
cd WORKDIR
cd content
IF EXIST config\%BASEINI%.ini (
	IF NOT EXIST ..\..\INIs\%BASEINI%.ini (
		copy content\config\%BASEINI%.ini ..\..\INIs\%BASEINI%.ini
	)
)
rmdir /s /q rom
rmdir /s /q config
rmdir /s /q Patch
mkdir rom
mkdir config
mkdir Patch
cd ..
cd ..
cls
echo Injection de la ROM... >con
cd ..
cd ..
cd ..
cd Files
IF EXIST iconTex.png (move iconTex.png ../Tools/png2tga)
IF NOT EXIST bootDrcTex.png (copy bootTvTex.png bootDrcTex.png)
IF EXIST bootTvTex.png (move bootTvTex.png ../Tools/png2tga)
IF EXIST bootDrcTex.png (move bootDrcTex.png ../Tools/png2tga)
IF EXIST bootLogoTex.png (move bootLogoTex.png ../Tools/png2tga)

IF EXIST bootSound.wav echo bootSound détecté, souhaitez-vous qu'il boucle? >con
IF EXIST bootSound.wav set /p AUDIODECIDE=[Y/N:] >con
IF /i "%AUDIODECIDE%"=="n" set LOOP=-noLoop
IF EXIST bootSound.wav ..\Tools\sox\sox.exe .\bootSound.wav -b 16 bootEdited.wav channels 2 rate 48k trim 0 6
IF EXIST bootEdited.wav ..\Tools\wav2btsnd.jar -in bootEdited.wav -out bootSound.btsnd %LOOP%
IF EXIST bootSound.wav (2>NUL del bootSound.wav)
IF EXIST bootEdited.wav (2>NUL del bootEdited.wav)
IF EXIST bootSound.btsnd (move bootSound.btsnd ../Tools/CONSOLES/NES/WORKDIR/meta/bootSound.btsnd)

IF EXIST *.z64 ren *.z64 ROM.z64
IF EXIST *.n64 java -jar ../Tools/CONSOLES/N64/N64Converter.jar -i *.n64 -o ROM.z64
IF EXIST *.v64 java -jar ../Tools/CONSOLES/N64/N64Converter.jar -i *.v64 -o ROM.z64
del *.n64 2>NUL
del *.v64 2>NUL
cd ..
move Files\ROM.z64 Tools\CONSOLES\N64\WORKDIR\content\rom\%BASEINI%
cd Tools
cd CONSOLES
cd N64
cd WORKDIR
cd content
cd config
SLEEP 1
cls

:COPY
echo Quel fichier config .ini souhaitez-vous utiliser? >con
echo.>con
echo Super Mario 64 [USA] (1) >con
echo Super Mario 64 [EUR] (2) >con
echo Donkey Kong 64 [USA] (3) >con
echo Donkey Kong 64 [EUR] (4) >con
echo Un config.ini personnalisé  (5) >con
echo Un config.ini vierge        (6) >con
echo Le config.ini de la base    (7) >con
echo Choisir un fichier .INI     (8) >con
echo.>con
set /p BASEDECIDE=[Votre choix:] >con
IF "%BASEDECIDE%"=="1" GOTO:SM64UCOPY
IF "%BASEDECIDE%"=="2" GOTO:SM64ECOPY
IF "%BASEDECIDE%"=="3" GOTO:DKUCOPY
IF "%BASEDECIDE%"=="4" GOTO:DKECOPY
IF "%BASEDECIDE%"=="5" GOTO:CUSTOMINI
IF "%BASEDECIDE%"=="6" GOTO:BLANKINI
IF "%BASEDECIDE%"=="7" GOTO:BASEINI
IF "%BASEDECIDE%"=="8" GOTO:ININotice
GOTO:COPY

:SM64UCOPY
cd ..
cd ..
cd ..
copy INIs\Unsme0.005.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:SM64ECOPY
cd ..
cd ..
cd ..
copy INIs\UNSMP0.016.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:DKUCOPY
cd ..
cd ..
cd ..
copy INIs\Undoe0.556.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:DKECOPY
cd ..
cd ..
cd ..
copy INIs\Undop0.599.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:BLANKINI
cd ..
cd ..
cd ..
copy nul WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:BASEINI
cd ..
cd ..
cd ..
IF EXIST INIs\%BASEINI%.ini (
	copy INIs\%BASEINI%.ini WORKDIR\content\config\%BASEINI%.ini
) else (
	cd WORKDIR
	cd content
	cd config
	echo Erreur: Le fichier ini de la base n'a pas été trouvé, veuillez sélectionner une autre option. >con
	echo.>con
	goto:COPY
)
cd WORKDIR
GOTO:NextStep

:ININotice
cls
echo Vous allez devoir choisir un fichier INI. >con
echo Si vous fermez la fenêtre qui s'ouvrira sans en choisir un, un fichier vierge sera utilisé. >con
echo.>con
pause >con
cls
cd ..
cd ..
cd ..
IF NOT EXIST ..\..\..\Files\*.ini (
	%windir%\system32\wscript.exe //Nologo ..\..\functions\open_file.vbs "" "Fichiers paramètres (*.ini)|*.ini|" "Sélection du fichier de configuration" "..\..\..\templogs\tempvar.txt"
	set /p ini_source=<..\..\..\templogs\tempvar.txt
	IF NOT "%ini_source%"=="" copy /v "%ini_source%" ..\..\..\Files
)
cd ..
cd ..
cd ..
	cd Files
IF NOT EXIST *.ini (copy nul ..\Tools\CONSOLES\N64\WORKDIR\content\config\%BASEINI%.ini)
IF EXIST *.ini (
	copy *.ini ..\Tools\CONSOLES\N64\WORKDIR\content\config\%BASEINI%.ini
	del /q *.ini
)
cd ..
cd Tools
cd CONSOLES
cd N64
cd WORKDIR
cls
GOTO:NextStep

:CUSTOMINI
echo [RomOption]>>%BASEINI%.ini

:TIMER
cls
echo Souhaitez-vous activer UseTimer? >con
echo Cela limitera la vitesse d'émulation. >con
set /p UseTimer=[O/N:] >con
echo.>con
IF /i "%UseTimer%"=="o" (
echo UseTimer = ^1>>%BASEINI%.ini
GOTO:VSYNC
)
IF /i "%UseTimer%"=="n" (
GOTO:VSYNC
)
GOTO:TIMER

:VSYNC
cls
echo Souhaitez-vous activer RetraceByVsync? >con
echo Cela réduira les lags. >con
set /p Vsync=[O/N:] >con
echo.>con
IF /i "%Vsync%"=="o" (
echo RetraceByVsync = ^1>>%BASEINI%.ini
GOTO:RUMBLE
)
IF /i "%Vsync%"=="n" (
GOTO:RUMBLE
)
GOTO:VSYNC

:RUMBLE
cls
echo Souhaitez-vous activer Rumble? >con
echo Cela est recommandé pour les jeux utilisant le Rumble Pak. >con
set /p Rumble=[O/N:] >con
echo.>con
IF /i "%Rumble%"=="o" (
echo Rumble = ^1>>%BASEINI%.ini
GOTO:MEMPAK
)
IF /i "%Rumble%"=="n" (
GOTO:MEMPAK
)
GOTO:RUMBLE

:MEMPAK
cls
echo Souhaitez-vous activer MemPak? >con
echo Cela est recommandé pour les jeux utilisant le Memory Pak. >con
set /p MemPak=[O/N:] >con
echo.>con
IF /i "%MemPak%"=="o" (
echo MemPak = ^1>>%BASEINI%.ini
GOTO:PreParse
)
IF /i "%MemPak%"=="n" (
GOTO:PreParse
)
GOTO:MEMPAK

:PreParse
cls
echo Souhaitez-vous activer NeedPreParse? >con
echo Cela corrigera quelques problèmes et bugs graphiques. >con
set /p PreParse=[O/N:] >con
echo.>con
IF /i "%PreParse%"=="o" (
@echo.>>%BASEINI%.ini
echo [Render]>>%BASEINI%.ini
echo NeedPreParse = ^1>>%BASEINI%.ini
GOTO:SM64
)
IF /i "%PreParse%"=="n" (
GOTO:SM64
)
GOTO:PreParse

:SM64
echo Souhaitez-vous activer Super Mario 64 BreakBlockInst? >con
echo Cela rendra Super Mario 64 jouable avec l'injection VC. >con
set /p SM64=[O/N:] >con
echo.>con
IF /i "%SM64%"=="o" (
@echo.>>%BASEINI%.ini
echo [BreakBlockInst]>>%BASEINI%.ini
echo Count = 1 >>%BASEINI%.ini
echo Address0 = 0x8027732C >>%BASEINI%.ini
echo Inst0 = 0x20C6FFFF >>%BASEINI%.ini
echo JmpPC0= 0x802772C0 >>%BASEINI%.ini
echo Type0 = 1 >>%BASEINI%.ini
GOTO:FinishCustom
)
IF /i "%SM64%"=="n" (
GOTO:FinishCustom
)
GOTO:SM64

:FinishCustom

cls

:: EDITING APP.XML AND META.XML

cd ..
cd ..


:NextStep
cls
echo Génération du fichier app.xml... >con
cd code
del /s app.xml >nul 2>&1
echo ^<?xml version="1.0" encoding="utf-8"?^>>app.xml
echo ^<app type="complex" access="777"^>>>app.xml
echo   ^<version type="unsignedInt" length="4"^>15^</version^>>>app.xml
echo   ^<os_version type="hexBinary" length="8"^>000500101000400A^</os_version^>>>app.xml
echo   ^<title_id type="hexBinary" length="8"^>000500001337%TITLEID%^</title_id^>>>app.xml
echo   ^<title_version type="hexBinary" length="2"^>0000^</title_version^>>>app.xml
echo   ^<sdk_version type="unsignedInt" length="4"^>21113^</sdk_version^>>>app.xml
echo   ^<app_type type="hexBinary" length="4"^>80000000^</app_type^>>>app.xml
echo   ^<group_id type="hexBinary" length="4"^>00001337^</group_id^>>>app.xml
echo   ^<os_mask type="hexBinary" length="32"^>0000000000000000000000000000000000000000000000000000000000000000^</os_mask^>>>app.xml
echo ^</app^>>>app.xml
SLEEP 1
cls

echo Génération du fichier meta.xml... >con
cd ..
cd meta
del /s meta.xml >nul 2>&1
echo ^<?xml version="1.0" encoding="utf-8"?^>>meta.xml
echo ^<menu type="complex" access="777"^>>>meta.xml
echo   ^<version type="unsignedInt" length="4"^>33^</version^>>>meta.xml
echo   ^<product_code type="string" length="32"^>WUP-N-%PRODUCTCODE%^</product_code^>>>meta.xml
echo   ^<content_platform type="string" length="32"^>WUP^</content_platform^>>>meta.xml
echo   ^<company_code type="string" length="8"^>0001^</company_code^>>>meta.xml
echo   ^<mastering_date type="string" length="32"^>^</mastering_date^>>>meta.xml
echo   ^<logo_type type="unsignedInt" length="4"^>0^</logo_type^>>>meta.xml
echo   ^<app_launch_type type="hexBinary" length="4"^>00000000^</app_launch_type^>>>meta.xml
echo   ^<invisible_flag type="hexBinary" length="4"^>00000000^</invisible_flag^>>>meta.xml
echo   ^<no_managed_flag type="hexBinary" length="4"^>00000000^</no_managed_flag^>>>meta.xml
echo   ^<no_event_log type="hexBinary" length="4"^>00000000^</no_event_log^>>>meta.xml
echo   ^<no_icon_database type="hexBinary" length="4"^>00000000^</no_icon_database^>>>meta.xml
echo   ^<launching_flag type="hexBinary" length="4"^>00000005^</launching_flag^>>>meta.xml
echo   ^<install_flag type="hexBinary" length="4"^>00000000^</install_flag^>>>meta.xml
echo   ^<closing_msg type="unsignedInt" length="4"^>0^</closing_msg^>>>meta.xml
echo   ^<title_version type="unsignedInt" length="4"^>0^</title_version^>>>meta.xml
echo   ^<title_id type="hexBinary" length="8"^>000500001337%TITLEID%^</title_id^>>>meta.xml
echo   ^<group_id type="hexBinary" length="4"^>00001337^</group_id^>>>meta.xml
echo   ^<boss_id type="hexBinary" length="8"^>0000000000000000^</boss_id^>>>meta.xml
echo   ^<os_version type="hexBinary" length="8"^>000500101000400A^</os_version^>>>meta.xml
echo   ^<app_size type="hexBinary" length="8"^>0000000000000000^</app_size^>>>meta.xml
echo   ^<common_save_size type="hexBinary" length="8"^>0000000000000000^</common_save_size^>>>meta.xml
echo   ^<account_save_size type="hexBinary" length="8"^>0000000002000000^</account_save_size^>>>meta.xml
echo   ^<common_boss_size type="hexBinary" length="8"^>0000000000000000^</common_boss_size^>>>meta.xml
echo   ^<account_boss_size type="hexBinary" length="8"^>0000000000000000^</account_boss_size^>>>meta.xml
echo   ^<save_no_rollback type="unsignedInt" length="4"^>0^</save_no_rollback^>>>meta.xml
echo   ^<join_game_id type="hexBinary" length="4"^>00000000^</join_game_id^>>>meta.xml
echo   ^<join_game_mode_mask type="hexBinary" length="8"^>0000000000000000^</join_game_mode_mask^>>>meta.xml
echo   ^<bg_daemon_enable type="unsignedInt" length="4"^>1^</bg_daemon_enable^>>>meta.xml
echo   ^<olv_accesskey type="unsignedInt" length="4"^>777542833^</olv_accesskey^>>>meta.xml
echo   ^<wood_tin type="unsignedInt" length="4"^>0^</wood_tin^>>>meta.xml
echo   ^<e_manual type="unsignedInt" length="4"^>1^</e_manual^>>>meta.xml
echo   ^<e_manual_version type="unsignedInt" length="4"^>0^</e_manual_version^>>>meta.xml
echo   ^<region type="hexBinary" length="4"^>00000004^</region^>>>meta.xml
echo   ^<pc_cero type="unsignedInt" length="4"^>128^</pc_cero^>>>meta.xml
echo   ^<pc_esrb type="unsignedInt" length="4"^>128^</pc_esrb^>>>meta.xml
echo   ^<pc_bbfc type="unsignedInt" length="4"^>192^</pc_bbfc^>>>meta.xml
echo   ^<pc_usk type="unsignedInt" length="4"^>6^</pc_usk^>>>meta.xml
echo   ^<pc_pegi_gen type="unsignedInt" length="4"^>7^</pc_pegi_gen^>>>meta.xml
echo   ^<pc_pegi_fin type="unsignedInt" length="4"^>192^</pc_pegi_fin^>>>meta.xml
echo   ^<pc_pegi_prt type="unsignedInt" length="4"^>6^</pc_pegi_prt^>>>meta.xml
echo   ^<pc_pegi_bbfc type="unsignedInt" length="4"^>7^</pc_pegi_bbfc^>>>meta.xml
echo   ^<pc_cob type="unsignedInt" length="4"^>0^</pc_cob^>>>meta.xml
echo   ^<pc_grb type="unsignedInt" length="4"^>128^</pc_grb^>>>meta.xml
echo   ^<pc_cgsrr type="unsignedInt" length="4"^>128^</pc_cgsrr^>>>meta.xml
echo   ^<pc_oflc type="unsignedInt" length="4"^>0^</pc_oflc^>>>meta.xml
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
echo   ^<drc_use type="unsignedInt" length="4"^>1^</drc_use^>>>meta.xml
echo   ^<network_use type="unsignedInt" length="4"^>0^</network_use^>>>meta.xml
echo   ^<online_account_use type="unsignedInt" length="4"^>0^</online_account_use^>>>meta.xml
echo   ^<direct_boot type="unsignedInt" length="4"^>0^</direct_boot^>>>meta.xml
echo   ^<reserved_flag0 type="hexBinary" length="4"^>00010001^</reserved_flag0^>>>meta.xml
echo   ^<reserved_flag1 type="hexBinary" length="4"^>00000000^</reserved_flag1^>>>meta.xml
echo   ^<reserved_flag2 type="hexBinary" length="4"^>00000000^</reserved_flag2^>>>meta.xml
echo   ^<reserved_flag3 type="hexBinary" length="4"^>00000000^</reserved_flag3^>>>meta.xml
echo   ^<reserved_flag4 type="hexBinary" length="4"^>00000000^</reserved_flag4^>>>meta.xml
echo   ^<reserved_flag5 type="hexBinary" length="4"^>00000000^</reserved_flag5^>>>meta.xml
echo   ^<reserved_flag6 type="hexBinary" length="4"^>00000003^</reserved_flag6^>>>meta.xml
echo   ^<reserved_flag7 type="hexBinary" length="4"^>00000001^</reserved_flag7^>>>meta.xml
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
echo   ^<publisher_ja type="string" length="256"^>Nintendo^</publisher_ja^>>>meta.xml
echo   ^<publisher_en type="string" length="256"^>Nintendo^</publisher_en^>>>meta.xml
echo   ^<publisher_fr type="string" length="256"^>Nintendo^</publisher_fr^>>>meta.xml
echo   ^<publisher_de type="string" length="256"^>Nintendo^</publisher_de^>>>meta.xml
echo   ^<publisher_it type="string" length="256"^>Nintendo^</publisher_it^>>>meta.xml
echo   ^<publisher_es type="string" length="256"^>Nintendo^</publisher_es^>>>meta.xml
echo   ^<publisher_zhs type="string" length="256"^>Nintendo^</publisher_zhs^>>>meta.xml
echo   ^<publisher_ko type="string" length="256"^>Nintendo^</publisher_ko^>>>meta.xml
echo   ^<publisher_nl type="string" length="256"^>Nintendo^</publisher_nl^>>>meta.xml
echo   ^<publisher_pt type="string" length="256"^>Nintendo^</publisher_pt^>>>meta.xml
echo   ^<publisher_ru type="string" length="256"^>Nintendo^</publisher_ru^>>>meta.xml
echo   ^<publisher_zht type="string" length="256"^>Nintendo^</publisher_zht^>>>meta.xml
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
SLEEP 1
cls

:: INJECTING IMAGES
:InjectingImages
cd ..
cd ..
cd ..
cd ..
cd png2tga
echo Conversion des images en TGA... >con
png2tgacmd.exe -i iconTex.png --width=128 --height=128 --tga-bpp=32 --tga-compression=none
png2tgacmd.exe -i bootTvTex.png --width=1280 --height=720 --tga-bpp=24 --tga-compression=none
png2tgacmd.exe -i bootDrcTex.png --width=854 --height=480 --tga-bpp=24 --tga-compression=none
IF EXIST bootLogoTex.png (png2tgacmd.exe -i bootLogoTex.png --width=170 --height=42 --tga-bpp=32 --tga-compression=none)
title Injectiine [N64]
del /f /q iconTex.png
del /f /q bootTvTex.png
del /f /q bootDrcTex.png
del /f /q bootLogoTex.png
cls
echo Déplacement des images dans le dossier meta... >con
move iconTex.tga ..\CONSOLES\N64\WORKDIR\meta
move bootTvTex.tga ..\CONSOLES\N64\WORKDIR\meta
move bootDrcTex.tga ..\CONSOLES\N64\WORKDIR\meta
move bootLogoTex.tga ..\CONSOLES\N64\WORKDIR\meta 2>nul
cls

:PackPrepare
cls
IF "%uwuhs_launch%"=="Y" (
	set packed_dir=..\..\..\..\Output
) else (
	set packed_dir=..\..\Output
)
IF NOT EXIST %packed_dir%\*.* (
	del /q %packed_dir% 2>nul
	mkdir %packed_dir%
)
IF /i "%PACKDECIDE%"=="n" (GOTO:LoadiinePack)
IF /i "%PACKDECIDE%"=="o" (GOTO:PackGame)

:LoadiinePack
cls
cd ../CONSOLES/N64
cd ..
move N64\WORKDIR "%packed_dir%\[N64] %GAMENAME% [%PRODUCTCODE%]"
GOTO:FinalCheckLoadiine

:: PACK GAME
:PackGame
echo Préparation du jeu... >con
cd ../CONSOLES/N64
cd ..
move N64\WORKDIR N64\NUSPacker\WORKDIR
cd N64
cd NUSPacker
java -jar NUSPacker.jar -in WORKDIR -out "[N64] %GAMENAME% (000500001337%TITLEID%)"
rd /s /q tmp
rd /s /q WORKDIR
rd /s /q output
cd ..
cd ..
move "N64\NUSPacker\[N64] %GAMENAME% (000500001337%TITLEID%)" %packed_dir%\

:: Final check if game exists
:FinalCheck
cd %packed_dir%
IF NOT EXIST "[N64] %GAMENAME% (000500001337%TITLEID%)" GOTO:GameError
cd "%~dp0"
CALL ..\..\functions\CONV_VAR_to_min.bat TITLEID
echo %TITLEID%>>..\..\blacklist_ids.txt
CALL ..\..\functions\CONV_VAR_to_MAJ.bat TITLEID
GOTO:GameComplete

:FinalCheckLoadiine
cd %packed_dir%
IF NOT EXIST "[N64] %GAMENAME% [%PRODUCTCODE%]" GOTO:LoadiineError
GOTO:GameComplete

:GameComplete
cls
echo :::::::::::::::::::::: >con
echo ::INJECTION COMPLETE:: >con
echo :::::::::::::::::::::: >con
echo.>con
echo Un répertoire a été créé et nomé >con
IF /i "%PACKDECIDE%"=="o" echo "[N64] %GAMENAME% (000500001337%TITLEID%)" >con
IF /i "%PACKDECIDE%"=="n" echo "[N64] %GAMENAME% [%PRODUCTCODE%]" >con
echo dans le répertoire Output. Vous pouvez l'installer en utilisant >con
echo WUP Installer GX2, WUP Installer Y Mod ou System Config Tool. >con
echo.>con
echo Il est recommandé de l'installer sur l'USB en cas de corruption du jeu. >con
echo.>con
GOTO:endscript

:: ERRORS

:LastChanceOne
IF NOT EXIST *.n64 GOTO:LastChanceTwo
GOTO:Main

:LastChanceTwo
IF NOT EXIST *.v64 GOTO:404ROMnotFound
GOTO:Main

:404ROMnotFound
cls
echo ::::::::: >con
echo ::ERREUR:: >con
echo ::::::::: >con
echo.>con
echo ROM N64 non trouvée. >con
echo.>con
GOTO:endscript

:404ImagesNotFound
cls
echo ::::::::: >con
echo ::ERREUR:: >con
echo ::::::::: >con
echo.>con
echo Images non trouvées. >con
echo.>con
echo Vérifiez que vous avez bien ces images dans le répertoire Files: >con
echo bootTvTex.png (1280 x 720) >con
echo iconTex.png (128 x 128) >con
echo.>con
GOTO:endscript

:LoadiineError
cls
echo ::::::::: >con
echo ::ERREUR:: >con
echo ::::::::: >con
echo.>con
echo La création d'un package Loadiine a échoué. >con
echo.>con
GOTO:endscript

:GameError
cls
echo ::::::::: >con
echo ::ERREUR:: >con
echo ::::::::: >con
echo.>con
echo La création d'un package WUP a échoué. >con
echo.>con
GOTO:endscript

:ROBOFAIL
cls
echo ::::::::: >con
echo ::ERREUR:: >con
echo ::::::::: >con
echo.>con
echo Robocopy n'a pas pu créé un répertoire de travail contenant les fichiers de base. >con
echo.>con
GOTO:endscript

:BASEFAIL
cls
echo ::::::::: >con
echo ::ERREUR:: >con
echo ::::::::: >con
echo.>con
echo La base personnalisée n'a pas été trouvée. >con
echo.>con
GOTO:endscript

:InternetSucks
cls
echo ::::::::: >con
echo ::ERREUR:: >con
echo ::::::::: >con
echo.>con
echo Le test de connexion internet a échoué. >con
echo.>con
GOTO:endscript

:endscript
pause >con
cd "%~dp0"
rmdir /s /q ..\..\..\templogs
IF EXIST "JNUSTool_temp" (
	del /q "JNUSTool_temp"
	rmdir /s /q "JNUSTool_temp"
)
cd ..\..
endlocal