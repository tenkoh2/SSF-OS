.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_tib
	.extern	__start_tcb
	.extern	__start_rdybuf

@
@	__regist_readybuf
@
@	Argument
@	r1:	Task Priority
@	r6:	Task ID
@
	.globl	__regist_readybuf
__regist_readybuf:
	ldr	r8, [r2, #u4_sbt_primap]
	sub	r1, r1, #1
	mov	r10, #0x00000001
	lsl	r10, r10, r1

	orr	r8, r8, r10

	str	r8, [r2, #u4_sbt_primap]

	add	r1, r1, #1

	ldr	r8, =__start_rdybuf
	mov	r10, #SIZE_rdybuf
	mul	r1, r1, r10
	add	r1, r1, r8

	ldrh	r8,  [r1, #u2_rdybuf_widx]
	ldr	r10, [r1, #pu4_rdybuf_rdybuf]
	lsl	r8, r8, #1
	add	r10, r10, r8
	strh	r6,  [r10, #0]

	lsr	r8, r8, #1
	ldr	r10, [r1, #u4_rdybuf_bufsize]
	add	r8, r8, #1
	cmp	r8, r10
	blt	.update_rdybuf_widx

	mov	r8, #0

.update_rdybuf_widx:
	strh	r8,  [r1, #u2_rdybuf_widx]

	bx	lr


@
@	__regist_readybuf_top
@
@	Argument
@	r1:	Task Priority
@	r6:	Task ID
@
	.globl	__regist_readybuf_top
__regist_readybuf_top:
	ldr	r8, [r2, #u4_sbt_primap]
	sub	r1, #1
	mov	r10, #0x00000001
	lsl	r10, r10, r1

	orr	r8, r8, r10

	str	r8, [r2, #u4_sbt_primap]

	add	r1, #1

	ldr	r8, =__start_rdybuf
	mov	r10, #SIZE_rdybuf
	mul	r1, r1, r10
	add	r1, r1, r8

	ldrh	r8,  [r1, #u2_rdybuf_ridx]
	ldr	r10, [r1, #pu4_rdybuf_rdybuf]
	ldr	r4,  [r1, #u4_rdybuf_bufsize]
	cmp	r8, #0
	bne	.end_readybuf_resize

	add	r8, r4, r8

.end_readybuf_resize:
	sub	r8, #1
	lsl	r8, r8, #1
	add	r10, r10, r8
	strh	r6,  [r10, #0]

	lsr	r8, r8, #1
	ldr	r10, [r1, #u4_rdybuf_bufsize]
	add	r8, r8, #1
	cmp	r8, r10
	blt	.update_rdybuf_ridx

	mov	r8, #0

.update_rdybuf_ridx:
	strh	r8,  [r1, #u2_rdybuf_ridx]

	bx	lr


@
@	_ActivateTask
@
@	Argument
@
	.globl	ActivateTask
ActivateTask:
	mov	r4, sp
	svc	#SST_ActivateTask
	bx	lr


@
@	_ssf_ActivateTask
@
@	Argument
@
	.globl	_ssf_ActivateTask
_ssf_ActivateTask:
	ldr	r2, =__start_sbt

	@ ID のチェック
	cmp	r0, #0
	ble	.err_e_os_id_ActivateTask

	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_tsknum]

	cmp	r0, r1
	bgt	.err_e_os_id_ActivateTask

	bl	_ssf_Body_ActivateTask

	cmp	r0, #-1
	beq	.err_e_os_limit_ActivateTask

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_ActivateTask:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit

.err_e_os_limit_ActivateTask:
	mov	r0, #E_OS_LIMIT
	b	__ServiceCallExit


@
@	_ssf_Body_ActivateTask
@
@	Argument
@	r0	:	Task ID
@
	.globl	_ssf_Body_ActivateTask
_ssf_Body_ActivateTask:
	@ actcnt の加算
	ldr	r1, =__start_tcb
	mov	r3, #SIZE_tcb
	mul	r3, r0, r3
	add	r3, r3, r1
	ldrb	r1, [r3, #u1_tcb_actcnt]
	add	r1, #1
	cmp	r1, #TMAX_ACTCNT
	bgt	.err_e_os_limit_Body_ActivateTask

	strb	r1, [r3, #u1_tcb_actcnt]

	@ タスク状態の更新
	ldrb	r1, [r3, #u1_tcb_sts]
	cmp	r1, #TCB_sts_suspneded
	bne	.end_reload_tsksts

	mov	r1, #TCB_sts_ready
	strb	r1, [r3, #u1_tcb_sts]

.end_reload_tsksts:
	ldr	r1, =__start_tib
	mov	r4, #SIZE_tib
	mul	r4, r0, r4
	add	r4, r4, r1
	ldrb	r1, [r4, #u1_tib_ipri]
	mov	r6, r0
	mov	r3, r1

	mov	r5, lr

	bl	__regist_readybuf

	mov	lr, r5

	ldrb	r5, [r2, #u1_sbt_sch_ena]
	ldrb	r4, [r2, #u1_sbt_highest_tsk]
	orr	r5, r5, #SBT_sch_ena_ENA
	cmp	r3, r4
	ble	.check_schdule_flag

	strb	r3, [r2, #u1_sbt_highest_tsk]
	and	r5, r5, #~SBT_sch_ena_ENA

.check_schdule_flag:
	strb	r5, [r2, #u1_sbt_sch_ena]

	mov	r0, #0
	bx	lr

.err_e_os_limit_Body_ActivateTask:
	mov	r0, #-1
	bx	lr


@
@	_ChainTask
@
@	Argument
@
	.globl	ChainTask
ChainTask:
	mov	r4, sp
	svc	#SST_CainTask
	bx	lr


@
@	_ssf_ChainTask
@
@	Argument
@
	.globl	_ssf_ChainTask
_ssf_ChainTask:
	ldr	r2, =__start_sbt
	ldrh	r7, [r2, #u2_sbt_syssts]
	and	r7, r7, #~SS_TSKRUN
	orr	r7, r7, #SS_PSTHOOK
	strh	r7, [r2, #u2_sbt_syssts]

	bl	PostTaskHook

	ldr	r2, =__start_sbt
	ldrh	r7, [r2, #u2_sbt_syssts]
	and	r7, r7, #~SS_PSTHOOK
	strh	r7, [r2, #u2_sbt_syssts]

	ldrh	r7, [r2, #u2_sbt_runtsk]
	ldr	r3, =__start_tcb
	mov	r1, #SIZE_tcb
	mul	r1, r7, r1
	add	r1, r1, r3
	ldrb	r3, [r1, #u1_tcb_res]
	orrs	r3, r3, r3
	beq	.end_rel_internal_res

	mov	r4, #0
	ldr	r5, =__start_rcb
	strb	r4, [r1, #u1_tcb_res]
	mov	r6, #SIZE_rcb
	mul	r3, r3, r6
	add	r3, r3, r5
	str	r4, [r3, #u4_rcb_tid]
	str	r4, [r3, #u4_rcb_rid]
	ldr	r5, =__start_tib
	mov	r6, #SIZE_tib
	mul	r6, r7, r6
	add	r5, r6, r5

	@ レディ・バッファ・アドレスを生成
	ldrb	r7, [r1, #u1_tcb_pri]
	mov	r4, #SIZE_rdybuf
	mul	r4, r7, r4
	ldr	r3, =__start_rdybuf
	add	r3, r3, r4

	@ タスク優先度を初期値に戻す
	ldrb	r6, [r5, #u1_tib_ipri]
	strb	r6, [r1, #u1_tcb_pri]

	@ レディ・バッファからタスクID をロード
	ldrh	r4, [r3, #u2_rdybuf_ridx]
	ldr	r7, [r3, #pu4_rdybuf_rdybuf]
	lsl	r4, r4, #1
	add	r7, r7, r4
	ldrh	r7, [r7, #0]

	lsr	r4, r4, #1
	ldr	r1, [r3, #u4_rdybuf_bufsize]
	add	r4, r4, #1
	cmp	r4, r1
	blt	.rdybuf_ridx_str_internal_res

	mov	r4, #0

.rdybuf_ridx_str_internal_res:
	strh	r4, [r3, #u2_rdybuf_ridx]
	ldrh	r6, [r3, #u2_rdybuf_widx]
	cmp	r4, r6
	bne	.end_rel_internal_res

	ldr	r6, [r2, #u4_sbt_primap]
	mov	r4, #1
	lsl	r4, r4, r7

	mvn	r4, r4
	and	r6, r6, r4

	str	r6, [r2, #u4_sbt_primap]

.end_rel_internal_res:
	ldrb	r4, [r1, #u1_tcb_actcnt]
	subs	r4, r4, #1
	strb	r4, [r1, #u1_tcb_actcnt]
	bne	.end_terminate_task

	mov	r4, #TCB_sts_suspneded
	strb	r4, [r1, #u1_tcb_sts]
	mov	r4, #0
	strh	r4, [r2, #u2_sbt_runtsk]
	strb	r4, [r2, #u1_sbt_highest_tsk]

.end_terminate_task:
	@ レディ・バッファ・アドレスを生成
	ldrb	r6, [r1, #u1_tcb_pri]
	mov	r4, #SIZE_rdybuf
	mul	r4, r6, r4
	ldr	r3, =__start_rdybuf
	add	r3, r3, r4

	@ レディ・バッファからタスクID をロード
	ldrh	r4, [r3, #u2_rdybuf_ridx]
	ldr	r7, [r3, #pu4_rdybuf_rdybuf]
	lsl	r4, r4, #1
	add	r7, r7, r4
	ldrh	r7, [r7, #0]

	lsr	r4, r4, #1
	ldr	r1, [r3, #u4_rdybuf_bufsize]
	add	r4, r4, #1
	cmp	r4, r1
	blt	.rdybuf_ridx_str

	mov	r4, #0

.rdybuf_ridx_str:
	strh	r4, [r3, #u2_rdybuf_ridx]
	ldrh	r6, [r3, #u2_rdybuf_widx]
	cmp	r4, r6
	bne	.end_primap_clear

	ldr	r6, [r2, #u4_sbt_primap]
	mov	r4, #1
	lsl	r4, r4, r5

	mvn	r4, r4
	and	r6, r6, r4

	str	r6, [r2, #u4_sbt_primap]

.end_primap_clear:
	ldrb	r6, [r2, #u1_sbt_sch_ena]
	and	r6, r6, #~SBT_sch_ena_ENA
	strb	r6, [r2, #u1_sbt_sch_ena]

	b	_ssf_ActivateTask


@
@	_Schedule
@
@	Argument
@
	.globl	Schedule
Schedule:
	mov	r4, sp
	svc	#SST_Schedule
	bx	lr


@
@	_ssf_Schedule
@
@	Argument
@
	.globl	_ssf_Schedule
_ssf_Schedule:
	ldr	r2, =__start_sbt

	ldrb	r0, [r2, #u1_sbt_sts]
	ands	r1, r0, #SBT_sts_intnst_MASK
	bne	.err_e_os_callevel_Schedule

	ldrh	r1, [r2, #u2_sbt_runtsk]
	ldr	r4, =__start_tcb
	mov	r3, #SIZE_tcb
	mul	r3, r1, r3
	add	r3, r3, r4
	ldrb	r4, [r3, #u1_tcb_res]

	cmp	r4, #0
	beq	.end_check_resource

	ldr	r5, =__start_rib
	mov	r6, #SIZE_rib
	mul	r6, r4, r6
	add	r6, r6, r5
	ldrb	r5, [r6, #u1_rib_atr]

	ldr	r7, =__start_rcb
	mov	r8, #SIZE_rcb
	mul	r8, r4, r8
	add	r8, r8, r7
	ldr	r7, [r8, #u4_rcb_rid]

	cmp	r7, #0
	bne	.err_e_os_resource_Schedule

	ands	r5, r5, #RIB_ATR_INTERNAL
	beq	.err_e_os_resource_Schedule

.end_check_resource:
	ldrh	r0, [r2, #u2_sbt_syssts]
	ands	r1, r0, #SS_DISDSP
	beq	.err_e_ok_Schedule

	cmp	r4, #0
	beq	.end_rel_internal_resource_Schedule

	mov	r7, #0
	strb	r7, [r3, #u1_tcb_res]
	str	r7, [r8, #u4_rcb_tid]
	str	r7, [r8, #u4_rcb_rid]
	ldr	r5, =__start_tib
	mov	r6, #SIZE_tib
	mul	r6, r1, r6
	add	r5, r6, r5

	@ レディ・バッファ・アドレスを生成
	ldrb	r6, [r3, #u1_tcb_pri]
	mov	r7, #SIZE_rdybuf
	mul	r7, r6, r7
	ldr	r4, =__start_rdybuf
	add	r4, r4, r7

	@ タスク優先度を初期値に戻す
	ldrb	r6, [r5, #u1_tib_ipri]
	strb	r6, [r3, #u1_tcb_pri]

	@ レディ・バッファからタスクID をロード
	ldrh	r5, [r4, #u2_rdybuf_ridx]
	ldr	r0, [r4, #pu4_rdybuf_rdybuf]
	lsl	r5, r5, #1
	add	r0, r0, r5
	ldrh	r0, [r0, #0]

	lsr	r5, r5, #1
	ldr	r1, [r4, #u4_rdybuf_bufsize]
	add	r5, r5, #1
	cmp	r5, r1
	blt	.rdybuf_ridx_str_internal_res_Schedule

	mov	r5, #0

.rdybuf_ridx_str_internal_res_Schedule:
	strh	r5, [r4, #u2_rdybuf_ridx]
	ldrh	r7, [r3, #u2_rdybuf_widx]
	cmp	r5, r7
	bne	.end_rel_internal_res

	ldr	r6, [r2, #u4_sbt_primap]
	mov	r4, #1
	lsl	r4, r4, r6

	mvn	r4, r4
	and	r6, r6, r4

	str	r6, [r2, #u4_sbt_primap]

	strh	r5, [r2, #u1_sbt_highest_tsk]

.end_rel_internal_resource_Schedule:
	ldrb	r5, [r2, #u1_sbt_sts]
	mov	r4, #0
	strb	r4, [r2, #u1_sbt_sts]
	bl	__Scheduler

	ldr	r2, =__start_sbt
	strb	r5, [r2, #u1_sbt_sts]
	ldr	r3, [r2, #u2_sbt_runtsk]
	ldr	r4, =__start_tib
	mov	r5, #SIZE_tib
	mul	r3, r3, r5
	add	r3, r3, r4
	ldr	r4, [r3, #u4_tib_ires]
	lsl	r4, #16
	mov	r5, #0xffff
	ands	r5, r4, r5
	beq	.end_get_internal_resource_Schedule

	ldr	r8, =__start_tcb
	mov	r4, #SIZE_tcb
	mul	r4, r3, r4
	add	r8, r4, r8

	@ インターナル・リソースの獲得処理
	mov	r4, #SIZE_rib
	mul	r4, r5, r4
	ldr	r7, =__start_rib
	add	r7, r7, r4

	mov	r4, #SIZE_rcb
	mul	r4, r5, r4
	ldr	r6, =__start_rcb
	add	r6, r6, r4

	ldrb	r4, [r8, #u1_tcb_res]
	str	r3, [r6, #u4_rcb_tid]
	str	r4, [r6, #u4_rcb_rid]
	strb	r5, [r8, #u1_tcb_res]

	ldrb	r1, [r7, #u1_rib_ceilpri]
	strb	r1, [r8, #u1_tcb_pri]
	mov	r6, r3
	strb	r1, [r2, #u1_sbt_highest_tsk]
	bl	__regist_readybuf_top

.end_get_internal_resource_Schedule:

.err_e_ok_Schedule:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_callevel_Schedule:
	mov	r0, #E_OS_CALLEVEL
	b	__ServiceCallExit

.err_e_os_resource_Schedule:
	mov	r0, #E_OS_RESOURCE
	b	__ServiceCallExit


@
@	_GetTaskID
@
@	Argument
@
	.globl	GetTaskID
GetTaskID:
	mov	r4, sp
	svc	#SST_GetTaskID
	bx	lr


@
@	_ssf_GetTaskID
@
@	Argument
@
	.globl	_ssf_GetTaskID
_ssf_GetTaskID:
	ldr	r2, =__start_sbt
	ldrh	r1, [r2, #u2_sbt_syssts]
	ands	r1, #(SS_STHOOK | SS_SDHOOK)
	bne	.err_e_ok_GetTaskID

	ldrh	r3, [r2, #u2_sbt_runtsk]
	cmp	r3, #0
	bne	.end_invalid_task_GetTaskID

	mov	r3, #INVALID_TASK

.end_invalid_task_GetTaskID:
	strh	r3, [r0, #0]

.err_e_ok_GetTaskID:
	mov	r0, #E_OK
	b	__ServiceCallExit


@
@	_GetTaskState
@
@	Argument
@
	.globl	GetTaskState
GetTaskState:
	mov	r4, sp
	svc	#SST_GetTaskState
	bx	lr


@
@	_ssf_GetTaskState
@
@	Argument
@
	.globl	_ssf_GetTaskState
_ssf_GetTaskState:
	cmp	r0, #0
	ble	.err_e_os_id_GetTaskState

	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_tsknum]

	cmp	r0, r1
	bgt	.err_e_os_id_GetTaskState

	mov	r3, #SIZE_tcb
	ldr	r4, =__start_tcb
	lsl	r0, #16
	mov	r5, #0xffff
	and	r0, r0, r5
	mul	r3, r0, r3
	add	r3, r3, r4
	ldrb	r4, [r3, #u1_tcb_sts]
	and	r4, r4, #TCB_sts_all
	strb	r4, [r1, #0]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_GetTaskState:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit
