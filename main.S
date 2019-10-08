/*
epd spi pins:
set pins to spi mode:

*/
#define AAA 0xbabe

.code 16
.word	0x20002000
.word	_start

.section .rodata
@ Look-up table for the epaper (90 bytes)
// const unsigned char WF_LUT[]={
.byte 0x82,0x00,0x00,0x00,0xAA,0x00,0x00,0x00
.byte 0xAA,0xAA,0x00,0x00,0xAA,0xAA,0xAA,0x00
.byte 0x55,0xAA,0xAA,0x00,0x55,0x55,0x55,0x55
.byte 0xAA,0xAA,0xAA,0xAA,0x55,0x55,0x55,0x55
.byte 0xAA,0xAA,0xAA,0xAA,0x15,0x15,0x15,0x15
.byte 0x05,0x05,0x05,0x05,0x01,0x01,0x01,0x01
.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
.byte 0x41,0x45,0xF1,0xFF,0x5F,0x55,0x01,0x00
.byte 0x00,0x00
.align 2, 255

.set GPIOA_MODER_RESET,		0xebfffcff
.set GPIOA_MODER_PA5OUT,	0xebfff4ff
.set GPIOA_MODER_PA0IN_PA5OUT,	0xebfff4fc

.text
.thumb_func
.global _start
_start:
	mov r0, #0
	mov r1, #255

	ldr r2, =0x4002102c	@ RCC_IOPENR
	ldr r3, [r2]
	add r3, r3, #1		@ enable port A clock
	strb r3, [r2]

	ldr r2, =0x50000000	@ GPIOA_MODER
	ldr r3, =GPIOA_MODER_PA0IN_PA5OUT
	strh r3, [r2]

loo:
	@ if button pressed, led high
	@ else led low

	ldr r2, =0x50000010	@ GPIOA_IDR
	ldr r3, [r2]
	mov r4, #1
	ldr r2, =0x50000014	@ GPIOA_ODR
	and r4, r3		@ PA5 low (or not)
beq lo				@ branch if Z flag set
	mov r4, #0x20		@ PA5 high
lo:	strb r4, [r2]
b loo

.hword AAA

hang:	b .


/*
ldr immediate pc relative?
ldm	r8, {r0,r1,r2,r3}
ldm	r9, {r4,r5,r6,r7}

.set	GPIOA_MODER	0x50000000
.set	GPIOA_PUPDR	0x5000000c
.set	GPIOB_MODER	0x50000400
.set	GPIOB_OSPEEDR	0x50000408
.set	RCC_IOPENR	0x4002102c
.set	RCC_APB2ENR	0x40021034
.set	SPI1_CR1	0x40013000
.set	SPI1_CR2	0x40013004

@ 7.3 RCC registers p.186
.set	_RCC_IOPENR	0x3		@ A,B clock enable
.set	_RCC_APB2ENR	0x1000		@ enable SPI1 clock

@ 9.3.2 I/O pin alternate function multiplexer and mapping p.239
@ 9.4 GPIO registers p.245
@ MODER: 00in 01out 10af 11analog(def)
.set	_GPIOA_MODER	0xabfcfcfc	@ A15cs=10,bsy=00,btn=00
.set	_GPIOB_MODER	0xff5ffb9f	@ dc=01,pwr=01,mosi=10,sck=10,rst=01
.set	_GPIOA_PUPDR	0x24020000	@ bsy=10pd
.set	_GPIOB_AFRL	0x0		@ 0def; B3sck,B5mosi =AF0
.set	_GPIOB_OTYPER	0x0		@ 0def; B3sck,B5mosi =push-pull
.set	_GPIOB_OSPEEDR	0x202000	@ B5mosi,B3sck =10hs

@ 31.3.7 SPI configuration p.877
@ 31.7 SPI registers p.906
.set	_SPI_CR1	0x00001010	@ 8b, SSM=0hwNSS, LSB=0,SPE=1, BR=0,MSTR=1, CPOL=0,CPHA=0
.set	_SPI_CR2	0x00000010	@ SSOE=1hwNSS
*/
