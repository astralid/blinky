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

hang:	b .
