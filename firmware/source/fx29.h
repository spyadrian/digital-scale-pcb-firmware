#ifndef FX29_H
#define FX29_H

#include <stdint.h>
#include <stdbool.h>

#define FX29_I2C_ADDR         (0x28 << 1)  // Adresse par défaut du capteur (7 bits décalé à gauche pour I2C NXP)
#define FX29_DATA_LENGTH      2           // Lecture de 2 octets

bool fx29_init(void);                     // Initialise le capteur (si nécessaire)
bool fx29_read_raw(uint16_t *raw);       // Lit la valeur brute (0-16383)
float fx29_get_force_lbf(uint16_t raw);  // Convertit la valeur brute en force (lbf)
void fx29_set_tare(uint16_t raw);
float fx29_get_force_lbf_tared(uint16_t raw);

#endif // FX29_H
