#include "fx29.h"
#include "fsl_i2c.h"
#include "peripherals.h"   // Pour I2C0
#include <stddef.h>

extern void delay_ms(uint32_t ms);  // Définie ailleurs dans ton projet
static uint16_t fx29_tare_offset = 0;

bool fx29_init(void) {
    // Aucun besoin particulier d'initialisation I2C si l'I2C est déjà initialisé par configtools
    return true;
}

bool fx29_read_raw(uint16_t *raw) {
    uint8_t buffer[2];

    status_t status = I2C_MasterReceiveBlocking(
        I2C0,                                  // Instance
        FX29_I2C_ADDR,                         // Adresse
        buffer,                                // Buffer de réception
        FX29_DATA_LENGTH,                      // Longueur
        kI2C_TransferDefaultFlag               // Flag standard
    );

    if (status != kStatus_Success) return false;

    *raw = ((uint16_t)buffer[0] << 8) | buffer[1];
    return true;
}

float fx29_get_force_lbf(uint16_t raw) {
    // Données de la datasheet : 0% = 1000 ; 100% = 15000
    // Donc échelle = (raw - 1000) / (15000 - 1000)
    float percent = ((float)(raw - 1000)) / (15000 - 1000);
    if (percent < 0) percent = 0;
    if (percent > 1) percent = 1;
    return percent * 100.0f;  // Pour FX29K0-100A-0010-L (max 100 lbf)
}

void fx29_set_tare(uint16_t raw) {
    fx29_tare_offset = raw;
}

float fx29_get_force_lbf_tared(uint16_t raw) {
    if (raw <= fx29_tare_offset) return 0.0f;
    return fx29_get_force_lbf(raw - fx29_tare_offset);
}

