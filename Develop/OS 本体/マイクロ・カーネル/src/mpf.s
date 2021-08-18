@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_sit
	.extern	__start_mpfinf
	.extern	__start_mpfctrl
	.extern	__ServiceCallExit


@
@	_get_mpf
@
@	Argument
@
	.globl	get_mpf
get_mpf:
	mov	r2, #-1
	mov	r4, sp
	svc	#SST_get_mpf
	bx	lr


@
@	_pget_mpf
@
@	Argument
@
	.globl	pget_mpf
pget_mpf:
	mov	r2, #0
	mov	r4, sp
	svc	#SST_pget_mpf
	bx	lr


@
@	_tget_mpf
@
@	Argument
@
	.globl	tget_mpf
tget_mpf:
	mov	r4, sp
	svc	#SST_tget_mpf
	bx	lr


@
@	_ssf_tget_mpf
@
@	Argument
@
	.globl	_ssf_tget_mpf
_ssf_tget_mpf:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_mpfnum]

	cmp	r0, r3
	bgt	.err_e_id_tget_mpf

	cmp	r0, #0
	ble	.err_e_id_tget_mpf

	cmp	r1, #0
	beq	.err_e_par_tget_mpf

	cmp	r2, #-2
	ble	.err_e_par_tget_mpf

	mov	r3, #SIZE_mpfctrl
	ldr	r4, =__start_mpfctrl
	mul	r3, r0, r3
	add	r3, r3, r4

	ldr	r4, [r3, #u4_mpfctrl_fblkcnt]
	cmp	r4, #0
	beq	.start_wai_ope_tget_mpf

	ldr	r5, [r3, #pv4_mplctrl_mpf]
	ldr	r6, [r5, #u4_mpf_next]
	str	r6, [r3, #pv4_mplctrl_mpf]

	str	r5, [r1, #0]
	sub	r4, r4, #1
	str	r4, [r3, #u4_mpfctrl_fblkcnt]

	mov	r0, #E_OK
	b	__ServiceCallExit

.start_wai_ope_tget_mpf:
	cmp	r2, #0
	beq	.err_e_tmout_tget_mpf

	ldrh	r5, [r5, #u2_sbt_runctsk]

	mov	r7, r1
	mov	r4, r2
	ldrb	r1, [r8, #u1_ctcb_pri]
	mov	r6, r5

	ldr	r2, =__start_sbt

	bl	__delete_readyqueue

	mov	r3, #SIZE_mpfctrl
	ldr	r4, =__start_mpfctrl
	mul	r3, r0, r3
	add	r3, r3, r4

	mov	r5, #SIZE_mpfinf
	ldr	r6, =__start_mpfinf
	mul	r5, r0, r5
	add	r5, r5, r6

	ldrb	r5, [r5, #u1_mpfinf_mpfatr]
	cmp	r5, #TA_TFIFO

	ldr	r5, =__start_sbt
	ldr	r4, [r3, #u4_mpfctrl_wtskid]
	ldrh	r5, [r5, #u2_sbt_runctsk]

	beq	.start_reg_waique_tget_mpf

	add	r6, r3, #u4_mpfctrl_wtskid

	bl	__que_search

.end_wai_ope_tget_mpf:
	mov	r5, #0xffff
	lsr	r8, r6, #16
	and	r8, r8, r5

	mov	r10, #SIZE_ctcb
	ldr	r9, =__start_ctcb
	mul	r10, r8, r10
	add	r10, r10, r9

	cmp	r4, #-1
	beq	.end_reg_timque_twai_sem

	ldr	r3, =__start_timerque_head
	ldr	r0, [r3, #u4_timerque_head]

	cmp	r0, #0
	bne	.end_reload_quehead_twai_sem

	str	r6, [r3, #u4_timerque_head]
	str	r6, [r10, #u4_ctcb_tprev]
	str	r6, [r10, #u4_ctcb_tnext]

	b	.end_reg_timque_twai_sem

.end_reload_quehead_twai_sem:
	mov	r5, #0xffff
	lsr	r8, r0, #16
	and	r8, r8, r5

	ldr	r3, =__start_ctcb
	mov	r9, #SIZE_ctcb
	mul	r1, r8, r9
	add	r1, r1, r3

	ldr	r8, [r1, #u4_ctcb_tprev]
	str	r6, [r1, #u4_ctcb_tprev]

	str	r8, [r10, #u4_ctcb_tprev]
	str	r0, [r10, #u4_ctcb_tnext]

	lsr	r8, r8, #16
	and	r8, r8, r5
	mul	r1, r8, r9
	add	r1, r1, r3

	str	r6, [r1, #u4_ctcb_tnext]
	str	r4, [r10, #u4_ctcb_waitick]

.end_reg_timque_twai_sem:
	ldrb	r5, [r2, #u1_sbt_sch_ena]
	and	r5, r5, #~SBT_sch_ena_ENA
	strb	r5, [r2, #u1_sbt_sch_ena]
	ldrb	r4, [r2, #u1_sbt_highest_ctsk]
	ldrb	r6, [r10, #u1_ctcb_pri]
	cmp	r4, r6
	bne	.end_reload_highpri_twai_sem

	mov	r6, #0
	strb	r6, [r2, #u1_sbt_highest_ctsk]

.end_reload_highpri_twai_sem:
	mov	r1, #0
	str	r1, [r10, #u4_ctcb_rtnprm]

	b	__ServiceCallExit

.start_reg_waique_tget_mpf:
	mov	r6, #SIZE_ctcb
	ldr	r7, =__start_ctcb
	mul	r8, r5, r6
	add	r8, r8, r7

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

	b	.end_wai_ope_tget_mpf

.reload_que_top_twai_sem:
	str	r5, [r3, #u4_semctrl_wtskid]
	str	r5, [r8, #u4_ctcb_prev]
	str	r5, [r8, #u4_ctcb_next]

	b	.end_wai_ope_tget_mpf

.err_e_id_tget_mpf:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_tget_mpf:
	mov	r0, #E_PAR
	b	__ServiceCallExit

.err_e_tmout_tget_mpf:
	mov	r0, #E_TMOUT
	b	__ServiceCallExit


@
@	_rel_mpf
@
@	Argument
@
	.globl	rel_mpf
rel_mpf:
	mov	r4, sp
	svc	#SST_rel_mpf
	bx	lr


@
@	_ssf_rel_mpf
@
@	Argument
@
	.globl	_ssf_rel_mpf
_ssf_rel_mpf:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_mpfnum]

	cmp	r0, r3
	bgt	.err_e_id_rel_mpf

	cmp	r0, #0
	ble	.err_e_id_rel_mpf

	cmp	r1, #0
	beq	.err_e_par_rel_mpf

	mov	r3, #SIZE_mpfctrl
	ldr	r4, =__start_mpfctrl
	mul	r3, r0, r3
	add	r3, r3, r4
	ldr	r4, [r3, #u4_mpfctrl_wtskid]

	cmp	r4, #0
	bne	.start_reg_rdyque_rel_mpf

	mov	r6, #SIZE_mpfctrl
	ldr	r7, =__start_mpfctrl
	mul	r6, r0, r6
	add	r6, r6, r7

	ldr	r5, [r1, #0]
	ldr	r4, [r3, #pv4_mplctrl_mpf]
	ldr	r9, [r3, #u4_mpfctrl_fblkcnt]
	str	r4, [r5, #u4_mpf_next]

	ldr	r8, [r6, #u4_mpfinf_blksz]
	str	r8, [r5, #u4_mpf_size]

	str	r5, [r3, #pv4_mplctrl_mpf]

	add	r9, r9, #1
	str	r9, [r3, #u4_mpfctrl_fblkcnt]

	mov	r0, #E_OK
	b	__ServiceCallExit

.start_reg_rdyque_rel_mpf:
	mov	r7, #SIZE_ctcb
	ldr	r5, =__start_ctcb

	mul	r0, r4, r7
	add	r0, r0, r5
	mov	r6, #0
	ldr	r8,  [r0, #u4_ctcb_next]
	ldr	r9,  [r0, #u4_ctcb_prev]
	ldrb	r10, [r0, #u1_ctcb_pri]
	str	r6,  [r0, #u4_ctcb_next]
	str	r6,  [r0, #u4_ctcb_prev]

	cmp	r4, r8
	beq	.reload_que_top_rel_mpf

	mul	r6, r8, r7
	add	r6, r6, r5
	str	r9, [r6, #u4_ctcb_prev]
	mul	r6, r9, r7
	add	r6, r6, r5
	str	r8, [r6, #u4_ctcb_next]

	mov	r6, r8

.reload_que_top_rel_mpf:
	str	r6, [r3, #u4_semctrl_wtskid]

	mov	r6, r4

	ldrb	r3, [r2, #u1_sbt_highest_ctsk]
	cmp	r10, r3
	bge	.regist_rdyque_sig_sem

	ldrb	r3,  [r2, #u1_sbt_sch_ena]
	strb	r10, [r2, #u1_sbt_highest_ctsk]
	and	r3,  r3, #~SBT_sch_ena_ENA
	strb	r3,  [r2, #u1_sbt_sch_ena]

.regist_rdyque_sig_sem:
	ldr	r3, [r0, #pv4_ctcb_stack]
	ldmfd	r3!, {r7}

	str	r1, [r7, #0]

	mov	r1, r10

	bl	__regist_readyqueue

	bl	__del_timque

	mov	r1, r7
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_rel_mpf:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_rel_mpf:
	mov	r0, #E_PAR
	b	__ServiceCallExit


@
@	_ref_mpf
@
@	Argument
@
	.globl	ref_mpf
ref_mpf:
	mov	r4, sp
	svc	#SST_ref_mpf
	bx	lr


@
@	_ssf_ref_mpf
@
@	Argument
@
	.globl	_ssf_ref_mpf
_ssf_ref_mpf:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_mpfnum]

	cmp	r0, r3
	bgt	.err_e_id_ref_mpf

	cmp	r0, #0
	ble	.err_e_id_ref_mpf

	cmp	r1, #0
	beq	.err_e_par_ref_mpf

	mov	r2, #SIZE_mpfctrl
	ldr	r3, =__start_mpfctrl
	mul	r2, r0, r2
	add	r2, r2, r3

	ldr	r3, [r2, #u4_mpfctrl_wtskid]
	ldr	r4, [r2, #u4_mpfctrl_fblkcnt]
	str	r3, [r1, #u4_rmpf_wtskid]
	str	r4, [r1, #u4_rmpf_fblkcnt]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_ref_mpf:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_ref_mpf:
	mov	r0, #E_PAR
	b	__ServiceCallExit
