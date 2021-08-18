@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_ctib
	.extern	__start_ctcb
	.extern	__start_timerque_head
	.extern	__ServiceCallExit


@
@	_slp_tsk
@
@	Argument
@
	.globl	slp_tsk
slp_tsk:
	mov	r0, #-1
	mov	r4, sp
	svc	#SST_slp_tsk
	bx	lr


@
@	_tslp_tsk
@
@	Argument
@
	.globl	tslp_tsk
tslp_tsk:
	mov	r4, sp
	svc	#SST_tslp_tsk
	bx	lr


@
@	_ssf_slp_tsk
@
@	Argument
@
	.globl	_ssf_tslp_tsk
_ssf_tslp_tsk:
	ldr	r2, =__start_sbt

	ldrh	r1, [r2, #u2_sbt_runctsk]

	ldr	r3, =__start_ctcb
	mov	r4, #SIZE_ctcb
	mul	r4, r1, r4
	add	r7, r4, r3

	ldrb	r4, [r7, #u1_ctcb_slpcnt]
	cmp	r4, #0
	bne	.end_slp_tsk

	cmp	r0, #-2
	bls	.err_e_par_slp_tsk

	cmp	r0, #0
	beq	.err_e_tmout_slp_tsk

	@ レディ・キューから削除
	mov	r6, r1
	ldrb	r1, [r7, #u1_ctcb_pri]
	bl	__delete_readyqueue

	@ タスク状態の更新
	ldrb	r3, [r7, #u1_ctcb_sts]
	ldr	r4, [r7, #u4_ctcb_taskwait]
	and	r3, r3, #~CTCB_sts_run
	orr	r3, r3, #CTCB_sts_wait
	str	r3, [r7, #u1_ctcb_sts]
	orr	r4, r4, #TTW_SLP
	str	r4, [r7, #u4_ctcb_taskwait]

	cmp	r0, #-1
	beq	.call_scheduler_slp_tsk

	ldr	r3, =__start_timerque_head
	ldr	r4, [r3, #u4_timerque_head]

	cmp	r4, #0
	bne	.end_reload_quehead_slp_tsk

	str	r6, [r3, #u4_timerque_head]
	str	r6, [r7, #u4_ctcb_tprev]
	str	r6, [r7, #u4_ctcb_tnext]

	b	.call_scheduler_slp_tsk

.end_reload_quehead_slp_tsk:
	mov	r5, #0xffff
	lsr	r8, r4, #16
	and	r8, r8, r5

	ldr	r3, =__start_ctcb
	mov	r9, #SIZE_ctcb
	mul	r1, r8, r9
	add	r1, r1, r3

	ldr	r8, [r1, #u4_ctcb_tprev]
	str	r6, [r1, #u4_ctcb_tprev]

	str	r8, [r7, #u4_ctcb_tprev]
	str	r4, [r7, #u4_ctcb_tnext]

	lsr	r8, r8, #16
	and	r8, r8, r5
	mul	r1, r8, r9
	add	r1, r1, r3

	str	r6, [r1, #u4_ctcb_tnext]
	str	r0, [r7, #u4_ctcb_waitick]

.call_scheduler_slp_tsk:
	ldrb	r5, [r2, #u1_sbt_sch_ena]
	and	r5, r5, #~SBT_sch_ena_ENA
	strb	r5, [r2, #u1_sbt_sch_ena]

	mov	r1, #0
	str	r1, [r7, #u4_ctcb_rtnprm]

	b	__ServiceCallExit

.err_e_par_slp_tsk:
	mov	r0, #E_PAR
	b	__ServiceCallExit

.err_e_tmout_slp_tsk:
	mov	r0, #E_TMOUT
	b	__ServiceCallExit

.end_slp_tsk:
	sub	r4, #1
	strb	r4, [r3, #u1_ctcb_slpcnt]

	mov	r0, #E_OK
	b	__ServiceCallExit


@
@	_wup_tsk
@
@	Argument
@
	.globl	wup_tsk
wup_tsk:
	mov	r4, sp
	svc	#SST_wup_tsk
	bx	lr


@
@	_ssf_wup_tsk
@
@	Argument
@
	.globl	_ssf_wup_tsk
_ssf_wup_tsk:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_ctsknum]

	cmp	r0, r1
	bgt	.err_e_id_wup_tsk

	cmp	r0, #0
	blt	.err_e_id_wup_tsk
	bne	.end_load_tskid_wup_tsk

	ldrh	r0, [r2, #u2_sbt_runctsk]

.end_load_tskid_wup_tsk:
	ldr	r1, =__start_ctcb
	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r3, r3, r1

	ldrb	r1, [r3, #u1_ctcb_sts]
	ands	r4, r1, #CTCB_sts_dormant
	bne	.err_e_obj_wup_tsk

	ldrh	r5, [r3, #u4_ctcb_taskwait]
	ands	r4, r5, #TTW_SLP
	beq	.inc_wup_cnt_wup_tsk

	and	r5, r5, #~TTW_SLP
	strh	r5, [r3, #u4_ctcb_taskwait]

	and	r1, r1, #~CTCB_sts_wait
	strb	r1, [r3, #u1_ctcb_sts]
	ands	r1, r1, #CTCB_sts_suspended
	beq	.err_e_ok_wup_tsk

	ldrb	r1, [r3, #u1_ctcb_pri]
	mov	r6, r0
	bl	__regist_readyqueue

	b	.err_e_ok_wup_tsk

.inc_wup_cnt_wup_tsk:
	ldrb	r1, [r3, #u1_ctcb_slpcnt]
	add	r1, #1
	cmp	r1, #255
	bgt	.err_e_qovr_wup_tsk

	strb	r1, [r3, #u1_ctcb_slpcnt]

.err_e_ok_wup_tsk:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_wup_tsk:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_obj_wup_tsk:
	mov	r0, #E_OBJ
	b	__ServiceCallExit

.err_e_qovr_wup_tsk:
	mov	r0, #E_QOVR
	b	__ServiceCallExit


@
@	_can_wup
@
@	Argument
@
	.globl	can_wup
can_wup:
	mov	r4, sp
	svc	#SST_can_wup
	bx	lr


@
@	_ssf_can_wup
@
@	Argument
@
	.globl	_ssf_can_wup
_ssf_can_wup:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_ctsknum]

	cmp	r0, r1
	bgt	.err_e_id_can_wup

	cmp	r0, #0
	blt	.err_e_id_can_wup
	bne	.end_load_tskid_can_wup

	ldrh	r0, [r2, #u2_sbt_runctsk]

.end_load_tskid_can_wup:
	ldr	r1, =__start_ctcb
	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r3, r3, r1

	ldrb	r1, [r3, #u1_ctcb_sts]
	ands	r4, r1, #CTCB_sts_dormant
	bne	.err_e_obj_can_wup

	ldrb	r0, [r3, #u1_ctcb_slpcnt]
	mov	r1, #0
	strb	r1, [r3, #u1_ctcb_slpcnt]

	b	__ServiceCallExit

.err_e_id_can_wup:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_obj_can_wup:
	mov	r0, #E_OBJ
	b	__ServiceCallExit


@
@	_rel_wai
@
@	Argument
@
	.globl	rel_wai
rel_wai:
	mov	r4, sp
	svc	#SST_rel_wai
	bx	lr


@
@	_ssf_rel_wai
@
@	Argument
@
	.globl	_ssf_rel_wai
_ssf_rel_wai:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_ctsknum]

	cmp	r0, r1
	bgt	.err_e_id_rel_wai

	cmp	r0, #0
	ble	.err_e_id_rel_wai

	ldr	r1, =__start_ctcb
	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r3, r3, r1

	ldrb	r1, [r3, #u1_ctcb_sts]
	ands	r4, r1, #CTCB_sts_wait
	beq	.err_e_obj_rel_wai

	mov	r4, #E_RLWAI
	str	r4, [r3, #u4_ctcb_rtnprm]
	ldr	r4, [r3, #u4_ctcb_taskwait]
	and	r1, r1, #~CTCB_sts_wait
	strb	r1, [r3, #u1_ctcb_sts]
	mov	r5, #TTW_ALL
	mvn	r5, r5
	and	r4, r4, r5
	str	r4, [r3, #u4_ctcb_taskwait]

	ands	r1, r1, #CTCB_sts_suspended
	bne	.err_e_ok_rel_wai

	ldrb	r1, [r3, #u1_ctcb_pri]
	mov	r6, r0
	bl	__regist_readyqueue

.err_e_ok_rel_wai:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_rel_wai:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_obj_rel_wai:
	mov	r0, #E_OBJ
	b	__ServiceCallExit


@
@	_sus_tsk
@
@	Argument
@
	.globl	sus_tsk
sus_tsk:
	mov	r4, sp
	svc	#SST_sus_tsk
	bx	lr


@
@	_ssf_sus_tsk
@
@	Argument
@
	.globl	_ssf_sus_tsk
_ssf_sus_tsk:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_ctsknum]

	cmp	r0, r1
	bgt	.err_e_id_sus_tsk

	cmp	r0, #0
	blt	.err_e_id_sus_tsk
	bne	.end_load_tskid_sus_tsk

	ldrh	r1, [r2, #u2_sbt_syssts]
	ands	r1, r1, #SS_DISDSP
	bne	.err_e_ctx_sus_tsk

	ldrh	r0, [r2, #u2_sbt_runctsk]

.end_load_tskid_sus_tsk:
	ldr	r1, =__start_ctcb
	mov	r7, #SIZE_ctcb
	mul	r7, r0, r7
	add	r7, r7, r1

	ldrb	r4, [r7, #u1_ctcb_sts]
	ands	r1, r4, #CTCB_sts_dormant
	bne	.err_e_obj_sus_tsk

	ldrb	r1, [r7, #u1_ctcb_suscnt]
	add	r1, #1
	cmp	r1, #255
	bgt	.err_e_qovr_sus_tsk

	strb	r1, [r7, #u1_ctcb_suscnt]

	ldrb	r1, [r7, #u1_ctcb_pri]
	ldrb	r4, [r7, #u1_ctcb_sts]
	mov	r6, r0
	ands	r4, r4, #(CTCB_sts_run | CTCB_sts_run)
	beq	.end_del_rdyque_sus_tsk

	and	r4, r4, #(!CTCB_sts_run | !CTCB_sts_run)

	bl	__delete_readyqueue

.end_del_rdyque_sus_tsk:
	orr	r4, r4, #CTCB_sts_suspended
	str	r4, [r7, #u1_ctcb_sts]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_sus_tsk:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_ctx_sus_tsk:
	mov	r0, #E_CTX
	b	__ServiceCallExit

.err_e_obj_sus_tsk:
	mov	r0, #E_OBJ
	b	__ServiceCallExit

.err_e_qovr_sus_tsk:
	mov	r0, #E_QOVR
	b	__ServiceCallExit


@
@	_rsm_tsk
@
@	Argument
@
	.globl	rsm_tsk
rsm_tsk:
	mov	r4, sp
	svc	#SST_rsm_tsk
	bx	lr


@
@	_ssf_rsm_tsk
@
@	Argument
@
	.globl	_ssf_rsm_tsk
_ssf_rsm_tsk:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_ctsknum]

	cmp	r0, r1
	bgt	.err_e_id_rsm_tsk

	cmp	r0, #0
	ble	.err_e_id_rsm_tsk

	ldr	r1, =__start_ctcb
	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r3, r3, r1

	ldrb	r1, [r3, #u1_ctcb_sts]
	ands	r4, r1, #CTCB_sts_suspended
	beq	.err_e_obj_rsm_tsk

	ldrb	r4, [r3, #u1_ctcb_suscnt]
	and	r1, r1, #~CTCB_sts_suspended
	sub	r4, r4, #1
	strb	r1, [r3, #u1_ctcb_sts]
	strb	r4, [r3, #u1_ctcb_suscnt]

	ands	r1, r1, #CTCB_sts_wait
	beq	.err_e_ok_rsm_tsk

	ldrb	r1, [r3, #u1_ctcb_pri]
	mov	r6, r0

	bl	__regist_readyqueue

.err_e_ok_rsm_tsk:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_rsm_tsk:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_obj_rsm_tsk:
	mov	r0, #E_OBJ
	b	__ServiceCallExit


@
@	_dly_tsk
@
@	Argument
@
	.globl	dly_tsk
dly_tsk:
	mov	r4, sp
	svc	#SST_dly_tsk
	bx	lr


@
@	_ssf_dly_tsk
@
@	Argument
@
	.globl	_ssf_dly_tsk
_ssf_dly_tsk:
	ldr	r2, =__start_sbt

	ldrh	r6, [r2, #u2_sbt_runctsk]

	ldr	r3, =__start_ctcb
	mov	r4, #SIZE_ctcb
	mul	r4, r6, r4
	add	r7, r4, r3

	cmp	r0, #0
	ble	.err_e_par_dly_tsk

	@ レディ・キューから削除
	ldrb	r1, [r7, #u1_ctcb_pri]
	bl	__delete_readyqueue

	@ タスク状態の更新
	ldrb	r3, [r7, #u1_ctcb_sts]
	ldr	r4, [r7, #u4_ctcb_taskwait]
	and	r3, r3, #~CTCB_sts_run
	orr	r3, r3, #CTCB_sts_wait
	str	r3, [r7, #u1_ctcb_sts]
	orr	r4, r4, #TTW_DLY
	str	r4, [r7, #u4_ctcb_taskwait]

	ldr	r3, =__start_timerque_head
	ldr	r4, [r3, #u4_timerque_head]

	cmp	r4, #0
	bne	.end_reload_quehead_dly_tsk

	str	r6, [r3, #u4_timerque_head]
	str	r6, [r7, #u4_ctcb_tprev]
	str	r6, [r7, #u4_ctcb_tnext]

	b	.call_scheduler_dly_tsk

.end_reload_quehead_dly_tsk:
	mov	r5, #0xffff
	lsr	r8, r4, #16
	and	r8, r8, r5

	ldr	r3, =__start_ctcb
	mov	r9, #SIZE_ctcb
	mul	r1, r8, r9
	add	r1, r1, r3

	ldr	r8, [r1, #u4_ctcb_tprev]
	str	r6, [r1, #u4_ctcb_tprev]

	str	r8, [r7, #u4_ctcb_tprev]
	str	r4, [r7, #u4_ctcb_tnext]

	lsr	r8, r8, #16
	and	r8, r8, r5
	mul	r1, r8, r9
	add	r1, r1, r3

	str	r6, [r1, #u4_ctcb_tnext]
	str	r0, [r7, #u4_ctcb_waitick]

.call_scheduler_dly_tsk:
	ldrb	r5, [r2, #u1_sbt_sch_ena]
	and	r5, r5, #~SBT_sch_ena_ENA
	strb	r5, [r2, #u1_sbt_sch_ena]

	mov	r1, #0
	str	r1, [r7, #u4_ctcb_rtnprm]

	b	__ServiceCallExit

.err_e_par_dly_tsk:
	mov	r0, #E_PAR
	b	__ServiceCallExit
