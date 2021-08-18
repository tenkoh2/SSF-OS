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
@	_GetAlarmBase
@
@	Argument
@
	.globl	GetAlarmBase
GetAlarmBase:
	mov	r4, sp
	svc	#SST_GetAlarmBase
	bx	lr


@
@	_ssf_GetAlarmBase
@
@	Argument
@
	.globl	_ssf_GetAlarmBase
_ssf_GetAlarmBase:
	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_os_id_GetAlarmBase

	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_almnum]

	cmp	r0, r3
	bgt	.err_e_os_id_GetAlarmBase

	ldr	r3, =__start_alminf
	ldr	r4, [r3, #u4_alminf_maxalwdval]
	ldr	r5, [r3, #u4_alminf_tickspbase]
	ldr	r6, [r3, #u4_alminf_mincycle]
	str	r4, [r1, #u4_almbsreftype_maxalwdval]
	str	r5, [r1, #u4_almbsreftype_tickspbase]
	str	r6, [r1, #u4_almbsreftype_mincycle]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_GetAlarmBase:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit


@
@	_GetAlarm
@
@	Argument
@
	.globl	GetAlarm
GetAlarm:
	mov	r4, sp
	svc	#SST_GetAlarm
	bx	lr


@
@	_ssf_GetAlarm
@
@	Argument
@
	.globl	_ssf_GetAlarm
_ssf_GetAlarm:
	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_os_id_GetAlarm

	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_almnum]

	cmp	r0, r3
	bgt	.err_e_os_id_GetAlarm

	mov	r2, #SIZE_almctrl
	ldr	r3, =__start_almctrl
	mul	r4, r0, r4
	add	r4, r4, r3
	ldr	r5, [r4, #u4_almctrl_sts]
	cmp	r5, #ALMCTRL_STS_STP
	beq	.err_e_os_nofunc_GetAlarm

	ldr	r5, [r4, #u4_almctrl_tick]
	str	r5, [r1, #0]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_GetAlarm:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit

.err_e_os_nofunc_GetAlarm:
	mov	r0, #E_OS_NOFUNC
	b	__ServiceCallExit


@
@	_SetRelAlarm
@
@	Argument
@
	.globl	SetRelAlarm
SetRelAlarm:
	mov	r4, sp
	svc	#SST_SetRelAlarm
	bx	lr


@
@	_ssf_SetRelAlarm
@
@	Argument
@
	.globl	_ssf_SetRelAlarm
_ssf_SetRelAlarm:
	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_os_id_SetRelAlarm

	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_almnum]

	cmp	r0, r3
	bgt	.err_e_os_id_SetRelAlarm

	mov	r3, #SIZE_alminf
	ldr	r4, =__start_alminf
	mul	r3, r0, r3
	add	r3, r3, r4
	ldr	r4, [r3, #u4_alminf_maxalwdval]
	ldr	r5, [r3, #u4_alminf_mincycle]

	cmp	r2, #0
	beq	.end_alarmbase_check_SetRelAlarm

	cmp	r2, r4
	bgt	.err_e_os_value_SetRelAlarm
	cmp	r2, r5
	blt	.err_e_os_value_SetRelAlarm

.end_alarmbase_check_SetRelAlarm:
	cmp	r1, #0
	blt	.err_e_os_value_SetRelAlarm
	cmp	r1, r4
	bgt	.err_e_os_value_SetRelAlarm

	mov	r5, #SIZE_almctrl
	ldr	r4, =__start_almctrl
	mul	r5, r0, r5
	add	r5, r5, r4
	ldr	r4, [r5, #u4_almctrl_sts]
	cmp	r4, #ALMCTRL_STS_STA
	beq	.err_e_os_state_SetRelAlarm

	orr	r4, r4, #ALMCTRL_STS_STA
	str	r4, [r5, #u4_almctrl_sts]

	cmp	r1, #0
	bne	.start_regist_counter_SetRelAlarm

	ldr	r4, [r3, #u2_alminf_almatr]
	cmp	r4, #ALMINF_ATR_ACTTSK
	beq	.alarm_expire_activate_SetRelAlarm

	cmp	r4, #ALMINF_ATR_SETEVT
	beq	.alarm_expire_setevent_SetRelAlarm

.end_alarm_expire_SetRelAlarm:
	mov	r1, r2
	cmp	r1, #0
	bne	.start_regist_counter_SetRelAlarm

.end_regist_counter_SetRelAlarm:
	cmp	r2, #0
	beq	.end_set_alarm_cycle_SetRelAlarm

	str	r2, [r5, #u4_almctrl_cycle]

.end_set_alarm_cycle_SetRelAlarm:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_SetRelAlarm:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit

.err_e_os_value_SetRelAlarm:
	mov	r0, #E_OS_VALUE
	b	__ServiceCallExit

.err_e_os_state_SetRelAlarm:
	mov	r0, #E_OS_STATE
	b	__ServiceCallExit

.start_regist_counter_SetRelAlarm:
	ldrh	r4, [r3, #u2_alminf_cntid]

	str	r1, [r5, #u4_almctrl_tick]

	mov	r6, #SIZE_cntctrl
	ldr	r7, =__start_cntctrl
	mul	r6, r4, r6
	add	r6, r6, r7
	ldr	r7, [r6, #u4_cntctrl_alrmid]

	cmp	r7, #0
	beq	.reload_quetop_SetRelAlarm

	mov	r8, #SIZE_almctrl
	ldr	r4, =__start_almctrl
	mul	r9, r7, r8
	add	r9, r9, r4
	ldr	r10, [r9, #u4_almctrl_prev]
	str	r0,  [r9, #u4_almctrl_prev]
	str	r7,  [r5, #u4_almctrl_next]
	str	r10, [r5, #u4_almctrl_prev]
	mul	r9, r10, r8
	add	r9, r9, r4
	str	r0,  [r9, #u4_almctrl_next]

	b	.end_regist_counter_SetRelAlarm

.reload_quetop_SetRelAlarm:
	str	r0, [r6, #u4_cntctrl_alrmid]
	str	r0, [r5, #u4_almctrl_next]
	str	r0, [r5, #u4_almctrl_prev]

	b	.end_regist_counter_SetRelAlarm

.alarm_expire_activate_SetRelAlarm:
	mov	r7,  r0
	mov	r9,  r1
	mov	r11, r2

	ldrh	r0, [r3, #u2_alminf_tskid]

	bl	_ssf_Body_ActivateTask

	mov	r0, r7
	mov	r1, r9
	mov	r2, r11

	b	.end_alarm_expire_SetRelAlarm

.alarm_expire_setevent_SetRelAlarm:
	mov	r7,  r0
	mov	r9,  r1
	mov	r11, r2

	ldrh	r0, [r3, #u2_alminf_tskid]
	ldr	r1, [r3, #u4_alminf_eventmask]

	bl	_ssf_Body_SetEvent

	mov	r0, r7
	mov	r1, r9
	mov	r2, r11

	b	.end_alarm_expire_SetRelAlarm


@
@	_SetAbsAlarm
@
@	Argument
@
	.globl	SetAbsAlarm
SetAbsAlarm:
	mov	r4, sp
	svc	#SST_SetAbsAlarm
	bx	lr


@
@	_ssf_SetAbsAlarm
@
@	Argument
@
	.globl	_ssf_SetAbsAlarm
_ssf_SetAbsAlarm:
	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_os_id_SetAbsAlarm

	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_almnum]

	cmp	r0, r3
	bgt	.err_e_os_id_SetAbsAlarm

	mov	r3, #SIZE_alminf
	ldr	r4, =__start_alminf
	mul	r3, r0, r3
	add	r3, r3, r4
	ldr	r4, [r3, #u4_alminf_maxalwdval]
	ldr	r5, [r3, #u4_alminf_mincycle]

	cmp	r2, #0
	beq	.end_alarmbase_check_SetAbsAlarm

	cmp	r2, r4
	bgt	.err_e_os_value_SetAbsAlarm
	cmp	r2, r5
	blt	.err_e_os_value_SetAbsAlarm

.end_alarmbase_check_SetAbsAlarm:
	cmp	r1, #0
	blt	.err_e_os_value_SetAbsAlarm
	cmp	r1, r4
	bgt	.err_e_os_value_SetAbsAlarm

	mov	r5, #SIZE_almctrl
	ldr	r4, =__start_almctrl
	mul	r5, r0, r5
	add	r5, r5, r4
	ldr	r4, [r5, #u4_almctrl_sts]
	cmp	r4, #ALMCTRL_STS_STA
	beq	.err_e_os_state_SetAbsAlarm

	orr	r4, r4, #ALMCTRL_STS_STA
	str	r4, [r5, #u4_almctrl_sts]

	ldrh	r4, [r3, #u2_alminf_cntid]

	mov	r6, #SIZE_cntctrl
	ldr	r7, =__start_cntctrl
	mul	r6, r4, r6
	add	r6, r6, r7
	ldr	r7, [r6, #u4_cntctrl_alrmid]

	ldr	r8, [r6, #u4_cntctrl_cntvalue]
	cmp	r1, r8
	ble	.already_past_tick_SetAbsAlarm

	sub	r1, r1, r8

.end_set_tick_SetAbsAlarm:
	str	r1, [r5, #u4_almctrl_tick]

	cmp	r7, #0
	beq	.reload_quetop_SetAbsAlarm

	mov	r8, #SIZE_almctrl
	ldr	r4, =__start_almctrl
	mul	r9, r7, r8
	add	r9, r9, r4
	ldr	r10, [r9, #u4_almctrl_prev]
	str	r0,  [r9, #u4_almctrl_prev]
	str	r7,  [r5, #u4_almctrl_next]
	str	r10, [r5, #u4_almctrl_prev]
	mul	r9, r10, r8
	add	r9, r9, r4
	str	r0,  [r9, #u4_almctrl_next]

	b	.end_regist_counter_SetAbsAlarm

.reload_quetop_SetAbsAlarm:
	str	r0, [r6, #u4_cntctrl_alrmid]
	str	r0, [r5, #u4_almctrl_next]
	str	r0, [r5, #u4_almctrl_prev]

.end_regist_counter_SetAbsAlarm:
	cmp	r2, #0
	beq	.end_set_alarm_cycle_SetAbsAlarm

	str	r2, [r5, #u4_almctrl_cycle]

.end_set_alarm_cycle_SetAbsAlarm:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_SetAbsAlarm:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit

.err_e_os_value_SetAbsAlarm:
	mov	r0, #E_OS_VALUE
	b	__ServiceCallExit

.err_e_os_state_SetAbsAlarm:
	mov	r0, #E_OS_STATE
	b	__ServiceCallExit

.already_past_tick_SetAbsAlarm:
	mov	r9,  #0xffff
	mov	r10, #0xffff
	lsl	r9, r9, #16
	orr	r9, r9, r10
	sub	r1, r8, r1
	sub	r1, r9, r1

	b	.end_set_tick_SetAbsAlarm


@
@	_CancelAlarm
@
@	Argument
@
	.globl	CancelAlarm
CancelAlarm:
	mov	r4, sp
	svc	#SST_CancelAlarm
	bx	lr


@
@	_ssf_CancelAlarm
@
@	Argument
@
	.globl	_ssf_CancelAlarm
_ssf_CancelAlarm:
	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_os_id_CancelAlarm

	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_almnum]

	cmp	r0, r3
	bgt	.err_e_os_id_CancelAlarm

	mov	r3, #SIZE_almctrl
	ldr	r4, =__start_almctrl
	mul	r5, r0, r3
	add	r5, r3, r4
	ldr	r6, [r5, #u4_almctrl_sts]
	cmp	r6, #ALMCTRL_STS_STP
	beq	.err_e_os_nofunc_CancelAlarm

	ldr	r6, [r5, #u4_almctrl_next]
	ldr	r8, [r5, #u4_almctrl_prev]
	mul	r7, r6, r3
	add	r7, r7, r4
	str	r8, [r7, #u4_almctrl_prev]
	mul	r7, r8, r3
	add	r7, r7, r4
	str	r6, [r7, #u4_almctrl_next]

	mov	r3, #SIZE_alminf
	ldr	r4, =__start_alminf
	mul	r3, r0, r3
	add	r3, r3, r4
	ldrh	r9, [r3, #u2_alminf_cntid]
	mov	r3, #SIZE_alminf
	ldr	r4, =__start_cntctrl
	mul	r3, r9, r3
	add	r3, r3, r4
	ldr	r9, [r3, #u4_cntctrl_alrmid]
	cmp	r0, r9
	bne	.end_reload_quetop_CancelAlarm

	cmp	r0, r6
	bne	.reload_quetop_CancelAlarm

	mov	r6, #0

.reload_quetop_CancelAlarm:
	str	r6, [r3, #u4_cntctrl_alrmid]

.end_reload_quetop_CancelAlarm:
	mov	r3, #0
	str	r3, [r5, #u4_almctrl_sts]
	str	r3, [r5, #u4_almctrl_tick]
	str	r3, [r5, #u4_almctrl_cycle]
	str	r3, [r5, #u4_almctrl_next]
	str	r3, [r5, #u4_almctrl_prev]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_CancelAlarm:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit

.err_e_os_nofunc_CancelAlarm:
	mov	r0, #E_OS_NOFUNC
	b	__ServiceCallExit
