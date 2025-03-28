ASM = nasm
CC = gcc
LD = ld

ASMBFLAGS = -f elf32 -w-orphan-labels
CFLAGS = -c -Os -std=c99 -m32 -Wall -ffreestanding -fno-stack-protector -nostdlib -fno-pic
LDFLAGS = -m elf_i386 -nostdlib -T tiny_sys.lds -Map TinySystem.map

TINYSYSTEM_OBJS = tiny_system_entry.o main.o
TINYSYSTEM_ELF = TinySystem.elf

.PHONY: all clean

all: clean $(TINYSYSTEM_ELF)

clean:
	rm -f *.o *.elf

$(TINYSYSTEM_ELF): $(TINYSYSTEM_OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.s
	$(ASM) $(ASMBFLAGS) -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<
