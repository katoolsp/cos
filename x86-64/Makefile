.PHONY: all clean boot

NASM := nasm -f elf64
RUSTC := rustc
RUSTFLAGS := --edition=2021 -C opt-level=3 -C link-args=-nostartfiles -C panic=abort -C debug-assertions=off -C overflow-checks=off -C codegen-units=1 -C lto --target x86_64-unknown-none

BUILD_DIR := build
SRC_DIR := src

ASM_SRC := $(filter-out $(SRC_DIR)/*.rs, $(wildcard $(SRC_DIR)/*.s))
RUST_SRC := $(SRC_DIR)/*.rs
OBJS := $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.s.o, $(ASM_SRC)) $(BUILD_DIR)/kernel.o
BOOT_IMAGE := $(BUILD_DIR)/boot_image

all: $(BOOT_IMAGE)

boot: $(BOOT_IMAGE)
	qemu-system-x86_64 -no-reboot -drive file=$<,format=raw,index=0,media=disk

$(BOOT_IMAGE): $(BUILD_DIR)/linked.o
	objcopy -O binary $< $@

$(BUILD_DIR)/linked.o: $(OBJS)
	ld -T linker.ld -o $@ $^

$(BUILD_DIR)/%.s.o: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	$(NASM) $< -o $@

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel.rs
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) --emit obj $< -o $@

clean:
	$(RM) -r $(BUILD_DIR)
