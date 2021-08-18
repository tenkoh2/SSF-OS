@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2

	.extern	__start_sbt
	.extern	__start_ctcb
	.extern	__start_mib
	.extern	__start_mcb
	.extern	__start_timerque_head
	.extern	__ServiceCallExit
	.extern	_ssf_ChangePriority


@
@	_loc_mtx
@
@	Argument
@
	.globl	loc_mtx
loc_mtx:
	mov	r1, #-1
	mov	r4, sp
	svc	#SST_loc_mtx
	bx	lr


@
@	_ploc_mtx
@
@	Argument
@
	.globl	ploc_mtx
ploc_mtx:
	mov	r1, #0
	mov	r4, sp
	svc	#SST_ploc_mtx
	bx	lr


@
@	_tloc_mtx
@
@	Argument
@
	.globl	tloc_mtx
tloc_mtx:
	mov	r1, #0
	mov	r4, sp
	svc	#SST_tloc_mtx
	bx	lr


@
@	_ssf_tloc_mtx
@
@	Argument
@
	.globl	_ssf_tloc_mtx
_ssf_tloc_mtx:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_mtxnum]

	cmp	r0, r3
	bgt	.err_e_id_tloc_mtx

	cmp	r0, #0
	ble	.err_e_id_tloc_mtx

	cmp	r1, #-2
	ble	.err_e_par_tloc_mtx

	ldrh	r3, [r2, #u2_sbt_runctsk]
	mov	r4, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r4, r3, r4
	add	r4, r4, r5

	ldr	r5, [r4, #u4_ctcb_mtxid]
	cmp	r5, #0
	bne	.err_e_iluse_tloc_mtx

	mov	r5, #SIZE_mib
	ldr	r6, =__start_mib
	mul	r5, r0, r5
	add	r5, r5, r6
	ldrh	r6, [r5, #u2_mib_mtxatr]
	cmp	r6, #TA_CEILING
	bne	.end_check_e_iluse_tloc_mtx

	ldrh	r6, [r5, #u2_mib_ceilpri]
	ldrb	r7, [r4, #u1_ctcb_bpri]
	cmp	r7, r6
	blt	.err_e_iluse_tloc_mtx

.end_check_e_iluse_tloc_mtx:
	mov	r8, #SIZE_mcb
	ldr	r9, =__start_mcb
	mul	r8, r0, r8
	add	r8, r8, r9
	ldr	r9, [r8, #u4_mcb_tskid]
	cmp	r9, #0
	bne	.start_waiting_ope_tloc_mtx

	str	r3, [r8, #u4_mcb_tskid]
	str	r0, [r4, #u4_ctcb_mtxid]

	ldrh	r6, [r5, #u2_mib_mtxatr]
	cmp	r6, #TA_CEILING
	bne	.err_e_ok_tloc_mtx

	ldrb	r9, [r4, #u1_ctcb_pri]
	cmp	r9, r6
	ble	.err_e_ok_tloc_mtx

	strb	r6, [r4, #u1_ctcb_pri]

	mov	r4, r1
	mov	r1, r9
	mov	r7, r6

	mov	r6, r3
	bl	__delete_readyqueue

	mov	r1, r7
	mov	r6, r3
	bl	__regist_readyqueue

	mov	r1, r4

	b	.err_e_ok_tloc_mtx

.start_waiting_ope_tloc_mtx:
	cmp	r1, #0
	beq	.err_e_tmout_tloc_mtx

	ldr	r2, =__start_sbt
	ldrh	r6, [r2, #u2_sbt_runctsk]
	mov	r3, #SIZE_ctcb
	ldr	r4, =__start_ctcb
	mul	r3, r6, r3
	add	r3, r3, r4
	ldrb	r4, [r3, #u1_ctcb_pri]

	mov	r7, r1
	mov	r1, r4
	bl	__delete_readyqueue

	mov	r1, r7

	ldrh	r3, [r2, #u2_sbt_runctsk]
	mov	r4, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r4, r3, r4
	add	r4, r4, r5

	ldrb	r6, [r4, #u1_ctcb_sts]
	ldrh	r7, [r5, #u2_mib_mtxatr]
	and	r6, r6, #~CTCB_sts_all
	orr	r6, r6, #CTCB_sts_wait
	strb	r6, [r4, #u1_ctcb_sts]

	ands	r7, r7, #TA_TPRI
	beq	.end_prique_tloc_mtx

	ldr	r4, [r8, #u4_mcb_wtskid]
	mov	r5, r3
	add	r6, r8, #u4_mcb_wtskid

	bl	__que_search

	b	.end_waique_tloc_mtx

.end_prique_tloc_mtx:
	ldr	r9, [r8, #u4_mcb_wtskid]
	cmp	r9, #0
	beq	.reload_que_top_tloc_mtx

	mov	r6, #SIZE_ctcb
	ldr	r7, =__start_ctcb
	mul	r11, r9, r6
	add	r11, r11, r7

	str	r9,  [r4,  #u4_ctcb_next]
	ldr	r10, [r11, #u4_ctcb_prev]
	str	r3,  [r11, #u4_ctcb_prev]
	str	r10, [r4,  #u4_ctcb_prev]

	mul	r11, r10, r6
	add	r11, r11, r7

	str	r3, [r11, #u4_ctcb_next]

	b	.end_waique_tloc_mtx

.reload_que_top_tloc_mtx:
	str	r5, [r8, #u4_mcb_wtskid]
	str	r4, [r4, #u4_ctcb_prev]
	str	r4, [r4, #u4_ctcb_next]

.end_waique_tloc_mtx:
	ldr	r3, =__start_sbt
	ldrh	r8, [r3, #u2_sbt_runctsk]

	cmp	r1, #-1
	beq	.end_reg_timque_tloc_mtx

	ldr	r3, =__start_timerque_head
	ldr	r4, [r3, #u4_timerque_head]

	lsl	r6, r8, #16
	orr	r6, r6, #ID_kind_task
	orr	r6, r6, #Core_ID

	cmp	r4, #0
	bne	.end_reload_quehead_tloc_mtx

	mov	r7, #SIZE_ctcb
	ldr	r9, =__start_ctcb
	mul	r7, r8, r7
	add	r7, r7, r9

	str	r6, [r3, #u4_timerque_head]
	str	r6, [r7, #u4_ctcb_tprev]
	str	r6, [r7, #u4_ctcb_tnext]

	b	.end_reg_timque_tloc_mtx

.end_reload_quehead_tloc_mtx:
	mov	r5, #0xffff
	lsr	r8, r4, #16
	and	r8, r8, r5

	ldr	r3, =__start_ctcb
	mov	r9, #SIZE_ctcb
	mul	r5, r8, r9
	add	r5, r5, r3

	lsl	r8, r8, #16
	orr	r8, r8, #ID_kind_task
	orr	r8, r8, #Core_ID

	ldr	r8, [r5, #u4_ctcb_tprev]
	str	r6, [r5, #u4_ctcb_tprev]

	str	r8, [r7, #u4_ctcb_tprev]
	str	r4, [r7, #u4_ctcb_tnext]

	lsr	r8, r8, #16
	and	r8, r8, r5
	mul	r5, r8, r9
	add	r5, r5, r3

	str	r6, [r5, #u4_ctcb_tnext]
	str	r1, [r7, #u4_ctcb_waitick]

.end_reg_timque_tloc_mtx:
	mov	r3, #SIZE_mib
	ldr	r6, =__start_mib
	mul	r3, r0, r3
	add	r3, r3, r6
	ldrh	r3, [r3, #u2_mib_mtxatr]
	cmp	r3, #TA_INHERIT
	bne	.end_chg_pri_tloc_mtx

	mov	r3, #SIZE_mcb
	ldr	r6, =__start_mcb
	mul	r3, r0, r3
	add	r3, r3, r6
	ldr	r3, [r3, #u4_mcb_tskid]

	mov	r6, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r6, r3, r6
	add	r6, r6, r5
	ldrb	r5, [r6, #u1_ctcb_pri]

	cmp	r5, r4
	ble	.end_chg_pri_tloc_mtx

	mov	r0, r3
	mov	r1, r4
	bl	_ssf_ChangePriority

.end_chg_pri_tloc_mtx:
	ldr	r2, =__start_sbt
	ldrh	r3, [r2, #u2_sbt_runctsk]
	mov	r4, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r4, r3, r4
	add	r7, r4, r5

	ldrb	r5, [r2, #u1_sbt_sch_ena]
	and	r5, r5, #~SBT_sch_ena_ENA
	strb	r5, [r2, #u1_sbt_sch_ena]

	mov	r1, #0
	str	r1, [r7, #u4_ctcb_rtnprm]

	b	__ServiceCallExit

.err_e_ok_tloc_mtx:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_tloc_mtx:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_tloc_mtx:
	mov	r0, #E_PAR
	b	__ServiceCallExit

.err_e_iluse_tloc_mtx:
	mov	r0, #E_ILUSE
	b	__ServiceCallExit

.err_e_tmout_tloc_mtx:
	mov	r0, #E_TMOUT
	b	__ServiceCallExit


@
@	_unl_mtx
@
@	Argument
@
	.globl	unl_mtx
unl_mtx:
	mov	r4, sp
	svc	#SST_unl_mtx
	bx	lr


@
@	_ssf_unl_mtx
@
@	Argument
@
	.globl	_ssf_unl_mtx
_ssf_unl_mtx:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_mtxnum]

	cmp	r0, r3
	bgt	.err_e_id_unl_mtx

	cmp	r0, #0
	ble	.err_e_id_unl_mtx

	ldrh	r3, [r2, #u2_sbt_runctsk]
	mov	r4, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r4, r3, r4
	add	r4, r4, r5
	ldr	r5, [r4, #u4_ctcb_mtxid]
	cmp	r0, r5
	bne	.err_e_iluse_unl_mtx

	mov	r4, #0
	mov	r6, #SIZE_mcb
	ldr	r7, =__start_mcb
	mul	r6, r0, r6
	add	r8, r6, r7
	ldr	r9, [r8, #u4_mcb_wtskid]
	str	r4, [r8, #u4_mcb_tskid]
	cmp	r9, #0
	beq	.end_waique_ope_unl_mtx

	mov	r4, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r6, r9, r4
	add	r6, r6, r5
	mov	r11, #0
	ldr	r7,  [r6,  #u4_ctcb_next]
	ldr	r10, [r6,  #u4_ctcb_prev]
	ldrb	r1,  [r11, #u1_ctcb_pri]
	str	r11, [r6,  #u4_ctcb_next]
	str	r11, [r6,  #u4_ctcb_prev]

	cmp	r9, r10
	beq	.reload_que_top_unl_mtx

	mul	r11,  r7, r4
	add	r11, r11, r5
	str	r9,  [r11, #u4_ctcb_prev]
	mul	r11, r10, r4
	add	r11, r11, r5
	str	r10, [r11, #u4_ctcb_next]

	mov	r11, r7

.reload_que_top_unl_mtx:
	str	r11, [r8, #u4_mcb_wtskid]
	str	r11, [r8, #u4_mcb_tskid]

	mov	r6, r3

	ldrb	r3, [r2, #u1_sbt_highest_ctsk]
	cmp	r1, r3
	bge	.regist_rdyque_unl_mtx

	ldrb	r3, [r2, #u1_sbt_sch_ena]
	strb	r1, [r2, #u1_sbt_highest_ctsk]
	and	r3, r3, #~SBT_sch_ena_ENA
	strb	r3, [r2, #u1_sbt_sch_ena]

.regist_rdyque_unl_mtx:
	mov	r4, r0
	mov	r3, r6
	bl	__regist_readyqueue

	mov	r7, r3
	bl	__del_timque
	mov	r3, r7

.end_waique_ope_unl_mtx:
	mov	r0, #SIZE_ctcb
	ldr	r1, =__start_ctcb
	mul	r0, r3, r0
	add	r0, r0, r1
	str	r2, [r0, #u4_ctcb_mtxid]
	ldrb	r3, [r0, #u1_ctcb_bpri]
	strb	r3, [r0, #u1_ctcb_pri]

	mov	r1, r3
	mov	r0, r3

	bl	_ssf_ChangePriority

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_unl_mtx:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_iluse_unl_mtx:
	mov	r0, #E_ILUSE
	b	__ServiceCallExit


@
@	_ref_mtx
@
@	Argument
@
	.globl	ref_mtx
ref_mtx:
	mov	r4, sp
	svc	#SST_ref_mtx
	bx	lr


@
@	_ssf_ref_mtx
@
@	Argument
@
	.globl	_ssf_ref_mtx
_ssf_ref_mtx:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_mtxnum]

	cmp	r0, r3
	bgt	.err_e_id_ref_mtx

	cmp	r0, #0
	ble	.err_e_id_ref_mtx

	cmp	r1, #0
	beq	.err_e_par_ref_mtx

	mov	r2, #SIZE_mcb
	ldr	r3, =__start_mcb
	mul	r2, r0, r2
	add	r2, r2, r3

	ldr	r3, [r2, #u4_mcb_wtskid]
	ldr	r4, [r2, #u4_mcb_tskid]
	str	r3, [r1, #u4_rmtx_wtskid]
	str	r4, [r1, #u4_rmtx_htskid]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_ref_mtx:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_ref_mtx:
	mov	r0, #E_PAR
	b	__ServiceCallExit
