.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_ctib
	.extern	__start_ctcb
	.extern	__start_seminf
	.extern	__start_mib
	.extern	__start_mcb
	.extern	__start_mbfinf
	.extern	__start_mbfctrl
	.extern	__start_mpfinf
	.extern	__start_mpfctrl
	.extern	__start_mplinf
	.extern	__start_mplctrl
	.extern	__start_rdyque_head

@
@	__regist_readyqueue
@
@	Argument
@	r1:	Task Priority
@	r6:	Task ID
@
	.globl	__regist_readyqueue
__regist_readyqueue:
	ldr	r0, [r2, #u4_sbt_cprimap]
	sub	r1, r1, #1
	mov	r10, #0x80000000
	lsr	r10, r10, r1

	orr	r0, r0, r10

	str	r0, [r2, #u4_sbt_cprimap]

	add	r1, r1, #1

	lsl	r10, r1, #2
	ldr	r8, =__start_rdyque_head
	add	r8, r8, r10

	ldr	r1,  [r8, #0]

	ands	r10, r6, #ID_kind_task
	bne	.end_id_shape

	lsl	r6, r6, #16
	orr	r6, r6, #ID_kind_task
	orr	r6, r6, #Core_ID

.end_id_shape:
	cmp	r1, #0
	bne	.update_link

	str	r6, [r8, #0]
	mov	r1, r6

.update_link:
	@	キュー・トップのprev をロード
	mov	r8, #0xffff
	lsr	r10, r1, #16
	and	r10, r10, r8
	mov	r8, #SIZE_ctcb
	mul	r8, r10, r8
	ldr	r10, =__start_ctcb
	add	r8, r8, r10

	ldr	r0, [r8, #u4_ctcb_prev]
	str	r6, [r8, #u4_ctcb_prev]

	@	キュー・トップのprev のnext を変更
	mov	r8, #0xffff
	lsr	r10, r0, #16
	and	r10, r10, r8
	mov	r8, #SIZE_ctcb
	mul	r8, r10, r8
	ldr	r10, =__start_ctcb
	add	r8, r8, r10

	str	r6, [r8, #u4_ctcb_next]

	mov	r10, #0xffff
	lsr	r6, r6, #16
	and	r6, r6, r10

	mov	r8, #SIZE_ctcb
	mul	r8, r6, r8
	ldr	r10, =__start_ctcb
	add	r8, r8, r10

	str	r1, [r8, #u4_ctcb_next]
	str	r0, [r8, #u4_ctcb_prev]

	bx	lr


@
@	__delete_readyqueue
@
@	Argument
@	r1:	Task Priority
@	r6:	Task ID
@
	.globl	__delete_readyqueue
__delete_readyqueue:
	ldr	r3, [r2, #u4_sbt_cprimap]
	sub	r1, #1
	mov	r10, #0x80000000
	lsr	r10, r10, r1

	mvn	r10, r10
	and	r3, r3, r10

	add	r1, #1

	lsl	r10, r1, #2
	ldr	r8, =__start_rdyque_head
	add	r8, r8, r10

@	mov	r9, #0xffff
@	lsr	r6, #16
@	and	r6, r6, r9

	ldr	r9, =__start_ctcb
	mov	r5, #SIZE_ctcb
	mul	r10, r6, r5
	add	r10, r10, r9

	ands	r5, r6, #ID_kind_task
	bne	.end_id_shape_delrdyque

	lsl	r6, r6, #16
	orr	r6, r6, #ID_kind_task
	orr	r6, r6, #Core_ID

.end_id_shape_delrdyque:
	ldr	r12, [r10, #u4_ctcb_prev]
	ldr	r11, [r10, #u4_ctcb_next]

	str	r6, [r10, #u4_ctcb_prev]
	str	r6, [r10, #u4_ctcb_next]

	mov	r10, r12
	mov	r5, #0xffff
	lsr	r10, r10, #16
	and	r10, r10, r5

	mov	r5, #SIZE_ctcb
	mul	r10, r10, r5
	add	r10, r10, r9

	str	r11, [r10, #u4_ctcb_next]

	mov	r5, #0xffff
	mov	r10, r11
	lsr	r10, r10, #16
	and	r10, r10, r5

	str	r12, [r10, #u4_ctcb_prev]

	ldr	r9,  [r8, #0]

	cmp	r6, r9
	bne	.end_que_top_delrdyque

	cmp	r6, r11
	bne	.reload_quetop_delrdyque

	mov	r9, #0
	str	r9, [r8, #0]
	str	r3, [r2, #u4_sbt_cprimap]
	strb	r9, [r2, #u1_sbt_highest_ctsk]

.end_que_top_delrdyque:
	bx	lr

.reload_quetop_delrdyque:
	str	r11, [r8, #0]
	bx	lr


@
@	_act_tsk
@
@	Argument
@
	.globl	act_tsk
act_tsk:
	mov	r4, sp
	svc	#SST_act_tsk
	bx	lr


@
@	_ssf_act_tsk
@
@	Argument
@
	.globl	_ssf_act_tsk
_ssf_act_tsk:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_ctsknum]

	cmp	r0, r1
	bgt	.err_e_id_act_tsk

	cmp	r0, #0
	blt	.err_e_id_act_tsk
	bne	.end_load_tskid_act_tsk

	ldrh	r0, [r2, #u2_sbt_runctsk]

.end_load_tskid_act_tsk:
	ldr	r1, =__start_ctcb
	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r3, r3, r1
	ldrb	r4, [r3, #u1_ctcb_actcnt]
	ldrb	r1, [r3, #u1_ctcb_sts]

	ands	r5, r1, #CTCB_sts_dormant
	bne	.end_inc_actcnt_act_tsk

	add	r4, #1
	cmp	r4, #255
	bgt	.err_e_qovr_act_tsk

	strb	r4, [r3, #u1_ctcb_actcnt]

.end_inc_actcnt_act_tsk:
	cmp	r4, #0
	bne	.end_reg_que_act_tsk

	ldr	r4, =__start_ctib
	mov	r5, #SIZE_ctib
	mul	r5, r0, r5
	add	r5, r5, r4
	and	r1, r1, #~CTCB_sts_dormant
	orr	r1, r1, #CTCB_sts_ready
	strb	r1, [r3, #u1_ctcb_sts]
	ldrb	r4, [r5, #u1_ctib_ipri]

	mov	r6, r0
	mov	r1, r4
	bl	__regist_readyqueue

.end_reg_que_act_tsk:
	ldrb	r5, [r2, #u1_sbt_sch_ena]
	ldrb	r1, [r2, #u1_sbt_highest_ctsk]
	orr	r5, r5, #SBT_sch_ena_ENA
	cmp	r4, r1
	bge	.end_reload_highest_act_tsk

	strb	r4, [r2, #u1_sbt_highest_ctsk]
	and	r5, r5, #~SBT_sch_ena_ENA

.end_reload_highest_act_tsk:
	strb	r5, [r2, #u1_sbt_sch_ena]
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_act_tsk:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_qovr_act_tsk:
	mov	r0, #E_QOVR
	b	__ServiceCallExit


@
@	_can_act
@
@	Argument
@
	.globl	can_act
can_act:
	mov	r4, sp
	svc	#SST_can_act
	bx	lr


@
@	_ssf_can_act
@
@	Argument
@
	.globl	_ssf_can_act
_ssf_can_act:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_ctsknum]

	cmp	r0, r1
	bgt	.err_e_id_can_act
	cmp	r0, #0
	blt	.err_e_id_can_act
	bne	.end_load_tskid_can_act

	ldrh	r0, [r2, #u2_sbt_runctsk]

.end_load_tskid_can_act:
	ldr	r1, =__start_ctcb
	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r3, r3, r1
	ldrb	r0, [r3, #u1_ctcb_actcnt]

	mov	r1, #0
	strb	r1, [r3, #u1_ctcb_actcnt]

	b	__ServiceCallExit

.err_e_id_can_act:
	mov	r0, #E_ID
	b	__ServiceCallExit


@
@	_sta_tsk
@
@	Argument
@
	.globl	sta_tsk
sta_tsk:
	mov	r4, sp
	svc	#SST_sta_tsk
	bx	lr


@
@	_ssf_sta_tsk
@
@	Argument
@
	.globl	_ssf_sta_tsk
_ssf_sta_tsk:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_ctsknum]

	cmp	r0, r1
	bgt	.err_e_id_sta_tsk
	cmp	r0, #0
	blt	.err_e_id_sta_tsk
	bne	.end_load_tskid_can_act

	ldr	r4, =__start_ctcb
	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r3, r3, r4

	ldrb	r4, [r3, #u1_ctcb_sts]
	ands	r5, r4, #CTCB_sts_dormant
	bne	.err_e_obj_sta_tsk

	and	r4, r4, #~CTCB_sts_dormant
	orr	r4, r4, #(CTCB_sts_ready | CTCB_sts_statsk)
	strb	r4, [r3, #u1_ctcb_sts]
	str	r1, [r3, #s4_ctcb_stacd]

	ldr	r4, =__start_ctib
	mov	r5, #SIZE_ctib
	mul	r5, r0, r5
	add	r5, r5, r4
	ldrb	r4, [r5, #u1_ctib_ipri]

	mov	r6, r0
	mov	r1, r4
	bl	__regist_readyqueue

	ldrb	r5, [r2, #u1_sbt_sch_ena]
	ldrb	r1, [r2, #u1_sbt_highest_ctsk]
	orr	r5, r5, #SBT_sch_ena_ENA
	cmp	r4, r1
	bge	.end_reload_highest_sta_tsk

	strb	r4, [r2, #u1_sbt_highest_ctsk]
	and	r5, r5, #~SBT_sch_ena_ENA

.end_reload_highest_sta_tsk:
	strb	r5, [r2, #u1_sbt_sch_ena]
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_sta_tsk:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_obj_sta_tsk:
	mov	r0, #E_OBJ
	b	__ServiceCallExit


@
@	_chg_pri
@
@	Argument
@
	.globl	chg_pri
chg_pri:
	mov	r4, sp
	svc	#SST_chg_pri
	bx	lr


@
@	_ssf_chg_pri
@
@	Argument
@
	.globl	_ssf_chg_pri
_ssf_chg_pri:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_ctsknum]

	cmp	r0, r3
	bgt	.err_e_id_chg_pri

	cmp	r0, #0
	blt	.err_e_id_chg_pri
	bne	.end_load_tskid_chg_pri

	ldrh	r0, [r2, #u2_sbt_runctsk]

.end_load_tskid_chg_pri:
	@ tskpri のチェック
	cmp	r1, #255
	bgt	.err_e_par_chg_pri

	cmp	r1, #0
	blt	.err_e_par_chg_pri
	bne	.end_load_tskpri_chg_pri

	bl	_ssf_ChangePriority

.err_e_ok_chg_pri:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_chg_pri:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_chg_pri:
	mov	r0, #E_PAR
	b	__ServiceCallExit

.err_e_obj_chg_pri:
	mov	r0, #E_OBJ
	b	__ServiceCallExit

.err_e_iluse_chg_pri:
	mov	r0, #E_ILUSE
	b	__ServiceCallExit


@
@	_ssf_ChangePriority
@
@	Argument
@	r0	:	Task ID
@	r1	:	Task Priority (Change)
@
	.globl	_ssf_ChangePriority
_ssf_ChangePriority:
	ldr	r4, =__start_ctib
	mov	r5, #SIZE_ctib
	mul	r5, r0, r5
	add	r5, r5, r4
	ldrb	r1, [r5, #u1_ctib_ipri]

.end_load_tskpri_chg_pri:
	ldr	r4, =__start_ctcb
	mov	r3, #SIZE_ctcb
	mul	r3, r0, r3
	add	r3, r3, r4

	ldrb	r4, [r3, #u1_ctcb_sts]
	ands	r4, r4, #CTCB_sts_dormant
	bne	.err_e_obj_chg_pri

	ldr	r4, [r3, #u4_ctcb_mtxid]
	cmp	r4, #0
	beq	.end_mtx_check_chg_pri

	ldr	r7, =__start_mib
	mov	r8, #SIZE_mib
	mul	r8, r4, r8
	add	r8, r8, r7
	ldrh	r7, [r8, #u2_mib_mtxatr]
	ands	r7, r7, #TA_CEILING
	beq	.end_mtx_check_chg_pri

	ldrh	r7, [r8, #u2_mib_ceilpri]
	cmp	r1, r7
	bgt	.err_e_iluse_chg_pri

.end_mtx_check_chg_pri:
	mov	r6, r0
	ldrb	r4, [r3, #u1_ctcb_sts]
	ands	r4, r4, #CTCB_sts_wait
	beq	.delete_readyqueue_chg_pri_2

	ldr	r6, [r3, #u4_ctcb_taskwait]
	and	r4, r6, #(TTW_SLP | TTW_DLY)
	bxne	lr

	ldr	r9, [r3, #u4_ctcb_wobjid]
	mov	r8, #0xffff
	lsr	r9, #16
	and	r9, r9, r8

	ands	r4, r6, #TTW_SEM
	bne	.find_sem_chg_pri

	ands	r4, r6, #TTW_MTX
	bne	.find_mtx_chg_pri

	ands	r4, r6, #(TTW_SMBF | TTW_RMBF)
	bne	.find_mbf_chg_pri

	ands	r4, r6, #TTW_MPF
	bne	.find_mpf_chg_pri

	ands	r4, r6, #TTW_MPL
	bne	.find_mpl_chg_pri

	bx	lr

.start_que_ope_chg_pri:
	ands	r6, r7, #TA_TPRI
	beq	.start_tsk_ope_chg_pri

	ldr	r10, [r3, #u4_ctcb_prev]
	ldr	r11, [r3, #u4_ctcb_next]

	mov	r6, #0xffff
	lsr	r11, #16
	and	r11, r11, r6

	ldr	r6, =__start_ctcb
	mov	r4, #SIZE_ctcb
	mul	r4, r11, r4
	add	r4, r4, r6

	str	r10, [r4, #u4_ctcb_prev]

	ldr	r11, [r3, #u4_ctcb_next]

	mov	r6, #0xffff
	lsr	r10, #16
	and	r10, r10, r6

	ldr	r6, =__start_ctcb
	mov	r4, #SIZE_ctcb
	mul	r4, r10, r4
	add	r4, r4, r6

	str	r11, [r3, #u4_ctcb_next]

	ldr	r10, [r8, #0]
	mov	r7, r10
	cmp	r10, r11
	bne	.end_reload_que_top_chg_pri

	str	r11, [r8, #0]
	mov	r10, r11
	mov	r7, r11

.end_reload_que_top_chg_pri:
	ldr	r11, =__start_ctcb
	mov	r4, #SIZE_ctcb

	mov	r6, #0xffff
	mov	r9, r10
	lsr	r10, #16
	and	r6, r10, r6

	mul	r4, r6, r4
	add	r4, r4, r11

	ldrb	r6, [r4, #u1_ctcb_pri]
	cmp	r1, r6
	blt	.reload_waique_chg_pri

	ldr	r10, [r4, #u4_ctcb_next]
	cmp	r10, r7
	beq	.reload_waique_end_chg_pri

	b	.end_reload_que_top_chg_pri

.reload_waique_chg_pri:
	ldr	r6, [r4, #u4_ctcb_prev]
	str	r0, [r4, #u4_ctcb_prev]
	str	r6, [r3, #u4_ctcb_prev]

	ldr	r11, =__start_ctcb
	mov	r4, #SIZE_ctcb

	mov	r10, #0xffff
	lsr	r6, #16
	and	r6, r6, r10

	mul	r4, r6, r4
	add	r4, r4, r11

	ldr	r6, [r4, #u4_ctcb_next]
	str	r0, [r4, #u4_ctcb_next]
	str	r6, [r3, #u4_ctcb_next]

	cmp	r7, r9
	bne	.start_tsk_ope_chg_pri

	str	r0, [r8, #0]

.start_tsk_ope_chg_pri:
	ldr	r4, [r3, #u4_ctcb_taskwait]
	and	r4, r4, #TTW_MTX
	bxeq	lr

	ldr	r4, [r3, #u4_ctcb_wobjid]
	mov	r5, r4
	mov	r6, #0xffff
	lsr	r4, #16
	and	r4, r4, r6

	ldr	r7, =__start_mib
	mov	r6, #SIZE_mib
	mul	r6, r4, r6
	add	r6, r6, r7

	ldrb	r7, [r6, #u1_rib_atr]
	and	r7, r7, #TA_INHERIT
	bxeq	lr

	ldr	r7, =__start_mcb
	mov	r6, #SIZE_mcb
	mul	r6, r4, r6
	add	r6, r6, r7

	ldr	r7, [r6, #u4_mcb_tskid]
	mov	r6, #0xffff
	lsr	r7, #16
	and	r7, r7, r6

	ldr	r6, =__start_ctib
	mov	r8, #SIZE_ctib
	mul	r8, r7, r8
	add	r8, r8, r6

	ldrb	r6, [r8, #u1_ctcb_pri]
	cmp	r1, r6
	bxge	lr

	ldrb	r6, [r8, #u1_ctcb_sts]
	ands	r6, r6, #CTCB_sts_wait
	mov	r6, r5
	beq	.delete_readyqueue_chg_pri_1

	mov	r3, r8

	ldr	r7, =__start_mib
	mov	r8, #SIZE_mib
	mul	r8, r4, r8
	add	r8, r8, r7
	ldrh	r7, [r8, #u2_mib_mtxatr]

	ldr	r10, =__start_mcb
	mov	r8, #SIZE_mcb
	mul	r8, r4, r8
	add	r8, r8, r10

	b	.start_que_ope_chg_pri

.find_sem_chg_pri:
	ldr	r7, =__start_seminf
	mov	r8, #SIZE_seminf
	mul	r8, r9, r8
	add	r8, r8, r7
	ldrb	r7, [r8, #u1_seminf_atr]

	ldr	r10, =__start_semctrl
	mov	r8, #SIZE_semctrl
	mul	r8, r9, r8
	add	r8, r8, r10

	b	.start_que_ope_chg_pri

.find_mtx_chg_pri:
	ldr	r7, =__start_mib
	mov	r8, #SIZE_mib
	mul	r8, r9, r8
	add	r8, r8, r7
	ldrb	r7, [r8, #u2_mib_mtxatr]

	ldr	r10, =__start_mcb
	mov	r8, #SIZE_mcb
	mul	r8, r9, r8
	add	r8, r8, r10

	b	.start_que_ope_chg_pri

.find_mbf_chg_pri:
	ldr	r7, =__start_mbfinf
	mov	r8, #SIZE_mbfinf
	mul	r8, r9, r8
	add	r8, r8, r7
	ldrb	r7, [r8, #u1_mbfinf_mbfatr]

	ldr	r10, =__start_mbfctrl
	mov	r8, #SIZE_mbfctrl
	mul	r8, r9, r8
	add	r8, r8, r10

	b	.start_que_ope_chg_pri

.find_mpf_chg_pri:
	ldr	r7, =__start_mpfinf
	mov	r8, #SIZE_mpfinf
	mul	r8, r9, r8
	add	r8, r8, r7
	ldrb	r7, [r8, #u1_mpfinf_mpfatr]

	ldr	r10, =__start_mpfctrl
	mov	r8, #SIZE_mpfctrl
	mul	r8, r9, r8
	add	r8, r8, r10

	b	.start_que_ope_chg_pri

.find_mpl_chg_pri:
	ldr	r7, =__start_mplinf
	mov	r8, #SIZE_mplinf
	mul	r8, r9, r8
	add	r8, r8, r7
	ldrb	r7, [r8, #u1_mplinf_mplatr]

	ldr	r10, =__start_mplctrl
	mov	r8, #SIZE_mplctrl
	mul	r8, r9, r8
	add	r8, r8, r10

	b	.start_que_ope_chg_pri

.reload_waique_end_chg_pri:
	ldr	r6, [r4, #u4_ctcb_next]
	str	r0, [r4, #u4_ctcb_next]
	str	r6, [r3, #u4_ctcb_next]

	ldr	r11, =__start_ctcb
	mov	r4, #SIZE_ctcb

	mov	r10, #0xffff
	lsr	r6, #16
	and	r6, r6, r10

	mul	r4, r6, r4
	add	r4, r4, r11

	ldr	r6, [r4, #u4_ctcb_prev]
	str	r0, [r4, #u4_ctcb_prev]
	str	r6, [r3, #u4_ctcb_prev]

	b	.end_reload_que_top_chg_pri

.delete_readyqueue_chg_pri_1:
	ldrb	r3, [r8, #u1_ctcb_pri]
	strb	r1, [r8, #u1_ctcb_pri]
	strb	r1, [r8, #u1_ctcb_bpri]
	ldrb	r5, [r8, #u1_ctcb_sts]
	ands	r5, r5, #(CTCB_sts_run | CTCB_sts_ready)
	beq	.end_rdyque_ope_chg_pri
	mov	r6, r7
	mov	r7, r1
	mov	r1, r3
	bl	__delete_readyqueue
	mov	r1, r7
	mov	r4, r1
	mov	r3, r6
	bl	__regist_readyqueue

.end_rdyque_ope_chg_pri:
	ldr	r5, =__start_ctcb
	mov	r7, #SIZE_ctcb

	mov	r6, #0xffff
	lsr	r3, #16
	and	r3, r3, r6

	mul	r7, r3, r7
	add	r7, r7, r5

	strb	r4, [r7, #u1_ctcb_pri]
	strb	r4, [r7, #u1_ctcb_bpri]

	bx	lr

.delete_readyqueue_chg_pri_2:
	ldrb	r4, [r3, #u1_ctcb_pri]
	strb	r1, [r3, #u1_ctcb_pri]
	strb	r1, [r3, #u1_ctcb_bpri]
	mov	r7, r1
	mov	r1, r4
	bl	__delete_readyqueue
	mov	r1, r7
	bl	__regist_readyqueue
	bx	lr


@
@	_ref_tsk
@
@	Argument
@
	.globl	ref_tsk
ref_tsk:
	mov	r4, sp
	svc	#SST_ref_tsk
	bx	lr


@
@	_ssf_ref_tsk
@
@	Argument
@
	.globl	_ssf_ref_tsk
_ssf_ref_tsk:
	ldr	r2, =__start_sbt
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_ctsknum]

	cmp	r0, r3
	bgt	.err_e_id_ref_tsk

	cmp	r0, #0
	blt	.err_e_id_ref_tsk
	bne	.end_load_tskid_ref_tsk

	ldrh	r0, [r2, #u2_sbt_runctsk]

.end_load_tskid_ref_tsk:
	@ パラメータのチェック
	cmp	r1, #0
	beq	.err_e_par_ref_tsk

	ldr	r3, =__start_ctcb
	mov	r4, #SIZE_ctcb
	mul	r4, r0, r4
	add	r3, r4, r3

	@ タスク状態
	ldrb	r4, [r3, #u1_ctcb_sts]
	and	r4, r4, #CTCB_sts_all
	strb	r4, [r1, #u1_rtsk_tskstat]

	@ 現在優先度/ベース優先度
	ldrb	r4, [r3, #u1_ctcb_pri]
	ldrb	r5, [r3, #u1_ctcb_bpri]
	strh	r4, [r1, #u2_rtsk_tskpri]
	strh	r4, [r1, #u2_rtsk_tskbpri]

	@ 待ち要因
	ldr	r4, [r3, #u4_ctcb_taskwait]
	strh	r4, [r1, #u2_rtsk_tskwait]

	@ 待ちオブジェクトID
	ldr	r4, [r3, #u4_ctcb_wobjid]
	mov	r5, #0xffff
	lsr	r4, #16
	and	r4, r4, r5
	strh	r4, [r1, #u2_rtsk_wobjid]

	@ 待ち時間
	ldr	r4, [r3, #u4_ctcb_waitick]
	str	r4, [r1, #u4_rtsk_lefttmo]

	@ 起動要求数
	ldrb	r4, [r3, #u1_ctcb_actcnt]
	str	r4, [r1, #u4_rtsk_actcnt]

	@ 起床要求数
	ldrb	r4, [r3, #u1_ctcb_slpcnt]
	str	r4, [r1, #u4_rtsk_wupcnt]

	@ 強制待ちネスト数
	ldrb	r4, [r3, #u1_ctcb_suscnt]
	str	r4, [r1, #u4_rtsk_suscnt]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_ref_tsk:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_ref_tsk:
	mov	r0, #E_PAR
	b	__ServiceCallExit
