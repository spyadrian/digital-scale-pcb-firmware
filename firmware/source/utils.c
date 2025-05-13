#include "utils.h"
#include "fsl_device_registers.h"

void delay_ms(uint32_t ms)
{
    SysTick->LOAD  = (SystemCoreClock / 1000) - 1;  // 1ms
    SysTick->VAL   = 0;
    SysTick->CTRL  = SysTick_CTRL_CLKSOURCE_Msk | SysTick_CTRL_ENABLE_Msk;

    for (uint32_t i = 0; i < ms; i++) {
        while ((SysTick->CTRL & SysTick_CTRL_COUNTFLAG_Msk) == 0);
    }

    SysTick->CTRL  = 0;
}
