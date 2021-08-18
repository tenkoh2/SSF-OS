@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2

	.extern	__start_sbt
	.extern	__start_ctcb
	.extern	__start_seminf
	.extern	__start_semctrl
	.extern	__start_timerque_head
	.extern	__ServiceCallExit
	.extern	__que_search


@
@	_sig_sem
@
@	Argument
@
	.globl	sig_sem
sig_sem:
	push	{lr}
	mov	r4, sp
	svc	#SST_sig_sem
	pop	{lr}
	bx	lr


@
@	_ssf_sig_sem
@
@	Argument
@
	.globl	_ssf_sig_sem
_ssf_sig_sem:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_semnum]

	cmp	r0, r3
	bgt	.err_e_id_sig_sem

	cmp	r0, #0
	ble	.err_e_id_sig_sem

	mov	r3, #SIZE_semctrl
	ldr	r4, =__start_semctrl

	mul	r3, r0, r3
	add	r3, r3, r4

	ldr	r4, [r3, #u4_semctrl_wtskid]
	cmp	r4, #0
	bne	.start_waique_reload

	ldr	r4, [r3, #u4_semctrl_semcnt]
	mov	r5, #SIZE_seminf
	ldr	r6, =__start_seminf
	mul	r5, r0, r5
	add	r5, r5, r6
	ldr	r6, [r5, #u4_seminf_maxsem]
	add	r4, r4, #1
	cmp	r4, r6
	bgt	.err_e_qovr_sig_sem

	str	r4, [r3, #u4_semctrl_semcnt]

	mov	r0, #E_OK
	b	__ServiceCallExit

.start_waique_reload:
	mov	r7, #SIZE_ctcb
	ldr	r5, =__start_ctcb

	mul	r0, r4, r7
	add	r0, r0, r5
	mov	r6, #0
	ldr	r8, [r0, #u4_ctcb_next]
	ldr	r9, [r0, #u4_ctcb_prev]
	ldrb	r1, [r0, #u1_ctcb_pri]
	str	r6, [r0, #u4_ctcb_next]
	str	r6, [r0, #u4_ctcb_prev]

	cmp	r4, r8
	beq	.reload_que_top_sig_sem

	mul	r6, r8, r7
	add	r6, r6, r5
	str	r9, [r6, #u4_ctcb_prev]
	mul	r6, r9, r7
	add	r6, r6, r5
	str	r8, [r6, #u4_ctcb_next]

	mov	r6, r8

.reload_que_top_sig_sem:
	str	r6, [r3, #u4_semctrl_wtskid]

	mov	r6, r4

	ldrb	r3, [r2, #u1_sbt_highest_ctsk]
	cmp	r1, r3
	bge	.regist_rdyque_sig_sem

	ldrb	r3, [r2, #u1_sbt_sch_ena]
	strb	r1, [r2, #u1_sbt_highest_ctsk]
	and	r3, r3, #~SBT_sch_ena_ENA
	strb	r3, [r2, #u1_sbt_sch_ena]

.regist_rdyque_sig_sem:
	bl	__regist_readyqueue

	bl	__del_timque

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_sig_sem:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_qovr_sig_sem:
	mov	r0, #E_QOVR
	b	__ServiceCallExit


@
@	_wai_sem
@
@	Argument
@
	.globl	wai_sem
wai_sem:
	mov	r1, #-1
	push	{lr}
	mov	r4, sp
	svc	#SST_wai_sem
	pop	{lr}
	bx	lr


@
@	_pol_sem
@
@	Argument
@
	.globl	pol_sem
pol_sem:
	mov	r1, #0
	push	{lr}
	mov	r4, sp
	svc	#SST_pol_sem
	pop	{lr}
	bx	lr


@
@	twai_sem
@
@	Argument
@
	.globl	twai_sem
twai_sem:
	cmp	r1, #-2
	ble	.err_e_par_twai_sem

	push	{lr}
	mov	r4, sp
	svc	#SST_twai_sem
	pop	{lr}
	bx	lr

.err_e_par_twai_sem:
	mov	r0, #E_PAR
	bx	lr


@
@	_ssf_twai_sem
@
@	Argument
@
	.globl	_ssf_twai_sem
_ssf_twai_sem:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_semnum]

	cmp	r0, r3
	bgt	.err_e_id_twai_sem

	cmp	r0, #0
	ble	.err_e_id_twai_sem

	mov	r3, #SIZE_semctrl
	ldr	r4, =__start_semctrl
	mul	r3, r0, r3
	add	r3, r3, r4
	ldr	r4, [r3, #u4_semctrl_semcnt]
	cmp	r4, #0
	bne	.dec_semcnt_twai_sem

	cmp	r1, #0
	beq	.err_e_tmout_twai_sem

	ldrh	r5, [r2, #u2_sbt_runctsk]

	mov	r6, #SIZE_ctcb
	ldr	r7, =__start_ctcb
	mul	r8, r5, r6
	add	r8, r8, r7

	mov	r4, r1
	ldrb	r1, [r8, #u1_ctcb_pri]
	mov	r6, r5

	bl	__delete_readyqueue

	mov	r1, r4

	ldrh	r5, [r2, #u2_sbt_runctsk]

	mov	r6, #SIZE_ctcb
	ldr	r7, =__start_ctcb
	mul	r8, r5, r6
	add	r8, r8, r7

	mov	r3, #SIZE_semctrl
	ldr	r4, =__start_semctrl
	mul	r3, r0, r3
	add	r3, r3, r4

	mov	r4, #SIZE_seminf
	ldr	r6, =__start_seminf
	mul	r4, r0, r4
	add	r4, r4, r6
	ldrb	r6, [r4, #u1_seminf_atr]

	ldr	r4, [r3, #u4_semctrl_wtskid]

	ands	r6, r6, #TA_TPRI
	bne	.call_que_search_twai_sem

	cmp	r4, #0
	beq	.reload_que_top_twai_sem

	mul	r9, r4, r6
	add	r9, r9, r7

	str	r4,  [r8, #u4_ctcb_next]
	ldr	r10, [r9, #u4_ctcb_prev]
	str	r5,  [r9, #u4_ctcb_prev]
	str	r10, [r8, #u4_ctcb_prev]

	mul	r9, r10, r6
	add	r9, r9, r7

	str	r5, [r9, #u4_ctcb_next]

	b	.end_reload_que_top_twai_sem

.reload_que_top_twai_sem:
	str	r5, [r3, #u4_semctrl_wtskid]
	str	r5, [r8, #u4_ctcb_prev]
	str	r5, [r8, #u4_ctcb_next]

.end_reload_que_top_twai_sem:
	mov	r5, #0xffff
	lsr	r8, r6, #16
	and	r8, r8, r5

	mov	r7, #SIZE_ctcb
	ldr	r9, =__start_ctcb
	mul	r7, r8, r7
	add	r7, r7, r9

	cmp	r1, #-1
	beq	.end_reg_timque_twai_sem

	ldr	r3, =__start_timerque_head
	ldr	r0, [r3, #u4_timerque_head]

	cmp	r0, #0
	bne	.end_reload_quehead_twai_sem

	str	r6, [r3, #u4_timerque_head]
	str	r6, [r7, #u4_ctcb_tprev]
	str	r6, [r7, #u4_ctcb_tnext]

	b	.end_reg_timque_twai_sem

.end_reload_quehead_twai_sem:
	mov	r5, #0xffff
	lsr	r8, r0, #16
	and	r8, r8, r5

	ldr	r3, =__start_ctcb
	mov	r9, #SIZE_ctcb
	mul	r1, r8, r9
	add	r1, r1, r3

	lsl	r8, r8, #16
	orr	r8, r8, #ID_kind_task
	orr	r8, r8, #Core_ID

	ldr	r8, [r1, #u4_ctcb_tprev]
	str	r6, [r1, #u4_ctcb_tprev]

	str	r8, [r7, #u4_ctcb_tprev]
	str	r0, [r7, #u4_ctcb_tnext]

	lsr	r8, r8, #16
	and	r8, r8, r5
	mul	r1, r8, r9
	add	r1, r1, r3

	str	r6, [r1, #u4_ctcb_tnext]
	str	r1, [r7, #u4_ctcb_waitick]

.end_reg_timque_twai_sem:
	ldrb	r5, [r2, #u1_sbt_sch_ena]
	and	r5, r5, #~SBT_sch_ena_ENA
	strb	r5, [r2, #u1_sbt_sch_ena]
	ldrb	r4, [r2, #u1_sbt_highest_ctsk]
	ldrb	r6, [r7, #u1_ctcb_pri]
	cmp	r4, r6
	bne	.end_reload_highpri_twai_sem

	mov	r6, #0
	strb	r6, [r2, #u1_sbt_highest_ctsk]

.end_reload_highpri_twai_sem:
	mov	r1, #0
	str	r1, [r7, #u4_ctcb_rtnprm]

	b	__ServiceCallExit

.call_que_search_twai_sem:
	add	r6, r3, #u4_semctrl_wtskid
	bl	__que_search

	ldr	r2, =__start_sbt
	ldrh	r5, [r2, #u2_sbt_runctsk]

	mov	r6, #SIZE_ctcb
	ldr	r7, =__start_ctcb
	mul	r8, r5, r6
	add	r8, r8, r7

	b	.end_reload_que_top_twai_sem

.dec_semcnt_twai_sem:
	sub	r4, r4, #1
	str	r4, [r3, #u4_semctrl_semcnt]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_twai_sem:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_tmout_twai_sem:
	mov	r0, #E_TMOUT
	b	__ServiceCallExit


@
@	_ref_sem
@
@	Argument
@
	.globl	ref_sem
ref_sem:
	mov	r4, sp
	svc	#SST_ref_sem
	bx	lr


@
@	_ssf_ref_sem
@
@	Argument
@
	.globl	_ssf_ref_sem
_ssf_ref_sem:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_semnum]

	cmp	r0, r3
	bgt	.err_e_id_ref_sem

	cmp	r0, #0
	ble	.err_e_id_ref_sem

	cmp	r1, #0
	beq	.err_e_par_ref_sem

	mov	r2, #SIZE_semctrl
	ldr	r3, =__start_semctrl
	mul	r2, r0, r2
	add	r2, r2, r3

	ldr	r3, [r2, #u4_semctrl_wtskid]
	ldr	r4, [r2, #u4_semctrl_semcnt]
	str	r3, [r1, #u4_rsem_wtskid]
	str	r4, [r1, #u4_rsem_semcnt]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_ref_sem:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_ref_sem:
	mov	r0, #E_PAR
	b	__ServiceCallExit
