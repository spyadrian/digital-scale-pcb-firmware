import matplotlib.pyplot as plt

# Données
v_battery = [2.0, 2.2, 2.4, 2.6, 2.8, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2, 4.4]
v_3_3V = [0, 0, 0, 0, 0, 0, 3.271, 3.274, 3.271, 3.272, 3.269, 3.268, 3.271]

# Création du graphique
plt.figure(figsize=(8, 5))
plt.plot(v_battery, v_3_3V, label="Sortie 3.3V", marker='o', color='b')

# Titres et labels
# plt.title("Valeurs des sorties en fonction de la tension de la batterie")
plt.xlabel("Tension de la batterie (V)", fontsize=12)
plt.ylabel("Tension de la sortie 3.3 (V)", fontsize=12)

# Affichage de la légende
plt.legend()

# Affichage du graphique
plt.grid(True)
plt.show()
