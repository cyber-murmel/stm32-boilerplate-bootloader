TARGET ?= firmware
BOARD ?= BluePill
BMP_PORT ?= /dev/ttyACM0

BOARDPATH = boards/$(BOARD)

ifeq ($(wildcard $(BOARDPATH)/.),)
$(error Invalid BOARD specified: $(BOARD))
endif

include ./mkenv.mak
include $(BOARDPATH)/board.mak

CROSS_COMPILE ?= arm-none-eabi-

SCRIPT_DIR := scripts

LIBS = -lc -lm -lnosys
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBS) -Wl,-Map=$(BUILD)/$(TARGET).map,--cref -Wl,--gc-sections

include src/bootloader/src.mak
include src/application/src.mak

OPT = -Og
CFLAGS = $(MCU) $(C_DEFS) $(INC) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS += -g -gdwarf-2
# Flags for optional C++ source code
CXXFLAGS += $(filter-out -std=c99,$(CFLAGS))

all: $(BUILD)/$(TARGET).elf $(BUILD)/$(TARGET).bin $(BUILD)/$(TARGET)_bootloader.elf

$(BUILD)/%.bin: $(BUILD)/%.elf
	$(Q)$(OBJCOPY) -O binary -S $< $@

#######################################
# code formatter
#######################################
format:
	find src -type f -name '*.[ch]' -exec clang-format -i -style=WebKit {} +
.PHONY: format

include ./mkrules.mak
