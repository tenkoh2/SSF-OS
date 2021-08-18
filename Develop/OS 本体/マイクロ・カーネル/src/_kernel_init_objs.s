@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_sit
	.extern	__start_seminf
	.extern	__start_semctrl
	.extern	__start_mcb
	.extern	__start_mbfinf
	.extern	__start_mbfctrl
	.extern	__start_mpfinf
	.extern	__start_mpfctrl
	.extern	__start_mplinf
	.extern	__start_mplctrl
	.extern	__start_cycinf
	.extern	__start_cycctrl
	.extern	__start_cycque_head

	.globl	__init_sem
__init_sem:
	ldr	r2, =__start_sit
	ldrb	r2, [r2, #u1_sit_semnum]

	mov	r3, #SIZE_seminf
	ldr	r4, =__start_seminf
	mov	r6, #SIZE_semctrl
	ldr	r7, =__start_semctrl

.loop_init_sem:
	mul	r8, r2, r3
	add	r8, r8, r4
	ldr	r9, [r8, #u4_seminf_isemcnt]

	mul	r5, r2, r6
	add	r5, r5, r7
	str	r9, [r5, #u4_semctrl_semcnt]
	mov	r9, #0
	str	r9, [r5, #u4_semctrl_wtskid]

	subs	r2, r2, #1
	bne	.loop_init_sem

	bx	lr


	.globl	__init_mtx
__init_mtx:
	ldr	r2, =__start_sit
	ldrb	r2, [r2, #u1_sit_mtxnum]

	mov	r3, #SIZE_seminf
	ldr	r4, =__start_mcb

	mov	r5, #0

.loop_init_mtx:
	mul	r6, r2, r3
	add	r6, r6, r4
	str	r5, [r6, #u4_mcb_wtskid]
	str	r5, [r6, #u4_mcb_tskid]

	subs	r2, r2, #1
	bne	.loop_init_mtx

	bx	lr


	.globl	__init_mbf
__init_mbf:
	ldr	r2, =__start_sit
	ldrb	r2, [r2, #u1_sit_mbfnum]

	mov	r3, #SIZE_mbfinf
	ldr	r4, =__start_mbfinf
	mov	r5, #SIZE_mbfctrl
	ldr	r6, =__start_mbfctrl

.loop_init_mbf:
	mul	r8, r2, r3
	add	r8, r8, r4

	mul	r9, r2, r5
	add	r9, r9, r6

	ldr	r10, [r8, #u4_mbfinf_mbfsz]
	ldr	r11, [r8, #pv4_mbfinf_mbf]
	str	r10, [r9, #u4_mbfctrl_fmbfsz]
	str	r11, [r9, #u4_mbfctrl_sndaddr]
	str	r11, [r9, #u4_mbfctrl_rcvaddr]

	subs	r2, r2, #1
	bne	.loop_init_mbf

	bx	lr


	.globl	__init_mpf
__init_mpf:
	ldr	r2, =__start_sit
	ldrb	r2, [r2, #u1_sit_mpfnum]

	mov	r3, #SIZE_mpfinf
	ldr	r4, =__start_mpfinf
	mov	r5, #SIZE_mpfctrl
	ldr	r6, =__start_mpfctrl

.loop_init_mpf:
	mul	r8, r2, r3
	add	r8, r8, r4

	mul	r9, r2, r5
	add	r9, r9, r6

	ldr	r10, [r8, #u4_mpfinf_blkcnt]
	ldr	r11, [r8, #pv4_mpfinf_mpf]
	str	r10, [r9, #u4_mpfctrl_fblkcnt]
	str	r11, [r9, #pv4_mplctrl_mpf]

	ldr	r12, [r8, #u4_mpfinf_blksz]

.loop_init_mpfblk:
	str	r12, [r11, #u4_mpf_size]
	add	r7, r11, r12
	str	r7, [r11, #u4_mpf_next]
	mov	r11, r7
	subs	r10, r10, #1
	bne	.loop_init_mpfblk

	sub	r11, r11, r12
	mov	r7, #MPF_TERMINATE
	str	r7, [r11, #u4_mpf_next]

	subs	r2, r2, #1
	bne	.loop_init_mpf

	bx	lr


	.globl	__init_mpl
__init_mpl:
	ldr	r2, =__start_sit
	ldrb	r2, [r2, #u1_sit_mplnum]

	mov	r3, #SIZE_mplinf
	ldr	r4, =__start_mplinf
	mov	r5, #SIZE_mplctrl
	ldr	r6, =__start_mplctrl

.loop_init_mpl:
	mul	r7, r2, r3
	add	r7, r7, r4

	mul	r8, r2, r5
	add	r8, r8, r6

	ldr	r9,  [r7, #pv4_mplinf_mpl]
	ldr	r10, [r7, #u4_mplinf_mplsz]
	str	r9,  [r8, #pv4_mplctrl_mpl]
	sub	r10, r10, #SIZE_mplheader
	str	r10, [r9, #u4_mpl_size]
	mov	r10, #MPL_TERMINATE
	str	r10, [r9, #u4_mpl_next]

	subs	r2, r2, #1
	bne	.loop_init_mpl

	bx	lr


	.globl	__init_cyc
__init_cyc:
	ldr	r2, =__start_sit
	ldrb	r2, [r2, #u1_sit_cycnum]

	mov	r3, #SIZE_cycinf
	ldr	r4, =__start_cycinf
	mov	r5, #SIZE_cycctrl
	ldr	r6, =__start_cycctrl

.loop_init_cyc:
	mul	r7, r2, r3
	add	r7, r7, r4

	mul	r8, r2, r5
	add	r8, r8, r6

	ldrb	r9, [r7, #u1_cycinf_cycatr]
	ands	r10, r9, #TA_STA
	beq	.next_loop_init_cyc

	ldr	r11, [r7, #u4_cycinf_cyctim]
	ands	r10, r9, #TA_PHS
	beq	.set_waitim_init_cyc

	ldr	r11, [r7, #u4_cycinf_cycphs]

.set_waitim_init_cyc:
	mov	r9, #TCYC_STA
	str	r11, [r8, #u4_cycctrl_cyctim]
	str	r9,  [r8, #u2_cycctrl_sts]

	ldr	r10, =__start_cycque_head

	ldr	r11, [r10, #0]
	cmp	r11, #0
	bne	.reg_cycque_init_cyc

	str	r2, [r10, #0]
	str	r2, [r8, #u4_cycctrl_prev]
	str	r2, [r8, #u4_cycctrl_next]

.next_loop_init_cyc:
	subs	r2, r2, #1
	bne	.loop_init_cyc

	bx	lr

.reg_cycque_init_cyc:
	mul	r9, r11, r5
	add	r9, r9, r6

	ldr	r10, [r9, #u4_cycctrl_prev]
	str	r2,  [r9, #u4_cycctrl_prev]
	str	r10, [r8, #u4_cycctrl_prev]

	mul	r9, r10, r5
	add	r9, r9, r6

	ldr	r10, [r9, #u4_cycctrl_next]
	str	r2,  [r9, #u4_cycctrl_next]
	str	r10, [r8, #u4_cycctrl_next]

	b	.next_loop_init_cyc
