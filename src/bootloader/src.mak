LDFLAGS_BOOT += $(LDFLAGS)

INC += $(addprefix -I, \
	src/bootloader/ \
)

SRC_C_BOOT += \
	$(SRC_C) \
	$(sort $(wildcard ./src/bootloader/*.c)) \

SRC_CXX_BOOT += \
	$(SRC_CXX) \

SRC_S_BOOT += \
	$(SRC_S) \

OBJ_BOOT += $(addprefix $(BUILD)/, $(SRC_C_BOOT:.c=.o))
OBJ_BOOT += $(addprefix $(BUILD)/, $(SRC_CXX_BOOT:.cpp=.o))
OBJ_BOOT += $(addprefix $(BUILD)/, $(SRC_S_BOOT:.s=.o))

OBJ += $(OBJ_BOOT)

$(BUILD)/$(TARGET)_bootloader.elf: $(OBJ_BOOT)
	$(ECHO) "LINK $@"
	$(Q)$(CC) $(LDFLAGS_BOOT) -o $@ $^ $(LIBS)
	$(Q)$(SIZE) $@
