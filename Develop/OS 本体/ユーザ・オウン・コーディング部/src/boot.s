.include	"kernel.inc"

	.extern	__kernel_vector
	.extern	__vector_end
	.extern	StartOS

	.align	8
	.globl	_start
_start:
	mov	r0, #0x2020
	lsl	r0, r0, #16
	orr	r0, r0, #0x0000
	mov	r1, #0x0000
	lsl	r1, r1, #16
	orr	r1, r1, #0x2000
	str	r1, [r0, #0]
	mov	r1, #0x006d
	lsl	r1, r1, #16
	orr	r1, r1, #0xb600
	orr	r1, r1, #0x00c0
	str	r1, [r0, #8]

	cps	#MODE_SYS
	ldr	r0, =__stack_system
	mov	sp, r0

	cps	#MODE_SVC
	ldr	r0, =__stack_svc
	mov	sp, r0

	cps	#MODE_FIQ
	ldr	r0, =__stack_fiq
	mov	sp, r0

	cps	#MODE_IRQ
	ldr	r0, =__stack_irq
	mov	sp, r0

	cps	#MODE_ABT
	ldr	r0, =__stack_abort
	mov	sp, r0

	cps	#MODE_UND
	ldr	r0, =__stack_undefine
	mov	sp, r0

	cps	#MODE_USR
	ldr	r0, =__stack_user
	mov	sp, r0

@	cps	#MODE_SVC

	mov	r0, #0
	ldr	r1, =__kernel_vector
	ldr	r2, =__vector_end

.loop_copy_entry:
	ldr	r3, [r1, #0]
	str	r3, [r0, #0]

	add	r0, r0, #4
	add	r1, r1, #4

	cmp	r1, r2
	bne	.loop_copy_entry

	mov	r0, #1
	bl	StartOS

.illegal_loop:
	b	.illegal_loop
