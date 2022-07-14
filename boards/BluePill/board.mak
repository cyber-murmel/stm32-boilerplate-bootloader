CPU += -mcpu=cortex-m3
FPU +=
FLOAT-ABI += -mfloat-abi=soft
MCU += $(CPU) -mthumb $(FPU) $(FLOAT-ABI)
APP_ADDR = 0x8002000

LDSCRIPT = $(BOARDPATH)/STM32F103C8Tx_FLASH.ld

INC += \
    $(sort $(addprefix -I$(BOARDPATH)/, \
		. \
		Core/Inc \
		Drivers/STM32F1xx_HAL_Driver/Inc \
		Drivers/STM32F1xx_HAL_Driver/Inc/Legacy \
		Drivers/CMSIS/Device/ST/STM32F1xx/Include \
		Drivers/CMSIS/Include \
	))

SRC_C += \
	$(sort \
		$(wildcard $(BOARDPATH)/Core/Src/*.c) \
		$(wildcard $(BOARDPATH)/Drivers/STM32F1xx_HAL_Driver/Src/*.c) \
	)

SRC_S += $(BOARDPATH)/startup_stm32f103xb.s

# macros for gcc
# AS defines
AS_DEFS +=

# C defines
C_DEFS +=  \
	-DUSE_HAL_DRIVER \
	-DSTM32F103xB \
	-DAPP_ADDR=$(APP_ADDR) \

# flashing and debug helper
DEBUG_CMD = $(GDB) \
	-ex "target extended-remote $(BMP_PORT)" \
	-ex 'monitor swdp_scan' \
	-ex 'attach 1'

FLASH_CMD = $(DEBUG_CMD) -nx --batch \
	-ex 'load' \
	-ex 'compare-sections' \
	-ex 'kill'

# #######################################
# # flashing
# #######################################
flash: $(BUILD)/$(TARGET).elf
	$(Q)$(FLASH_CMD) $<
.PHONY: flash

flash_bootloader: $(BUILD)/$(TARGET)_bootloader.elf
	$(Q)$(FLASH_CMD) $<
.PHONY: flash_bootloader

#######################################
# debug
#######################################
debug: $(BUILD)/$(TARGET).elf
	$(Q)$(DEBUG_CMD) $<
.PHONY: debug
