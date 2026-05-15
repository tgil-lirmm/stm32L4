TARGET = main
DEBUG = 1
OPT = -O0

BUILD_DIR = build

C_SOURCES = Core/main.c
ASM_SOURCES = Core/startup.s

PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size

MCU = -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS = $(MCU) $(OPT) -Wall -fdata-sections -ffunction-sections -g -gdwarf-2
ASFLAGS = $(MCU) $(CFLAGS)

# Définition de la mémoire Flash/RAM (générique STM32L476)
LDFLAGS = $(MCU) -specs=nano.specs -specs=nosys.specs -Wl,--gc-sections
LDFLAGS += -Wl,--defsym=_estack=0x20018000 # Fin de la RAM pour L476
LDFLAGS += -Wl,--section-start=.isr_vector=0x08000000
LDFLAGS += -Wl,--section-start=.text=0x08000400

all: $(BUILD_DIR)/$(TARGET).elf

OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
	$(AS) -c $(ASFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR):
	mkdir $@

clean:
	rm -fR $(BUILD_DIR)
