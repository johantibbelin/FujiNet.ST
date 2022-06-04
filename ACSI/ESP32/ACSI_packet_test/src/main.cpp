#include <esp_system.h>
#include <nvs_flash.h>
#include <esp32/spiram.h>
#include <esp32/himem.h>
#include <driver/gpio.h>

//* Signal PINs
#define IRQ 35
#define CS 34
#define HDRQ 33
#define ACK 27
#define ST_RESET 22
#define RW 25
#define A1 26

//* Data PINs
#define D0 13
#define D1 14
#define D2 15
#define D3 12
#define D4 32
#define D5 18
#define D6 19
#define D7 21

//* Non ACSI PINs
#define LED 23
//* Data bus pins
static uint8_t data_bus_pins[] = {D0, D1, D2,D3, D4, D5, D6, D7};


void main_setup() {
    /**
     * Setting up GPIO pins
     * 
     */
    /* Pins always in output*/
    esp_err_t ret;
    ret = gpio_set_direction(GPIO_NUM_35, GPIO_MODE_INPUT);
}

extern "C" {

void app_main() {

    main_setup();

}
}