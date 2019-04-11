::Script by Shadow256
set "chaine1=%~2"
set nb=%~3
set i=0
:check_chars_changing
IF %i% NEQ %nb% (
	set "temp_letter=!chaine1:~%i%,1!"
	::chars replacement begin
	if "!temp_letter!"=="&" set temp_letter=^^^&amp;
	::if "!temp_letter!"=="à" set temp_letter=Ã 
	::if "!temp_letter!"=="â" set temp_letter=Ã¢
	::if "!temp_letter!"=="é" set temp_letter=Ã©
	::if "!temp_letter!"=="è" set temp_letter=Ã¨
	::if "!temp_letter!"=="ê" set temp_letter=Ãª
	::if "!temp_letter!"=="ë" set temp_letter=Ã«
	::if "!temp_letter!"=="î" set temp_letter=Ã®
	::if "!temp_letter!"=="ï" set temp_letter=Ã¯
	::if "!temp_letter!"=="ô" set temp_letter=Ã´
	::if "!temp_letter!"=="ö" set temp_letter=Ã¶
	::if "!temp_letter!"=="ù" set temp_letter=Ã¹
	::if "!temp_letter!"=="û" set temp_letter=Ã»
	::if "!temp_letter!"=="ü" set temp_letter=Ã¼
	::if "!temp_letter!"=="ç" set temp_letter=Ã§
	::if "!temp_letter!"=="æ" set temp_letter=Ã¦
	::if "!temp_letter!"=="œ" set temp_letter=Å
	::if "!temp_letter!"=="€" set temp_letter=â¬
	::if "!temp_letter!"=="°" set temp_letter=Â°
	::if "!temp_letter!"=="©" set temp_letter=Â©
	::if "!temp_letter!"=="¤" set temp_letter=Â¤
	::chars replacement end
	set "chaine2=!chaine2!!temp_letter!"
	set /a i+=1
	goto:check_chars_changing
)
set "%~1=%chaine2%"