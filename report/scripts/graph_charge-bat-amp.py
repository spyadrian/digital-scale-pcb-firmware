import matplotlib.pyplot as plt

# Data
tension_batterie = [2.0, 2.2, 2.4, 2.6, 2.8,
                    3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2, 4.4]
ampere_usb = [53, 52, 52, 53, 314, 346, 383, 430, 491, 500, 502, 0, 0]
ampere_bat = [50, 49, 49, 50, 305, 323, 350, 380, 430, 490, 500, 6, 8]

# Plotting
plt.figure(figsize=(10, 6))
plt.plot(tension_batterie, ampere_usb,
         label="Courant USB", marker='o', color='b')
plt.plot(tension_batterie, ampere_bat,
         label="Courant batterie", marker='x', color='r')

# Labels and title
plt.xlabel('Tension Batterie (V)', fontsize=12)
plt.ylabel('Courant (mA)', fontsize=12)
# plt.title('Courant USB vs. Courant Batterie en fonction de la tension')

# Add grid and legend
plt.grid(True)
plt.legend()

# Show plot
plt.tight_layout()
plt.show()
