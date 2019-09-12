.code 16
@.cpu cortex-m0

.set GPIOA_MODER_RESET,		0xebfffcff
.set GPIOA_MODER_PA5OUT,	0xebfff4ff
.set GPIOA_MODER_PA0IN_PA5OUT,	0xebfff4fc

.word	0x20002000
.word	_start

.thumb_func
.global _start
_start:
	mov r0, #0
	mov r1, #255

	ldr r2, =0x4002102c	@ RCC_IOPENR
	ldr r3, [r2]
	add r3, r3, #1		@ enable port A clock
	strb r3, [r2]
	ldr r7, [r2]

	ldr r2, =0x50000000	@ GPIOA_MODER
	ldr r3, =GPIOA_MODER_PA0IN_PA5OUT
	strh r3, [r2]
	ldr r6, [r2]

	add r2, r2, #0x14	@ GPIOA_ODR
	ldr r3, =0x20		@ PA5 high
	strb r3, [r2]
	ldr r5, [r2]
	
	
	
loo:
	add R0, R0, #1
	cmp r0, r1
	beq hang
b loo
nop
.hword 0x2701
hang:	b .
