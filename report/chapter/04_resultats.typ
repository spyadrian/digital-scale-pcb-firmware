= Résultats et Discussion


== Résultats des tests

=== Alimentation via USB

La sortie $3.3$ V est fonctionnelle, mais présente un manque de stabilité.
Une ondulation de $0.6$ V crête à crête est observée, ce qui représente environ $10 %$ de la tension de sortie, une valeur trop élevée pour garantir un fonctionnement fiable.
Cette oscillation excessive pourrait être liée à un condensateur de sortie inadapté, dont les caractéristiques ne conviennent peut -être pas aux exigences de cette application.

#figure(
  table(
    columns: (10em, 5em),
    align: (left, center),
    table.header([*Tension (V)*], [*Valeur*]),

    [Min], [3.0],
    [Moyenne], [3.3],
    [Max], [3.6],
    [Crête à crête], [0.6],
  ),

  caption: "Tensions de la sortie 3.3 V lors d'une alimentation via USB 5V",
)

=== Charge de la batterie

Le fonctionnement de la charge de la batterie a été vérifié en simulant différentes tensions de batterie.
Durant ces tests, les tensions de sortie et la consommation électrique ont été mesurées, ce qui a permis de valider plusieurs points critiques du circuit.

Premièrement, on observe que la consommation entre l’entrée USB et la batterie est très faible : en moyenne, seulement $8%$ du courant entrant est absorbé par le circuit, le reste étant effectivement utilisé pour recharger la batterie, ce qui témoigne d’un bon rendement.
Ensuite, la batterie ne commence à se charger qu’au-delà de $2.8$ V, et la charge s’interrompt une fois les $4.2$ V atteints.
Ce comportement est conforme aux spécifications des batteries Li-ion, qui ne doivent pas être chargées en dehors de cette plage pour éviter une dégradation prématurée ou des risques de dommages.

#figure(
  image("../figure/graph_charge-A.png", width: 100%),

  caption: "Courant de l'entrée USB et de la batterie en fonction de la tension de la batterie",
)

De manière surprenante, la tension de sortie reste particulièrement stable lors de la charge de la batterie, bien plus que lorsque l’alimentation est fournie uniquement via l’USB, et ce pour une raison encore inconnue.
Cette observation est illustrée dans la @fig_img_graph-charge-V, où l’on peut également noter que la sortie $3.3$ V s’active uniquement lorsque la tension de la batterie dépasse $3$ V.
Cette condition permet de protéger la batterie en empêchant son utilisation lorsqu’elle est trop déchargée.

#figure(
  image("../figure/graph_charge-V.png", width: 100%),

  caption: "Stabilité de la sortie 3.3V lors de la charge de la batterie",
) <fig_img_graph-charge-V>

=== Décharge de la batterie

Afin de tester la décharge de la batterie, un oscilloscope capable de tirer un courant spécifié a été connecté.
De l’autre côté, un autre oscilloscope à été branché afin de simuler une batterie à une tension donnée et capable de mesurer le courant tiré.
La tension de sortie ainsi que le courant utilisé par la batterie ont été les deux éléments principaux qui ont été observés lors de ce test.
Ces valeurs ont été mesurées dans $35$ différentes configurations différentes, données par la variation de la tension de la batterie entre $3.0$V et $4.2$V ainsi que le courant tiré par la sortie entre $100$mA et $500$mA.

La @fig_img_graph-decharge-V illustre l’évolution de la tension de sortie 3.3 V en fonction de la tension batterie.
On y observe que la régulation est globalement efficace, sauf sous une charge de 500 mA, où la tension chute à environ $3.0$V pour des tensions batterie de $3.4$ V et $3.6$ V.
Cette baisse pourrait être causée par une impédance interne élevée de la batterie à faible tension, ou par un manque de capacité de filtrage en sortie du régulateur.

#figure(
  image("../figure/graph_decharge-V.png", width: 100%),

  caption: "Tension moyenne mesurée à la sortie 3.3V lors de la décharge",
) <fig_img_graph-decharge-V>

La @fig_img_graph-decharge-A récapitule les valeurs du courant tiré sur la batterie en fonction de la tension de la batterie et du courant de sortie.
Ils permettent de comparer de manière visuelle la consommation du circuit entre les différents niveaux de la batterie et de courant tiré.

Le graphique concernant la sortie $3.3$V montre que la consommation augmente en fonction de la tension de la batterie : plus elle est baisse, plus on consomme.
Évidemment, uniquement quand la sortie est activée.
Cette augmentation est négligeable lorsque l’on tire $100$mA mais drastique lorsqu’il s’agit de $500$mA, avec une différence de plus de $100$mA entre une tension de $3.2$V et $4.2$V.
En effet, lorsque la tension de la batterie diminue, le régulateur doit fournir plus de courant pour maintenir une puissance de sortie constante.
Cela provoque une augmentation des pertes.
Son rendement réduit alors grandement.

#figure(
  image("../figure/graph_decharge-A.png", width: 100%),

  caption: "Variation du courant tiré sur la batterie en fonction de sa tension et du courant de la sortie 3.3V",
) <fig_img_graph-decharge-A>

