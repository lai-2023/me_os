#!/bin/sh

echo "Compiling..."
nasm -I boot/include/ -o build/mbr.bin boot/mbr.S
nasm -I boot/include/ -o build/loader.bin boot/loader.S
gcc -m32 -I lib/kernel/ -m32 -I lib/ -m32 -I kernel/ -c -fno-builtin -o build/main.o kernel/main.c
gcc -m32 -I lib/kernel/ -m32 -I lib/ -m32 -I kernel/ -c -fno-builtin -o build/interrupt.o kernel/interrupt.c
gcc -m32 -I lib/kernel/ -m32 -I lib/ -m32 -I kernel/ -c -fno-builtin -o build/init.o kernel/init.c
nasm -f elf -o build/print.o lib/kernel/print.S
nasm -f elf -o build/kernel.o kernel/kernel.S
ld -m elf_i386 -Ttext 0xc0001500 -e main -o build/kernel.bin build/main.o build/init.o build/interrupt.o build/print.o build/kernel.o

echo "Writing mbr, loader and kernel to disk..."
dd if=/home/laihui/桌面/source/ch7_2/build/mbr.bin of=/home/laihui/桌面/bochs/hd60M.img bs=512 count=2 conv=notrunc
dd if=/home/laihui/桌面/source/ch7_2/build/loader.bin of=/home/laihui/桌面/bochs/hd60M.img bs=512 count=5 seek=2 conv=notrunc
dd if=/home/laihui/桌面/source/ch7_2/build/kernel.bin of=/home/laihui/桌面/bochs/hd60M.img bs=512 count=100 seek=9 conv=notrunc

echo "end..."
