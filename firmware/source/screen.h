#ifndef SCREEN_H
#define SCREEN_H

#include <stdint.h>
#include <stdbool.h>

#include "utils.h"

#define SCREEN_I2C_ADDR 0x3D


void screen_init(void);

bool screen_write_command(uint8_t cmd);

bool screen_write_data(uint8_t data);

void screen_write_string(const char *str);

void screen_set_cursor(uint8_t row, uint8_t col);

void screen_clear(void);

#endif // SCREEN_H
