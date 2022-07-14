LDFLAGS_APP += $(LDFLAGS) -Wl,--section-start=.isr_vector=$(APP_ADDR)

INC += $(addprefix -I, \
	src/application/ \
)

SRC_C_APP += \
	$(SRC_C) \
	$(sort $(wildcard ./src/application/*.c)) \

SRC_CXX_APP += \
	$(SRC_CXX) \

SRC_S_APP += \
	$(SRC_S) \

OBJ_APP += $(addprefix $(BUILD)/, $(SRC_C_APP:.c=.o))
OBJ_APP += $(addprefix $(BUILD)/, $(SRC_CXX_APP:.cpp=.o))
OBJ_APP += $(addprefix $(BUILD)/, $(SRC_S_APP:.s=.o))

OBJ += $(OBJ_APP)

$(BUILD)/$(TARGET).elf: $(OBJ_APP)
	$(ECHO) "LINK $@"
	$(Q)$(CC) $(LDFLAGS_APP) -o $@ $^ $(LIBS)
	$(Q)$(SIZE) $@
