= Composants Principaux <chap_composants_principaux>


== Microcontrôleur NXP - _LPC804M101JDH20J_

Le _LPC804_ fait partie de la famille _LPC80x_.
Cette famille de microcontrôleurs $32$ bits est basés sur Arm, fonctionnant à des fréquences CPU allant jusqu'à $15$ MHz, prend en charge jusqu'à $32$ KB de mémoire flash et jusqu'à $4$ KB de SRAM.
Cet appareil est entièrement pris en charge par le logiciel et les outils MCUXpresso de NXP, un ensemble complet et cohérent d'outils de développement logiciel gratuits pour les microcontrôleurs LPC.

#figure(
  image("../figure/mcu.jpg", width: 33%),

  caption: "Photo du microcontrôleur NXP",
)

=== Justification

Un microcontrôleur constitue la pièce maitresse du projet ayant comme tâche de contrôler et de synchroniser les différents périphériques.
Ce _LPC804M101JDH20J_ répond pleinement aux besoins fonctionnels du projet.
Il dispose de plusieurs broches GPIOs : une pour la gestion du bouton TARE et une autre pour l’indication de présence d’un poids via une LED.
Il intègre également deux interfaces I2C, nécessaires pour communiquer à la fois avec le capteur de force et l’écran OLED.
Ce microcontrôleur prend aussi en charge le débogage via SWD, répondant à l'exigence d’un connecteur de debug.

Ce composant appartient à la famille LPC de NXP, étudiée en cours, ce qui facilite sa prise en main et le développement logiciel.
Il est compatible avec l’outil de programmation MCUXpresso et dispose d’une documentation claire, ce qui réduit le temps de mise en œuvre.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Fréquence de fonctionnement [Max] (MHz)], [15],
    [Mémoire Flash (kB)],                      [32],
    [Mémoire RAM (kB)],                        [4],
    [Communication série],                     [1 x SPI, 2 x I2C, 2 x UART],
    [Canaux ADC],                              [12],
    [Timers],                                  [1],
    [GPIO],                                    [17],
    [Tension d'alimentation [Min à Max] (V)],  [1.71 à 3.6],
  ),

  caption: "Caractéristiques principales du microcontrôleur NXP",
)


== Régulateur de tension - _LTC3127EDD\#PBF_

Le _LTC3127EDD\#PBF_ est un régulateur de tension à découpage en topologie boost-buck.
Il permet de générer une tension de sortie stable à partir d’une tension d’entrée variable comprise entre $2.4$ V et $15$ V, avec une sortie ajustable jusqu’à $15$ V.
Il offre un rendement élevé, même à faible charge, et dispose d’un courant de sortie pouvant atteindre $1$ A.

#figure(
  image("../figure/boost-buck.jpg", width: 33%),

  caption: "Photo du régulateur de tension",
)

=== Justification

Ce régulateur assure la stabilisation de l'alimentation du système embarqué à partir d’une source batterie, qui peut varier en tension au cours du temps.
Le choix du _LTC3127EDD\#PBF_ s’explique par sa capacité à fonctionner en mode buck (abaisseur) et en mode boost (élévateur).
Cela garantit une tension stable même lorsque la tension batterie passe en dessous de la tension requise par les composants.

Le _LTC3127EDD\#PBF_ est compatible avec notre projet, acceptant une entrée entre $1.8$ V à $5.5$ V pour sortir entre $1.8$ V à $5.25$ V.
De plus, sa pin #overline[_SHDN_] permet d'activer ou de désactiver le régulateur de tension.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Tension d'entrée (V)],                   [1.8 à 5.5],
    [Tension de sortie ajustable (V)],        [1.8 à 5.25],
    [Courant de sortie max (A)],              [1.0 (VIN > 3V)],
    [Fréquence de commutation (MHz)],         [1.35],
    [Consommation en veille (µA)],            [\< 1],
    [Seuil #overline[_SHDN_] ON (V)],           [\> 1.1],
    [Seuil #overline[_SHDN_] OFF (V)],          [\< 0.4],
  ),

  caption: "Caractéristiques principales du régulateur de tension",
)


== Gestionnaire de batterie - _MCP73831T-2ACI/OT_

Le composant _MCP73831T-2ACI/OT_ est un gestionnaire de batterie dédié aux batteries lithium-ion et lithium-polymère.
Il est conçu pour charger une seule cellule et, entre autres, réguler la tension de sortie.

#figure(
  image("../figure/battery-management.png", width: 25%),

  caption: "Photo du gestionnaire de batterie",
)

=== Justification

Le gestionnaire de batterie s'inscrit dans notre projet comme étant l'élément qui supervisera le chargement de la batterie.
En effet, pour bien conserver une batterie lithium-polymère, il est nécessaire de ne pas charger la batterie au-delà de $4.2$V, en plus de ne pas la charger avec trop de charge lorsqu'elle est en dessous de $2.9$V.
Cela pourrait réduire la capacité de la batterie ainsi que sa durée de vie.

