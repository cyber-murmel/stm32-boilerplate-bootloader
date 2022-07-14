/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "gpio.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
#define MMIO32(addr) (*(volatile uint32_t*)(addr))
#define SCB_VTOR MMIO32(SCB_BASE + 0x08)

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
uint32_t app_address = APP_ADDR;

/* Private function prototypes -----------------------------------------------*/
extern void SystemClock_Config(void);

/* Private functions ---------------------------------------------------------*/

static inline void blink(int ms)
{
    HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_RESET);
    HAL_Delay(ms / 2);
    HAL_GPIO_WritePin(LED_GPIO_Port, LED_Pin, GPIO_PIN_SET);
    HAL_Delay(ms / 2);
}

static inline void jump_app_if_valid(void)
{
    /* Boot the application if it's valid */
    if ((*(volatile uint32_t*)app_address & 0x2FFE0000) == 0x20000000) {
        /* Set vector table base address */
        SCB_VTOR = app_address & 0x1FFFFF; /* Max 2 MByte Flash*/
        /* Initialise master stack pointer */
        asm volatile("msr msp, %0" ::"g"(*(volatile uint32_t*)app_address));
        /* Jump to application */
        (*(void (**)())(app_address + 4))();
    }
}

/**
 * @brief  Main program
 * @param  None
 * @retval None
 */
int main(void)
{
    /* MCU Configuration--------------------------------------------------------*/

    /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
    HAL_Init();

    /* Configure the system clock */
    SystemClock_Config();

    /* Initialize all configured peripherals */
    MX_GPIO_Init();

    for (int i = 0; i < 3; i++) {
        blink(1000);
    }

    jump_app_if_valid();

    for (int i = 0; i < 3; i++) {
        blink(100);
    }

    while (1) {
    }
}
