@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
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
	.extern	__ServiceCallExit
	.extern	__Scheduler


@
@	_SetEvent
@
@	Argument
@
	.globl	SetEvent
SetEvent:
	mov	r4, sp
	svc	#SST_SetEvent
	bx	lr


@
@	_ssf_SetEvent
@
@	Argument
@
	.globl	_ssf_SetEvent
_ssf_SetEvent:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_tsknum]

	cmp	r0, #255
	bgt	.err_e_os_id_SetEvent

	cmp	r0, #0
	ble	.err_e_os_id_SetEvent

	bl	_ssf_Body_SetEvent

	cmp	r0, #-1
	beq	.err_e_os_state_SetEvent

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_SetEvent:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit

.err_e_os_state_SetEvent:
	mov	r0, #E_OS_STATE
	b	__ServiceCallExit


@
@	_ssf_Body_SetEvent
@
@	Argument
@	r0	:	Task ID
@	r1	:	Event Mask
@
	.globl	_ssf_Body_SetEvent
_ssf_Body_SetEvent:
	mov	r3, #SIZE_tcb
	ldr	r4, =__start_tcb
	mul	r3, r0, r3
	add	r3, r3, r4

	ldrb	r4, [r3, #u1_tcb_sts]
	ands	r4, r4, #TCB_sts_all

	beq	.err_e_os_state_Body_SetEvent

	str	r1, [r3, #u4_tcb_event]

	ands	r4, r4, #TCB_sts_waiting
	ldr	r4, [r3, #u4_tcb_waievent]
	beq	.end_to_ready_SetEvent

	ands	r4, r4, r1
	beq	.end_to_ready_SetEvent

	mov	r4, #0
	str	r4, [r3, #u4_tcb_waievent]
	mov	r4, #TCB_sts_ready
	str	r4, [r3, #u1_tcb_sts]

	ldrb	r1, [r3, #u1_tcb_pri]
	mov	r6, r0

	ldrb	r4, [r2, #u1_sbt_highest_tsk]
	cmp	r1, r4
	ble	.end_set_pri_SetEvent

	ldrb	r4, [r2, #u1_sbt_sch_ena]
	strb	r1, [r2, #u1_sbt_highest_tsk]
	and	r4, r4, #~SBT_sch_ena_ENA
	strb	r4, [r2, #u1_sbt_sch_ena]

.end_set_pri_SetEvent:
	bl	__regist_readybuf

.end_to_ready_SetEvent:
	bx	lr

.err_e_os_state_Body_SetEvent:
	mov	r0, #-1
	bx	lr




@
@	_ClearEvent
@
@	Argument
@
	.globl	ClearEvent
ClearEvent:
	mov	r4, sp
	svc	#SST_ClearEvent
	bx	lr


@
@	_ssf_ClearEvent
@
@	Argument
@
	.globl	_ssf_ClearEvent
_ssf_ClearEvent:
	ldr	r2, =__start_sbt

	ldrb	r3, [r2, #u1_sbt_sts]
	ldrh	r4, [r2, #u2_sbt_runtsk]
	ands	r3, r3, #SBT_sts_intnst_MASK
	bne	.err_e_os_callevel_ClearEvent

	mov	r3, #SIZE_tcb
	ldr	r5, =__start_tcb
	mul	r3, r4, r3
	add	r3, r3, r5
	ldr	r4, [r3, #u4_tcb_event]
	mvn	r0, r0
	and	r4, r4, r0
	str	r4, [r3, #u4_tcb_event]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_callevel_ClearEvent:
	mov	r0, #E_OS_CALLEVEL
	b	__ServiceCallExit


@
@	_GetEvent
@
@	Argument
@
	.globl	GetEvent
GetEvent:
	mov	r4, sp
	svc	#SST_GetEvent
	bx	lr


@
@	_ssf_GetEvent
@
@	Argument
@
	.globl	_ssf_GetEvent
_ssf_GetEvent:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_tsknum]

	cmp	r0, r3
	bgt	.err_e_os_id_GetEvent

	cmp	r0, #0
	ble	.err_e_os_id_GetEvent

	mov	r3, #SIZE_tcb
	ldr	r4, =__start_tcb
	mul	r3, r0, r3
	add	r3, r3, r4
	ldrb	r2, [r3, #u1_tcb_sts]
	ands	r2, r2, #TCB_sts_all
	beq	.err_e_os_state_GetEvent

	ldr	r4, [r3, #u4_tcb_event]
	str	r4, [r1, #0]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_GetEvent:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit

.err_e_os_state_GetEvent:
	mov	r0, #E_OS_STATE
	b	__ServiceCallExit


@
@	_WaitEvent
@
@	Argument
@
	.globl	WaitEvent
WaitEvent:
	mov	r4, sp
	svc	#SST_WaitEvent
	bx	lr


@
@	_ssf_WaitEvent
@
@	Argument
@
	.globl	_ssf_WaitEvent
_ssf_WaitEvent:
	ldr	r2, =__start_sbt

	ldrb	r3, [r2, #u1_sbt_sts]
	ands	r3, r3, #SBT_sts_intnst_MASK
	bne	.err_e_os_callevel_WaitEvent

	ldrh	r3, [r2, #u2_sbt_runtsk]

	mov	r8, #SIZE_tib
	mul	r8, r3, r8
	ldr	r9, =__start_tib
	add	r8, r8, r9

	mov	r1, #SIZE_tcb
	ldr	r5, =__start_tcb
	mul	r1, r3, r1
	add	r1, r1, r5
	ldrb	r5, [r1, #u1_tcb_res]

	cmp	r5, #0
	beq	.end_check_resource_WaitEvent

	mov	r4, #SIZE_rib
	ldr	r3, =__start_rib
	mul	r4, r5, r4
	add	r4, r4, r3
	ldrb	r3, [r4, #u1_rib_atr]

	ands	r3, r3, #RIB_ATR_INTERNAL
	beq	.err_e_os_resource_WaitEvent

	mov	r4, #SIZE_rcb
	ldr	r3, =__start_rcb
	mul	r4, r5, r4
	add	r4, r4, r3
	ldrb	r3, [r4, #u4_rcb_rid]
	cmp	r3, #0
	bne	.err_e_os_resource_WaitEvent

	ldr	r6, [r1, #u4_tcb_event]
	ands	r6, r0, r6
	bne	.noWait_WaitEvent

	mov	r6, #0
	str	r6, [r4, #u4_rcb_tid]
	str	r6, [r4, #u4_rcb_rid]

	ldrb	r6, [r1, #u1_tcb_pri]
	mov	r7, #SIZE_rdybuf
	mul	r7, r6, r7
	ldr	r9, =__start_rdybuf
	add	r9, r9, r7

	ldrb	r7, [r8, #u1_tib_ipri]
	strb	r7, [r1, #u1_tcb_pri]

	ldrh	r4,  [r9, #u2_rdybuf_ridx]
	ldr	r10, [r9, #u4_rdybuf_bufsize]
	add	r4, r4, #1
	cmp	r4, r10
	blt	.rdybuf_ridx_str_internal_res_WaitEvent

	mov	r4, #0

.rdybuf_ridx_str_internal_res_WaitEvent:
	strh	r4,  [r9, #u2_rdybuf_ridx]
	ldrh	r10, [r9, #u2_rdybuf_widx]
	cmp	r4, r10
	bne	.end_check_resource_WaitEvent

	ldr	r10, [r2, #u4_sbt_primap]
	mov	r4, #1
	lsl	r4, r4, r6

	mvn	r4, r4
	and	r10, r10, r4

	str	r10, [r2, #u4_sbt_primap]

	mov	r6, #0
	strb	r6, [r2, #u1_sbt_highest_tsk]

.end_check_resource_WaitEvent:
	ldrb	r7, [r1, #u1_tcb_pri]
	mov	r4, #SIZE_rdybuf
	mul	r4, r7, r4
	ldr	r3, =__start_rdybuf
	add	r3, r3, r4

	ldrh	r4, [r3, #u2_rdybuf_ridx]
	ldr	r6, [r3, #u4_rdybuf_bufsize]
	add	r4, r4, #1
	cmp	r4, r6
	blt	.rdybuf_ridx_str_WaitEvent

	mov	r4, #0

.rdybuf_ridx_str_WaitEvent:
	strh	r4, [r3, #u2_rdybuf_ridx]
	ldrh	r6, [r3, #u2_rdybuf_widx]
	cmp	r4, r6
	bne	.end_primap_clear_WaitEvent

	ldr	r6, [r2, #u4_sbt_primap]
	mov	r4, #1
	lsl	r4, r4, r7

	mvn	r4, r4
	and	r6, r6, r4

	str	r6, [r2, #u4_sbt_primap]

	mov	r6, #0
	strb	r6, [r2, #u1_sbt_highest_tsk]

.end_primap_clear_WaitEvent:
	ldrb	r3, [r1, #u1_tcb_sts]
	and	r3, r3, #~TCB_sts_all
	orr	r3, r3, #TCB_sts_waiting
	strb	r3, [r1, #u1_tcb_sts]

	ldrb	r6, [r2, #u1_sbt_sch_ena]
	and	r6, r6, #~SBT_sch_ena_ENA
	strb	r6, [r2, #u1_sbt_sch_ena]

	str	r0, [r1, #u4_tcb_waievent]

.noWait_WaitEvent:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_resource_WaitEvent:
	mov	r0, #E_OS_RESOURCE
	b	__ServiceCallExit

.err_e_os_callevel_WaitEvent:
	mov	r0, #E_OS_CALLEVEL
	b	__ServiceCallExit
