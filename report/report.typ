#import "conf.typ": *

#show: conf.with(
  title: [Développement d'une balance électrique en système embarqué],
  authors: [Adrian Spycher],
  date: [Avril, 2025],
  illustration: image("figure/pcb_3d_front.png", width: 80%),
)

#show: introduction

#outline(title: "Table des matières")

#outline(title: "Liste des figures", target: figure.where(kind: image))

#outline(title: "Liste des tableaux", target: figure.where(kind: table))

#show: chapter

#include "chapter/01_introduction.typ"

#include "chapter/02_composants.typ"

#include "chapter/03_solution.typ"

#include "chapter/04_resultats.typ"

#include "chapter/05_programmation.typ"

#include "chapter/06_conclusion.typ"
