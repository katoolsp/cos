#![no_std]
#![no_main]

const VGA_COLUMNS_NUM: usize = 80;
const VGA_ROWS_NUM: usize = 25;
const VGA_BUFFER: *mut u8 = 0xb8000 as *mut u8;

#[no_mangle]
pub unsafe extern "C" fn memset(dest: *mut u8, val: u8, n: usize) {
    for i in 0..n {
        *dest.add(i) = val;
    }
}

#[no_mangle]
pub extern "C" fn _start_kernel() {
    unsafe {
        memset(VGA_BUFFER, 0, VGA_COLUMNS_NUM * VGA_ROWS_NUM * 2);

        let msg = b"Welcome to the Common Operating System!";

        for (i, &byte) in msg.iter().enumerate() {
            *VGA_BUFFER.add(i * 2) = byte;
            *VGA_BUFFER.add(i * 2 + 1) = 0x9F;
        }
    }
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}
