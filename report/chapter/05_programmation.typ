
= Programmation du MCU

== Mise en place de l'environnement

L’environnement de développement MCUXpresso IDE a permis de configurer le projet en important le SDK spécifique au LPC804.
J’ai utilisé le LPC-Link2 (OM13054) pour la programmation et le débogage du microcontrôleur via l’interface SWD.
L’outil ConfigTools a été utilisé pour configurer les broches (via le Switch Matrix), activer les périphériques internes et générer le code d’initialisation.

#figure(
  image("../figure/mcux_tools.jpg", width: 100%),

  caption: "Programmes MCUXpresso et ces outils",
)

== L'affichage OLED via I2C

L’un des premiers modules fonctionnels implémentés a été l’afficheur OLED, basé sur un contrôleur US2066 communiquant en I2C.
L’adresse I2C a été déterminée par la broche SA0, fixée à VDD, donnant une adresse de 0x3D.
L’afficheur a été correctement initialisé à l’aide d’une séquence adaptée extraite de la fiche technique.
Avec cela, des fonctions d'utilisation de l'écran OLED ont été créés telles que :

- `screen_init()`
- `screen_set_cursor(row, col)`
- `screen_write_string(char *)`
- `screen_clear()`

Ce module a permis d’afficher dynamiquement des messages et des mesures sur deux lignes de 16 caractères.

== Lecture du capteur de force

Le capteur de charge utilisé, délivre ses mesures via une interface I2C digitale 14 bits.
Sa lecture se fait sous forme de 2 octets contenant un comptage entre environ $1000$ (zéro charge) et $15000$ (100 % charge).
Ce module n'a pas été implémenté complétement car, le capteur de force n'était pas encore arrivé.

== Affichage du poids et gestion des GPIOs

À cause du problème cité au-dessus, l'affichage du poids et la gestion des GPIOs ont été remplacés par un simple comme démonstratifs pour mon PCB.
La boucle principale du programme a été conçue sans blocage, avec une temporisation de $10$ms, et une gestion logicielle du clignotement de la LED toutes les secondes.
Lors d’un appui sur le bouton, une valeur aléatoire est affichée sur l’écran OLED.
