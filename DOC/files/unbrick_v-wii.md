<h1>Fonctions de débrick de la V-wii</h1>
&nbsp;
<a href="https://github.com/shadow2560/Ultimate-Wii-U-Hack-Script/tree/master/DOC/index.md">Aller à la documentation du script</a>
<br/>
<h2>Généralités</h2>
&nbsp;
<p>
Cette partie de la documentation expliquera le fonctionnement de l'ensemble de scripts permettant de débricker la partie V-wii d'une Wii U européenne. Les sources de ces infos proviennent de <a target="_new" href="https://www.reboot.ms/forum/threads/unbrick-vwii-di-wiiu.5056/">cette page</a>.
<br/><br/>
<strong>Important: Sauvegarder les fichiers sur une Wii U dont la partie V-wii est déjà bricker ne sert à rien, il faut que cela soit fait sur une Wii U européenne sur laquelle la V-wii fonctionne correctement pour pouvoir ensuite restaurer les fichiers d'une V-wii brickée.</strong>
<br/><br/>
<strong>Important: Ne pas mettre vos sauvegardes dans un dossier nommé "save_v-wii" dans les dossiers du script car ce dossier est utilisé par les différents scripts et il est nettoyé au début et à la fin de l'exécution de ceux-ci donc vous perdriez vos sauvegardes dans le même temps.</strong>
<br/><br/>
Sachez que la sauvegarde, le remplacement, la suppression ou le changement de permissions des dossiers peuvent aussi être faites en lançant Haxchi/Mocha ou en ayant CBHC d'installé et en lançant Ftpiiu_everywhere sur la Wii U. Ensuite, il ne restera plus qu'à se connecter via un client FTP et à procéder aux changements décrient dans les différentes parties qui suivront. Notez que de cette façon, la vitesse de transfert des fichiers est nettement plus rapide qu'en utilisant Wup_server.
<br/><br/>
Pour utiliser les scripts décrient ci-après, vous devrez lancer Wup_server sur votre console et avoir un PC se trouvant sur le même réseau que la console. La manière la plus simple de le faire est de lancer Mocha en laissant les options par défaut. Notez qu'il faut que les modifications soient faites sur la Sysnand, le mode V-wii ne fonctionnant de toute façon pas sur une Rednand. Il vous faudra également connaître l'adresse IP de votre console (adresse du type "192.168.1.3"), vous pouvez lancer Ftpiiu pour l'obtenir simplement.
</p>
&nbsp;
<h2>Sauvegarde des fichiers importants</h2>
&nbsp;
<p>
Ce script sauvegarde les fichiers "/vol/storage_mlccmpt01/title/00000001/00000002/content/00000022.app" et "/vol/storage_mlccmpt01/title/00000001/00000002/content/00000023.app" ainsi que le dossier "/vol/storage_mlccmpt01/title/00000001/00000050" et son contenu.
</p>
&nbsp;
<h2>Restauration des fichiers importants</h2>
&nbsp;
<p>
Ce script restaure les fichiers "/vol/storage_mlccmpt01/title/00000001/00000002/content/00000022.app" et "/vol/storage_mlccmpt01/title/00000001/00000002/content/00000023.app" ainsi que le dossier "/vol/storage_mlccmpt01/title/00000001/00000050" et son contenu à partir d'une sauvegarde faite précédemment.
</p>
&nbsp;
<h2>Restauration des permissions du dossier "storage_slccmpt01"</h2>
&nbsp;
<p>
Restaure les permissions de tous les dossiers du dossier "/vol/storage_slccmpt01" à "755". Ce script est à exécuter en cas de restauration complète du contenu du dossier "slccmpt01", juste après que la restauration ai été faite.
<br/><br/>
Notez que la fonction de sauvegarde/restauration complète du dossier "slccmpt01" n'est pas gérée par les scripts que je propose car cela serait bien trop long à faire en passant par Wup_server. Pour faire une sauvegarde/restauration du dossier "slccmpt01", je conseil donc d'utiliser un client FTP puis d'exécuter le script de restauration des permissions une fois que la restauration sera terminée.
</p>
&nbsp;
<h2>Suppression d'un titre v-wii</h2>
&nbsp;
<p>
Sauvegarde un titre V-wii contenu dans le dossier "/vol/storage_slccmpt01/title/00000001" puis le supprime de la console. Ce script peut être pratique pour récupérer d'un "banner brick" mais il faut connaître le numéro du titre responsable de ce brick.
<br/><br/>
Soyez prudent en utilisant cette fonction car cela supprime définitivement des fichiers de la partie v-wii, pouvant causer le brick de celle-ci.
</p>
&nbsp;
<h2>Restauration d'un titre v-wii</h2>
&nbsp;
<p>
Restaure un titre V-wii contenu dans le dossier "/vol/storage_slccmpt01/title/00000001" sauvegardé précédemment via la suppression d'un titre V-wii. Ce script peut être pratique pour récupérer d'un brick causé par la suppression d'un titre V-wii.
</p>
&nbsp;
<h2>Restauration complète de la v-wii</h2>
&nbsp;
<p>
Cette fonction n'ai pas gérée par mes scripts car cela serait trop long à faire via Wup_server mais je vais décrire ici la solution ultime pour restaurer la v-wii si aucune autre technique n'a fonctionné.
</p>
<ul>
<li>Tout d'abord, il faut sauvegarder l'intégralité du dossier "slccmpt01" d'une Wii U sur laquelle la v-wii fonctionne via Ftpiiu_everywhere.</li>
<li>Je conseil de faire la même chose sur la Wii U dont la V-wii est brickée, on ne sais jamais.</li>
<li>Ensuite, toujours via Ftpiiu_everywhere, il faut restaurer ce dossier sur la Wii U sur laquelle le mode V-wii est brické (la Wii U doit être de la même région et probablement sur le même firmware que celle utilisée pour la sauvegarde), écrasez les fichiers/dossiers si nécessaire.</li>
<li>Pour terminer, il faut restaurer les permissions des dossiers via mon script ou via le serveur FTP (ne pas redémarrer la console entre temps si vous souhaitez le faire de cette façon) (permissions mise à "755" par mon script, peuvent aussi apparemment être mises à "666").</li>
</ul>
<br/><br/>
<a href="https://github.com/shadow2560/Ultimate-Wii-U-Hack-Script/tree/master/DOC/index.md">Aller à la documentation du script</a>