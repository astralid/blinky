all: main.bin

main.o: main.S
	arm-none-eabi-as -mthumb -g -mcpu=cortex-m0plus -o main.o main.S

main.elf: main.o
	arm-none-eabi-ld -Ttext 0x8000000 main.o -o main.elf
   
main.bin: main.elf   
	arm-none-eabi-objcopy -S -O binary main.elf main.bin
	arm-none-eabi-size main.elf

dis:
	arm-none-eabi-objdump -d main.o
   
deb:
	arm-none-eabi-gdb main.elf -ex 'tar ext :4242' -ex load

clean:
	rm main.elf main.o main.bin
