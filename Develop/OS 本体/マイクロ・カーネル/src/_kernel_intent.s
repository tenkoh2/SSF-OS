@
@	Stupid, Foolish and Slow OS
@	(C) 2019 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2

	.extern	__start_sbt
	.extern	__start_sit
	.extern	__start_tcb
	.extern	__start_ctcb
	.extern	__start_iib

	.extern	__kernel_TimerInterrupt

	.extern	_kernel_int_factor

	.globl	__kernel_intentry
__kernel_intentry:
	cps	#MODE_IRQ
	stmfd	sp!, {r0-r2}

	@ 多重割り込みか？
	ldr	r2, =__start_sbt
	ldrb	r0, [r2, #u1_sbt_sts]
	mov	r1, #SBT_sts_intnst_MASK
	ands	r0, r0, r1
	bne	.from_interrupt

	@ タスクが割り込まれた？
	ldrh	r0, [r2, #u2_sbt_runtsk]
	cmp	r0, #0
	bne	.from_task

	@ 準タスクが割り込まれた？
	ldrh	r0, [r2, #u2_sbt_runctsk]
	cmp	r0, #0
	bne	.from_ctask

	@ アイドルで割り込み発生
	ldmfd	sp!, {r0-r2}

	cps	#MODE_SYS
	stmfd	sp!, {r0-r12, lr}
	cps	#MODE_IRQ

.intnst_inc:
	ldrb	r0, [r2, #u1_sbt_sts]
	add	r0, r0, #1
	strb	r0, [r2, #u1_sbt_sts]

	@
	@ ユーザ・オウン・コーディング部
	@
	@ 戻り値で割り込み要因が返ってくることを期待している
	@
	@ unsigned int kernel_int_factor(void);
	@
	bl	_kernel_int_factor

	ldr	r3, =__start_sit
	ldr	r4, [r3, #u4_sit_tintfact]

	cmp	r0, r4
	bne	.start_InterruptServiceRoutine

	bl	__kernel_TimerInterrupt

	b	__kernel_intexit

.start_InterruptServiceRoutine:
	ldr	r4, =__start_iib

	mov	r5, #SIZE_iib
	mul	r5, r0, r5
	add	r5, r5, r4

	ldr	r4, [r5, #pv4_iib_isr]

	ldr	lr, =__kernel_intexit

	bx	r4

.from_interrupt:
	ldmfd	sp!, {r0-r2}
	cps	#MODE_IRQ
	stmfd	sp!, {r0-r12, lr}

	ldr	r2, =__start_sbt

	b	.intnst_inc

.from_task:
	ldmfd	sp!, {r0-r2}
	cps	#MODE_USR
	stmfd	sp!, {r0-r12, lr}

	ldr	r2, =__start_sbt
	ldrh	r0, [r2, #u2_sbt_runtsk]

	ldr	r1, =__start_tcb

	mov	r3, #SIZE_tcb
	mul	r3, r0, r3
	add	r0, r1, r3

	str	sp, [r0, #pv4_tcb_stack]

	ldrb	r1, [r0, #u1_tcb_sts]
	orr	r1, r1, #TCB_sts_ictxexist
	strb	r1, [r0, #u1_tcb_sts]

@	cps	#MODE_IRQ

	ldr	r0, [r2, #pv4_sbt_sysstk]
	cmp	r0, #0
	beq	.goto_intnst_inc_task

	mov	r1, #0
	mov	sp, r0
	str	r1, [r2, #pv4_sbt_sysstk]

.goto_intnst_inc_task:
	b	.intnst_inc

.from_ctask:
	ldmfd	sp!, {r0-r2}
	cps	#MODE_USR
	stmfd	sp!, {r0-r12, lr}

	ldr	r2, =__start_sbt
	ldrh	r0, [r2, #u2_sbt_runctsk]

	ldr	r1, =__start_ctcb

	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r0, r1, r3

	str	sp, [r0, #pv4_ctcb_stack]

	ldrb	r1, [r0, #u1_ctcb_sts]
	orr	r1, r1, #CTCB_sts_ictxexist
	strb	r1, [r0, #u1_ctcb_sts]

@	cps	#MODE_IRQ

	ldr	r0, [r2, #pv4_sbt_sysstk]
	cmp	r0, #0
	beq	.goto_intnst_inc_ctask

	mov	r1, #0
	mov	sp, r0
	str	r1, [r2, #pv4_sbt_sysstk]

.goto_intnst_inc_ctask:
	b	.intnst_inc


	.globl	__kernel_intexit
__kernel_intexit:
	ldr	r2, =__start_sbt
	ldrb	r1, [r2, #u1_sbt_sts]
	sub	r1, r1, #1
	strb	r1, [r2, #u1_sbt_sts]
	ands	r0, r1, #SBT_sts_intnst_MASK
	bne	.from_interrupt_exit

	ldrh	r0, [r2, #u2_sbt_runtsk]
	cmp	r0, #0
	bne	.from_task_exit

	ldrh	r0, [r2, #u2_sbt_runctsk]
	cmp	r0, #0
	bne	.from_ctask_exit

@	cps	#MODE_SYS

	cmp	r1, #0
	beq	__Scheduler

	ldmfd	sp!, {r0-r12, lr}

	subs	pc, lr, #4

.from_interrupt_exit:
@	cps	#MODE_IRQ
	ldmfd	sp!, {r0-r12, lr}

	subs	pc, lr, #4

.from_task_exit:
	cmp	r1, #0
	beq	__Scheduler

	ldr	r1, =__start_tcb

	mov	r3, #SIZE_tcb
	mul	r3, r0, r3
	add	r0, r1, r3

	ldrb	r1, [r0, #u1_tcb_sts]
	and	r1, r1, #~TCB_sts_ictxexist
	strb	r1, [r0, #u1_tcb_sts]

	str	sp, [r2, #pv4_sbt_sysstk]

@	cps	#MODE_USR

	ldr	sp, [r0, #pv4_tcb_stack]

	ldmfd	sp!, {r0-r12, lr}

	subs	pc, lr, #4

.from_ctask_exit:
	cmp	r1, #0
	beq	__Scheduler

	ldr	r1, =__start_ctcb

	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r0, r1, r3

	ldrb	r1, [r0, #u1_ctcb_sts]
	and	r1, r1, #~CTCB_sts_ictxexist
	strb	r1, [r0, #u1_ctcb_sts]

	str	sp, [r2, #pv4_sbt_sysstk]

@	cps	#MODE_USR

	ldr	sp, [r0, #pv4_ctcb_stack]

	ldmfd	sp!, {r0-r12, lr}

	subs	pc, lr, #4
