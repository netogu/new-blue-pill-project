MODULE = bluepill
OPENCM3_DIR = external/libopencm3
PROJECT = app_$(MODULE)
BUILD_DIR = build
PROJECT_DIR = src

TARGET ?= stm32/f1
DEVICE = stm32f103c8t6

SRC = $(wildcard src/*.c)
OBJS = $(SRC:.c=.o)

CFLAGS          += -Os -ggdb3
CFLAGS          += -std=c99
CPPFLAGS        += -MD
LDFLAGS         += -static -nostartfiles
LDLIBS          += -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group

# Enable color loggink
CFLAGS          += -DLOG_ENABLE_COLORS=1



include $(OPENCM3_DIR)/mk/gcc-config.mk
# Linker File Autogeneration
include $(OPENCM3_DIR)/mk/genlink-config.mk
# LDSCRIPT = src/generated.$(DEVICE).ld
LDSCRIPT = $(PROJECT_DIR)/stm32f103c8t6.ld




# .PHONY: lib lib-clean clean firmware all
.PHONY: all bin

all: lib
	$(MAKE) bin

bin:  $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)/$(PROJECT).hex


lib: 
	$(MAKE) -C $(OPENCM3_DIR) TARGETS=$(TARGET)

lib-clean: 
	$(MAKE) -C $(OPENCM3_DIR) TARGETS=$(TARGET) clean

# firmware: $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)/$(PROJECT).bin $(BUILD_DIR)/$(PROJECT).hex

# flash: firmware
# 	@echo "\\033[1;37;42m--- Flashing $(PROJECT).bin to device ---\\033[0m"

clean: lib-clean
	$(Q)$(RM) -rf $(BUILD_DIR)/$(PROJECT).*
	$(Q)$(RM) -rf $(BUILD_DIR)/$(OBJS) $(OBJS:.o=.d)
	$(Q)$(RM) -rf $(PROJECT_DIR)/generated.*.ld


# include $(OPENCM3_DIR)/mk/genlink-rules.mk
include $(OPENCM3_DIR)/mk/gcc-rules.mk
