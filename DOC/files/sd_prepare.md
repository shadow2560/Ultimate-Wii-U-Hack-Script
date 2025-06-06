<h1>Contenu des différents packs</h1>
&nbsp;
<a href="https://github.com/shadow2560/Ultimate-Wii-U-Hack-Script/tree/master/DOC/index.md">Aller à la documentation du script</a>
<br/>
<h2>Contenu du pack "hack_wiiu"</h2>
&nbsp;
<p>
Tutoriels de référence:
<br/>
<a target="_new" href="http://nintendo-wii.logic-sunrise.com/dossiers-et-tutoriaux-959469-installation-de-cfw-sur-wii-u.html">Installation d'un CFW sur Wii U</a>
<br/>
<a target="_new" href="http://nintendo-wii.logic-sunrise.com/dossiers-et-tutoriaux-950209-wii-u-bloquer-les-mises-a-jour-de-votre-wii-u-sans-dns-et-sans-spoof.html">Bloquer les mises à jour système sans DNS</a>
<br/>
<a target="_new" href="https://github.com/GaryOderNichts/udpih/">Utiliser l'exploit Udpih</a>
</p>
&nbsp;
<h3>Contenu des fichiers et dossiers à la racine de la SD:</h3>
&nbsp;
<ul>
<li>apps: Le dossier des homebrews Wii.</li>
<li>controllers: Ce dossier contient des fichiers de configuration permettant de faire en sorte que certaines manettes soient reconnues par Nintendont.</li>
<li>games: Le dossier pour la mise en place de la structure des jeux Gamecube.</li>
<li>install: Le dossier dans lequel on copiera les jeux, DLCs, mises à jour et chaînes à installer via l'homebrew Wup Installer GX2.</li>
<li>wiiu: Ce dossier contient un dossier apps qui est le dossier contenant les homebrews Wii U.</li>
<li>nincfg.bin: Un fichier de configuration pour Nintendont. Les options de widescreen sont activées, les cartes mémoires sont émulées et une carte mémoire de 251 blocks est créée par jeu. Les autres options sont par défaut.</li>
<li>recovery_menu: Permet de lancer le Recovery Menu lié à l'exploit Udpih.</li>
</ul>
&nbsp;
<h3>Les homebrews Wii U présents dans le dossier "wiiu/apps":</h3>
&nbsp;
<ul>
<li>appstore: Installer, mettre à jour ou supprimer les homebrews de la Wii U simplement.</li>
<li>Dumpling: Dumper un grand nombre d'éléments.</li>
<li>ftpiiu_everywhere_haxchi: Si aucun CFW n'est lancé, peut être utilisé comme serveur FTP pour accéder au contenu de la SD. Si un CFW a été lancé, permet d'accéder complètement à la console, donc attention au brick. Cette version est compatible avec le CFW de Haxchi ou de CBHC uniquement.</li>
<li>ftpiiu_everywhere_mocha: La même chose que pour ftpiiu_everywhere_haxchi mais compatible avec Mocha CFW et pas avec Haxchi.</li>
<li>homebrew_launcher: La version 1.4 du Homebrew Launcher Wii U, à ne pas toucher.</li>
<li>mocha: Le CFW Mocha.</li>
<li>nanddumper: Permet de dumper la nand Wii U.</li>
<li>nnu-patcher: Permet d'installer les mises à jour des jeux ou de lancer le shop Nintendo malgré une version système inférieur à la version requise par Nintendo pour y accéder. Permet également d'y accéder si les mises à jour ont été bloquée via le routeur ou via les DNS de la console.</li>
<li>savemii_mod: Permet de sauvegarder/restaurer les sauvegardes des jeux.</li>
<li>sign_c2w_patcher: Permet de patcher la Wii U pour prendre en compte le boost des homebrews lancées via une Wii VC. Il est a noter que ce homebrew seul ne suffit pas, il faut aussi créer la Wii VC selon certaines règles pour que le boost fonctionne et tous les homebrews Wii ne sont pas compatibles.</li>
<li>sign_patcher: Permet de patcher quelques signatures et de pouvoir revenir dirrectement au HBL, pratique pour ceux en 5.5.2 sans Haxchi qui voudraient installer la chaîne HBL avec WUP Instaler. Une fois cela fait, Mocha reste plus complet donc inutile de garder ce homebrew ensuite.</li>
<li>wup_installer_gx2: Permet d'installer les jeux, DLCs, mises à jour et chaînes présent dans le dossier "install" de la carte SD. Chaque élément à installer doit être mis dans un dossier spécifique, peut importe son nom (les caractères spéciaux sont à éviter), dans ce dossier.</li>
</ul>
&nbsp;
<h3>Les homebrews Wii présents dans le dossier "apps":</h3>
&nbsp;
<ul>
<li>nintendont: Le loader de jeux Gamecube.</li>
</ul>
&nbsp;
<h3>Les chaînes à installer avec WUP Installer et les sig_patches activés (utiliser Mocha, le CFW d'Haxchi ou CBHC):</h3>
&nbsp;
<ul>
<li>hbl_channel: La chaîne du Homebrew Launcher.</li>
<li>wup_installer_gx2_channel: La chaîne de Wup Installer GX2.</li>
</ul>
&nbsp;
<h2>Contenu des environements (Tiramisu et Aroma)</h2>
&nbsp;
<p>
Tutoriel de référence:
<br/>
<a target="_new" href="https://wiiu.hacks.guide/#/tiramisu/sd-preparation">Mise en place de l'environement Tiramisu</a>
<br/>
<a target="_new" href="https://github.com/GaryOderNichts/udpih/">Utiliser l'exploit Udpih</a>
</p>
&nbsp;
<h3>Contenu des fichiers et dossiers à la racine de la SD:</h3>
&nbsp;
<ul>
<li>apps: Le dossier des homebrews Wii.</li>
<li>controllers: Ce dossier contient des fichiers de configuration permettant de faire en sorte que certaines manettes soient reconnues par Nintendont.</li>
<li>games: Le dossier pour la mise en place de la structure des jeux Gamecube.</li>
<li>install: Le dossier dans lequel on copiera les jeux, DLCs, mises à jour et chaînes à installer via l'homebrew Wup Installer GX2.</li>
<li>wiiu: Ce dossier contient un dossier apps qui est le dossier contenant les homebrews Wii U. Ce dossier "wiiu"  contient également les dossiers/fichiers nécessaires à la mise en place des environements.</li>
<li>nincfg.bin: Un fichier de configuration pour Nintendont. Les options de widescreen sont activées, les cartes mémoires sont émulées et une carte mémoire de 251 blocks est créée par jeu. Les autres options sont par défaut.</li>
<li>recovery_menu: Permet de lancer le Recovery Menu lié à l'exploit Udpih.</li>
</ul>
&nbsp;
<h3>Les homebrews Wii U présents dans le dossier "wiiu/apps":</h3>
&nbsp;
<ul>
<li>appstore: Installer, mettre à jour ou supprimer les homebrews de la Wii U simplement.</li>
<li>Bloopair_pair_menu: Utiliser des manettes différentes de celles de la WiiU.</li>
<li>Dumpling: Dumper un grand nombre d'éléments.</li>
<li>homebrew_launcher: La version 1.4 du Homebrew Launcher Wii U, à ne pas toucher.</li>
<li>nanddumper: Permet de dumper la nand Wii U.</li>
<li>nnu-patcher: Permet d'installer les mises à jour des jeux ou de lancer le shop Nintendo malgré une version système inférieur à la version requise par Nintendo pour y accéder. Permet également d'y accéder si les mises à jour ont été bloquée via le routeur ou via les DNS de la console.</li>
<li>savemii_mod: Permet de sauvegarder/restaurer les sauvegardes des jeux.</li>
<li>sign_c2w_patcher: Permet de patcher la Wii U pour prendre en compte le boost des homebrews lancées via une Wii VC. Il est a noter que ce homebrew seul ne suffit pas, il faut aussi créer la Wii VC selon certaines règles pour que le boost fonctionne et tous les homebrews Wii ne sont pas compatibles.</li>
<li>wup_installer_gx2: Permet d'installer les jeux, DLCs, mises à jour et chaînes présent dans le dossier "install" de la carte SD. Chaque élément à installer doit être mis dans un dossier spécifique, peut importe son nom (les caractères spéciaux sont à éviter), dans ce dossier.</li>
</ul>
&nbsp;
<p>
Note importante: Les homebrews "mocha" et "sign_patcher" seront automatiquement supprimés car inutils dans les environements.
</p>
&nbsp;
<h3>Les homebrews Wii présents dans le dossier "apps":</h3>
&nbsp;
<ul>
<li>nintendont: Le loader de jeux Gamecube.</li>
</ul>
&nbsp;
<h3>Les chaînes à installer avec WUP Installer et les sig_patches activés (utiliser Mocha, le CFW d'Haxchi ou CBHC):</h3>
&nbsp;
<ul>
<li>hbl_channel: La chaîne du Homebrew Launcher.</li>
<li>wup_installer_gx2_channel: La chaîne de Wup Installer GX2.</li>
</ul>
&nbsp;
<h2>Contenu du pack "hack_v-wii"</h2>
&nbsp;
<p>
Tutoriel de référence:
<br/>
<a target="_new" href="http://nintendo-wii.logic-sunrise.com/dossiers-et-tutoriaux-924206-installation-de-lhomebrew-channel-sur-vwii-et-lancement-de-backups-wii-sur-wii-u.html">Installation de l'Homebrew Channel sur vWii et lancement de backups Wii sur Wii U</a>
</p>
&nbsp;
<h3>Contenu des fichiers et dossiers à la racine de la SD:</h3>
&nbsp;
<ul>
<li>apps: Le dossier des homebrews Wii.</li>
<li>install: Le dossier dans lequel on copiera les jeux, DLCs, mises à jour et chaînes à installer via l'homebrew Wup Installer GX2.</li>
<li>wad: Le dossier contenant les wads compatibles v-wii à installer avec Some-YAWMM-Mod.</li>
<li>wbfs: Le dossier dans lequel copier les jeux Wii pour les loaders.</li>
<li>wiiu: Ce dossier contient un dossier apps qui est le dossier contenant les homebrews Wii U.</li>
<li>boot.elf: Le fichier extrait de Hackmii nécessaire pour hacker la v-wii avec Wuphax.</li>
<li>hbl2hbc.txt: Un fichier de configuration pour le homebrew HBL2HBC, celui-ci peut être modifié selon les besoins.</li>
</ul>
&nbsp;
<h3>Les homebrews Wii U présents dans le dossier "wiiu/apps":</h3>
&nbsp;
<ul>
<li>hbl2hbc: Permet de booter dirrectement sur une chaîne installée sur la v-wii.</li>
<li>homebrew_launcher: La version 1.4 du Homebrew Launcher Wii U, à ne pas toucher.</li>
<li>mocha: Le CFW Mocha.</li>
<li>vwii-nand-restorer: Permet de restaurer un dump "slccmpt.bin" de la v-wii (nécessite les clés de votre console "otp.bin" et "keys.bin"). Permet aussi d'extraire un dump, de restaurer via un dump extrait, de remettre à zéro la partie slccmpt de la console et de fixer les permissions des dossiers de la partie slccmpt de la console.</li>
<li>sign_patcher: Permet de patcher quelques signatures et de pouvoir revenir dirrectement au HBL, pratique pour ceux en 5.5.2 sans Haxchi qui voudraient installer la chaîne HBL avec WUP Instaler. Une fois cela fait, Mocha reste plus complet donc inutile de garder ce homebrew ensuite.</li>
<li>wuphax: Permet de préparer ou de restaurer la chaîne Mii de la v-wii pour hacker la partie v-wii.</li>
<li>wup_installer_gx2: Permet d'installer les jeux, DLCs, mises à jour et chaînes présent dans le dossier "install" de la carte SD. Chaque élément à installer doit être mis dans un dossier spécifique, peut importe son nom (les caractères spéciaux sont à éviter), dans ce dossier.</li>
</ul>
&nbsp;
<h3>Les homebrews Wii présents dans le dossier "apps":</h3>
&nbsp;
<ul>
<li>CleanRip: Permet de dumper les jeux Gamecube et Wii.</li>
<li>d2x-cios-installer: Nécessaire pour installer quelques IOS v-wii pour pouvoir utiliser correctement les loaders.</li>
<li>DmpMiNND: Permet de dumper la nand v-wii.</li>
<li>homebrew_browser: Permet de télécharger dirrectement des homebrews Wii.</li>
<li>IOS236 Installer MOD v8 Special vWii Edition: Installe l'IOS 236 modifié pour la v-wii, n'est pas indispensable à utiliser pour le hack v-wii et doit donc être utilisé si vous savez se que vous faites.</li>
<li>Patched IOS80 Installer for vWii: Installe l'IOS 80 modifié pour la v-wii permettant de pouvoir installer ensuite les wads.</li>
<li>some-yawmm-mod: Permet d'installer ou de désinstaller des wads.</li>
<li>SysCheckHDE: Permet de vérifier le système v-wii et de créer un rapport.</li>
<li>YetAnotherBlueDumpMod: Permet de dumper les IOS de la v-wii. Il est fortement conseillé de le faire même si cela est un peu long.</li>
</ul>
&nbsp;
<h3>Les chaînes à installer avec WUP Installer et les sig_patches activés (utiliser Mocha, le CFW d'Haxchi ou CBHC):</h3>
&nbsp;
<ul>
<li>hbl_channel: La chaîne du Homebrew Launcher.</li>
<li>WiiU 2 HBC: La chaîne pour HBL2HBC.</li>
<li>wup_installer_gx2_channel: La chaîne de Wup Installer GX2.</li>
</ul>
&nbsp;
<h3>Les wads présent dans le dossier "wad"</h3>
&nbsp;
<ul>
<li>Homebrew Channel - HBCB Modified.wad: Permet d'avoir le HBC qui corrige le bug d'affichage du HBC classique.</li>
<li>Homebrew.Channel.-.OHBC_1.4.1.wad: L'open Homebrew Channel, à installer et à utiliser à la place du HBC classique. Attention, ne pas désinstaller le HBC classique malgré tout.</li>
</ul>
&nbsp;
<h2>Contenu du pack "haxchi-cbhc"</h2>
&nbsp;
<p>
Tutoriels de référence:
<br/>
<a target="_new" href="http://nintendo-wii.logic-sunrise.com/dossiers-et-tutoriaux-959469-installation-de-cfw-sur-wii-u.html">Installation d'un CFW sur Wii U</a>
<br/>
<a target="_new" href="http://nintendo-wii.logic-sunrise.com/dossiers-et-tutoriaux-950209-wii-u-bloquer-les-mises-a-jour-de-votre-wii-u-sans-dns-et-sans-spoof.html">Bloquer les mises à jour système sans DNS</a>
<br/>
</p>
&nbsp;
<p>
Cette partie est un peu particulière. Seul le HBL, Ftpiiu_everywhere, Nnupatcher et le nécessaire pour installer soit Haxchi, soit CBHC se trouvent dans ces packs. S'il vous plaît, évitez d'utiliser Haxchi si CBHC est installé sur votre console à moins de savoir se que vous faites sous peine de brick.
<br/><br/>
Note: Si vous utilisez Haxchi, vous pouvez modifier le fichier "config.txt" se trouvant dans le dossier "haxchi" de votre carte SD pour qu'il utilise les homebrews de votre choix (homebrews au format "elf" uniquement). Pour que les modifications de ce fichier soient prises en compte, il faudra relancer l'installeur d'Haxchi sur le jeu que vous utilisez (ne surtout pas faire ça sur le jeu sur lequel  vous utilisez CBHC sous peine de brick).
<br/>
Le fichier "config.txt" du pack permet par défaut de lancer le CFW d'Haxchi, de lancer Mocha en maintenant le bouton "A" et de lancer le HBL en maintenant le bouton "B" (boutons à maintenir sur le Gamepad uniquement).
<br/><br/>
ATTENTION: Si vous installez CBHC, il y a des règles à suivre pour ne pas bricker votre Wii U, veuillez les respecter. Vous êtes seul responsable des domages qui pourraient résulter de son utilisation sur votre console.
<br/><br/>
Notez que vous pouvez annuler l'autoboot de CBHC en appuyant sur la touche "Home" lorsque le message "autobooting..." s'affiche. Vous pouvez alors reconfigurer CBHC ou lancer un des homebrews proposé.
</p>
<br/><br/>
<a href="https://github.com/shadow2560/Ultimate-Wii-U-Hack-Script/tree/master/DOC/index.md">Aller à la documentation du script</a>