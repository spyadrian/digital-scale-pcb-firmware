#include <stdio.h>
#include "board.h"
#include "peripherals.h"
#include "pin_mux.h"
#include "clock_config.h"
#include "fsl_debug_console.h"
#include "fsl_gpio.h"				// function for GPIO
#include "fsl_iocon.h"				// function for IOCON (elec)
#include "screen.h"
#include "utils.h"
#include "fx29.h"

// --- DEFINE ---

#define LED_GPIO       GPIO
#define LED_GPIO_PORT  0
#define LED_GPIO_PIN   15
#define BTN_GPIO       GPIO
#define BTN_GPIO_PORT  0
#define BTN_GPIO_PIN   1


// --- INIT ---

static bool btn_last = false;


// --- FUNCTION ---

void check_tare_button(void) {
    bool btn_state = !GPIO_PinRead(BTN_GPIO, BTN_GPIO_PORT, BTN_GPIO_PIN); // Active LOW
    if (btn_state && !btn_last) {
        // front montant = bouton pressé
        uint16_t raw;
        if (fx29_read_raw(&raw)) {
            fx29_set_tare(raw);
        }
    }
    btn_last = btn_state;
}


// --- MAIN ---

int main(void) {

    // -- Init board hardware --
    BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitBootPeripherals();
    BOARD_InitDebugConsole();

    // - GPIO init -

    // set led
    gpio_pin_config_t led_config = {kGPIO_DigitalOutput, 0};
    GPIO_PinInit(LED_GPIO, LED_GPIO_PORT, LED_GPIO_PIN, &led_config);

    // set btn
    gpio_pin_config_t btn_config = {kGPIO_DigitalInput, 0};
    GPIO_PinInit(BTN_GPIO, BTN_GPIO_PORT, BTN_GPIO_PIN, &btn_config);

    // - screen init -
    screen_init();
    screen_set_cursor(0, 0);
    screen_write_string("Hello LPC804!");
    screen_set_cursor(1, 0);
    screen_write_string("OLED Ready!");

    // -- Main Loop --

    srand(1234);
    PRINTF("Hello World\r\n");

    static bool btn_last = false;
    uint32_t led_timer = 0;

    while (1) {

        if (++led_timer >= 100) {
            GPIO_PortToggle(LED_GPIO, LED_GPIO_PORT, 1u << LED_GPIO_PIN);
            led_timer = 0;
        }

        bool btn_state = !GPIO_PinRead(BTN_GPIO, BTN_GPIO_PORT, BTN_GPIO_PIN);

        if (btn_state && !btn_last) {

            float weight = (float)(rand() % 10000) / 100.0f;
            screen_set_cursor(0, 0);
            char buf[17];
            int value = (int)(weight * 100);
            snprintf(buf, sizeof(buf), "Poids: %2d.%02d kg", value / 100, value % 100);
            screen_write_string(buf);

            screen_set_cursor(1, 0);
            screen_write_string("                ");
        }

        btn_last = btn_state;

        delay_ms(10);
    }

    return 0;
}

