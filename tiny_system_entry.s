; 明确定义 multiboot2 头到独立段
[section .multiboot_header]
header_start:
    dd 0xE85250D6               ; Multiboot2 魔数
    dd 0                        ; 架构 (i386)
    dd header_end - header_start ; 头长度
    dd -(0xE85250D6 + 0 + (header_end - header_start)) ; 校验和

    ; 信息请求标签 (Type=1, 请求内存信息)
    align 8
    dw 1                        ; 类型: Information request
    dw 0                        ; 标志
    dd 16                       ; 大小 (8字节头 + 8字节内容)
    dd 6                        ; 请求内存信息 (Tag=6)
    dd 0                        ; 结束请求

    ; 结束标签 (Type=0)
    align 8
    dw 0                        ; 类型: 结束标签
    dw 0                        ; 标志
    dd 8                        ; 大小
header_end:

[section .start.text]
[bits 32]
global _start
extern main

_start:
    jmp _entry

_entry:
    cli                         ; 关闭中断
    ; 禁用 NMI
    in al, 0x70
    or al, 0x80
    out 0x70, al

    ; 加载 GDT
    lgdt [GDT_PTR]

    ; 长跳转到保护模式
    jmp dword 0x08:_32bits_mode  ; 代码段选择子 0x08

_32bits_mode:
    ; 初始化段寄存器
    mov ax, 0x10                ; 数据段选择子 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; 初始化栈指针
    mov esp, 0x9000

    ; 初始化调试输出 (VGA)
    mov edi, 0xB8000
    mov word [edi], 0x1F45      ; 蓝底白字 'E'

    ; 调用 C 主函数
    call main

halt_step:
    hlt
    jmp halt_step

; GDT 定义
GDT_START:
knull_dsc: dq 0                 ; 空描述符
kcode_dsc: dq 0x00CF9E000000FFFF ; 32位代码段 (DPL=0)
kdata_dsc: dq 0x00CF92000000FFFF ; 32位数据段 (DPL=0)
GDT_END:

GDT_PTR:
    dw GDT_END - GDT_START - 1  ; GDT 界限
    dd GDT_START                ; GDT 基地址
