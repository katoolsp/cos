#![no_std]
#![no_main]

const UART_BASE: *mut u8 = 0x10000000 as *mut u8;
const QEMU_EXIT: *mut u32 = 0x100000 as *mut u32;

#[no_mangle]
pub unsafe extern "C" fn memset(dest: *mut u8, val: u8, n: usize) {
    for i in 0..n {
        *dest.add(i) = val;
    }
}

#[no_mangle]
pub extern "C" fn _start_kernel() {
    unsafe {
        for _ in 0..1000 {
            core::arch::asm!("nop");
        }
        memset(UART_BASE, 0, 1);
        let msg = b"Welcome to the Common Operating System!\n";
        for &byte in msg.iter() {
            *UART_BASE = byte;
            for _ in 0..1000 {
                core::arch::asm!("nop");
            }
        }
        *QEMU_EXIT = 0x5555;
    }
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    unsafe {
        *QEMU_EXIT = 0x5557;
    }
    loop {}
}
