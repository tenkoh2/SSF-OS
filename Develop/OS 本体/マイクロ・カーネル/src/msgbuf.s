@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_ctcb
	.extern	__start_mbfinf
	.extern	__start_mbfctrl
	.extern	__start_timerque_head
	.extern	__regist_readyqueue
	.extern	__delete_readyqueue
	.extern	__que_search
	.extern	__ServiceCallExit

@
@	_snd_mbf
@
@	Argument
@
	.globl	snd_mbf
snd_mbf:
	mov	r3, #-1
	mov	r4, sp
	svc	#SST_snd_mbf
	bx	lr


@
@	_psnd_mbf
@
@	Argument
@
	.globl	psnd_mbf
psnd_mbf:
	mov	r3, #0
	mov	r4, sp
	svc	#SST_psnd_mbf
	bx	lr


@
@	_tsnd_mbf
@
@	Argument
@
	.globl	tsnd_mbf
tsnd_mbf:
	mov	r4, sp
	svc	#SST_tsnd_mbf
	bx	lr


@
@	_ssf_tsnd_mbf
@
@	Argument
@
	.globl	_ssf_tsnd_mbf
_ssf_tsnd_mbf:
	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_id_tsnd_mbf

	ldr	r4, =__start_sit
	ldrb	r4, [r4, #u1_sit_mbfnum]

	cmp	r0, r4
	bgt	.err_e_id_tsnd_mbf

	cmp	r1, #0
	beq	.err_e_par_tsnd_mbf

	cmp	r2, #0
	beq	.err_e_par_tsnd_mbf

	cmp	r3, #-2
	ble	.err_e_par_tsnd_mbf

	mov	r4, #SIZE_mbfctrl
	ldr	r5, =__start_mbfctrl
	mul	r4, r0, r4
	add	r4, r4, r5

	mov	r5, #SIZE_mbfinf
	ldr	r6, =__start_mbfinf
	mul	r5, r0, r5
	add	r5, r5, r6

	ldr	r6, [r4, #u4_mbfctrl_fmbfsz]
	add	r2, #4
	cmp	r6, r2
	blt	.start_wait_ope_tsnd_mbf

	ldr	r6, [r5, #pv4_mbfinf_mbf]
	ldr	r7, [r5, #u4_mbfinf_mbfsz]
	sub	r6, r6, #1
	add	r6, r7

	ldr	r7, [r4, #u4_mbfctrl_sndaddr]
	ldr	r8, [r4, #u4_mbfctrl_fmbfsz]
	sub	r8, r8, r2
	sub	r2, #4
	str	r2, [r7, #0]
	str	r8, [r4, #u4_mbfctrl_fmbfsz]
	add	r7, #4
	cmp	r7, r6
	blt	.loop_mbf_tsnd_mbf

	ldr	r7, [r5, #pv4_mbfinf_mbf]

.loop_mbf_tsnd_mbf:
	ldrb	r8, [r1, #0]
	strb	r8, [r7, #0]
	add	r7, r7, #1
	add	r1, r1, #1
	cmp	r7, r6
	blt	.end_reload_mbf_addr_tsnd_mbf

	ldr	r7, [r5, #pv4_mbfinf_mbf]

.end_reload_mbf_addr_tsnd_mbf:
	subs	r2, r2, #1
	bne	.loop_mbf_tsnd_mbf

	ldr	r8, [r4, #u4_mbfctrl_smsgcnt]
	str	r7, [r4, #u4_mbfctrl_sndaddr]
	add	r8, r8, #1
	str	r8, [r4, #u4_mbfctrl_smsgcnt]

	mov	r0, #E_OK
	b	__ServiceCallExit

.start_wait_ope_tsnd_mbf:
	ldr	r6, [r4, #u4_mbfctrl_rtskid]
	cmp	r6, #0
	beq	.end_check_rcvtsk_exist_tsnd_mbf

	mov	r7, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r4, r6, r7
	add	r4, r4, r5

	ldr	r5, [r4, #pv4_ctcb_stack]
	ldmfd	r5!, {r8}

	mov	r0, r2
	mov	r12, r8

.loop_01_copy_msg_tsnd_mbf:
	ldrb	r7, [r1, #0]
	add	r1, r1, #1
	strb	r7, [r8,  #0]
	add	r8, r8, #1
	subs	r2, r2, #1

	bne	.loop_01_copy_msg_tsnd_mbf

	mul	r3, r6, r7
	add	r3, r3, r5
	mov	r11, #0
	ldr	r8,  [r3, #u4_ctcb_next]
	ldr	r9,  [r3, #u4_ctcb_prev]
	ldrb	r1,  [r3, #u1_ctcb_pri]
	str	r11, [r3, #u4_ctcb_next]
	str	r11, [r3, #u4_ctcb_prev]

	cmp	r6, r8
	beq	.reload_que_top_01_tsnd_mbf

	mul	r10, r8, r7
	add	r10, r10, r5
	str	r9, [r10, #u4_ctcb_prev]
	mul	r7, r9, r7
	add	r7, r7, r5
	str	r8, [r7, #u4_ctcb_next]

	mov	r11, r8

.reload_que_top_01_tsnd_mbf:
	str	r11, [r4, #u4_mbfctrl_rtskid]

	ldr	r2, =__start_sbt
	ldrb	r3, [r2, #u1_sbt_highest_ctsk]
	cmp	r1, r3
	bge	.regist_rdyque_tsnd_mbf

	ldrb	r3, [r2, #u1_sbt_sch_ena]
	strb	r1, [r2, #u1_sbt_highest_ctsk]
	and	r3, r3, #~SBT_sch_ena_ENA
	strb	r3, [r2, #u1_sbt_sch_ena]

.regist_rdyque_tsnd_mbf:
	mov	r4, r0

	bl	__regist_readyqueue

	bl	__del_timque

	mov	r0, r4
	mov	r1, r12

	b	__ServiceCallExit

.end_check_rcvtsk_exist_tsnd_mbf:
	cmp	r3, #0
	beq	.err_e_tmout_tsnd_mbf

	mov	r7, #SIZE_ctcb
	ldr	r8, =__start_ctcb
	ldr	r11, =__start_sbt
	ldrh	r11, [r11, #u2_sbt_runctsk]

	mul	r9, r11, r7
	add	r9, r9, r8

	mov	r4, r3
	ldrb	r1, [r9, #u1_ctcb_pri]
	mov	r6, r11

	bl	__delete_readyqueue

	mov	r5, #SIZE_mbfinf
	ldr	r6, =__start_mbfinf
	mul	r5, r0, r5
	add	r5, r5, r6

	mov	r7, #SIZE_ctcb
	ldr	r8, =__start_ctcb
	ldr	r11, =__start_sbt
	ldrh	r11, [r11, #u2_sbt_runctsk]

	mul	r9, r11, r7
	add	r9, r9, r8

	ldrb	r6, [r5, #u1_mbfinf_mbfatr]
	ands	r6, r6, #TA_TPRI
	bne	.start_wait_pre_que_tsnd_mbf

	ldrh	r6, [r4, #u4_mbfctrl_stskid]

	cmp	r6, #0
	bne	.reload_que_top_tsnd_mbf

	mul	r10, r6, r7
	add	r10, r10, r8

	str	r6,  [r9,  #u4_ctcb_next]
	ldr	r12, [r10, #u4_ctcb_prev]
	str	r11, [r10, #u4_ctcb_prev]
	str	r12, [r9,  #u4_ctcb_prev]

	mul	r7, r12, r7
	add	r7, r7, r8

	str	r11, [r7, #u4_ctcb_next]

	b	.end_reload_que_top_tsnd_mbf

.reload_que_top_tsnd_mbf:
	str	r11, [r4, #u4_mbfctrl_stskid]
	str	r11, [r9, #u4_ctcb_prev]
	str	r11, [r9, #u4_ctcb_next]

.end_reload_que_top_tsnd_mbf:
	cmp	r4, #-1
	beq	.end_reg_timque_tsnd_mbf

	ldr	r3, =__start_timerque_head
	ldr	r0, [r3, #u4_timerque_head]

	mov	r5, #0xffff
	lsr	r8, r6, #16
	and	r8, r8, r5

	cmp	r0, #0
	bne	.end_reload_quehead_tsnd_mbf

	mov	r7, #SIZE_ctcb
	ldr	r9, =__start_ctcb
	mul	r7, r8, r7
	add	r7, r7, r9

	str	r6, [r3, #u4_timerque_head]
	str	r6, [r7, #u4_ctcb_tprev]
	str	r6, [r7, #u4_ctcb_tnext]

	b	.end_reg_timque_tsnd_mbf

.end_reload_quehead_tsnd_mbf:
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
	str	r4, [r7, #u4_ctcb_waitick]

.end_reg_timque_tsnd_mbf:
	ldr	r2, =__start_sbt
	ldrb	r5, [r2, #u1_sbt_sch_ena]
	and	r5, r5, #~SBT_sch_ena_ENA
	strb	r5, [r2, #u1_sbt_sch_ena]
	ldrb	r4, [r2, #u1_sbt_highest_ctsk]
	ldrb	r6, [r7, #u1_ctcb_pri]
	cmp	r4, r6
	bne	.end_reload_highpri_tsnd_mbf

	mov	r6, #0
	strb	r6, [r2, #u1_sbt_highest_ctsk]

.end_reload_highpri_tsnd_mbf:
	mov	r1, #0
	str	r1, [r7, #u4_ctcb_rtnprm]

	b	__ServiceCallExit

.start_wait_pre_que_tsnd_mbf:
	add	r6, r3, #u4_mbfctrl_stskid
	bl	__que_search

	ldr	r2, =__start_sbt
	ldrh	r11, [r2, #u2_sbt_runctsk]

	mov	r6, #SIZE_ctcb
	ldr	r7, =__start_ctcb
	mul	r9, r11, r6
	add	r9, r9, r7

	b	.end_reload_que_top_tsnd_mbf

.err_e_id_tsnd_mbf:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_tsnd_mbf:
	mov	r0, #E_PAR
	b	__ServiceCallExit

.err_e_tmout_tsnd_mbf:
	mov	r0, #E_TMOUT
	b	__ServiceCallExit


@
@	_rcv_mbf
@
@	Argument
@
	.globl	rcv_mbf
rcv_mbf:
	mov	r2, #-1
	mov	r4, sp
	svc	#SST_rcv_mbf
	bx	lr


@
@	_prcv_mbf
@
@	Argument
@
	.globl	prcv_mbf
prcv_mbf:
	mov	r2, #0
	mov	r4, sp
	svc	#SST_prcv_mbf
	bx	lr


@
@	_trcv_mbf
@
@	Argument
@
	.globl	trcv_mbf
trcv_mbf:
	mov	r4, sp
	svc	#SST_trcv_mbf
	bx	lr


@
@	_ssf_trcv_mbf
@
@	Argument
@
	.globl	_ssf_trcv_mbf
_ssf_trcv_mbf:
	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_id_trcv_mbf

	ldr	r4, =__start_sit
	ldrb	r4, [r4, #u1_sit_mbfnum]

	cmp	r0, r4
	bgt	.err_e_id_trcv_mbf

	cmp	r1, #0
	beq	.err_e_par_trcv_mbf

	cmp	r2, #-2
	ble	.err_e_par_trcv_mbf

	mov	r4, #SIZE_mbfctrl
	ldr	r5, =__start_mbfctrl
	mul	r4, r0, r4
	add	r4, r4, r5

	mov	r5, #SIZE_mbfinf
	ldr	r6, =__start_mbfinf
	mul	r5, r0, r5
	add	r5, r5, r6

	ldr	r6, [r4, #u4_mbfctrl_smsgcnt]
	cmp	r6, #0
	bne	.start_rcv_msg_trcv_mbf

	ldr	r6, [r4, #u4_mbfctrl_stskid]
	cmp	r6, #0
	bne	.start_wait_ope_trcv_mbf

	mov	r7, #SIZE_ctcb
	ldr	r8, =__start_ctcb
	mul	r9, r6, r7
	add	r9, r9, r8

	ldr	r12, [r9, #pv4_ctcb_stack]

	ldr	r11, [r10, #4]
	ldr	r10, [r10, #0]

	mov	r0, r10

.loop_01_copy_msg_trcv_mbf:
	ldrb	r7, [r11, #0]
	add	r11, r11, #1
	strb	r7, [r1,  #0]
	add	r1, r1, #1
	subs	r12, r12, #1

	bne	.loop_01_copy_msg_trcv_mbf

	mov	r7, #SIZE_ctcb
	ldr	r5, =__start_ctcb

	mul	r0, r6, r7
	add	r0, r0, r5
	mov	r11, #0
	ldr	r8,  [r0, #u4_ctcb_next]
	ldr	r9,  [r0, #u4_ctcb_prev]
	ldrb	r1,  [r0, #u1_ctcb_pri]
	str	r11, [r0, #u4_ctcb_next]
	str	r11, [r0, #u4_ctcb_prev]

	cmp	r6, r8
	beq	.reload_que_top_01_trcv_mbf

	mul	r10, r8, r7
	add	r10, r10, r5
	str	r9, [r10, #u4_ctcb_prev]
	mul	r7, r9, r7
	add	r7, r7, r5
	str	r8, [r7, #u4_ctcb_next]

	mov	r11, r8

.reload_que_top_01_trcv_mbf:
	str	r11, [r4, #u4_mbfctrl_stskid]

	ldr	r2, =__start_sbt
	ldrb	r3, [r2, #u1_sbt_highest_ctsk]
	cmp	r1, r3
	bge	.regist_rdyque_trcv_mbf

	ldrb	r3, [r2, #u1_sbt_sch_ena]
	strb	r1, [r2, #u1_sbt_highest_ctsk]
	and	r3, r3, #~SBT_sch_ena_ENA
	strb	r3, [r2, #u1_sbt_sch_ena]

.regist_rdyque_trcv_mbf:
	bl	__regist_readyqueue

	bl	__del_timque

	b	__ServiceCallExit

.start_wait_ope_trcv_mbf:
	cmp	r2, #0
	beq	.err_e_tmout_trcv_mbf

	mov	r7, #SIZE_ctcb
	ldr	r8, =__start_ctcb
	ldr	r11, =__start_sbt
	ldrh	r11, [r11, #u2_sbt_runctsk]

	mul	r9, r11, r7
	add	r9, r9, r8

	mov	r7, r1
	mov	r4, r2
	ldrb	r1, [r9, #u1_ctcb_pri]
	mov	r6, r11

	bl	__delete_readyqueue

	mov	r2, r4

	mov	r7, #SIZE_ctcb
	ldr	r8, =__start_ctcb
	ldr	r11, =__start_sbt
	ldrh	r11, [r11, #u2_sbt_runctsk]

	mul	r9, r11, r7
	add	r9, r9, r8

	mov	r5, #SIZE_mbfinf
	ldr	r6, =__start_mbfinf
	mul	r5, r0, r5
	add	r5, r5, r6

	mov	r4, #SIZE_mbfctrl
	ldr	r5, =__start_mbfctrl
	mul	r4, r0, r4
	add	r4, r4, r5

	ldrb	r6, [r5, #u1_mbfinf_mbfatr]
	ands	r6, r6, #TA_TPRI
	bne	.start_wait_pre_que_trcv_mbf

	ldrh	r6, [r4, #u4_mbfctrl_rtskid]

	cmp	r6, #0
	bne	.reload_que_top_02_trcv_mbf

	mul	r10, r6, r7
	add	r10, r10, r8

	str	r6,  [r9,  #u4_ctcb_next]
	ldr	r12, [r10, #u4_ctcb_prev]
	str	r11, [r10, #u4_ctcb_prev]
	str	r12, [r9,  #u4_ctcb_prev]

	mul	r7, r12, r7
	add	r7, r7, r8

	str	r11, [r7, #u4_ctcb_next]

	b	.end_reload_que_top_trcv_mbf

.reload_que_top_02_trcv_mbf:
	str	r11, [r4, #u4_mbfctrl_rtskid]
	str	r11, [r9, #u4_ctcb_prev]
	str	r11, [r9, #u4_ctcb_next]

.end_reload_que_top_trcv_mbf:
	cmp	r2, #-1
	beq	.end_reg_timque_trcv_mbf

	ldr	r3, =__start_timerque_head
	ldr	r0, [r3, #u4_timerque_head]

	mov	r5, #0xffff
	lsr	r8, r6, #16
	and	r8, r8, r5

	cmp	r0, #0
	bne	.end_reload_quehead_trcv_mbf

	mov	r7, #SIZE_ctcb
	ldr	r9, =__start_ctcb
	mul	r7, r8, r7
	add	r7, r7, r9

	str	r6, [r3, #u4_timerque_head]
	str	r6, [r7, #u4_ctcb_tprev]
	str	r6, [r7, #u4_ctcb_tnext]

	b	.end_reg_timque_trcv_mbf

.end_reload_quehead_trcv_mbf:
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
	str	r2, [r7, #u4_ctcb_waitick]

.end_reg_timque_trcv_mbf:
	ldr	r2, =__start_sbt
	ldrb	r5, [r2, #u1_sbt_sch_ena]
	and	r5, r5, #~SBT_sch_ena_ENA
	strb	r5, [r2, #u1_sbt_sch_ena]
	ldrb	r4, [r2, #u1_sbt_highest_ctsk]
	ldrb	r6, [r7, #u1_ctcb_pri]
	cmp	r4, r6
	bne	.end_reload_highpri_trcv_mbf

	mov	r6, #0
	strb	r6, [r2, #u1_sbt_highest_ctsk]

.end_reload_highpri_trcv_mbf:
	mov	r1, #0
	str	r1, [r7, #u4_ctcb_rtnprm]

	b	__ServiceCallExit

.start_wait_pre_que_trcv_mbf:
	add	r6, r3, #u4_mbfctrl_stskid
	bl	__que_search

	ldr	r2, =__start_sbt
	ldrh	r11, [r2, #u2_sbt_runctsk]

	mov	r6, #SIZE_ctcb
	ldr	r7, =__start_ctcb
	mul	r9, r11, r6
	add	r9, r9, r7

	b	.end_reload_que_top_trcv_mbf

.start_rcv_msg_trcv_mbf:
	ldr	r7,  [r4, #u4_mbfctrl_rcvaddr]
	ldr	r9,  [r5, #pv4_mbfinf_mbf]
	ldr	r10, [r5, #u4_mbfinf_mbfsz]
	sub	r9, r9, #1
	add	r9, r9, r10

	ldr	r8, [r7, #0]

	sub	r0, r8, #4

	ldr	r10, [r4, #u4_mbfctrl_fmbfsz]
	add	r10, r10, r8
	str	r10, [r4, #u4_mbfctrl_fmbfsz]

	add	r7, r7, #4
	cmp	r7, r9
	blt	.loop_02_copy_msg_trcv_mbf

	ldr	r7, [r5, #pv4_mbfinf_mbf]

.loop_02_copy_msg_trcv_mbf:
	ldrb	r10, [r7, #0]
	strb	r10, [r1, #0]
	add	r1, r1, #1
	add	r7, r7, #1

	cmp	r7, r9
	blt	.end_reload_mbf_addr_trcv_mbf

	ldr	r7, [r5, #pv4_mbfinf_mbf]

.end_reload_mbf_addr_trcv_mbf:
	subs	r8, r8, #1
	bne	.loop_02_copy_msg_trcv_mbf

	sub	r6, r6, #1
	str	r6, [r4, #u4_mbfctrl_smsgcnt]

	b	__ServiceCallExit

.err_e_id_trcv_mbf:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_trcv_mbf:
	mov	r0, #E_PAR
	b	__ServiceCallExit

.err_e_tmout_trcv_mbf:
	mov	r0, #E_TMOUT
	b	__ServiceCallExit


@
@	_ref_mbf
@
@	Argument
@
	.globl	ref_mbf
ref_mbf:
	mov	r4, sp
	svc	#SST_ref_mbf
	bx	lr


@
@	_ssf_ref_mbf
@
@	Argument
@
	.globl	_ssf_ref_mbf
_ssf_ref_mbf:
	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_id_ref_mbf

	ldr	r4, =__start_sit
	ldrb	r4, [r4, #u1_sit_mbfnum]

	cmp	r0, r4
	bgt	.err_e_id_ref_mbf

	cmp	r1, #0
	beq	.err_e_par_ref_mbf

	mov	r4, #SIZE_mbfctrl
	ldr	r5, =__start_mbfctrl
	mul	r4, r0, r4
	add	r4, r4, r5
	ldr	r6, [r4, #u4_mbfctrl_stskid]
	ldr	r7, [r4, #u4_mbfctrl_rtskid]
	ldr	r8, [r4, #u4_mbfctrl_smsgcnt]
	ldr	r9, [r4, #u4_mbfctrl_fmbfsz]

	str	r6, [r1, #u4_rmbf_stskid]
	str	r7, [r1, #u4_rmbf_rtskid]
	str	r8, [r1, #u4_rmbf_smsgcnt]
	str	r9, [r1, #u4_rmbf_fmbfsz]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_ref_mbf:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_ref_mbf:
	mov	r0, #E_PAR
	b	__ServiceCallExit
