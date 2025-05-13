= Détaille de la Solution


== Architecture générale

L'architecture de notre projet peut être divisée en quatre grandes sections : le microcontrôleur, l'alimentation, les GPIOs et les connecteurs.
Chaque section est elle-même constituée d'éléments spécifiques, décrits en détail dans les sous-chapitres suivants.

Le microcontrôleur occupe une position centrale sur le circuit.
Il communique avec les connecteurs via les interfaces I2C et SWD et est directement relié aux GPIOs pour assurer la logique de fonctionnement de la balance.
Son alimentation est assurée par le circuit dédié à la gestion de l'énergie, qui utilise certains connecteurs pour obtenir la tension de $3.3$ V.
Cette organisation générale est illustrée sur la @fig_img_architecture-general.

#figure(
  image("../figure/general_schematics.png", width: 100%),

  caption: "Schéma de l'architecture générale",
) <fig_img_architecture-general>


== Microcontrôleur NXP

Le microcontrôleur utilisé dans ce projet est le NXP _LPC804M101JDH20J_.
Il dispose de 20 pins multifonctions permettant d'être utilisé en entrée/sortie numérique (GPIO), en conversion analogique-numérique (ADC), en communication de débogage via SWD, ainsi qu'en gestion d'alimentation.

À l'aide de l'environnement MCUXpresso IDE fourni par NXP, il est possible de configurer des pins et de réaliser le programme embarqué.
Le développement logiciel, y compris la configuration des pins et l’écriture du programme embarqué, est réalisé à l’aide de l’environnement MCUXpresso IDE fourni par NXP, qui supporte directement le microcontrôleur LPC804.

Le tableau suivant décrit les principales fonctions associées à chaque broche du microcontrôleur :

