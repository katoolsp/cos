.PHONY: all clean boot

AS := riscv64-unknown-elf-as
LD := riscv64-unknown-elf-ld
RUSTC := rustc
RUSTFLAGS := --edition=2021 -C opt-level=3 -C link-args=-nostartfiles -C panic=abort --target riscv64gc-unknown-none-elf

BUILD_DIR := build
SRC_DIR := src

ASM_SRC := $(filter-out $(SRC_DIR)/*.rs, $(wildcard $(SRC_DIR)/*.s))
RUST_SRC := $(SRC_DIR)/kernel.rs
OBJS := $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.s.o, $(ASM_SRC)) $(BUILD_DIR)/kernel.o
BOOT_IMAGE := $(BUILD_DIR)/boot_image

all: $(BOOT_IMAGE)

boot: $(BOOT_IMAGE)
	qemu-system-riscv64 -machine virt -bios none -kernel $< -serial mon:stdio

$(BOOT_IMAGE): $(BUILD_DIR)/linked.o
	riscv64-unknown-elf-objcopy -O binary $< $@

$(BUILD_DIR)/linked.o: $(OBJS)
	$(LD) -T linker.ld -o $@ $^

$(BUILD_DIR)/%.s.o: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	$(AS) -march=rv64gc $< -o $@

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel.rs
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) --emit obj $< -o $@

clean:
	$(RM) -r $(BUILD_DIR)
