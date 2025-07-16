.section .text
   .global _start

   _start:
       li sp, 0x80200000
       j stage2
