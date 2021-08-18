@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2

	.extern	__start_sit
	.extern	__start_sbt
	.extern	__start_ctcb
	.extern	__kernel_TimerInterrupt

	.globl	__kernel_TimerInterrupt
__kernel_TimerInterrupt:
	ldr	r2, =__start_sbt
	ldr	r3, [r2, #u4_sbt_ltim]
	adds	r3, r3, #1
	str	r3, [r2, #u4_sbt_ltim]
	bne	.end_systim_inc_timint

	ldrh	r3, [r2, #u2_sbt_utim]
	add	r3, r3, #1
	strh	r3, [r2, #u2_sbt_utim]

.end_systim_inc_timint:
	ldr	r0, =__start_cycque_head

	ldr	r1, [r0, #0]

	mov	r2, #SIZE_cycinf
	ldr	r3, =__start_cycinf
	mov	r4, #SIZE_cycctrl
	ldr	r5, =__start_cycctrl

	mov	r6, r1

.loop_cycque_timint:
	mul	r7, r6, r4
	add	r7, r7, r5

	ldr	r8, [r7, #u4_cycctrl_cyctim]
	subs	r8, r8, #1
	bne	.reload_cyctim_timint

	mul	r9, r6, r2
	add	r9, r9, r3

	stmfd	sp!, {r0-r9, lr}

	ldr	r0,  [r9, #u4_cycinf_exinf]
	ldr	r10, [r9, #pv4_cycinf_cychdr]

	blx	r10

	ldmfd	sp!, {r0-r9, lr}

	ldr	r8, [r9, #u4_cycinf_cyctim]

.reload_cyctim_timint:
	str	r8, [r7, #u4_cycctrl_cyctim]

	ldr	r6, [r7, #u4_cycctrl_next]

	cmp	r1, r6
	bne	.loop_cycque_timint


	ldr	r1, =__start_time_cntque

.loop_almque_timint:
	ldr	r0, [r1, #0]

	cmp	r0, #0
	beq	.end_almque_timint

	stmfd	sp!, {r1, lr}

	bl	_ssf_Body_IncrementCounter

	ldmfd	sp!, {r1, lr}

	add	r1, r1, #4
	b	.loop_almque_timint

.end_almque_timint:
	ldr	r0, =__start_timerque_head

	ldr	r1, [r0, #0]

	mov	r2, #SIZE_ctcb
	ldr	r3, =__start_ctcb

	mov	r6, r1

	ldr	r10, =__start_sbt

.loop_timque_timint:
	mul	r4, r6, r2
	add	r4, r4, r3

	ldr	r5, [r4, #u4_ctcb_waitick]
	cmp	r5, #0
	beq	.start_queope_timint

	subs	r5, r5, #1
	str	r5, [r4, #u4_ctcb_waitick]
	bne	.load_ctask_id_timint

.start_queope_timint:
	stmfd	sp!, {r1-r4, r6, r10, lr}

	bl	__del_timque

	ldmfd	sp!, {r1-r4, r6, r10, lr}

	stmfd	sp!, {r1-r4, r6, r10, lr}

	ldrb	r1, [r4, #u1_ctcb_pri]

	bl	__regist_readyqueue

	ldmfd	sp!, {r1-r4, r6, r10, lr}

	ldr	r7, [r4, #u1_ctcb_sts]

	mov	r5, #E_TMOUT
	str	r5, [r4, #u4_ctcb_rtnprm]

	mov	r5, #0
	str	r5, [r4, #u4_ctcb_taskwait]

	and	r7, r7, #~CTCB_sts_wait
	str	r7, [r4, #u1_ctcb_sts]

	ldrb	r7, [r4,  #u1_ctcb_pri]
	ldrb	r8, [r10, #u1_sbt_highest_ctsk]
	cmp	r7, r8
	bge	.load_ctask_id_timint

	ldrb	r8, [r10, #u1_sbt_sch_ena]
	strb	r7, [r10, #u1_sbt_highest_ctsk]
	and	r8, r8, #~SBT_sch_ena_ENA
	strb	r8, [r10, #u1_sbt_sch_ena]

.load_ctask_id_timint:
	ldr	r6, [r4, #u4_ctcb_tnext]

	cmp	r1, r6
	bne	.loop_timque_timint

	bx	lr
