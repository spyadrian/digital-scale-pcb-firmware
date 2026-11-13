import matplotlib.pyplot as plt
import numpy as np

# Données
battery_voltages = [3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2]
currents = [100, 200, 300, 400, 500]

# Tension moyenne (V avg) mesurée aux sorties 3.3V
v_avg_33 = [
    [0, 0, 0, 0, 0],                             # 3.0V
    [3.329, 3.331, 3.330, 3.330, 3.329],         # 3.2V
    [3.331, 3.332, 3.329, 3.330, 2.901],         # 3.4V
    [3.330, 3.328, 3.332, 3.329, 3.109],         # 3.6V
    [3.331, 3.330, 3.328, 3.332, 3.331],         # 3.8V
    [3.329, 3.330, 3.331, 3.328, 3.332],         # 4.0V
    [3.330, 3.331, 3.328, 3.332, 3.329],         # 4.2V
]

# Création du graphique
fig, ax = plt.subplots(figsize=(12, 6))

# Générer des nuances de bleu
colors = plt.cm.Blues(np.linspace(0.4, 0.9, len(currents)))

# Tracer les courbes pour chaque courant (3.3V)
for i, (current, color) in enumerate(zip(currents, colors)):
    ax.plot(
        battery_voltages,
        [v[i] for v in v_avg_33],
        marker='o',
        label=f"3.3V, {current} mA",
        color=color
    )

# Configuration du graphique
ax.set_xlabel("Tension de la batterie (V)", fontsize=16)
ax.set_ylabel("Tension moyenne mesurée (V)", fontsize=16)
# ax.set_title("Tension moyenne mesurée à la sortie 3.3V")
ax.set_xticks(battery_voltages)
ax.legend(loc='lower right')  # Légende en bas à droite
ax.grid(True, linestyle="--", alpha=0.6)

# Afficher le graphique
plt.tight_layout()
plt.show()
