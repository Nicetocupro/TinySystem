ENTRY(_start)
OUTPUT_FORMAT(elf32-i386)

SECTIONS {
    /* 内核加载地址 1MiB (GRUB 标准) */
    . = 0x00100000;

    /* 强制 .multiboot_header 在最前面 */
    .multiboot_header : {
        *(.multiboot_header)
    }

    /* 启动代码段 */
    .start.text : {
        *(.start.text)
    }

    /* 主代码段 */
    .text : {
        *(.text .text.*)
    }

    /* 只读数据 */
    .rodata : {
        *(.rodata .rodata.*)
    }

    /* 数据段 */
    .data : {
        *(.data)
    }

    /* BSS 段 */
    .bss : {
        *(.bss)
    }

    /* 丢弃冗余段 */
    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
        *(.note.*)
    }
}
