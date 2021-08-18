@
@	F-OS
@	(C) 2019 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_tib
	.extern	__start_tcb
	.extern	__start_rib
	.extern	__start_rcb
	.extern	__start_rdybuf
	.extern	__t_Scheduler
	.extern	__t_dispatcher_suspend
	.extern	__regist_readybuf

	.extern	PreTaskHook
	.extern	PostTaskHook

@
@	__Scheduler
@
@	Argument
@	r1:	lr
@
	.globl	__Scheduler
__Scheduler:
	@ 実行中タスクID をロード、実行中タスクがあれば
	@ 実行コンテキストをスタックに保存する
	ldr	r2, =__start_sbt
	ldrb	r0, [r2, #u1_sbt_sch_ena]
	cmp	r0, #0
	bxne	lr
	ldrh	r0, [r2, #u2_sbt_runtsk]
	cmp	r0, #0
	beq	.scheduler_1
	mov	r0, lr
	bl	__dispatcher_suspend
	mov	lr, r0

.scheduler_1:
	ldrh	r0, [r2, #u2_sbt_runctsk]
	cmp	r0, #0
	beq	.scheduler_0
	mov	r1, lr
	bl	__t_dispatcher_suspend
	mov	lr, r1

.scheduler_0:
	@ 最高優先度をロード、最高優先度が0でなければ
	@ スケジューラをスキップ
	ldr	r2, =__start_sbt
	ldrb	r0, [r2, #u1_sbt_highest_tsk]
	cmp	r0, #0
	bne	.scheduler_2

	mov	r0, #0

	ldr	r3, [r2, #u4_sbt_primap]

	mov	r1, #0xff000000
	orr	r1, r1, #0x00ff0000
	ands	r1, r3, r1
	beq	.scheduler_3

	add	r0, r0, #16
	lsr	r3, r3, #16

.scheduler_3:
	mov	r1, #0x0000ff00
	ands	r1, r3, r1
	beq	.scheduler_4

	add	r0, r0, #8
	lsr	r3, r3, #8

.scheduler_4:
	mov	r1, #0x000000f0
	ands	r1, r3, r1
	beq	.scheduler_5

	add	r0, r0, #4
	lsr	r3, r3, #4

.scheduler_5:
	mov	r1, #0x0000000c
	ands	r1, r3, r1
	beq	.scheduler_6

	add	r0, r0, #2
	lsr	r3, r3, #2

.scheduler_6:
	mov	r1, #0x00000003
	ands	r1, r3, r1
	beq	.scheduler_7

	add	r0, r0, #1
	lsr	r3, r3, #1

.scheduler_7:
	mov	r1, #0x00000001
	ands	r1, r3, r1
	beq	.scheduler_8

	add	r0, r0, #1

.scheduler_8:
	@ 最高優先度が見つからない場合、
	@ 準タスク・スケジューラを起動
	cmp	r0, #0
	bne	.scheduler_2

	mov	r0, #0
	strh	r0, [r2, #u2_sbt_runtsk]

	b	__t_Scheduler

.scheduler_2:
	ldrb	r4, [r2, #u1_sbt_sch_ena]
	orr	r4, r4, #SBT_sch_ena_ENA
	strb	r4, [r2, #u1_sbt_sch_ena]

	@ レディ・バッファ・アドレスを生成
	mov	r4, #SIZE_rdybuf
	mul	r4, r0, r4
	ldr	r3, =__start_rdybuf
	add	r3, r3, r4

	@ レディ・バッファからタスクID をロード
	mov	r5, r0
	ldrh	r4, [r3, #u2_rdybuf_ridx]
	ldr	r0, [r3, #pu4_rdybuf_rdybuf]
	lsl	r4, r4, #1
	add	r0, r0, r4
	ldrh	r0, [r0, #0]

@	lsr	r4, r4, #1
@	ldr	r1, [r3, #u4_rdybuf_bufsize]
@	add	r4, r4, #1
@	cmp	r4, r1
@	blt	.rdybuf_ridx_str

@	mov	r4, #0

@.rdybuf_ridx_str:
@	strh	r4, [r3, #u2_rdybuf_ridx]
@	ldrh	r6, [r3, #u2_rdybuf_widx]
@	cmp	r4, r6
@	bne	.end_primap_clear

@	ldr	r6, [r2, #u4_sbt_primap]
@	mov	r4, #1
@	lsl	r4, r4, r5

@	mvn	r4, r4
@	and	r6, r6, r4

@	str	r6, [r2, #u4_sbt_primap]

@.end_primap_clear:
	strb	r5, [r2, #u1_sbt_highest_tsk]
	strh	r0, [r2, #u2_sbt_runtsk]

	mov	r4, #SIZE_tib
	mul	r4, r0, r4
	ldr	r3, =__start_tib
	add	r3, r3, r4

	ldrb	r4, [r3, #u1_tib_atr]

	ands	r4, r4, #TIB_atr_disdsp
	beq	.load_task_sts

	ldrb	r1, [r2, #u1_sbt_sts]
	orr	r1, r1, r4
	strb	r1, [r2, #u1_sbt_sts]

.load_task_sts:

	.globl	_TaskEntry
_TaskEntry:
	ldr	r1, [r3, #u4_tib_ires]
	cmp 	r1, #0
	beq	.end_get_internal_res

	@ インターナル・リソースの獲得処理
	mov	r4, #SIZE_rib
	mul	r4, r1, r4
	ldr	r7, =__start_rib
	add	r7, r7, r4

	mov	r4, #SIZE_rcb
	mul	r4, r1, r4
	ldr	r5, =__start_rcb
	add	r5, r5, r4

	mov	r4, #SIZE_tcb
	mul	r4, r0, r4
	ldr	r6, =__start_tcb
	add	r6, r6, r4

	ldrb	r4, [r6, #u1_tcb_res]
	str	r0, [r5, #u4_rcb_tid]
	str	r4, [r5, #u4_rcb_rid]
	strb	r1, [r6, #u1_tcb_res]

	ldrb	r1, [r7, #u1_rib_ceilpri]
	strb	r1, [r6, #u1_tcb_pri]
	mov	r6, r0
	strb	r1, [r2, #u1_sbt_highest_tsk]
	bl	__regist_readybuf_top

.end_get_internal_res:
	mov	r4, #SIZE_tcb
	mul	r4, r0, r4
	ldr	r6, =__start_tcb
	add	r6, r6, r4

	ldrb	r4, [r3, #u1_tib_atr]
	ands	r4, r4, #CTIB_atr_disdsp
	beq	.end_syssts_tskentry

	ldr	r2, =__start_sbt
	ldrb	r0, [r2, #u1_sbt_sts]
	orr	r0, r0, r4
	strb	r0, [r2, #u1_sbt_sts]

.end_syssts_tskentry:
	ldrb	r1, [r6, #u1_tcb_sts]
	ands	r4, r1, #TCB_sts_ctxexist
	bne	__dispatcher_resume

	ands	r4, r1, #TCB_sts_ictxexist
	bne	__dispatcher_int_resume

	mov	r4, #TCB_sts_run
	strb	r4, [r6, #u1_tcb_sts]

	ldr	r4, [r3, #u4_tib_ires]
	cmp	r4, #0
	bne	.end_pri_set_tskentry
	ldrb	r4, [r3, #u1_tib_ipri]
	strb	r4, [r6, #u1_tcb_pri]

.end_pri_set_tskentry:
	mov	r4, #0
	str	r4, [r6, #u4_tcb_event]
	str	r4, [r6, #u4_tcb_waievent]

	mov	r0, r6
	mov	r1, r3
	mov	r2, r2

	ldrh	r4, [r2, #u2_sbt_syssts]
	orr	r4, r4, #SS_PREHOOK
	strh	r4, [r2, #u2_sbt_syssts]

	bl	PreTaskHook

	mov	r6, r0
	mov	r3, r1
	mov	r2, r2

	ldrh	r4, [r2, #u2_sbt_syssts]
	and	r4, r4, #~SS_PREHOOK
	orr	r4, r4, #SS_TSKRUN
	strh	r4, [r2, #u2_sbt_syssts]

	ldr	r0, [r3, #s4_tib_exinf]
	ldr	r1, [r3, #pv4_tib_task]
	cps	#MODE_USR
	ldr	sp, [r3, #pv4_tib_istack]
	ldr	lr, =TerminateTask

	bx	r1

@
@	Argument
@	r0 :	Task ID
@	r1 :	lr
@
	.globl	__dispatcher_suspend
__dispatcher_suspend:
	@ TCB アドレスを算出
	mov	r2, #SIZE_tcb
	mul	r2, r0, r2
	ldr	r3, =__start_tcb
	add	r3, r3, r2

	@ コンテキストありのフラグを立てる
	ldrb	r0, [r3, #u1_tcb_sts]
	orr	r0, r0, #TCB_sts_ctxexist
	and	r0, r0, #~TCB_sts_run
	ands	r2, r0, #TCB_sts_ictxexist
	bne	.from_SC
	strb	r0, [r3, #u1_tcb_sts]

	@ タスク・スタックをロード
	ldr	r2, [r3, #pv4_tcb_stack]

	cmp	r2, #0
	bne	.save_context_dispatcher_suspend

	mov	r2, sp

.save_context_dispatcher_suspend:
	@ コンテキストをスタックに積む
	stmfd	r2!, {r1, r4-r12, lr}

	@ TCB にスタック・ポインタを保存
	str	r2, [r3, #pv4_tcb_stack]

.from_SC:
	bx	lr


@
@	Argument
@	r0 :	Task ID
@	r1 :	Task Status
@	r6 :	TCB addr
@
	.globl	__dispatcher_resume
__dispatcher_resume:
	mov	r3, #SIZE_tcb
	mul	r3, r0, r3
	ldr	r2, =__start_tcb
	add	r3, r3, r2

	and	r1, r1, #~TCB_sts_ctxexist
	and	r1, r1, #~TCB_sts_all
	orr	r1, r1, #TCB_sts_run
	strb	r1, [r3, #u1_tcb_sts]

	ldrh	r4, [r2, #u2_sbt_syssts]
	orr	r4, r4, #SS_TSKRUN
	strh	r4, [r2, #u2_sbt_syssts]

	ldr	r1, [r3, #u4_tcb_cpsr]
	msr	spsr, r1

	cps	#MODE_SVC

	ldr	r2, [r3, #pv4_tcb_stack]
	ldmfd	sp!, {r1, r4-r12, lr}
	str	r2, [r3, #pv4_tcb_stack]

	mov	r2, r0

.end_loadcontext:
	mov	pc, r2


	.globl	__dispatcher_int_resume
__dispatcher_int_resume:
	and	r1, r1, #~TCB_sts_ictxexist
	and	r1, r1, #~TCB_sts_all
	orr	r1, r1, #TCB_sts_run
	strb	r1, [r6, #u1_tcb_sts]

	ldrh	r4, [r2, #u2_sbt_syssts]
	orr	r4, r4, #SS_TSKRUN
	strh	r4, [r2, #u2_sbt_syssts]

	ldr	r1, [r2, #u4_sbt_cpsr]
	msr	spsr, r1

	ldr	sp, [r2, #pv4_tcb_stack]

	ldmfd	sp!, {r0-r12, lr}

	cps	#MODE_IRQ

	subs	pc, lr, #4


@
@	_TerminateTask
@
@	Argument
@	none
@
	.globl	TerminateTask
TerminateTask:
	svc	#SST_TerminateTask

	.globl	_ssf_TerminateTask
_ssf_TerminateTask:
	ldr	r2, =__start_sbt
	ldrh	r0, [r2, #u2_sbt_syssts]
	and	r0, r0, #~SS_TSKRUN
	orr	r0, r0, #SS_PSTHOOK
	strh	r0, [r2, #u2_sbt_syssts]

	ldrb	r0, [r2, #u1_sbt_sts]
	sub	r0, r0, #SBT_sts_syslvl
	strb	r0, [r2, #u1_sbt_sts]

	bl	PostTaskHook

	ldr	r2, =__start_sbt
	ldrh	r0, [r2, #u2_sbt_syssts]
	and	r0, r0, #~SS_PSTHOOK
	strh	r0, [r2, #u2_sbt_syssts]

	ldrh	r0, [r2, #u2_sbt_runtsk]
	ldr	r5, =__start_tib
	mov	r6, #SIZE_tib
	mul	r6, r0, r6
	add	r5, r6, r5

	ldrb	r5, [r5, #u1_tib_atr]
	ands	r5, r5, #CTIB_atr_disdsp
	beq	.end_disdsp_TerminateTask

	ldrb	r5, [r2, #u1_sbt_sts]
	and	r5, r5, #~SBT_sts_disdsp
	strb	r5, [r2, #u1_sbt_sts]

.end_disdsp_TerminateTask:
	ldr	r3, =__start_tcb
	mov	r1, #SIZE_tcb
	mul	r1, r0, r1
	add	r1, r1, r3
	ldrb	r3, [r1, #u1_tcb_res]
	cmp	r3, #0
	beq	.end_rel_internal_res

	mov	r4, #0
	ldr	r5, =__start_rcb
	strb	r4, [r1, #u1_tcb_res]
	mov	r6, #SIZE_rcb
	mul	r3, r3, r6
	add	r3, r3, r5
	str	r4, [r3, #u4_rcb_tid]
	str	r4, [r3, #u4_rcb_rid]
	ldr	r5, =__start_tib
	mov	r6, #SIZE_tib
	mul	r6, r0, r6
	add	r5, r6, r5

	@ レディ・バッファ・アドレスを生成
	ldrb	r7, [r1, #u1_tcb_pri]
	mov	r4, #SIZE_rdybuf
	mul	r4, r7, r4
	ldr	r3, =__start_rdybuf
	add	r3, r3, r4

	@ タスク優先度を初期値に戻す
	ldrb	r6, [r5, #u1_tib_ipri]
	strb	r6, [r1, #u1_tcb_pri]

	@ レディ・バッファからタスクID をロード
	ldrh	r4, [r3, #u2_rdybuf_ridx]
	ldr	r0, [r3, #pu4_rdybuf_rdybuf]
	lsl	r4, r4, #1
	add	r0, r0, r4
	ldrh	r0, [r0, #0]

	lsr	r4, r4, #1
	ldr	r8, [r3, #u4_rdybuf_bufsize]
	add	r4, r4, #1
	cmp	r4, r8
	blt	.rdybuf_ridx_str_internal_res

	mov	r4, #0

.rdybuf_ridx_str_internal_res:
	strh	r4, [r3, #u2_rdybuf_ridx]
	ldrh	r6, [r3, #u2_rdybuf_widx]
	cmp	r4, r6
	bne	.end_rel_internal_res

	ldr	r6, [r2, #u4_sbt_primap]
	mov	r4, #1
	sub	r7, r7, #1
	lsl	r4, r4, r7

	mvn	r4, r4
	and	r6, r6, r4

	str	r6, [r2, #u4_sbt_primap]

.end_rel_internal_res:
	ldrb	r4, [r1, #u1_tcb_actcnt]
	subs	r4, r4, #1
	strb	r4, [r1, #u1_tcb_actcnt]
	bne	.end_terminate_task

	mov	r4, #TCB_sts_suspneded
	strb	r4, [r1, #u1_tcb_sts]
	mov	r4, #0
	strh	r4, [r2, #u2_sbt_runtsk]
	strb	r4, [r2, #u1_sbt_highest_tsk]

.end_terminate_task:
	@ レディ・バッファ・アドレスを生成
	ldrb	r6, [r1, #u1_tcb_pri]
	mov	r4, #SIZE_rdybuf
	mul	r4, r6, r4
	ldr	r3, =__start_rdybuf
	add	r3, r3, r4

	@ レディ・バッファからタスクID をロード
	ldrh	r4, [r3, #u2_rdybuf_ridx]
	ldr	r0, [r3, #pu4_rdybuf_rdybuf]
	lsl	r4, r4, #1
	add	r0, r0, r4
	ldrh	r0, [r0, #0]

	lsr	r4, r4, #1
	ldr	r1, [r3, #u4_rdybuf_bufsize]
	add	r4, r4, #1
	cmp	r4, r1
	blt	.rdybuf_ridx_str

	mov	r4, #0

.rdybuf_ridx_str:
	strh	r4, [r3, #u2_rdybuf_ridx]
	ldrh	r7, [r3, #u2_rdybuf_widx]
	cmp	r4, r7
	bne	.end_primap_clear

	ldr	r7, [r2, #u4_sbt_primap]
	mov	r4, #1
	sub	r6, r6, #1
	lsl	r4, r4, r6

	mvn	r4, r4
	and	r7, r7, r4

	str	r7, [r2, #u4_sbt_primap]

.end_primap_clear:
	ldrb	r6, [r2, #u1_sbt_sch_ena]
	and	r6, r6, #~SBT_sch_ena_ENA
	strb	r6, [r2, #u1_sbt_sch_ena]

	bl	__Scheduler

.illegal_loop_TerminateTask:
	b	.illegal_loop_TerminateTask