Le gestionnaire de batterie _MCP73831T-2ACI/OT_ convient à nos critères, car il fixe la tension maximale appliquée à la batterie à $4.2$V.
De plus, afin de ne pas brusquer la batterie, le _MCP73831T-2ACI/OT_ définit plusieurs modes de charge pour la batterie.
Lorsqu'elle est en dessous de $66.5$ % de la tension maximale, donc $~2.8$V, il passera en _Trickle Charge Mode_ (en préconditionnement) qui consiste à charger la batterie en utilisant uniquement $10$ % du courant maximal spécifié.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Tension de sortie (V)],                        [4.2],
    [Courant de sortie (mA)],                       [15 à 500],
    [Tension d'alimentation en fonctionnement (V)], [3.75 à 6.0],
    [Seuil de tension de préconditionnement (V)],   [66.5 %],
    [Courant de préconditionnement (A)],            [10 %],
  ),

  caption: "Caractéristiques principales du gestionnaire de batterie",
)


== Détecteur de tension - _BD5330G-2MTR_

Le composant _BD5330G-2MTR_ est un détecteur de tension.
Ce type de circuit intégré est conçu pour surveiller une tension d'entrée (par exemple, celle d'une batterie ou d'une alimentation) et générer un signal lorsqu'une certaine condition de tension est atteinte.

#figure(
  image("../figure/voltage-detector.jpg", width: 35%),

  caption: "Photo du détecteur de tension",
)

=== Justification

Dans notre cas, nous ne voulons pas que la batterie soit utilisée lorsqu'elle n'est pas chargée au-delà de $3$ V.
Pour cela, nous utilisons la condition du _BD5330G-2MTR_ définie à $3$ V pour activer et désactiver les régulateurs de tension utilisés avant les sorties.
De sorte, le circuit utilisant la batterie ne pourra pas l'utiliser lorsque celle-ci se trouve en dessous de $3$ V.
La tension d'entrée du détecteur de tension est évidemment la sortie de la batterie.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Tension de seuil (V)],                   [3],
    [Type de sortie],                         [CMOS],
    [Tension d'alimentation - Max (V)],       [7],
    [Courant de sortie (mA)],                 [70],
    [Tension de sortie "bas" - Max (V)],      [0.4],
    [Tension de sortie "haut" - Min (V)],     [2.6 (VDD - 0.4)],
  ),

  caption: "Caractéristiques principales du détecteur de tension",
)


== GPIO Bouton-poussoir - _B3SN-3012P_

Le _B3SN-3012P_ est un bouton-poussoir tactile de type SPST-NO (contact normalement ouvert), conçu pour un montage en surface (SMD).
Dans le cadre de la balance électrique, ce bouton est utilisé pour la fonction _TARE_, permettant à l'utilisateur de réinitialiser le poids mesuré.
Ce bouton est compact, avec des dimensions de $6.5$ mm x $6.0$ mm x $3.1$ mm, et est conçu pour une utilisation fiable.

#figure(
  image("../figure/btn.jpg", width: 33%),

  caption: "Photo du bouton-poussoir",
)

=== Justification

Le _B3SN-3012P_ est parfait pour ce projet grâce à sa taille, de son montage en surface (SMD) et de sa durée de vie mécanique de 100 000 cycles.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Type de contact],                        [SPST-NO (Normalement ouvert)],
    [Fonction du commutateur],                [Momentané (OFF-(ON))],
    [Montage],                                [Surface (SMD)],
    [Dimensions (L x l x h) (mm)],            [6,5 x 6,0 x 3,1],
    [Durée de vie mécanique (cycles)],        [100'000],
    [Indice de protection],                   [IP67],
  ),

  caption: "Caractéristiques principales du bouton-poussoir",
)


== GPIO LED - _HSMR-C191-S0000_

La HSMR-C191-S0000 est une LED bleue de type SMD 0603.
Cette LED est utilisée comme indicateur visuel pour signaler la présence ou l'absence de poids sur la balance.

#figure(
  image("../figure/led.jpg", width: 33%),

  caption: "Photo de la LED de présence",
)

=== Justification

Il existe énormément de LED rentrant dans les critères de notre projet.
Le choix de ce composant a été fait dû à son accessibilité sur Mouser et à son faible encombrement.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Couleur de l'émission],                  [Bleu],
    [Intensité lumineuse (mcd)],              [208 typique],
    [Courant direct (mA)],                    [20],
    [Dimensions (L × l × h) (mm)],            [1.6 × 0.8 × 0.6],
    [Type de montage],                        [Montage en surface (SMD)],
  ),

  caption: "Caractéristiques principales de la LED de présence",
)


== Connecteur SWD - _BD125-10-A-0305-0580-L-B_

Le _BD125-10-A-0305-0580-L-B_ est un connecteur mâle double rangée à 10 positions conçu pour un montage en surface (SMD).
Ce connecteur permet l'application de type SWD (Serial Wire Debug), permettant le débogage et la programmation du microcontrôleur.

