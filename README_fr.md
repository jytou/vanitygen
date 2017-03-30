But: génère des adresses Duniter « vanité »

# Introduction

Ce programme permet de chercher des adresses publiques contenant certains motifs, et donne le mot de passe et sel nécessaires pour se connecter avec ces adresses. N'avez-vous jamais rêvé d'avoir une adresse de type :

    JeanDupond1PivbbQCsfyJrAUDZJTqfnQHqJm2E89Vc

ou bien

    MonAssocySrb7tfj3buJUQbL7xTSWi5JnGYwmC6Qpes

Si c'est le cas, alors ce générateur est exactement ce qu'il vous faut!

# Avertissement

Si vous faites tourner cet utilitaire sur une machine dont vous n'avez pas le contrôle total, quelqu'un pourrait espionner votre terminal et s'emparer des mots de passe et sel générés. N'utilisez ce logiciel **que** sur des environnements dont vous êtes sûrs à 100%!
# Prérequis

- Un compilateur gcc, éventuellement l'outil make. Aucune librairie n'est nécessaire.
- Un ordinateur rapide (ou mieux, une floppée d'ordinateurs rapides!).
- De la patience. Vous aurez peut-être besoin d'attendre quelques heures, ou bien semaines ou mois en fonction de vos exigences. Jetez un coup d'œil à la section Conseils ci-dessous.

# Installation et compilation

Téléchargez les fichiers de ce dépôt ou bien en ligne de commande "git clone https://github.com/jytou/vanitygen.git".
Vérifiez le fichier Makefile et commentez/décommentez ce qui correspond à votre système.

Pour savoir si votre processeur supporte SSE ou non, voilà quelques suggestions:
- si le processeur n'est pas un ARM et qu'il est assez récent, il y a de grandes chances qu'il supporte SSE,
- tapez "grep -i sse /proc/cpuinfo" en ligne de commande, normalement il ne supporte SSE que si des informations s'affichent,
- de toute façon, si SSE est activé et que le système ne le supporte pas, il y a de grandes chances que la compilation échoue.

À remarquer que pour les processeurs ne supportant pas SSE, la vitesse de recherche est bien moindre. Un processeur 4 cœurs ARM à 1.2GHz sur un Raspberry Pi 3 atteint 22 clés/s, alors qu'un AMD ou un processeur Intel i5 à 1.4GHz avec SSE activé atteint 150-200 clés/s sur 4 cœurs, et des systèmes avec double Xeon et 24 cœurs peuvent atteindre 1000 clés/s. Mais la consommation en électricité et le coût de ces différents systèmes sont aussi vastes que leurs performances.

Lancez make. Et voilà!

Je n'ai testé que sur des systèmes Unix comme Linux et Solaris. N'hésitez pas à proposer des corrections pour Windows, MacOS ou tout autre système que vous utilisez.
Il faut bien voir aussi que, au regard des opérations de bas niveau effectuées (décallages de bits, xors, etc.), la première étape que suit le programme est de générer une adresse connue à partir d'un couple mot de passe/sel connu, et s'assure que le résultat généré est correct pour éviter de générer de fausses clés par la suite.

# Trouver ce que vous cherchez

Le programme cherche en fonction des expressions régulières (regex en anglais) que vous fournissez. Les expressions régulières sont de type POSIX, et le programme se base sur les librairies standard système pour effectuer la recherche. Vous pouvez chercher autant d'expressions que vous le voulez et les insérer dans un fichier texte, une expression par ligne.

# Conseils sur la complexité des expressions régulières

Sur une machine correcte, vous pouvez espérer atteindre 200 addresses par seconde. Si vous générez des clés à partir d'un noyau, vous pouvez atteindre 50k addresses par seconde, mais vous ne pourrez pas vous logger dans les clients classiques duniter (Cesium et Sakia), seul Silkaj (en ligne de commande) le supporte pour le moment. C'est dans tous les cas très lent. Si le pourcentage de chances de trouver une clé correspondant à votre expression régulière est de 0,000001%, vous devriez être prêt à attendre au moins un mois. C'est long. Alors, avant de vous jeter sur des expressions régulières, il est sage d'estimer le temps moyen pour trouver une adresse correspondante. Inutile de chercher une expression régulière s'il faut attendre 500 ans pour avoir un résultat.

Les adresses publiques utilisent 58 caractères différents. Alors, si vous cherchez un mot de 5 lettres (sensible à la casse) au tout début de la chaîne, la probabilité d'en trouver une est de : (1/58)^5=0,000000002. Ce qui fait, à 200 clés par seconde, un temps de recherche moyen de 20 jours. Si en revanche, vous cherchez votre chaîne n'importe où dans la clé publique, alors vous multipliez vos chances par la taille de la clé moins 5 (les clés font 43 caractères), ce qui ramène à peu près à un jour de recherche. Mais dans ce cas, votre magnifique nom ou expression risque d'être noyé en plein milieu de la clé, et ne sera pas visible.

Vous pouvez aussi améliorer vos chances (et donc raccourcir statistiquement le temps de recherche) en recherchant sans être sensible à la casse, voire même en utilisant le style « hackeur » (1 pour l, 3 pour E, etc.).

Et bien sûr, si vous pouvez faire tourner plusieurs machines en parallèle, vous augmentez vos chances d'autant.

Si vous n'êtes pas à l'aise avec les statistiques, vous pouvez commencer par rechercher des expressions faciles et courtes, comme par exemple "^bad" et voir en combien de temps vous obtenez un résultat pour ensuite itérativement complexifier vos recherches.

# Usage

Usage: [-s][-n min max][-w fichiermots [-f typeremplissage][-c]] fichierexpressions

	-n min max (optionnel): nombre minimum et maximum de caractères/mots à utiliser pour générer des mots de passe.
	-w fichiermots (optionnel): générer des mots de passe/sel avec une liste de mots contenue dans le fichier « fichiermots », plutôt que générer à partir de caractères aléatoires.
		-f typeremplissage (optionnel) type de remplissage entre les mots: 0=espaces (défaut), 1=caractères spéciaux et chiffres, 2=aucun.
		-c (optionnel): met en majuscule le premier caractère de chaque mot (vous pouvez aussi mettre des mots avec majuscules dans le fichier de mots).
	-s (optionnel): Générer uniquement à partir d'un noyau, sans mot de passe/sel (!!!ATTENTION!!! Vous ne pourrez pas vous logger dans Sakia ou Cesium avec un noyau).
	fichierexpressions (requis): un fichier contenant une liste d'expressions régulières (une par ligne). Les lignes commençant par une tabulation sont ignorées.

Exemples d'expressions régulières:

    Clé publique commençant par "duniter" non sensible à la casse: "^[Dd][Uu][Nn][Ii][Tt][Ee][rR]"
    Clé publique contenant "Duniter" sensible à la casse: "Duniter"
    Clé publique se terminant par "Freedom" (avec éventuellement un style hacker :p ): "[fF][rR][eE3][eE3][dD][oO0][mM]$"

Exemples d'utilisation:

    Simple avec expression régulière: regex.txt
        Exemple de mot de passe/sel généré: "q,d/dQ[i6-?_w$,#I/yu"

    Génération à partir d'un fichier de mots, utilisant de 6 à 10 mots, commençant par une majuscule: -w words.txt -n 6 10 -c regex.txt
        Exemple de mot de passe/sel généré: "Apple Factory Jump Music Truck Buddha Movie Fountain"

    Génération à partir d'un fichier de mots, séparés par des caractères spéciaux et chiffres: -w words.txt -f 1 regex.txt
        Exemple de mot de passe/sel généré: "apple!factory5jump;music-truck9buddha<movie(fountain"

# License

Ce programme contient des parties de code copiées de la librairie NaCL.
J'ai aussi copié du code depuis diverses sources, mais ce code a été modifié de manière conséquente.

# Pour les curieux

J'ai écrit ce programme dans l'espoir de le convertir un jour en opencl pour accélérer le processus, c'est la raison pour laquelle j'ai inclus à l'intérieur toutes les dépendances pour pouvoir les porter en opencl. Ça arrivera peut-être un jour!