#[
  #set par(
    leading: 0.5em,
  )

  #set align(horizon)

  #figure(
    table(
      columns: (2em, 3fr, 5fr),
      align: (center, center, left),
      table.header(
        [*\#*], [*Symbole*], [*Fonction*],
      ),

      [1],  [PIO0_16/ACMP_I4/ADC_3],          [GPIO, entrée du comparateur ACMP_I4, entrée ADC_3],
      [2],  [PIO0_17/ADC_9],                  [GPIO, entrée ADC_9],
      [3],  [PIO0_13/ADC_10],                 [GPIO, entrée ADC_10],
      [4],  [PIO0_12],                        [GPIO, entrée ISP (LOW pendant reset pour entrer en mode ISP)],
      [5],  [#overline[RESET]/PIO0_5],        [Entrée de réinitialisation externe active basse ou GPIO],
      [6],  [PIO0_4/ADC_11/#overline[TRSTN]], [GPIO, entrée ADC_11, TRSTN (reset JTAG actif bas)],
      [7],  [SWCLK/PIO0_3/TCK],               [Horloge SWD (Serial Wire Debug), GPIO, TCK (clock JTAG)],
      [8],  [SWDIO/PIO0_2/TMS],               [Données SWD, GPIO, TMS (mode select JTAG)],
      [9],  [PIO0_11/ADC_6/WKTCLKIN],         [GPIO, entrée ADC_6, entrée horloge du Wake-up Timer],
      [10], [PIO0_10/ADC_7],                  [GPIO, entrée ADC_7],
      [11], [PIO0_15/ADC_8],                  [GPIO, entrée ADC_8],
      [12], [PIO0_1/ADC_0/ACMP_I2/TDI/CLKIN], [GPIO, entrée ADC_0, entrée comparateur ACMP_I2, TDI (entrée série JTAG), horloge externe],
      [13], [PIO0_9/ADC_4],                   [GPIO, entrée ADC_4],
      [14], [PIO0_8/ADC_5],                   [GPIO, entrée ADC_5],
      [15], [VDD],                            [Alimentation principale ($1.71\,$V à $3.6\,$V)],
      [16], [VSS],                            [Masse (0\,V)],
      [17], [PIO0_7/ADC_1/ACMPVREF],          [GPIO, entrée ADC_1, entrée de référence du comparateur analogique],
      [18], [VREFP],                          [Référence de tension positive pour l'ADC (optionnelle, sinon connectée à VDD)],
      [19], [PIO0_0/ACMP_I1/TDO],             [GPIO, entrée du comparateur ACMP_I1, TDO (sortie série JTAG)],
      [20], [PIO0_14/ADC_2/ACMP_I3],          [GPIO, entrée ADC_2, entrée comparateur ACMP_I3],
    ),

    caption: "Description des pins du microcontrôleur NXP",
  )
]

La correspondance entre les pins et les composants externes connectés est illustrée dans le schéma électrique sur la @fig_img_mcu_schema.

#figure(
  image("../figure/mcu_schema.png", width: 100%),

  caption: "Schéma électronique du microcontrôleur NXP",
) <fig_img_mcu_schema>

Comme proposé par le schéma, les pins un à quatre sont configurées afin d'être utilisées en I2C pour l'écran OLED et le capteur de force.
Le pin cinq est utilisé comme #overline[RESET] et les pins sept et huit sont utilisées pour le SWD.
De l'autre côté, les pins 11 et 12 sont utilisés pour les GPIOs (LED / bouton-poussoir).

Les condensateurs présents dans le circuit servent principalement à lisser les sorties/entrées et à atténuer le bruit.
Pour leurs valeurs, nous avons décidé de garder les valeurs données dans la datasheet.

== Régulateur de tension

Le régulateur de tension permet de générer une tension de sortie stable à partir d'une tension d'entrée variable, dans notre cas $3.3$ V.
Pour fonctionner, il est nécessaire que la configuration de plusieurs pins soit bien faite.
Les principales connexions, comme l'entrée d'alimentation, la sortie régulée, le contrôle de courant ou encore la boucle de rétroaction, sont détaillées dans le tableau @fig_tab_desc-regul-tension.

#figure(
  table(
    columns: (2em, 1fr, 5fr),
    align: (center, center, left),
    table.header(
      [*\#*], [*Symbole*], [*Fonction*],
    ),

    [1],  [SW1],             [Connexion à l'inductance (côté SW1)],
    [2],  [VIN],             [Entrée d'alimentation ($1.8$ V à $5.5$ V)],
    [3],  [#overline[SHDN]], [Entrée de mise en veille (actif haut)],
    [4],  [MODE],            [Sélection du mode de fonctionnement (Burst Mode ou PWM)],
    [5],  [PROG],            [Programmation du courant d'entrée via une résistance],
    [6],  [SGND],            [Masse pour le circuit intégré],
    [7],  [FB],              [Entrée de rétroaction pour la régulation de la tension de sortie],
    [8],  [VC],              [Filtrage de la boucle de compensation],
    [9],  [VOUT],            [Sortie régulée ($1.8$ V à $5.25$ V)],
    [10], [SW2],             [Connexion à l'inductance (côté SW2)],
    [11], [PGND],            [Masse], // G UBLIÉ EL GROND
  ),

  caption: "Description des pins du régulateur de tension",
) <fig_tab_desc-regul-tension>

À partir de la description des pins, les composants externes (résistances, condensateurs, inductance) ont pu être correctement dimensionnés.
Le schéma électrique correspondant est présenté sur la @fig_img_boost-buck-schema et leurs calculs en dessous.

#figure(
  image("../figure/boost-buck_schema.png", width: 100%),

  caption: "Schéma électronique du régulateur de tension",
) <fig_img_boost-buck-schema>

Étant donné que nous souhaitons obtenir une tension de sortie de $3.3$ V, les résistances R5 et R6 doivent être dimensionnées par rapport à l'équation @eq_boost-buck-VOUT :

$ "VOUT" = 1.195 times (1 + "R5"/"R6") $ <eq_boost-buck-VOUT>

Pour atteindre la tension souhaitée, et en suivant les recommandations d'un schéma d'exemple, les valeurs de R5 et R6 ont été fixées à respectivement $320"k"Omega$ et $180"k"Omega$.

La pin MODE est connecté à la masse pour activer le Burst Mode.
Ce mode permet de minimiser la consommation d'énergie au repos, ce qui est essentiel dans une application alimentée par batterie.
La pin #overline[SHDN] est connectée directement à la sortie EN du gestionnaire de batterie pour activer ou désactiver le régulateur de tension en fonction de la batterie restante.
R7 permet de programmer le courant d'entrée, elle est régie par @eq_boost-buck-PROG.

$ "R7" = 54.92 times I_"LIMIT" + 4.94 $ <eq_boost-buck-PROG>

Cette résistance a été fixée à $33"k"Omega$ conformément à l'équation.

Comme le montre le schéma électrique de la @fig_img_boost-buck-schema.
La piste horizontale n'est pas connectée au ground, alors qu'elle le devrait.
En effet, c'est une erreur d'inattention qui s'est glissée lors de la création des schématiques du projet.
Ceci fut remarqué, avant de recevoir le PCB, lors de l'écriture du rapport.
Pour pallier cela, il fallut faire des ponts entre le plan de masse et cette piste.
Ceci est expliqué plus en détail dans le @chap_montage-pcb.


== Gestionnaire de batterie

Le gestionnaire de batterie n'est pas un composant compliqué.
Il n'est nécessaire d'ajouter qu'une résistance afin de le voir fonctionner correctement.
Celle-ci se trouve entre les pins PROG et VSS.
Le @tab_bat_desc_pins décrit l'utilité de chaque pin.

#figure(
  table(
    columns: (2em, 1fr, 5fr),
    align: (center, center, left),
    table.header(
      [*\#*], [*Symbole*], [*Fonction*],
    ),

    [1], [STAT], [Status de la charge],
    [2], [VSS],  [Référence de gestion de batterie ($0$V)],
    [3], [VBAT], [Sortie pour la charge de la batterie],
    [4], [VDD],  [Entrée de l'alimentation],
    [5], [PROG], [Le courant maximum est programmé avec une résistance de PROG à VSS],
  ),

  caption: "Description des pins du gestionnaire de batterie",
) <tab_bat_desc_pins>

Tandis que VDD et VBAT sont respectivement l'entrée et la sortie du gestionnaire de batterie, la pin PROG sert à configurer le courant maximum.
La pin STAT, elle, est utilisée afin de donner un retour utilisateur sur l'état de la batterie.

#figure(
  image("../figure/battery-management_schema.png", width: 100%),

  caption: "Schéma électronique du gestionnaire de batterie",
)

Dans le but de configurer la sortie du gestionnaire de batterie à $500$mA, nous avons placé une résistance entre la pin PROG et VSS comme indiqué dans la _datasheet_.
La valeur de cette résistance est donnée à l'aide de l'@eq_bat_res.

$
  &I_"REG" = (1000"V")/R_"PROG" \
  arrow.l.r.double &R_"PROG" = (1000"V")/I_"REG"
$ <eq_bat_res>

Étant donné les $500$mA souhaiter en sortie, la valeur de la résistance $R_"PROG"$ (R13) est de $2$k$ohm$.

La pin STAT est relié à une LED ainsi qu'à une résistance afin d'indiquer l'état de la charge.
Connaissant le courant que l'on veut faire passer dans la LED, il suffit d'utiliser la loi d'Ohm pour trouver la valeur de la résistance.

$ U = R times I arrow.l.r.double R = U / I $

Pour faire illuminer la LED à $75%$ de sa capacité, nous devons faire passer $10$mA à travers.
Cela revient à avoir une résistance de $500ohm$.
Le plus proche avec la norme _E24_ étant $470ohm$.

Les condensateurs qui restent sont principalement là pour atténuer le bruit et lisser les signaux d'entrées et de sorties.
En ce qui concerne leurs valeurs, nous avons repris celle donnée dans la _datasheet_.


== Détecteur de tension

Le schéma du détecteur de tension est très simple dans mon cas, car l'intégralité du travail, pour détecter une tension, est faite à l'intérieur du `BD53E30G-MTR`.

#figure(
  table(
    columns: (2em, 1fr, 5fr),
    align: (center, center, left),
    table.header(
      [*\#*], [*Symbole*], [*Fonction*],
    ),

    [1], [VOUT], [Signal de sortie pour le (EN)],
    [2], [VDD],  [Tension d'alimentation de référence],
    [3], [GND],  [Masse],
    [4], [N.C.], [Pin non connectée],
    [5], [CT],   [Connexion pour un condensateur ajoutant un délai à la sortie],
  ),

  caption: "Description des pins du détecteur de tension",
)

Les deux pins les plus importantes de ce composant sont les pins VDD et VOUT.
VDD est l'entrée sur laquelle va se baser la détection et VOUT sera le signal de sortie.

La tension à surveiller dans notre projet est celle située sur le segment VBAT qui est lié à la sortie de notre batterie lithium-polymère et à celle de notre gestionnaire de batterie.
Notre signal de sortie sera utilisé pour activer ou désactiver le régulateur de tension.

#figure(
  image("../figure/voltage-detector_schema.png", width: 50%),

  caption: "Schéma électronique du détecteur de tension",
)

Dans notre schéma, il aurait été possible de rajouter un condensateur connecté à la pin CT afin d'ajouter un délai à la sortie.
Dans le cadre de notre projet, il a été jugé que ce condensateur n'était pas nécessaire.
Il est bon de noter que mettre un condensateur $0$F à la sortie CT revient à la laisser flottante.


== GPIOs

Le bouton-poussoir utilisé dans ce projet est un composant simple qui détecte une action de l'utilisateur, notamment la remise à zéro (TARE) de la balance.
Il est équipé de plusieurs bornes de commutation, dont le rôle est précisé dans le tableau @fig_tab_desc-bouton.

#figure(
  table(
    columns: (2em, 2fr, 5fr),
    align: (center, center, left),
    table.header(
      [*\#*], [*Symbole*], [*Fonction*],
    ),

    [1], [COM1], [Contact A (borne de commutation) (relié à COM2)],
    [2], [COM2], [Contact B (borne de commutation)],
    [3], [NO1],  [Contact A (borne de commutation) (relié à NO2)],
    [4], [NO2],  [Contact B (borne de commutation)],
  ),

  caption: "Description des pins du bouton-poussoir",
) <fig_tab_desc-bouton>

Le circuit présent dans la @fig_img_btn-schema permet de connecter un bouton à une entrée GPIO en assurant la stabilité des appuis.
La résistance R9 ($1"k"Omega$) tire l'entrée au niveau haut lorsque aucun appui n'est détecté.
La résistance R10 ($0.1"k"Omega$) et le condensateur C9 ($0.1"µF"$) forment un filtre RC qui élimine les rebonds mécaniques du bouton lors des appuis.
Lorsque le bouton est pressé, l'entrée est reliée à la masse, passant à un niveau bas.

#figure(
  image("../figure/btn_schema.png", width: 50%),

  caption: "Schéma électronique du bouton",
) <fig_img_btn-schema>

La LED GPIO est bien plus simple, elle sert à indiquer la présence d'un objet se faisant peser.
Elle a deux pins décrits dans le @fig_tab_desc-led.

#figure(
  table(
    columns: (2em, 1fr, 5fr),
    align: (center, center, left),
    table.header(
      [*\#*], [*Symbole*], [*Fonction*],
    ),

    [1], [1], [Anode (connexion positive)],
    [2], [2], [Cathode (connexion négative)],
  ),

  caption: "Description des pins de la LED de présence",
) <fig_tab_desc-led>

Le circuit électrique de la LED est classique.
Il s'agit d'une simple résistance R12 fixée à $1"k"Omega$ afin d'avoir une bonne luminosité à $20"mA"$.
Celle-ci a été calculée grâce à la loi d'Ohm.

#figure(
  image("../figure/led_schema.png", width: 40%),

  caption: "Schéma électronique de la LED de présence",
)


== Connecteurs SWD & USB

Afin de permettre la programmation et le débogage du microcontrôleur, un connecteur SWD (Serial Wire Debug) est ajouté au circuit.
Ce connecteur permet l'accès aux fonctions de débogage SWD en limitant le nombre de pins non connectées.
La description des différentes pins du connecteur est présentée dans le @fig_tab_desc-swd.

#figure(
  table(
    columns: (2em, 1fr, 5fr),
    align: (center, center, left),
    table.header(
      [*\#*], [*Symbole*], [*Fonction*],
    ),

    [1],  [Pin 1],  [VCC (alimentation cible)],
    [2],  [Pin 2],  [Signal SWDIO (données de débogage)],
    [3],  [Pin 3],  [GND (masse)],
    [4],  [Pin 4],  [Signal SWCLK (horloge de débogage)],
    [5],  [Pin 5],  [GND (masse)],
    [6],  [Pin 6],  [NC (non connecté)],
    [7],  [Pin 7],  [NC (non connecté)],
    [8],  [Pin 8],  [NC (non connecté)],
    [9],  [Pin 9],  [GND (masse)],
    [10], [Pin 10], [Signal RESETN (réinitialisation)],
  ),

  caption: "Description des pins du connecteur SWD",
) <fig_tab_desc-swd>

Le circuit de l'interface SWD est décrit sur la @fig_img_swd-schema.
Elle montre que les pins 2 et 4 sont bien connectées au signal SWD du microcontrôleur avec une _pull-up_.
Et que le signal RESETN controllé par le microcontrôleur l'est aussi.

#figure(
  image("../figure/swd_schema.png", width: 80%),

  caption: "Schéma électronique du connecteur SWD",
) <fig_img_swd-schema>

Le connecteur USB présent sur le circuit est utilisé principalement pour l'alimentation de la carte.
Bien que le connecteur offre également des lignes de données et de configuration, seules les broches nécessaires à l'alimentation et à la gestion des niveaux logiques sont utilisées dans notre projet.
La description des différentes pins du connecteur est donnée dans le @fig_tab_desc-usb.

#figure(
  table(
    columns: (3em, 1fr, 5fr),
    align: (center, center, left),
    table.header(
      [*\#*], [*Symbole*], [*Fonction*],
    ),

    [A9],  [VBUS], [Données USB (VCC)],
    [B9],  [VBUS], [Données USB (VCC)],
    [A5],  [CC1],       [Configuration Channel 1],
    [B5],  [CC2],       [Configuration Channel 2],
    [A12], [GND],       [GND (masse)],
    [B12], [GND],       [Masse],
    [1],   [GND],       [Masse],
    [2],   [GND],       [Masse],
    [3],   [GND],       [Masse],
    [4],   [GND],       [Masse],
  ),

  caption: "Description des pins du connecteur USB",
) <fig_tab_desc-usb>

Dans la @fig_img_usb-schema on peut voir que des résistances de $5.1"k"Omega$ sont placées entre les broches CC1 et CC2 et la masse.
Ces résistances sont nécessaires pour signaler à l'alimentation USB que l'appareil est un périphérique consommateur (sink), conformément à la norme USB Type-C.
La figure suivante présente le câblage détaillé du connecteur USB.

#figure(
  image("../figure/usb_schema.png", width: 40%),

  caption: "Schéma électronique du connecteur USB",
) <fig_img_usb-schema>

== Écran OLED

L'écran OLED est piloté par un contrôleur compatible avec l'interface I2C.
Celui-ci nécessite plusieurs signaux d'alimentation, de communication et de contrôle pour fonctionner correctement.
Le tableau @fig_tab_desc-ecran-oled présente les différentes pins du connecteur et leur rôle dans le fonctionnement de l'afficheur.

#figure(
  table(
    columns: (2em, 1fr, 5fr),
    align: (center, center, left),
    table.header(
      [*\#*], [*Symbole*], [*Fonction*],
    ),

    [1], [GND],              [Masse],
    [2], [VDD_SEL],          [Tension d'alimentation pour le fonctionnement logique],
    [3], [VDDIO],            [Tension d'alimentation],
    [4], [SA0],              [Signal de sélection d'adresse esclave (LOW=3C, HIGH=3D)],
    [5], [SCL],              [Signal d'horloge I2C],
    [6], [SDA],              [Signal de données I2C],
    [7], [#overline[RESET]], [Signal de réinitialisation],
  ),

  caption: "Description des pins du controlleur de l'écran OLED",
) <fig_tab_desc-ecran-oled>

Le schéma de la @fig_img_ecran-schema présente les connexions du connecteur de l'écran OLED.
La pin 4 (SA0) est connecté au $3.3$V afin de configurer l'adresse de l'écran à 3D.
Il faut noter qu'il n'est pas nécessaire de mettre des _pull-up_ sur les signaux I2C car elles sont déjà présentes dans le contrôleur de l'écran OLED.

#figure(
  image("../figure/oled_schema.png", width: 35%),

  caption: "Schéma électronique du controlleur de l'écran OLED",
) <fig_img_ecran-schema>


== Capteur de Force

Le capteur de force utilisé communique avec le microcontrôleur via une interface I2C.
Il nécessite, alors, des lignes de communication pour transmettre les données de mesure.
Le tableau @fig_tab_desc-capteur-force décrit les différentes broches du capteur et leur fonction.

#figure(
  table(
    columns: (2em, 1fr, 5fr),
    align: (center, center, left),
    table.header(
      [*\#*], [*Symbole*], [*Fonction*],
    ),

    [1], [GND], [Masse],
    [2], [SDA], [Signal de données I2C],
    [3], [SCL], [Signal d'horloge I2C],
    [4], [VDD], [Alimentation (3.0V typique)],
  ),

  caption: "Description des pins du capteur de force",
) <fig_tab_desc-capteur-force>

Le schéma électrique du capteur de force est similaire à celui du contrôleur de l'écran OLED sauf qu'il y ajoute les résistances de _pull-up_.
De plus, il y place un condensateur C12 à $0.1"uF"$ recommandé par la _datasheet_.

#figure(
  image("../figure/load-charge_schema.png", width: 70%),

  caption: "Schéma électronique du capteur de force",
)


== Routage du PCB

Au vu du nombre de composants, le routage du PCB s’est effectué sans difficulté majeure.
Une règle de base appliquée lors du dimensionnement des pistes était d’utiliser une largeur de $1"mm"$ pour $100"mA"$ de courant, afin de garantir une bonne tenue thermique.

Le passage à un PCB double face a permis d'optimiser l’organisation des composants ainsi que des pistes.
Un plan de masse a été ajouté sur chacune des deux faces du PCB, améliorant ainsi la stabilité électrique.
La seule difficulté notable concerne le tracé de la piste RESETN, qui doit traverser plusieurs vias pour atteindre le connecteur SWD.

#figure(
  image("../figure/pcb_2d_front.png", width: 70%),

  caption: "Face des routes du PCB sur Altium",
)

#figure(
  image("../figure/pcb_2d_back.png", width: 70%),

  caption: "Dos des routes du PCB sur Altium",
)


== Montage du PCB <chap_montage-pcb>

Étant le deuxième PCB monté lors de ce cours, il n'y pas eu de difficulté majeure.
Par contre, il fallut récupérer quelques erreur venant de la schématique et du routage.
Celle-ci ne concernait pas la face avant du PCB mais plus celle arrière où se trouve toute la gestion de l'alimentation.

#figure(
  image("../figure/pcb_irl_front.png", width: 70%),

  caption: "Photo du PCB de face",
)

Lors des premiers tests, le régulateur de tension ne fonctionnait pas correctement en raison d’une piste non connectée au plan de masse.
Pour corriger cela, des ponts de soudure ont été ajoutés en plusieurs points afin d’uniformiser la liaison entre cette piste et la masse.
Les ponts $A$ et $B$ visibles sur la @fig_img_pcb-irl-back illustrent cette correction.

Malgré cette modification, le régulateur générait encore des pics de tension anormaux entre 2 V et 7 V.
Plusieurs combinaisons de bobines (L1) et de condensateurs (C8) ont été testées sans amélioration notable.
Le problème provenait finalement de l’absence de connexion entre les masses SGND (masse de signal) et PGND (masse de puissance) du régulateur.
Cette séparation involontaire empêchait le bon fonctionnement du circuit interne.
Un pont supplémentaire ($C$) a donc été réalisé pour relier SGND au plan de masse et résoudre définitivement l’instabilité de la sortie.

#figure(
  image("../figure/pcb_irl_back.png", width: 70%),

  caption: "Photo du PCB de dos",
) <fig_img_pcb-irl-back>

