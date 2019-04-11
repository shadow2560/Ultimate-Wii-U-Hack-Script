# Ultimate-Wii-U-Hack-Script

Ceci est un ensemble de scripts batch automatisant beaucoup de choses.

La licence GPL V3 s'applique sur les scripts batch . Pour le reste, les licences propres aux logiciels concernés s'appliquent.

## Fonctionnalités

### Wiivc Injector Script

* Injection de jeux Wii, Gamecube, homebrews Wii et Wiivc Chan Booter grâce à une version modifiée de Wiivc Injector Script 2.2.6.
* Sauvegarde, restauration et remise à zéro des différents paramètres.
* Création d'une blacklist pour éviter qu'une injection puisse avoir le même Title ID.
### Injectiine

* Injection de jeux NES, SNES, GBA, N64 et NDS grâce à une version modifiée de Injectiine.
* Sauvegarde, restauration et remise à zéro des différents paramètres.
* Création d'une blacklist pour éviter qu'une injection puisse avoir le même Title ID.

### Autres fonctionnalités

* Installation des éléments requis pendant l'utilisation des scripts (Java 8).
* Mises en place des fichiers nécessaires au hack basique Wii U, au hack de la partie v-wii, à l'installation d'Haxchi ou à l'installation de CBHC. Pour plus d'informations, voir <a href="files\sd_prepare.html">cette page de la documentation</a>.
* Création d'un serveur web permettant d'héberger l'exploit navigateur en local pour les versions système 5.5.0, 5.5.1 et 5.5.2 de la Wii U.
* Débricker la partie V-wii, voir <a href="files/unbrick_v-wii.html">cette page de la documentation</a> pour plus d'informations.
* Bloquer ou autoriser la mise à jour du firmware de la console en supprimant/restaurant le dossier adéquat via Wup_server, voir <a target="_new" href="http://nintendo-wii.logic-sunrise.com/dossiers-et-tutoriaux-950209-wii-u-bloquer-les-mises-a-jour-de-votre-wii-u-sans-dns-et-sans-spoof.html">cette page</a> pour plus d'informations sur le dossier modifié.

## Bugs connus:

* L'injection d'un jeu via Wiivc Injector Script plantera ou donnera un jeu ne fonctionnant pas s'il est exécuté à partir d'un support formaté en FAT, FAT16 ou FAT32. Ce problème ne peut pas être corrigé car un fichier temporaire fait obligatoirement plus de 4 GO durant l'injection et donc pose problème sur les supports formatés en FAT, FAT16 ou FAT32.
* L'utilisation de guillemets ou de points d'exclamations dans les entrées utilisateurs fait planter le script.
* Lorsqu'une sortie console faite par un "echo" est effectuée, cela produit une erreur dans le fichier log. L'encodage en UTF-8 semble être à l'origine de ce problème mais je n'ai pas trouvé comment le résoudre pour l'instant.
* Dans Wiivc Injector Script, si le jeu Wii est splité (sauf fichiers "wbfs") et que son chemin ou son nom contient un accent ou tout autre symboles refusé par Wit, le script ne fonctionnera pas, même avec la tentative de correction d'erreurs.
* Pour l'instant, le script permettant d'extraire le dump MLC de la nand Wii U n'accepte pas l'extraction vers un dossier se trouvant dans un chemin ayant des espaces et est obligé de faire des manipulations sur les fichiers qui ne devraient pas être nécessaire mais Wfs-extract ne semble pas vouloir des chemins avec des espaces, je cherche une solution.

## Crédits:

Il y a vraiment trop de monde à remercier pour tous les projets intégrés à ce script mais je remercie chaque contributeur de ces projets car sans eux ce script ne pourrait même pas exister (certains sont créditer dans la documentation). Je remercie également tout ceux qui m'aident à tester les scripts et ceux qui me suggèrent de nouvelles fonctionnalités.