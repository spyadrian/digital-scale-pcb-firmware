= Introduction


== Énoncé du problème

Le projet consiste à concevoir un système embarqué complet, compact (≤ 3×3 cm), basé sur un microcontrôleur et alimenté par batterie.
Il doit intégrer un connecteur de débogage JTAG/SWD, un protocole de communication série (I2C, SPI ou UART), un capteur numérique, ainsi qu’un retour utilisateur visuel, sonore ou haptique.
Le respect de ces contraintes implique une sélection rigoureuse de composants, une architecture matérielle optimisée et un développement logiciel efficace pour assurer l’autonomie, la fiabilité de mesure et l’interaction utilisateur sur un espace limité.

== Objectifs et périmètre

L’objectif de ce projet est de développer une balance électronique autonome, basée sur un microcontrôleur NXP, capable d’afficher le poids sur un écran OLED, tout en étant alimentée par batterie.
Le projet couvre l’intégralité de la chaîne de développement matériel, incluant :

- la sélection et l’intégration de composants (capteur de force, écran OLED, gestionnaire de batterie, etc.),
- la conception et le routage du PCB,
- la mise en œuvre logicielle du microcontrôleur,
- et la validation fonctionnelle du système.

