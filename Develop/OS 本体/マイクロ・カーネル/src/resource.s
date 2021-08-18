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
	.extern	__regist_readybuf
	.extern	__ServiceCallExit

@
@	_GetResource
@
@	Argument
@
	.globl	GetResource
GetResource:
	mov	r4, sp
	svc	#SST_GetResource
	bx	lr


@
@	_ssf_GetResource
@
@	Argument
@
	.globl	_ssf_GetResource
_ssf_GetResource:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_rscnum]

	cmp	r0, r1
	bgt	.err_e_os_id_GetResource

	cmp	r0, #0
	ble	.err_e_os_id_GetResource

	ldrh	r1, [r2, #u2_sbt_runtsk]

	ldr	r5, =__start_rib
	mov	r4, #SIZE_rib
	mul	r4, r0, r4
	add	r4, r4, r5

	ldrb	r6, [r4, #u1_rib_atr]
	ands	r6, r6, #RIB_ATR_INTERNAL
	bne	.err_e_os_access_GetResource

	ldr	r7, =__start_tib
	mov	r3, #SIZE_tib
	mul	r3, r1, r3
	add	r3, r3, r7

	ldrb	r9, [r4, #u1_rib_ceilpri]
	ldrb	r8, [r3, #u1_tib_ipri]
	cmp	r9, r8
	blt	.err_e_os_access_GetResource

	ldr	r6, =__start_rcb
	mov	r5, #SIZE_rcb
	mul	r7, r1, r5
	add	r8, r5, r6

	ldr	r7, [r8, #u4_rcb_tid]
	cmp	r7, #0
	bne	.err_e_os_access_GetResource

	str	r1, [r8, #u4_rcb_tid]

	ldr	r7, =__start_tcb
	mov	r3, #SIZE_tcb
	mul	r3, r1, r3
	add	r3, r3, r7

	ldrb	r7, [r3, #u1_tcb_res]
	cmp	r7, #0
	beq	.end_resque_GetResource

	mov	r0, r7

.loop_rid_GetResource:
	mul	r8, r7, r5
	add	r8, r8, r6
	ldr	r7, [r8, #u4_rcb_rid]
	cmp	r7, #0
	bne	.loop_rid_GetResource

.end_resque_GetResource:
	strb	r0, [r3, #u1_tcb_res]

	ldrb	r7, [r3, #u1_tcb_pri]
	cmp	r7, r9
	bge	.end_ceilpri_ope_GetResource

	strb	r9, [r3, #u1_tcb_pri]

	mov	r6, r1
	mov	r1, r9
	bl	__regist_readybuf_top

.end_ceilpri_ope_GetResource:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_GetResource:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit

.err_e_os_access_GetResource:
	mov	r0, #E_OS_ACCESS
	b	__ServiceCallExit


@
@	_ReleaseResource
@
@	Argument
@
	.globl	ReleaseResource
ReleaseResource:
	mov	r4, sp
	svc	#SST_ReleaseResource
	bx	lr


@
@	_ssf_ReleaseResource
@
@	Argument
@
	.globl	_ssf_ReleaseResource
_ssf_ReleaseResource:
	ldr	r2, =__start_sbt

	@ ID のチェック
	ldr	r1, =__start_sit
	ldrb	r1, [r1, #u1_sit_rscnum]

	cmp	r0, r1
	bgt	.err_e_os_id_ReleaseResource

	cmp	r0, #0
	ble	.err_e_os_id_ReleaseResource

	ldrh	r1, [r2, #u2_sbt_runtsk]

	ldr	r7, =__start_tcb
	mov	r3, #SIZE_tcb
	mul	r3, r1, r3
	add	r3, r3, r7

	ldrb	r9, [r3, #u1_tcb_res]
	cmp	r9, #0
	beq	.err_e_os_nofunc_ReleaseResource

	ldr	r6, =__start_rcb
	mov	r5, #SIZE_rcb

	mul	r8, r0, r5
	add	r8, r8, r6
	ldr	r4, [r8, #u4_rcb_rid]
	cmp	r1, r4
	bne	.err_e_os_nofunc_ReleaseResource

.loop_rid_ReleaseResource:
	mov	r7, r9
	mul	r8, r7, r5
	add	r8, r8, r6
	ldr	r9, [r8, #u4_rcb_rid]
	cmp	r9, #0
	bne	.loop_rid_ReleaseResource

	cmp	r7, r0
	bne	.err_e_os_nofunc_ReleaseResource

	mov	r7, #0
	strb	r7, [r8, #u4_rcb_tid]

	ldrb	r9, [r3, #u1_tcb_res]

.loop_rid_clear_ReleaseResource:
	mov	r7, r9
	mul	r8, r7, r5
	add	r8, r8, r6
	ldr	r9, [r8, #u4_rcb_rid]
	cmp	r9, r0
	bne	.loop_rid_clear_ReleaseResource

	mov	r9, #0
	str	r9, [r8, #u4_rcb_rid]

	ldr	r10, =__start_rib
	mov	r11, #SIZE_rib

	ldrb	r9, [r3, #u1_tcb_res]
	mov	r4, #0

.loop_rid_ceilpri_ReleaseResource:
	mov	r7, r9
	mul	r8, r7, r11
	add	r8, r8, r10
	ldr	r9, [r8, #u1_rib_ceilpri]
	cmp	r9, r4
	ble	.next_search_ReleaseResource

	mov	r4, r9

.next_search_ReleaseResource:
	mul	r8, r7, r5
	add	r8, r8, r6
	ldr	r9, [r8, #u4_rcb_rid]
	cmp	r9, #0
	bne	.loop_rid_ceilpri_ReleaseResource

	ldrb	r8, [r3, #u1_ctcb_pri]
	cmp	r4, r8
	beq	.end_rdybuf_ope_ReleaseResource

	strb	r4, [r3, #u1_ctcb_pri]

	@ レディ・バッファ・アドレスを生成
	mov	r4, #SIZE_rdybuf
	mul	r4, r8, r4
	ldr	r5, =__start_rdybuf
	add	r5, r5, r4

	@ レディ・バッファからタスクID をロード
	ldrh	r4, [r5, #u2_rdybuf_ridx]
	ldr	r7, [r5, #pu4_rdybuf_rdybuf]
	lsl	r4, r4, #1
	add	r7, r7, r4
	ldrh	r7, [r7, #0]

	lsr	r4, r4, #1
	ldr	r6, [r5, #u4_rdybuf_bufsize]
	add	r4, r4, #1
	cmp	r4, r6
	blt	.rdybuf_ridx_str_ReleaseResource

	mov	r4, #0

.rdybuf_ridx_str_ReleaseResource:
	strh	r4, [r5, #u2_rdybuf_ridx]
	ldrh	r6, [r5, #u2_rdybuf_widx]
	cmp	r4, r6
	bne	.end_primap_clear

	ldr	r6, [r2, #u4_sbt_primap]
	mov	r4, #1
	lsl	r4, r4, r8

	mvn	r4, r4
	and	r6, r6, r4

	str	r6, [r2, #u4_sbt_primap]

.end_primap_clear:
	ldrb	r6, [r2, #u1_sbt_sch_ena]
	and	r6, r6, #~SBT_sch_ena_ENA
	strb	r6, [r2, #u1_sbt_sch_ena]

.end_rdybuf_ope_ReleaseResource:
	ldrb	r9, [r3, #u1_tcb_res]
	cmp	r0, r9
	bne	.err_e_ok_ReleaseResource

	mov	r9, #0
	strb	r9, [r3, #u1_tcb_res]

.err_e_ok_ReleaseResource:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_os_id_ReleaseResource:
	mov	r0, #E_OS_ID
	b	__ServiceCallExit

.err_e_os_nofunc_ReleaseResource:
	mov	r0, #E_OS_NOFUNC
	b	__ServiceCallExit
