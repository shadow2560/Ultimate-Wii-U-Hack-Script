��    ;      �  O   �        6  	  0  @    q  %    k  �          +  ,   E     r  %   �  ,   �  -   �        &   2     Y     y     �     �     �  Q   �  *     [   A  G   �  <   �  <   "     _     p  5   �  1   �  :   �  3   '  N   [  P   �  (   �  ,   $  &   Q     x     �     �     �     �  (   �  �   �     �  q   �     C     b     ~     �     �     �     �     �     	     #     :     U     f  �  u  �  .  �     T  �!  �  --  m  �.  ;   J1  &   �1  O   �1  (   �1  J   &2  O   q2  P   �2  +   3  K   >3  2   �3  2   �3     �3     �3  ?   4  �   P4  6   �4  �   5     �5  s   &6  s   �6  $   7  (   37  D   \7  b   �7  �   8  R   �8  x   �8  r   V9  E   �9  >   :  H   N:  "   �:  "   �:  "   �:  (    ;  ,   );  F   V;  �  �;     l=  �   n=  H   >  [   K>  2   �>  (   �>  <   ?  $   @?  F   e?  <   �?  "   �?  (   @  (   5@     ^@     x@                   #   %                    )          ;                (   $   &   *   '      0   ,      	          8   "   /   !       -                    6         5          7              +           1   .       4                   
      2             9                 3   :        
Context control:
  -B, --before-context=NUM  print NUM lines of leading context
  -A, --after-context=NUM   print NUM lines of trailing context
  -C, --context=NUM         print NUM lines of output context
  -NUM                      same as --context=NUM
      --color[=WHEN],
      --colour[=WHEN]       use markers to highlight the matching strings;
                            WHEN is `always', `never', or `auto'
  -U, --binary              do not strip CR characters at EOL (MSDOS)
  -u, --unix-byte-offsets   report offsets as if CRs were not there (MSDOS)

 
Miscellaneous:
  -s, --no-messages         suppress error messages
  -v, --invert-match        select non-matching lines
  -V, --version             print version information and exit
      --help                display this help and exit
      --mmap                use memory-mapped input if possible
 
Output control:
  -m, --max-count=NUM       stop after NUM matches
  -b, --byte-offset         print the byte offset with output lines
  -n, --line-number         print line number with output lines
      --line-buffered       flush output on every line
  -H, --with-filename       print the filename for each match
  -h, --no-filename         suppress the prefixing filename on output
      --label=LABEL         print LABEL as filename for standard input
  -o, --only-matching       show only the part of a line matching PATTERN
  -q, --quiet, --silent     suppress all normal output
      --binary-files=TYPE   assume that binary files are TYPE;
                            TYPE is `binary', `text', or `without-match'
  -a, --text                equivalent to --binary-files=text
  -I                        equivalent to --binary-files=without-match
  -d, --directories=ACTION  how to handle directories;
                            ACTION is `read', `recurse', or `skip'
  -D, --devices=ACTION      how to handle devices, FIFOs and sockets;
                            ACTION is `read' or `skip'
  -R, -r, --recursive       equivalent to --directories=recurse
      --include=FILE_PATTERN  search only files that match FILE_PATTERN
      --exclude=FILE_PATTERN  skip files and directories matching FILE_PATTERN
      --exclude-from=FILE   skip files matching any file pattern from FILE
      --exclude-dir=PATTERN directories that match PATTERN will be skipped.
  -L, --files-without-match print only names of FILEs containing no match
  -l, --files-with-matches  print only names of FILEs containing matches
  -c, --count               print only a count of matching lines per FILE
  -T, --initial-tab         make tabs line up (if needed)
  -Z, --null                print 0 byte after FILE name
   -E, --extended-regexp     PATTERN is an extended regular expression (ERE)
  -F, --fixed-strings       PATTERN is a set of newline-separated fixed strings
  -G, --basic-regexp        PATTERN is a basic regular expression (BRE)
  -P, --perl-regexp         PATTERN is a Perl regular expression
   -e, --regexp=PATTERN      use PATTERN for matching
  -f, --file=FILE           obtain PATTERN from FILE
  -i, --ignore-case         ignore case distinctions
  -w, --word-regexp         force PATTERN to match only whole words
  -x, --line-regexp         force PATTERN to match only whole lines
  -z, --null-data           a data line ends in 0 byte, not newline
 %s: illegal option -- %c
 %s: invalid option -- %c
 %s: option `%c%s' doesn't allow an argument
 %s: option `%s' is ambiguous
 %s: option `%s' requires an argument
 %s: option `--%s' doesn't allow an argument
 %s: option `-W %s' doesn't allow an argument
 %s: option `-W %s' is ambiguous
 %s: option requires an argument -- %c
 %s: unrecognized option `%c%s'
 %s: unrecognized option `--%s'
 ' (standard input) Binary file %s matches
 Example: %s -i 'hello world' menu.h main.c

Regexp selection and interpretation:
 In GREP_COLORS="%s", the "%s" capacity %s. In GREP_COLORS="%s", the "%s" capacity is boolean and cannot take a value ("=%s"); skipped. In GREP_COLORS="%s", the "%s" capacity needs a value ("=..."); skipped. Invocation as `egrep' is deprecated; use `grep -E' instead.
 Invocation as `fgrep' is deprecated; use `grep -F' instead.
 Memory exhausted No syntax specified PATTERN is a set of newline-separated fixed strings.
 PATTERN is an extended regular expression (ERE).
 PATTERN is, by default, a basic regular expression (BRE).
 Search for PATTERN in each FILE or standard input.
 Stopped processing of ill-formed GREP_COLORS="%s" at remaining substring "%s". Support for the -P option is not compiled into this --disable-perl-regexp binary The -P and -z options cannot be combined The -P option only supports a single pattern Try `%s --help' for more information.
 Unbalanced ( Unbalanced ) Unbalanced [ Unfinished \ escape Unknown system error Usage: %s [OPTION]... PATTERN [FILE]...
 With no FILE, or when FILE is -, read standard input.  If less than two FILEs
are given, assume -h.  Exit status is 0 if any line was selected, 1 otherwise;
if any error occurs and -q was not given, the exit status is 2.
 ` `egrep' means `grep -E'.  `fgrep' means `grep -F'.
Direct invocation as either `egrep' or `fgrep' is deprecated.
 conflicting matchers specified input is too large to count invalid context length argument invalid max count malformed repeat count memory exhausted recursive directory loop unfinished repeat count unknown binary-files type unknown devices method unknown directories method warning: %s: %s
 writing output Project-Id-Version: grep 2.5.3
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2009-02-03 14:51-0400
PO-Revision-Date: 2007-09-01 17:27+0100
Last-Translator: Azilet Beishenaliev <aziletb@gmail.com>
Language-Team: Kirghiz <i18n-team-ky-kyrgyz@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
X-Poedit-Language: Kyrgyz
X-Poedit-Country: KYRGYZSTAN
 
Контексти менен жыйынтык чыгаруу:
  -B, --before-context=N    уйкаш болгон саптан мурунку N сап да көрсөтүлөт
  -A, --after-context=N     уйкаш болгон саптан кийинки N сап да көрсөтүлөт
  -C, --context=N           уйкаш болгон саптан мурунку жана кийинки N сап да көрсөтүлөт
  -N                        --context=NUM менен бирдей
      --color[=УЧУР],
      --colour[=УЧУР]       уйкаш сөз кайсы учурда айырмаландырылат
                            УЧУР - `always'(ардайым), `never'(эч качан) же `auto'(авто) боло алат.
  -U, --binary              катар соңунда (EOL) CR тамгасы алынбайт (MSDOS)
  -u, --unix-byte-offsets   орундарды CR жок болгондой кылып көрсөтөт (MSDOS)

 
Түрдүү:
  -s, --no-messages         каталарды көрсөтпөйт
  -v, --invert-match        уйкашы болбогон саптар тандалат
  -V, --version             версия маалыматын көрсөтүп бүтүрөт
      --help                бул жардам маалыматын көрсөтүп бүтүрөт
      --mmap                мүмкүнчүлүк болсо mmap кирүүсү колдонулат
 
Жыйынтык берүү опциялары:
  -m, --max-count=N         N жолу уйкаш табылгандан кийин токтойт
  -b, --byte-offset         жыйынтыкта байт жайгашуусу көрсөтүлөт
  -n, --line-number         жыйынтыкта саптын катар номери көрсөтүлөт
      --line-buffered       табылган ар саптан улам жыйынтык көрсөтүлөт
  -H, --with-filename       ар уйкаш үчүн файлдын аты көрсөтүлөт
  -h, --no-filename         жыйынтыкта файлдын аты көрсөтүлбөйт
      --label=ТАМГА         стандарт кирүүдөн келгендерди ТАМГА файлынан деп көрсөтөт
  -o, --only-matching       сапта ШАБЛОН менен уйкаш болгон жер эле көрсөтүлөт
  -q, --quiet, --silent     жазылатурган баардык жыйынтык көрсөтүлбөйт
      --binary-files=ТҮР   бинариктердин түрүн ТҮР катары алат
                            ТҮР - 'binary', 'text', же 'without-match' боло алат
  -a, --text                --binary-files=text менен бирдей
  -I                        --binary-files=without-match менен бирдей
  -d, --directories=ACTION  папкаларды кандай иштетерин билдирет
                            ACTION - 'read', 'recurse', же 'skip' боло алат
  -D, --devices=ACTION      аспаптарды, FIFO жана сокеттерди кандай иштетерин билдирет
                            ACTION - 'read' же 'skip' боло алат
  -R, -r, --recursive       --directories=recurse менен бирдей
      --include=ФАЙЛ_ШАБЛОНУ      ФАЙЛ_ШАБЛОНУ менен уйкашкан файлдар гана каралат
      --exclude=ФАЙЛ_ШАБЛОНУ      ФАЙЛ_ШАБЛОНУ менен уйкашкан файл жана папкалар каралбайт
      --exclude-from=ФАЙЛ   ФАЙЛдын ичиндеги шаблондор менен уйкашкан файлдар каралбайт
      --exclude-dir=ШАБЛОН ШАБЛОН менен уйкашкан папкалар каралбайт
  -L, --files-without-match эч уйкаш табылбаган файлдардын аты гана көрсөтүлөт
  -l, --files-with-matches  уйкаш табылган файлдардын аты гана жазылат
  -c, --count               ар файлда табылган уйкаш саны гана жазылат
  -T, --initial-tab         табтарды түздөйт (керек болсо)
  -Z, --null                файлдын атынан кийин 0 байты жазылат
   -E, --extended-regexp     ШАБЛОН кеңейтилген түрдөгү регулярдуу выражение
  -F, --fixed-strings       ШАБЛОН ар сапта бир сөз болгон жыйын
  -G, --basic-regexp        ШАБЛОН негизги түрдөгү регулярдуу выражение
  -P, --perl-regexp         ШАБЛОН Perl түрүндөгү регулярдуу выражение
   -e, --regexp=ШАБЛОН       ШАБЛОНду регулярдуу выражение катары колдон
  -f, --file=ФАЙЛ           ШАБЛОН ФАЙЛдан алынат
  -i, --ignore-case         тамгалардын чоң-кичинеси айырмаланбайт
  -w, --word-regexp         ШАБЛОН толук сөздөр менен гана уйкаштырылат
  -x, --line-regexp         ШАБЛОН толук сап менен гана уйкаштырылат
  -z, --null-data           дата(данный) саптары 0 байты(EOL эмес) менен бүтөт
 %s: мындай опция колдонулбайт -- %c
 %s: жараксыз опция -- %c
 %s: `%c%s' опциясы менен аргумент колдонулбайт
 %s: `%s' опциясы так эмес
 %s: `%s' опциясы менен аргумент болуш керек
 %s: `--%s' опциясы менен аргумент колдонулбайт
 %s: `-W %s' опциясы менен аргумент колдонулбайт
 %s: `-W %s' опциясы так эмес
 %s: бул опциянын аргументи болуш керек -- %c
 %s: бул опция түшүнүксүз `%c%s'
 %s: бул опция түшүнүксүз `--%s'
 " (стандарт кирүү) Экилик форматтагы %s файлы уйкашат
 Мисалы: %s -i 'салам дүйнө' menu.h main.c

Регулярдуу выражение тандоо жана мааниси:
 GREP_COLORS="%s" дегенде, "%s" көлөмү %s. GREP_COLORS="%s" дегенде, "%s" көлөмү булев түрүндө жана маани алалбайт ("=%s"); колдонулбайт. GREP_COLORS="%s" дегенде, "%s" көлөмүнө маани жазылыш керек ("=..."); колдонулбайт. `egrep' деген колдонулбай калды; анын ордуна `grep -E' деп колдонунуз.
 `fgrep' деген колдонулбай калды; анын ордуна `grep -F' деп колдонунуз.
 Память жетпей калды Синтаксис аталган жок ШАБЛОН ар сапта бир сөз болгон жыйын.
 ШАБЛОН кеңейтилген түрдөгү регулярдуу выражение (ERE).
 ШАБЛОН, алдынала тандалгандай, негизги түрдөгү регулярдуу выражение (BRE)
 Ар ФАЙЛда же стандарт кирүүдө ШАБЛОНду изде.
 Туура эмес жазылган GREP_COLORS="%s", "%s" катарында ишке алынуусу токтоду. Бул --disable-perl-regexp опциясы менен жасалган, -P опциясы кошулуу эмес -P жана -z опциялары чогуу колдонулбайт -P опциясы бир гана шаблон ала алат Толук маалымат үчүн `%s --help' деп жазгыла.
 ( - мунун уйкашы жок ) - мунун уйкашы жок [ - мунун уйкашы жок Бүтпөй калган эскейп \ Белгисиз система катасы Колдонулушу: %s [ОПЦИЯ]... ШАБЛОН [ФАЙЛ]...
 ФАЙЛ жазылбаса же ФАЙЛ - (тире) болсо, стандарт кирүү колдонулат. Экиден аз ФАЙЛ берилген болсо -h опциясы бар болот. Эгер сап тандалган болсо бүтүрүү статусу 0 болот, башка учурда 1; эгерде ката чыкса жана -q опциясы берилбеген болсо бүтүрүү статусу 2 болот.
 " `egrep' деген `grep -E'.  `fgrep' деген `grep -F'.
`egrep' же `fgrep'  деп туз иштетуу колдонулбай калды.
 уйкаштыруучуларда конфликттер табылды берилген данныйлардын саны саналбай турганча көп контекст узундугу жарабайт максимум сан жарабайт кайталоо саны туура эмес жазылды память жетпей калды бирибирине кирген папка айлампасы бар кайталоо саны толук эмес жазылды белгисиз файл түрү аспап методу белгисиз папка методу белгисиз эскертүү: %s: %s
 жооп жазыбатат 