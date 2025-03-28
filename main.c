void main() {
    volatile char *vga = (volatile char*)0xB8000 + 4;
    *vga = 'K'; 
    *(vga + 1) = 0x0F; // 显示 'K'
    while(1);
}
