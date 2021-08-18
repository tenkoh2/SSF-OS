@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_cntctrl
	.extern	__start_alminf
	.extern	__start_almctrl
	.extern	_ssf_Body_ActivateTask
	.extern	_ssf_Body_SetEvent
	.extern	__ServiceCallExit

@
@	_IncrementCounter
@
@	Argument
@
	.globl	IncrementCounter
IncrementCounter:
	mov	r4, sp
	svc	#SST_IncrementCounter
	bx	lr


@
@	_ssf_IncrementCounter
@
@	Argument
@
	.globl	_ssf_IncrementCounter
_ssf_IncrementCounter:
	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_os_id_IncrementCounter

	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_cntnum]

	cmp	r0, r3
	bgt	.err_e_os_id_IncrementCounter

	bl	_ssf_Body_IncrementCounter

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_IncrementCounter:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit


@
@	_ssf_Body_IncrementCounter
@
@	Argument
@	r0	:	Counter ID
@
	.globl	_ssf_Body_IncrementCounter
_ssf_Body_IncrementCounter:
	ldr	r2, =__start_sbt
	ldrh	r1, [r2, #u2_sbt_syssts]
	ands	r3, r1, #SS_CNTEXE
	beq	.start_cnt_Body_IncrementCounter

	ldr	r1, [r2, #u4_sbt_cntnst]
	add	r1, r1, #1
	str	r1, [r2, #u4_sbt_cntnst]

	bx	lr

.start_cnt_Body_IncrementCounter:
	orr	r1, r1, #SS_CNTEXE
	strh	r1, [r2, #u2_sbt_syssts]

	mov	r1, #SIZE_cntctrl
	ldr	r2, =__start_cntctrl
	mul	r1, r0, r1
	add	r1, r1, r2

	ldr	r2, [r1, #u4_cntctrl_cntvalue]
	ldr	r3, [r1, #u4_cntctrl_alrmid]
	add	r2, r2, #1
	str	r2, [r1, #u4_cntctrl_cntvalue]

	cmp	r3, #0
	beq	.end_IncrementCouter

	mov	r5, r3

.loop_alarm_expire_IncrementCounter:
	mov	r2, #SIZE_almctrl
	ldr	r4, =__start_almctrl
	mul	r2, r3, r2
	add	r2, r2, r4
	ldr	r4, [r2, #u4_almctrl_tick]
	ldr	r11, =__start_sbt
	ldr	r6, [r11, #u4_sbt_cntnst]
	sub	r4, r4, #1
	sub	r4, r4, r6
	mov	r6, #0
	str	r6, [r11, #u4_sbt_cntnst]
	cmp	r4, #0
	ldr	r6, [r2, #u4_almctrl_next]
	bgt	.load_next_alarm_IncrementCounter

	mov	r4, #SIZE_alminf
	ldr	r6, =__start_alminf
	mul	r4, r3, r4
	add	r4, r4, r6
	ldr	r6, [r4, #u2_alminf_almatr]
	cmp	r6, #ALMINF_ATR_ACTTSK
	beq	.ActivateTask_IncrementCounter
	bne	.SetEvent_IncrementCounter

.end_alarm_expire_action_IncrementCounter:
	ldr	r6, [r2, #u4_almctrl_cycle]
	cmp	r6, #0
	beq	.delete_almque_IncrementCounter

	str	r6, [r2, #u4_almctrl_tick]

	ldr	r6, [r2, #u4_almctrl_next]
.load_next_alarm_IncrementCounter:
	mov	r3, r6
	cmp	r3, r5
	bne	.loop_alarm_expire_IncrementCounter

.end_IncrementCouter:
	ldr	r2, =__start_sbt
	ldrh	r1, [r2, #u2_sbt_syssts]
	and	r1, r1, #~SS_CNTEXE
	strh	r1, [r2, #u2_sbt_syssts]

	bx	lr


.delete_almque_IncrementCounter:
	mov	r7, #SIZE_almctrl
	ldr	r9, =__start_almctrl
	ldr	r9, [r2, #u4_almctrl_next]
	ldr	r8, [r2, #u4_almctrl_prev]
	mul	r10, r9, r3
	add	r10, r10, r4
	str	r8, [r10, #u4_almctrl_prev]
	mul	r10, r8, r7
	add	r10, r10, r4
	str	r9, [r10, #u4_almctrl_next]

	mov	r10, #0
	str	r10, [r2, #u4_almctrl_next]
	str	r10, [r2, #u4_almctrl_prev]

	mov	r6, r9

	cmp	r3, r5
	bne	.load_next_alarm_IncrementCounter

	cmp	r3, r9
	bne	.reload_almque_top_IncrementCounter

	mov	r9, #0

.reload_almque_top_IncrementCounter:
	str	r9, [r1, #u4_cntctrl_alrmid]

	b	.load_next_alarm_IncrementCounter

.ActivateTask_IncrementCounter:
	stmfd	sp!, {r1-r5, lr}
	ldrh	r0, [r4, #u2_alminf_tskid]
	bl	_ssf_Body_ActivateTask

	cmp	r0, #-1
	bne	.end_call_ErrorHook_IncrementCounter

	ldr	r2, =__start_sbt
	ldrh	r12, [r2, #u2_sbt_syssts]
	and	r0, r12, #~SS_ALL
	orr	r0, r0, #SS_ERRHOOK
	strh	r0, [r2, #u2_sbt_syssts]

	mov	r0, #E_OS_LIMIT
	bl	ErrorHook

	strh	r12, [r2, #u2_sbt_syssts]

.end_call_ErrorHook_IncrementCounter:
	ldmfd	sp!, {r1-r5, lr}
	b	.end_alarm_expire_action_IncrementCounter

.SetEvent_IncrementCounter:
	stmfd	sp!, {r1-r5, lr}
	ldrh	r0, [r4, #u2_alminf_tskid]
	ldr	r1, [r4, #u4_alminf_eventmask]

	bl	_ssf_Body_SetEvent

	ldmfd	sp!, {r1-r5, lr}
	b	.end_alarm_expire_action_IncrementCounter
