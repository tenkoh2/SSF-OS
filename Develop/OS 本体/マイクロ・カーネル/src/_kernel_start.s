.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_sit
	.extern	__start_tcb
	.extern	__start_tib
	.extern	__start_rdybuf
	.extern	__start_rdybufinf
	.extern	__start_rdyque_head

	.extern	__kernel_init_obj
	.extern	__regist_readybuf
	.extern	StartupHook
	.extern	__Scheduler

	.globl	StartOS
StartOS:
	ldr	r1, =__kernel_init_obj

.init_obj_loop:
	ldr	r2, [r1, #0]
	cmp	r2, #0
	beq	.init_sbt

	blx	r2

	add	r1, r1, #4
	b	.init_obj_loop

.init_sbt:
	mov	r1, #0
	ldr	r2, =__start_sbt
	ldr	r3, =__start_sit

	@
	@ SBT èâä˙âªèàóù
	@
	strb	r1, [r2, #u1_sbt_sts]
	strb	r1, [r2, #u1_sbt_highest_tsk]
	strh	r1, [r2, #u2_sbt_syssts]
	str	r1, [r2, #u4_sbt_primap]

	ldr	sp, [r3, #pv4_sit_isysstk]
	str	r1, [r2, #pv4_sbt_sysstk]

	strh	r1, [r2, #u2_sbt_runtsk]
	strh	r1, [r2, #u2_sbt_runapp]

	strb	r1, [r2, #s1_sbt_sch_c_ena]
	strb	r1, [r2, #u1_sbt_highest_ctsk]
	strh	r1, [r2, #u2_sbt_runctsk]
	str	r1, [r2, #u4_sbt_cprimap]

	str	r0, [r2, #u4_sbt_appmode]

	@ ÉÅÉÇÉäÅEÉvÅ[Éãèâä˙âªèàóù
	ldr	r1, [r3, #u4_sit_isysmplsz]
	str	r1, [r2, #u4_sbt_sysmplsz]
	ldr	r1, [r3, #pv4_sit_isysmpl_head]
	str	r1, [r2, #pv4_sbt_sysmpl_head]
	ldr	r1, [r3, #u4_sit_implsz]
	str	r1, [r2, #u4_sbt_mplsz]
	ldr	r1, [r3, #pv4_sit_impl_head]
	str	r1, [r2, #pv4_sbt_mpl_head]
	ldr	r1, [r3, #u4_sit_impfsz]
	str	r1, [r2, #u4_sbt_mpfsz]
	ldr	r1, [r3, #pv4_sit_impf_head]
	str	r1, [r2, #pv4_sbt_mpf_head]

.init_rdybuf:
	mov	r1, #32
	ldr	r4, =__start_rdybuf
	ldr	r5, =__start_rdybufinf

.init_rdybuf_loop:
	mov	r8, #0
	mov	r6, #SIZE_rdybuf
	mov	r7, #SIZE_rdybufinf
	mul	r6, r1, r6
	mul	r7, r1, r7
	add	r6, r4, r6
	add	r7, r5, r7

	strh	r8, [r6, #u2_rdybuf_ridx]
	strh	r8, [r6, #u2_rdybuf_widx]

	ldr	r8, [r7, #u4_rdybufinf_bufsize]
	str	r8, [r6, #u4_rdybuf_bufsize]
	ldr	r8, [r7, #pu4_rdybufinf_rdybuf]
	str	r8, [r6, #pu4_rdybuf_rdybuf]

	subs	r1, r1, #1
	bne	.init_rdybuf_loop

.init_task_ready:
	ldrb	r6, [r3, #u1_sit_tsknum]
	ldr	r4, =__start_tcb
	ldr	r5, =__start_tib

.init_task_ready_loop:
	mov	r7, #SIZE_tcb
	mov	r8, #SIZE_tib
	mul	r7, r6, r7
	mul	r8, r6, r8
	add	r7, r4, r7
	add	r8, r5, r8

	mov	r11, #TCB_sts_suspneded
	ldrb	r1, [r8, #u1_tib_ipri]
	strb	r1, [r7, #u1_tcb_pri]
	ldr	r9, [r8, #pv4_tib_istack]
	str	r9, [r7, #pv4_tcb_stack]
	ldr	r9, [r8, #u4_tib_appid]
	str	r9, [r7, #u4_tcb_appid]

	ldrb	r10, [r8, #u1_tib_appmode]

	mov	r9, #0
	ands	r10, r10, r0
	beq	.end_regist_rdybuf

	bl	__regist_readybuf
		@ destroy
		@ r1, r8, r10

	mov	r9, #1
	mov	r11, #TCB_sts_ready

.end_regist_rdybuf:
	strb	r9, [r7, #u1_tcb_actcnt]
	strb	r11, [r7, #u1_tcb_sts]

	subs	r6, r6, #1
	bne	.init_task_ready_loop

.init_rdyque:
	mov	r1, #32
	ldr	r4, =__start_rdyque_head
	mov	r9, #0

.init_rdyque_loop:
	lsl	r8, r1, #2
	add	r7, r8, r4
	str	r9, [r7, #0]

	subs	r1, r1, #1
	bne	.init_rdyque_loop

.init_ctask_ready:
	ldrb	r6, [r3, #u1_sit_ctsknum]
	ldr	r4, =__start_ctcb
	ldr	r5, =__start_ctib

.init_ctask_ready_loop:
	mov	r7, #SIZE_ctcb
	mov	r8, #SIZE_ctib
	mul	r7, r6, r7
	mul	r8, r6, r8
	add	r7, r4, r7
	add	r8, r5, r8

	ldrb	r11, [r8, #u1_ctib_atr]
	ldrb	r1, [r8, #u1_ctib_ipri]
	strb	r1, [r7, #u1_ctcb_pri]
	ldr	r9, [r8, #pv4_ctib_istack]
	str	r9, [r7, #pv4_ctcb_stack]

	lsl	r6, #16
	orr	r6, r6, #ID_kind_task
	orr	r6, r6, #Core_ID
	str	r6, [r7, #u4_ctcb_prev]
	str	r6, [r7, #u4_ctcb_next]
	str	r6, [r7, #u4_ctcb_tprev]
	str	r6, [r7, #u4_ctcb_tnext]
	mov	r10, #0xffff
	lsr	r6, r6, #16
	and	r6, r6, r10

	mov	r9, #0

	and	r10, r11, #TA_ACT
	mov	r11, #CTCB_sts_dormant
	beq	.end_regist_rdyque

	mov	r11, #CTCB_sts_ready

	bl	__regist_readyqueue
		@ destroy
		@ r0, r1, r8, r10

.end_regist_rdyque:
	str	r9, [r7, #u1_ctcb_actcnt]
	strb	r11, [r7, #u1_ctcb_sts]

	subs	r6, r6, #1
	bne	.init_ctask_ready_loop

.start_scheduler:
	ldrh	r0, [r2, #u2_sbt_syssts]
	orr	r0, r0, #SS_STHOOK
	strh	r0, [r2, #u2_sbt_syssts]

	bl	StartupHook

	ldr	r2, =__start_sbt
	ldrh	r0, [r2, #u2_sbt_syssts]
	and	r0, r0, #~SS_STHOOK
	strh	r0, [r2, #u2_sbt_syssts]

	bl	__Scheduler

.illegal_loop:
	b	.illegal_loop
