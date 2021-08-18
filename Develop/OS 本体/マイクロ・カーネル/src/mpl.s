@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_sit
	.extern	__start_mplinf
	.extern	__start_mplctrl
	.extern	__ServiceCallExit


@
@	__get_vmempool
@
@	Argument
@	r6 :	memory pool ID
@	r7 :	memory pool size
@
@	Return
@	r0 :	memory pool address
@
	.globl	__get_vmempool
__get_vmempool:
	mov	r8, #SIZE_mplctrl
	ldr	r9, =__start_mplctrl
	mul	r8, r6, r8
	add	r8, r8, r9
	add	r8, r8, #pv4_mplctrl_mpl
	ldr	r9, [r8, #0]

.loop_get_mempool:
	ldr	r10, [r9, #u4_mpl_size]
	cmp	r7, r10
	bgt	.load_next_address_mempool

	add	r0, r9, #SIZE_mplheader
	str	r7, [r9, #u4_mpl_size]

	cmp	r7, r10
	blt	.sub_size_mempool

	ldr	r10, [r9, #u4_mpl_next]
	str	r10, [r8, #u4_mpl_next]

	bx	lr

.sub_size_mempool:
	ldr	r11, [r9,  #u4_mpl_next]
	sub	r6, r10, r7
	add	r10, r9, r7
	str	r10, [r8,  #u4_mpl_next]
	str	r11, [r10, #u4_mpl_next]
	str	r6,  [r10, #u4_mpl_size]

	bx	lr

.load_next_address_mempool:
	mov	r8, r9
	ldr	r9, [r9, #u4_mpl_next]
	cmp	r9, #MPL_TERMINATE
	bne	.loop_get_mempool

	mov	r0, #-1
	bx	lr


@
@	__rel_vmempool
@
@	Argument
@	r6 :	memory pool ID
@	r7 :	memory pool address
@
	.globl	__rel_vmempool
__rel_vmempool:
	mov	r8, #SIZE_mplctrl
	ldr	r9, =__start_mplctrl
	mul	r8, r6, r8
	add	r8, r8, r9
	add	r8, r8, #pv4_mplctrl_mpl
	ldr	r9, [r8, #0]

	sub	r7, r7, #SIZE_mplheader

	ldr	r10, [r9, #u4_mpl_next]

.loop_rel_mempool:
	cmp	r10, #MPL_TERMINATE
	bne	.switch_compare_address_mempool

	str	r7,  [r9, #u4_mpl_next]
	str	r10, [r7, #u4_mpl_next]

	bx	lr

.switch_compare_address_mempool:
	cmp	r7, r10
	bgt	.add_address_size_mempool

	str	r7, [r9, #u4_mpl_next]
	ldr	r6, [r7, #u4_mpl_size]
	add	r8, r7, r6
	cmp	r8, r10
	bne	.island_rel_mempool

	ldr	r8,  [r9, #u4_mpl_size]
	add	r8, r8, #SIZE_mplheader
	add	r6, r6, r8
	str	r6,  [r7, #u4_mpl_size]
	str	r10, [r7, #u4_mpl_next]

	bx	lr

.island_rel_mempool:
	str	r10, [r7, #u4_mpl_next]
	bx	lr

.add_address_size_mempool:
	ldr	r6, [r9, #u4_mpl_size]
	add	r8, r9, r6
	add	r8, r8, #SIZE_mplheader
	cmp	r7, r8
	bne	.next_loop_mempool

	ldr	r5, [r7, #u4_mpl_size]
	ldr	r4, [r9, #u4_mpl_next]
	add	r8, r8, r5
	add	r8, r8, #SIZE_mplheader
	cmp	r4, r8
	bne	.resize_rel_mempool

	ldr	r3, [r4, #u4_mpl_size]
	add	r5, r5, r6
	add	r5, r5, #SIZE_mplheader
	add	r5, r5, r3
	add	r5, r5, #SIZE_mplheader
	ldr	r3, [r4, #u4_mpl_next]

	str	r5, [r9, #u4_mpl_size]
	str	r3, [r9, #u4_mpl_next]

	bx	lr

.resize_rel_mempool:
	add	r6, r6, r5
	add	r6, r6, #SIZE_mplheader
	str	r6, [r9, #u4_mpl_size]

	bx	lr

.next_loop_mempool:
	mov	r9, r10
	ldr	r10, [r9, #u4_mpl_next]
	b	.loop_rel_mempool


@
@	_get_mpl
@
@	Argument
@
	.globl	get_mpl
get_mpl:
	mov	r3, #-1
	mov	r4, sp
	svc	#SST_get_mpl
	bx	lr


@
@	_pget_mpl
@
@	Argument
@
	.globl	pget_mpl
pget_mpl:
	mov	r3, #0
	mov	r4, sp
	svc	#SST_pget_mpl
	bx	lr


@
@	_tget_mpl
@
@	Argument
@
	.globl	tget_mpl
tget_mpl:
	mov	r4, sp
	svc	#SST_tget_mpl
	bx	lr


@
@	_ssf_tget_mpl
@
@	Argument
@
	.globl	_ssf_tget_mpl
_ssf_tget_mpl:
	@ ID のチェック
	ldr	r4, =__start_sit
	ldrb	r4, [r4, #u1_sit_mplnum]

	cmp	r0, r4
	bgt	.err_e_id_tget_mpl

	cmp	r0, #0
	ble	.err_e_id_tget_mpl

	cmp	r1, #0
	beq	.err_e_par_tget_mpl

	cmp	r2, #0
	beq	.err_e_par_tget_mpl

	mov	r6, r0
	mov	r7, r1

	bl	__get_vmempool

	cmp	r0, #-1
	beq	.start_wai_ope_tget_mpl

	str	r0, [r2, #0]

	mov	r0, #E_OK
	b	__ServiceCallExit

.start_wai_ope_tget_mpl:
	cmp	r3, #0
	beq	.err_e_tmout_tget_mpl

	ldr	r9, =__start_sbt
	ldrh	r5, [r9, #u2_sbt_runctsk]


	mov	r9, #SIZE_ctcb
	ldr	r10, =__start_ctcb
	mul	r11, r5, r9
	add	r11, r11, r10

	ldr	r1, [r11, #u1_ctcb_pri]

	mov	r4, r3
	mov	r6, r5

	bl	__delete_readyqueue

	mov	r3, r4

	ldr	r9, =__start_sbt
	ldrh	r5, [r9, #u2_sbt_runctsk]

	mov	r9, #SIZE_ctcb
	ldr	r10, =__start_ctcb
	mul	r11, r5, r9
	add	r11, r11, r10

	ldr	r1, [r11, #u1_ctcb_pri]

	mov	r6, #SIZE_mplctrl
	ldr	r7, =__start_mplctrl
	mul	r6, r0, r6
	add	r6, r6, r7
	ldr	r4, [r6, #u4_mplctrl_wtskid]

	mov	r7, #SIZE_mplinf
	ldr	r8, =__start_mplinf
	mul	r7, r0, r7
	add	r7, r7, r8

	ldr	r7, [r7, #u1_mplinf_mplatr]
	cmp	r7, #TA_TPRI
	beq	.call_que_search_tget_mpl


	cmp	r4, #0
	beq	.reload_que_top_tget_mpl

	mul	r7, r4, r9
	add	r7, r7, r10

	str	r4, [r11, #u4_ctcb_next]
	ldr	r8, [r7,  #u4_ctcb_prev]
	str	r5, [r7,  #u4_ctcb_prev]
	str	r8, [r11, #u4_ctcb_prev]

	mul	r9, r8, r9
	add	r9, r9, r10

	str	r5, [r9, #u4_ctcb_next]

	b	.end_reload_que_top_tget_mpl

.reload_que_top_tget_mpl:
	str	r5, [r6,  #u4_semctrl_wtskid]
	str	r5, [r11, #u4_ctcb_prev]
	str	r5, [r11, #u4_ctcb_next]

.end_reload_que_top_tget_mpl:
	cmp	r3, #-1
	beq	.end_reg_timque_tget_mpl

	mov	r5, #0xffff
	lsr	r8, r6, #16
	and	r8, r8, r5

	mov	r10, #SIZE_ctcb
	ldr	r9, =__start_ctcb
	mul	r10, r8, r10
	add	r10, r10, r9

	ldr	r4, =__start_timerque_head
	ldr	r0, [r4, #u4_timerque_head]

	cmp	r0, #0
	bne	.end_reload_quehead_tget_mpl

	str	r6, [r4, #u4_timerque_head]
	str	r6, [r10, #u4_ctcb_tprev]
	str	r6, [r10, #u4_ctcb_tnext]

	b	.end_reg_timque_tget_mpl

.end_reload_quehead_tget_mpl:
	mov	r5, #0xffff
	lsr	r8, r0, #16
	and	r8, r8, r5

	ldr	r4, =__start_ctcb
	mov	r9, #SIZE_ctcb
	mul	r1, r8, r9
	add	r1, r1, r4

	ldr	r8, [r1, #u4_ctcb_tprev]
	str	r6, [r1, #u4_ctcb_tprev]

	str	r8, [r10, #u4_ctcb_tprev]
	str	r0, [r10, #u4_ctcb_tnext]

	lsr	r8, r8, #16
	and	r8, r8, r5
	mul	r1, r8, r9
	add	r1, r1, r4

	str	r6, [r1, #u4_ctcb_tnext]
	str	r3, [r10, #u4_ctcb_waitick]

.end_reg_timque_tget_mpl:
	ldrb	r5, [r2, #u1_sbt_sch_ena]
	and	r5, r5, #~SBT_sch_ena_ENA
	strb	r5, [r2, #u1_sbt_sch_ena]
	ldrb	r4, [r2, #u1_sbt_highest_ctsk]
	ldrb	r6, [r10, #u1_ctcb_pri]
	cmp	r4, r6
	bne	.end_reload_highpri_tget_mpl

	mov	r6, #0
	strb	r6, [r2, #u1_sbt_highest_ctsk]

.end_reload_highpri_tget_mpl:
	mov	r1, #0
	str	r1, [r10, #u4_ctcb_rtnprm]

	b	__ServiceCallExit

.call_que_search_tget_mpl:
	mov	r1, r3
	add	r6, r6, #u4_mplctrl_wtskid

	bl	__que_search

	mov	r3, r1
	sub	r6, r6, #u4_mplctrl_wtskid

	b	.end_reload_que_top_tget_mpl

.err_e_id_tget_mpl:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_tget_mpl:
	mov	r0, #E_PAR
	b	__ServiceCallExit

.err_e_tmout_tget_mpl:
	mov	r0, #E_TMOUT
	b	__ServiceCallExit


@
@	_rel_mpl
@
@	Argument
@
	.globl	rel_mpl
rel_mpl:
	mov	r4, sp
	svc	#SST_rel_mpl
	bx	lr


@
@	_ssf_rel_mpl
@
@	Argument
@
	.globl	_ssf_rel_mpl
_ssf_rel_mpl:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_mplnum]

	cmp	r0, r3
	bgt	.err_e_id_rel_mpl

	cmp	r0, #0
	ble	.err_e_id_rel_mpl

	cmp	r1, #0
	beq	.err_e_par_rel_mpl

	mov	r6, r0
	mov	r7, r1

	bl	__rel_vmempool

	mov	r8, #SIZE_mplctrl
	ldr	r9, =__start_mplctrl
	mul	r8, r0, r8
	add	r8, r8, r9

	ldr	r4, [r8, #u4_mplctrl_wtskid]
	cmp	r4, #0
	bne	.get_mpl_rel_mpl

	mov	r0, #E_OK
	b	__ServiceCallExit

.get_mpl_rel_mpl:
	mov	r3, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r3, r4, r3
	add	r3, r3, r5
	ldr	r5, [r3, #pv4_ctcb_stack]
	ldmfd	r5!, {r1-r2}
	mov	r6, r0
	mov	r7, r1

	bl	__get_vmempool

	cmp	r0, #-1
	bne	.wakeup_task_rel_mpl

	stmfd	r5!, {r1-r2}

	mov	r0, #E_OK
	b	__ServiceCallExit

.wakeup_task_rel_mpl:
	str	r0, [r1, #0]
	stmfd	r5!, {r1-r2}

	mov	r6, r4

	bl	__del_waique

	mov	r6, r4

	bl	__regist_readyqueue

	mov	r6, r4

	bl	__del_timque

	mov	r3, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r3, r4, r3
	add	r3, r3, r5

	mov	r0, #E_OK
	str	r0, [r3, #u4_ctcb_rtnprm]

	b	__ServiceCallExit

.err_e_id_rel_mpl:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_rel_mpl:
	mov	r0, #E_ID
	b	__ServiceCallExit


@
@	_ref_mpl
@
@	Argument
@
	.globl	ref_mpl
ref_mpl:
	mov	r4, sp
	svc	#SST_ref_mpl
	bx	lr


@
@	_ssf_ref_mpl
@
@	Argument
@
	.globl	_ssf_ref_mpl
_ssf_ref_mpl:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_mplnum]

	cmp	r0, r3
	bgt	.err_e_id_ref_mpl

	cmp	r0, #0
	ble	.err_e_id_ref_mpl

	cmp	r1, #0
	beq	.err_e_par_ref_mpl

	mov	r3, #SIZE_mplctrl
	ldr	r4, =__start_mplctrl
	mul	r3, r0, r3
	add	r3, r3, r4

	ldr	r4, [r3, #pv4_mplctrl_mpl]
	ldr	r5, [r4, #u4_mpl_next]
	ldr	r6, [r4, #u4_mpl_size]
	mov	r7, r6

.loop_ref_mpl:
	cmp	r5, #MPL_TERMINATE
	beq	.err_e_ok_ref_mpl

	ldr	r9, [r5, #u4_mpl_size]
	add	r7, r7, r9
	cmp	r6, r9
	bge	.end_size_check_ref_mpl

	mov	r6, r9

.end_size_check_ref_mpl:
	ldr	r5, [r5, #u4_mpl_next]
	b	.loop_ref_mpl

.err_e_ok_ref_mpl:
	ldr	r8, [r3, #u4_mplctrl_wtskid]
	str	r7, [r0, #u4_rmpl_fmplsz]
	str	r6, [r0, #u4_rmpl_fblksz]
	str	r8, [r0, #u4_rmpl_wtskid]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_ref_mpl:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_ref_mpl:
	mov	r0, #E_PAR
	b	__ServiceCallExit