#figure(
  image("../figure/swd.jpg", width: 30%),

  caption: "Photo du connecteur SWD",
)

=== Justification

L’utilisation d’un connecteur SWD (Serial Wire Debug) dans le projet répond à l’une des contraintes du cahier des charges : permettre le débogage et la programmation du microcontrôleur.

Le connecteur BD125-10-A-0305-0580-L-B a été sélectionné pour exposer cette interface de manière fiable.
Il est compatible SMD avec un pas de 1,27 mm, il est adapté à cet environnement de développement.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Type de connecteur],                     [Header mâle double rangée],
    [Nombre de positions],                    [10],
    [Pas (mm)],                               [1,27],
    [Type de montage],                        [Surface (SMD)],
    [Hauteur au-dessus du PCB (mm)],          [6,12],
  ),

  caption: "Caractéristiques principales du connecteur SWD",
)


== Connecteur USB - _USB4125-GF-A-0190_

Le USB4125-GF-A-0190 est un connecteur USB Type-C femelle conçu pour le montage en surface (SWD).

#figure(
  image("../figure/usb.jpg", width: 30%),

  caption: "Photo du connecteur USB",
)

=== Justification

Le choix du modèle USB4125-GF-A-0190 s'explique par sa simplicité (alimentation uniquement), sa compacité et sa facilité d'intégration sur un PCB grâce à son montage en surface.
De plus, c'est un composant qui a déjà été utilisé lors du projet précédent.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Type de connecteur],                     [USB Type-C femelle],
    [Nombre de contacts],                     [6 (alimentation uniquement)],
    [Montage],                                [Surface (SMD), angle droit],
    [Orientation],                            [Horizontale],
    [Tension nominale (VDC)],                 [48],
    [Courant nominal (A)],                    [3],
    [Dimensions (L × l × h) (mm)],            [6,8 × 6,5 × 3,16],
  ),

  caption: "Caractéristiques principales du connecteur USB Type-C",
)


== Écran OLED - _NHD-0216AW-IB3_

Le _NHD-0216AW-IB3_ est un écran OLED monochrome affichant $16$ caractères sur deux lignes.
Il utilise un contrôleur _US2066_ et communique via une interface I2C, facilitant son intégration avec des microcontrôleurs tels que le _LPC804_.

#figure(
  image("../figure/oled.jpg", width: 30%),

  caption: "Photo de l'écran OLED",
)

=== Justification

Dans le cadre de la balance électrique, cet écran est utilisé pour afficher le poids mesuré.
Le choix du NHD-0216AW-IB3 s'explique par sa communication en I2C, sa faible consommation et, fonctionnant avec $3.3$ V et $5$ V, sa compatibilité pour les projets embarqués.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Type d'affichage],                       [OLED monochrome],
    [Format d'affichage],                     [16 x 2 caractères],
    [Couleur du texte],                       [Bleu],
    [Contrôleur],                             [US2066],
    [Interface],                              [I2C],
    [Tension d'alimentation (V)],             [3,3 ou 5],
    [Dimensions (L × l × h) (mm)],            [41,4 × 11,4 × 1,95],
  ),

  caption: "Caractéristiques principales de l'écran OLED",
)


== Capteur de Force - _FX29K0-100A-0010-L_

Le _FX29K0-100A-0010-L_ est un capteur de force compact de type cellule de charge en compression, conçu pour mesurer des forces jusqu'à $4.5$ kilogramme-force (kgf).
Ce capteur mesure la force appliquée grâce à des jauges de contrainte internes (comme vu en deuxième année).
Il convertit cette force en un signal numérique transmis via I2C, facilitant son intégration directe avec le microcontrôleur.

#figure(
  image("../figure/load-charge.jpg", width: 30%),

  caption: "Photo du capteur de force",
)

=== Justification

le _FX29K0-100A-0010-L_ est utilisé pour mesurer le poids appliqué sur la plateforme.
Son interface I2C permet une communication directe avec le microcontrôleur, réduisant le nombre de broches nécessaires et simplifiant le câblage.
La capacité de mesure jusqu'à $4.5$ kgf est adéquate pour les charges prévues dans ce projet.
S'il a été choisi, c'est parce qu'il existe peu de capteurs de charge simples ayant une communication I2C.

=== Caractéristiques principales

#figure(
  table(
    columns: (3fr, 2fr),
    align: (left, right),
    table.header([*Paramètre*], [*Valeur*]),

    [Plage de mesure (N)],                    [50 (5kg)],
    [Sortie],                                 [I2C],
    [Tension d'alimentation (V)],             [$1$ à $6$],
    [Courant de fonctionnement (mA)],         [3],
    [Précision],                              [±1 %],
    [Cycle de vie (cycles)],                  [1'000'000],
  ),

  caption: "Caractéristiques principales du capteur de force",
)

