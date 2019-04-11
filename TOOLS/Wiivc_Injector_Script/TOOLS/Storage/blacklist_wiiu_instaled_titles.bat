::Script by Shadow256
setlocal
echo on
chcp 65001 >nul
IF NOT EXIST templogs\*.* (
	del /q templogs 2>nul
	mkdir templogs
)
IF NOT EXIST TOOLS\Storage\blacklist_ids.txt copy nul TOOLS\Storage\blacklist_ids.txt
::IF EXIST TOOLS\Wupclient\wupclient.py set /p confirm_ip=Voulez-vous concerver l'adresse IP utilisée pour se connecter à votre Wii U? (O/n): >con
::IF /i "%confirm_ip%"=="o" goto:define_ids
set /p custom_ip=Entrez l'adresse IP de votre Wii U: >con
::TOOLS\gnuwin32\bin\head.exe -q -n+28 <TOOLS\Wupclient\wupclient_orig.py >TOOLS\Wupclient\wupclient.py
::echo     def __init__(self, ip='%custom_ip%', port=1337):>>TOOLS\Wupclient\wupclient.py
::TOOLS\gnuwin32\bin\tail.exe -q -n+30 <TOOLS\Wupclient\wupclient_orig.py >>TOOLS\Wupclient\wupclient.py

:define_ids
TOOLS\Wupclient\list_title_folders.exe %custom_ip% >templogs\ids_list.txt
TOOLS\gnuwin32\bin\egrep.exe "*ff/$" <templogs\ids_list.txt >templogs\ids_list2.txt
TOOLS\gnuwin32\bin\cut.exe --output-delimiter=ff -c 8-11 templogs\ids_list2.txt >templogs\ids_list3.txt
TOOLS\gnuwin32\bin\grep.exe "1337" <templogs\ids_list.txt >templogs\ids_list2.txt
TOOLS\gnuwin32\bin\cut.exe --output-delimiter=1337 -c 10-13 templogs\ids_list2.txt >>templogs\ids_list3.txt
del /q templogs\ids_list.txt
move templogs\ids_list3.txt templogs\ids_list.txt
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\ids_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
IF "%tempcount%"=="0" (
	echo Aucun ID à blacklister ou il n'a pas été possible d'accéder à votre Wii U. >con
	goto:endscript
)
:blacklisting
IF "%tempcount%"=="0" (
	echo Blacklist effectuée. >con
	goto:endscript
)
TOOLS\gnuwin32\bin\head.exe -%tempcount% <templogs\ids_list.txt | TOOLS\gnuwin32\bin\tail.exe -1>templogs\ids_list2.txt
set /p temp_id=<templogs\ids_list2.txt
TOOLS\gnuwin32\bin\grep.exe -m 1 "%temp_id%" <TOOLS\Storage\blacklist_ids.txt >templogs\ids_list2.txt
set /p temp_id2=<templogs\ids_list2.txt
IF "%temp_id2%"=="" (
	echo %temp_id%>>TOOLS\Storage\blacklist_ids.txt
	set temp_id=
) else (
	set temp_id=
	set temp_id2=
)
set /a tempcount-=1
goto:blacklisting
:endscript
rmdir /s /q templogs
pause >con
endlocal