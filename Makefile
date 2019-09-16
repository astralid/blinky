all: main.bin

main.s: main.S
	gcc -E main.S | grep -v '^#.*' | tee main.s

main.o: main.s
	arm-none-eabi-as -mthumb -g -mcpu=cortex-m0plus -o main.o main.s

main.elf: main.o
	arm-none-eabi-ld -Ttext 0x8000000 main.o -o main.elf
   
main.bin: main.elf   
	arm-none-eabi-objcopy -S -O binary main.elf main.bin
	arm-none-eabi-size main.elf

dis:
	arm-none-eabi-objdump -D -z main.o | less
   
deb:
	arm-none-eabi-gdb main.elf -ex 'tar ext :4242' -ex load

clean:
	rm main.elf main.o main.bin main.s

