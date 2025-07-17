# The Common Operating System (COS)
#### Pronounced as "Cosine"

## Overview
The Common Operating System (COS) is an under-development, gold-standard 64-bit monolithic operating system for the x86_64 architecture. COS is designed to be a minimal, robust kernel built from scratch using Assembly and Rust. The current version initializes a 64-bit environment and displays a welcome message on the VGA text buffer.

## Current Features
- Two-stage bootloader:
  - boot.s: Loads the initial boot sector and reads the second stage from disk.
  - stage2.s: Transitions from 16-bit real mode to 32-bit protected mode, then to 64-bit long mode, and sets up a basic 4-level page table.
- Rust kernel (kernel.rs):
  - Clears the VGA text buffer (0xb8000).
  - Displays "Welcome to the Common Operating System!".
- Bare-metal environment with no standard library, using a custom memset implementation.
- Built and tested with QEMU for x86_64 and RISC-V.

## Prerequisites
- NASM: For assembling bootloader files.
- Rust: For compiling the kernel (requires x86_64-unknown-none or riscv-unknown-linux-gnu targets).
- GCC and LD: For linking the kernel.
- QEMU: For running the kernel (qemu-system-x86_64 or qemu-system-riscv).
- Make: For build automation.

## Building and Running
1. Navigate to the project directory:
   ```bash
   cd cos/[yourarchitecturehere]
   ```

2. Build the kernel:
   ```bash
   make clean && make
   ```
   This compiles boot_sector.s, stage2.s, and kernel.rs, links them with linker.ld, and produces build/boot_image.

3. Run in QEMU:
   ```bash
   make boot
   ```
   This displays "Welcome to the Common Operating System!" in QEMU.

## Future Plans
- VGA text driver with newline and scrolling support.
- Keyboard input via PS/2 for an interactive shell.
- Memory management with a frame allocator.
- Interrupt handling for timer and exceptions.
- Implementation of the Fish shell.
- Permissions and users via exFAT filesystem.
- Package manager and simple text-based GUI.
- Networking and server capabilities.

## Contributing
Contributions are welcome! Test changes with `make boot` and ensure no linker errors. Use a version control system like Git to manage changes.

## Contact
Open an issue on the repository or contact me at <me@spamska.com> for questions.
