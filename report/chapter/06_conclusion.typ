= Conclusion


== Résumé du projet

Ce projet a abouti à la réalisation complète d’un prototype fonctionnel de balance électronique embarquée.
La conception matérielle a été rigoureuse, avec un soin particulier apporté à l’architecture d’alimentation et à l’intégration des composants via l’interface I2C.
L’interface utilisateur simple (OLED + bouton) a été mise en place avec succès, bien que le capteur de force n’ait pu être pleinement exploité faute de livraison à temps.
Côté logiciel, l’environnement MCUXpresso a facilité le développement et le débogage via l’interface SWD.

Malgré quelques erreurs corrigées tardivement dans le routage du PCB (notamment la gestion des plans de masse du régulateur), les tests ont démontré une stabilité correcte de la sortie $3.3$V lorsque le système est alimenté par batterie, ainsi qu’un bon comportement de la charge.

== Améliorations futures

Plusieurs pistes d’amélioration ont été identifiées :

- Finaliser l’intégration du capteur de force avec un code de lecture calibré et un affichage en grammes.
- Stabiliser davantage la tension d’alimentation, particulièrement en choisissant des composants passifs mieux adaptés à la régulation en mode USB.
- Optimiser la consommation en veille, en exploitant les modes basse consommation du microcontrôleur.
- Enrichir l’interface utilisateur, par exemple en ajoutant un indicateur de batterie ou un retour sonore.

Ces améliorations permettraient d’approcher un produit fini et utilisable au quotidien, tout en consolidant l’apprentissage acquis lors de ce projet.
