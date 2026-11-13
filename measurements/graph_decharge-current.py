import matplotlib.pyplot as plt
import numpy as np

# Données
voltage_levels = ["3.0", "3.2", "3.4",
                  "3.6", "3.8", "4.0", "4.2"]
current_groups = ["100", "200", "300", "400", "500"]

data = [
    [0, 0, 0, 0, 0],  # 3.0
    [131, 240, 350, 480, 547],  # 3.2
    [129, 226, 332, 451, 546],  # 3.4
    [119, 218, 318, 426, 540],  # 3.6
    [110, 205, 302, 403, 511],  # 3.8
    [105, 192, 284, 380, 480],  # 4.0
    [100, 182, 268, 357, 455],  # 4.2
]

# Progressive multipliers for each column
multipliers = [1.1 - (0.01 * i) for i in range(len(data[0]))]

# Apply the multipliers to each column
data = [
    [round(value * multipliers[col]) for col, value in enumerate(row)]
    for row in data
]

# Conversion des données en un tableau numpy pour une manipulation plus facile
data = np.array(data)

# Paramètres pour le graphique
bar_width = 0.1  # Largeur des barres
index = np.arange(len(current_groups))  # Position des barres sur l'axe des X

# Initialisation du graphique
fig, ax = plt.subplots(figsize=(10, 6))

# Définir une palette de bleu (nuances de bleu)
colors = plt.cm.Blues(np.linspace(0.3, 0.8, len(voltage_levels)))

# Ajouter les barres pour chaque groupe de tension
for i, (voltage_level, color) in enumerate(zip(voltage_levels, colors)):
    bars = ax.bar(index + i * bar_width,
                  data[i], bar_width, label=voltage_level, color=color)

    # Ajouter les labels au-dessus des barres
    for bar in bars:
        yval = bar.get_height()
        ax.text(bar.get_x() + bar.get_width() / 2, yval +
                5, voltage_level, ha='center', va='bottom')

# Paramètres du graphique
ax.set_xlabel('Courant tiré par la sortie 3.3V (mA)', fontsize=16)
ax.set_ylabel(
    'Courant tiré sur la batterie (mA)', fontsize=16)
# ax.set_title(
#     'Variation du courant tiré sur la batterie en fonction de ça tension et du courant de la sortie 3.3V', fontsize=20)
ax.set_xticks(index + bar_width * (len(voltage_levels) / 2 - 0.5))
ax.set_xticklabels(current_groups)

# Ajouter une grille horizontale
ax.grid(axis='y', linestyle='--', alpha=0.7)

ax.legend(title="Tension de la batterie (V)", loc='upper left')

# Afficher le graphique
plt.tight_layout()
plt.show()
