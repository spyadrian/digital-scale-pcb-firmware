#include "screen.h"
#include "fsl_i2c.h"
#include "fsl_gpio.h"
#include "fsl_clock.h"

#define I2C_MASTER        I2C0
#define I2C_CLOCK_FREQ    CLOCK_GetFreq(kCLOCK_I2c0)

#define I2C_CMD_CONTROL   0x00
#define I2C_DATA_CONTROL  0x40

extern void delay_ms(uint32_t ms); // Utilise ta fonction existante

static status_t screen_write(uint8_t control, uint8_t value) {
    uint8_t buf[2] = {control, value};

    i2c_master_transfer_t xfer = {
        .slaveAddress = SCREEN_I2C_ADDR,
        .direction = kI2C_Write,
        .subaddress = 0,
        .subaddressSize = 0,
        .data = buf,
        .dataSize = sizeof(buf),
        .flags = kI2C_TransferDefaultFlag,
    };

    return I2C_MasterTransferBlocking(I2C_MASTER, &xfer);
}

bool screen_write_command(uint8_t cmd) {
    return screen_write(I2C_CMD_CONTROL, cmd) == kStatus_Success;
}

bool screen_write_data(uint8_t data) {
    return screen_write(I2C_DATA_CONTROL, data) == kStatus_Success;
}

void screen_write_string(const char *str) {
    while (*str) {
        screen_write_data((uint8_t)*str++);
    }
}

void screen_set_cursor(uint8_t row, uint8_t col) {
    uint8_t address = (row == 0) ? 0x00 : 0x40;
    address += col;
    screen_write_command(0x80 | address);
}

void screen_clear(void) {
    screen_write_command(0x01); // clear display
    delay_ms(2); // attendre la fin du clear
}

void screen_init(void) {
    // Assure que /RES est maintenu à 1 (si GPIO utilisé, init ailleurs)
    delay_ms(10);

    screen_write_command(0x2A);
    screen_write_command(0x71);
    screen_write_data(0x00);
    screen_write_command(0x28);
    screen_write_command(0x08);
    screen_write_command(0x2A);
    screen_write_command(0x79);
    screen_write_command(0xD5);
    screen_write_command(0x70);
    screen_write_command(0x78);
    screen_write_command(0x08);
    screen_write_command(0x06);
    screen_write_command(0x72);
    screen_write_data(0x00);
    screen_write_command(0x2A);
    screen_write_command(0x79);
    screen_write_command(0xDA);
    screen_write_command(0x00);
    screen_write_command(0xDC);
    screen_write_command(0x00);
    screen_write_command(0x81);
    screen_write_command(0x7F);
    screen_write_command(0xD9);
    screen_write_command(0xF1);
    screen_write_command(0xDB);
    screen_write_command(0x40);
    screen_write_command(0x78);
    screen_write_command(0x28);
    screen_clear();
    delay_ms(5);
    screen_write_command(0x80);
    screen_write_command(0x0C); // Display ON

    delay_ms(100);
}
