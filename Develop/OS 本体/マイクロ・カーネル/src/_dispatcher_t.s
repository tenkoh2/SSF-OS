@
@	F-OS
@	(C) 2019 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sit
	.extern	__start_sbt
	.extern	__start_ctib
	.extern	__start_ctcb
	.extern	__start_mcb
	.extern	__start_rdyque_head
	.extern	__idle_task

@
@	__Scheduler
@
@	Argument
@	r1:	lr
@
	.globl	__t_Scheduler
__t_Scheduler:
	@ 最高優先度をロード、最高優先度が0でなければ
	@ スケジューラをスキップ
	ldr	r2, =__start_sbt
	ldrb	r0, [r2, #u1_sbt_highest_ctsk]
	cmp	r0, #0
	bne	.t_scheduler_2

	mov	r0, #0

	ldr	r3, [r2, #u4_sbt_cprimap]

	mov	r1, #0x0000ff00
	orr	r1, r1, #0x000000ff
	ands	r1, r3, r1
	beq	.t_scheduler_3

	add	r0, r0, #16
	lsl	r3, r3, #16

.t_scheduler_3:
	mov	r1, #0x00ff0000
	ands	r1, r3, r1
	beq	.t_scheduler_4

	add	r0, r0, #8
	lsl	r3, r3, #8

.t_scheduler_4:
	mov	r1, #0x0f000000
	ands	r1, r3, r1
	beq	.t_scheduler_5

	add	r0, r0, #4
	lsl	r3, r3, #4

.t_scheduler_5:
	mov	r1, #0x30000000
	ands	r1, r3, r1
	beq	.t_scheduler_6

	add	r0, r0, #2
	lsl	r3, r3, #2

.t_scheduler_6:
	mov	r1, #0xc0000000
	ands	r1, r3, r1
	beq	.t_scheduler_7

	add	r0, r0, #1
	lsl	r3, r3, #1

.t_scheduler_7:
	mov	r1, #0x80000000
	ands	r1, r3, r1
	beq	.t_scheduler_8

	add	r0, r0, #1

.t_scheduler_8:
	@ 最高優先度が見つからない場合、
	@ 準タスク・スケジューラを起動
	cmp	r0, #0
	bne	.t_scheduler_2

	mov	r0, #0
	strh	r0, [r2, #u2_sbt_runctsk]

	cps	#MODE_SYS

	ldr	r2, =__start_sit
	ldr	sp, [r2, #pv4_sit_iidlstk]

	b	__idle_task

.t_scheduler_2:
@	@ レディ・キュー・アドレスを生成
@	lsl	r4, r5, #1
@	ldr	r3, =__start_rdyque_head
@	add	r3, r3, r4

@	@ レディ・キューからタスクID をロード
@	ldr	r4, [r3, #0]

@	mov	r10, #0xffff
@	lsr	r9, r4, #16
@	and	r9, r9, r10
@	mov	r0, #SIZE_ctcb
@	mul	r6, r9, r0
@	ldr	r1, =__start_ctcb
@	add	r6, r6, r1

@	@ キュー・トップのprev とnext を取り出す
@	ldr	r7, [r6, #u4_ctcb_prev]
@	ldr	r8, [r6, #u4_ctcb_next]

@	str	r4, [r6, #u4_ctcb_prev]
@	str	r4, [r6, #u4_ctcb_next]

@	@ prev のnext にキュー・トップのnext を格納
@	and	r9, r7, r10
@	lsr	r9, r9, #16
@	mul	r9, r9, r0
@	add	r9, r9, r1
@	str	r8, [r9, #u4_ctcb_next]

@	@ next のprev にキュー・トップのprev を格納
@	and	r9, r8, r10
@	lsr	r9, r9, #16
@	mul	r9, r9, r0
@	add	r9, r9, r1
@	str	r7, [r9, #u4_ctcb_prev]

@	@ キュー・トップにキュー・トップのnext を格納
@	cmp	r4, r8
@	bne	.update_queue_top

@	mov	r8, #0

@.update_queue_top:
@	str	r8, [r3, #0]

@	mov	r7, #0
@	cmp	r8, r7
@	bne	.end_cprimap_clear

@	ldr	r0, [r2, #u4_sbt_cprimap]
@	mov	r7, #0x80000000
@	lsr	r7, r7, r5

@	mvn	r7, r7
@	and	r0, r0, r7

@	str	r0, [r2, #u4_sbt_cprimap]

@.end_cprimap_clear:
	strb	r0, [r2, #u1_sbt_highest_ctsk]

	ldrb	r4, [r2, #u1_sbt_sch_ena]
	orr	r4, r4, #SBT_sch_ena_ENA
	strb	r4, [r2, #u1_sbt_sch_ena]

	@ レディ・キュー・アドレスを生成
	lsl	r4, r0, #2
	ldr	r3, =__start_rdyque_head
	add	r3, r3, r4

	@ レディ・キューからタスクID をロード
	ldr	r4, [r3, #0]

	mov	r10, #0xffff
	lsr	r0, r4, #16
	and	r0, r0, r10

	strh	r0, [r2, #u2_sbt_runctsk]

	mov	r4, #SIZE_ctib
	mul	r4, r0, r4
	ldr	r3, =__start_ctib
	add	r3, r3, r4

	ldrb	r4, [r3, #u1_ctib_atr]

	ands	r4, r4, #CTIB_atr_disdsp
	beq	.load_ctask_sts

	ldrb	r1, [r2, #u1_sbt_sts]
	orr	r1, r1, r4
	strb	r1, [r2, #u1_sbt_sts]

.load_ctask_sts:

	.globl	_C_TaskEntry
_C_TaskEntry:
	mov	r4, #SIZE_ctcb
	mul	r4, r0, r4
	ldr	r6, =__start_ctcb
	add	r6, r6, r4

	ldrb	r1, [r6, #u1_ctcb_sts]
	ands	r4, r1, #CTCB_sts_ctxexist
	bne	__t_dispatcher_resume

	ands	r4, r1, #CTCB_sts_ictxexist
	bne	__t_dispatcher_int_resume

	ldrb	r4, [r3, #u1_ctib_atr]
	and	r4, r4, #CTIB_atr_disdsp
	ldrh	r0, [r2, #u2_sbt_syssts]
	orr	r0, r0, #SS_CTSKRUN
	orr	r4, r4, r0
	strh	r4, [r2, #u2_sbt_syssts]
	mov	r4, #0
	strb	r4, [r6, #u1_ctcb_slpcnt]
	strb	r4, [r6, #u1_ctcb_suscnt]
	orr	r4, r4, #CTCB_sts_ready
	ldr	r0, [r3, #s4_ctib_exinf]
	ldrb	r4, [r6, #u1_ctcb_sts]
	and	r4, #~TCB_sts_all
	orr	r4, #TCB_sts_run
	ands	r1, r4, #CTCB_sts_statsk
	beq	.end_load_stacd
	ldr	r0, [r6, #s4_ctcb_stacd]
.end_load_stacd:
	and	r4, r4, #~CTCB_sts_statsk
	strb	r4, [r6, #u1_ctcb_sts]
	ldrb	r4, [r3, #u1_ctib_ipri]
	strb	r4, [r6, #u1_ctcb_pri]
	ldr	r1, [r3, #pv4_ctib_task]
	cps	#MODE_USR
	ldr	sp, [r3, #pv4_ctib_istack]
	ldr	lr, =ext_tsk

	bx	r1

@
@	Argument
@	r0 :	Task ID
@	r1 :	lr
@
	.globl	__t_dispatcher_suspend
__t_dispatcher_suspend:
	@ CTCB アドレスを算出
	mov	r2, #SIZE_ctcb
	mul	r2, r0, r2
	ldr	r3, =__start_ctcb
	add	r3, r3, r2

	@ コンテキストありのフラグを立てる
	ldrb	r0, [r3, #u1_ctcb_sts]
	orr	r0, r0, #CTCB_sts_ctxexist
	and	r0, r0, #~CTCB_sts_run
	ands	r2, r0, #CTCB_sts_ictxexist
	bne	.from_SC
	strb	r0, [r3, #u1_ctcb_sts]

	@ タスク・スタックをロード
	ldr	r2, [r3, #pv4_ctcb_stack]

	cmp	r2, #0
	bne	.save_context_t_dispatcher_suspend

	mov	r2, sp

.save_context_t_dispatcher_suspend:
	@ コンテキストをスタックに積む
	stmfd	r2!, {r1, r4-r12, lr}

	@ TCB にスタック・ポインタを保存
	str	r2, [r3, #pv4_ctcb_stack]

.from_SC:
	bx	lr


@
@	Argument
@	r0 :	Task ID
@	r1 :	Task Status
@	r6 :	TCB addr
@
	.globl	__t_dispatcher_resume
__t_dispatcher_resume:
	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	ldr	r2, =__start_ctcb
	add	r3, r3, r2

	and	r1, r1, #~CTCB_sts_ctxexist
	and	r1, r1, #~CTCB_sts_all
	orr	r1, r1, #CTCB_sts_run
	strb	r1, [r3, #u1_ctcb_sts]

	ldrh	r4, [r2, #u2_sbt_syssts]
	orr	r4, r4, #SS_CTSKRUN
	strh	r4, [r2, #u2_sbt_syssts]

	ldr	r1, [r3, #u4_ctcb_cpsr]
	msr	spsr, r1

	cps	#MODE_SVC

	ldr	r2, [r3, #pv4_ctcb_stack]
	ldmfd	r2!, {r1, r4-r12, lr}
	str	r2, [r3, #pv4_ctcb_stack]

	mov	r2, r1

	ldr	r0, [r3, #u4_ctcb_rtnprm]

.end_loadcontext:
	mov	pc, r2


	.globl	__t_dispatcher_int_resume
__t_dispatcher_int_resume:
	and	r1, r1, #~CTCB_sts_ictxexist
	and	r1, r1, #~CTCB_sts_all
	orr	r1, r1, #CTCB_sts_run
	strb	r1, [r6, #u1_ctcb_sts]

	ldrh	r4, [r2, #u2_sbt_syssts]
	orr	r4, r4, #SS_TSKRUN
	strh	r4, [r2, #u2_sbt_syssts]

	ldr	r1, [r2, #u4_sbt_cpsr]
	msr	spsr, r1

	ldr	r0, [r6, #u4_ctcb_rtnprm]

	ldr	sp, [r6, #pv4_ctcb_stack]
	ldmfd	sp!, {r0-r12, lr}

	cps	#MODE_IRQ

	subs	pc, lr, #4


@
@	_ext_tsk
@
@	Argument
@	none
@
	.globl	ext_tsk
ext_tsk:
	svc	#SST_ext_tsk

	.globl	_ssf_ext_tsk
_ssf_ext_tsk:
	ldr	r2, =__start_sbt
	ldrh	r0, [r2, #u2_sbt_syssts]
	and	r0, r0, #~SS_CTSKRUN
	strh	r0, [r2, #u2_sbt_syssts]

	ldrb	r0, [r2, #u1_sbt_sts]
	sub	r0, r0, #SBT_sts_syslvl
	strb	r0, [r2, #u1_sbt_sts]

	ldrh	r0, [r2, #u2_sbt_runctsk]
	ldr	r3, =__start_ctcb
	mov	r1, #SIZE_ctcb
	mul	r1, r0, r1
	add	r1, r1, r3
	ldrb	r3, [r1, #u4_ctcb_mtxid]
	orrs	r3, r3, r3
	beq	.end_unl_mtx

	ldr	r4, =__start_mcb
	mov	r7, #SIZE_mcb
	mul	r0, r3, r7
	add	r0, r0, r4

	mov	r5, #0
	str	r5, [r0, #u4_mcb_tskid]

.end_unl_mtx:
	ldrb	r5, [r1, #u1_ctcb_pri]

	@ レディ・キュー・アドレスを生成
	lsl	r4, r5, #2
	ldr	r3, =__start_rdyque_head
	add	r3, r3, r4

	@ レディ・キューからタスクID をロード
	ldr	r4, [r3, #0]

	@ キュー・トップのprev とnext を取り出す
	ldr	r7, [r1, #u4_ctcb_prev]
	ldr	r8, [r1, #u4_ctcb_next]

	str	r4, [r1, #u4_ctcb_prev]
	str	r4, [r1, #u4_ctcb_next]

	mov	r0, #SIZE_ctcb
	ldr	r10, =__start_ctcb

	mov	r6, #0xffff

	@ prev のnext にキュー・トップのnext を格納
	lsr	r9, r7, #16
	and	r9, r9, r6
	mul	r9, r9, r0
	add	r9, r9, r10
	str	r8, [r9, #u4_ctcb_next]

	@ next のprev にキュー・トップのprev を格納
	lsr	r9, r8, #16
	and	r9, r9, r6
	mul	r9, r9, r0
	add	r9, r9, r10
	str	r7, [r9, #u4_ctcb_prev]

	@ キュー・トップにキュー・トップのnext を格納
	cmp	r4, r8
	bne	.update_queue_top

	mov	r8, #0

	ldr	r0, [r2, #u4_sbt_cprimap]
	sub	r5, #1
	mov	r7, #0x80000000
	lsr	r7, r7, r5

	mvn	r7, r7
	and	r0, r0, r7

	str	r0, [r2, #u4_sbt_cprimap]

.update_queue_top:
	str	r8, [r3, #0]

	ldr	r0, =__start_ctib
	mov	r3, #SIZE_ctib
	lsr	r5, r4, #16
	and	r5, r5, r6
	mul	r3, r3, r5
	add	r3, r3, r0
	ldrb	r0, [r3, #u1_ctib_ipri]
	strb	r0, [r1, #u1_ctcb_bpri]
	strb	r0, [r1, #u1_ctcb_pri]

	mov	r3, #0
	strb	r3, [r1, #u1_ctcb_slpcnt]
	strb	r3, [r1, #u1_ctcb_suscnt]

	strh	r3, [r2, #u2_sbt_runctsk]
	strb	r3, [r2, #u1_sbt_highest_ctsk]

	ldrb	r3, [r1, #u1_ctcb_actcnt]
	cmp	r3, #0
	mov	r5, #CTCB_sts_dormant
	beq	.end_react

	sub	r3, r3, #1
	strb	r3, [r1, #u1_ctcb_actcnt]
	mov	r5, #CTCB_sts_ready

	mov	r6, r4
	mov	r1, r0
	bl	__regist_readyqueue

.end_react:
	strb	r5, [r1, #u1_ctcb_sts]

	ldrb	r6, [r2, #u1_sbt_sch_ena]
	and	r6, r6, #~SBT_sch_ena_ENA
	strb	r6, [r2, #u1_sbt_sch_ena]

	bl	__Scheduler

.illegal_loop_ext_tsk:
	b	.illegal_loop_ext_tsk
