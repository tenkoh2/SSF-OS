@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_sit
	.extern	__start_cycque_head
	.extern	__ServiceCallExit


@
@	_sta_cyc
@
@	Argument
@
	.globl	sta_cyc
sta_cyc:
	mov	r4, sp
	svc	#SST_sta_cyc
	bx	lr


@
@	_ssf_sta_cyc
@
@	Argument
@
	.globl	_ssf_sta_cyc
_ssf_sta_cyc:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_cycnum]

	cmp	r0, r3
	bgt	.err_e_id_sta_cyc

	cmp	r0, #0
	ble	.err_e_id_sta_cyc

	mov	r3, #SIZE_cycinf
	ldr	r4, =__start_cycinf
	mul	r3, r0, r3
	add	r3, r3, r4

	mov	r4, #SIZE_cycctrl
	ldr	r5, =__start_cycctrl
	mul	r4, r0, r4
	add	r4, r4, r5

	ldrh	r5, [r4, #u2_cycctrl_sts]
	ands	r6, r5, #TCYC_STA
	bne	.reload_cyctim_sta_cyc

	ldrb	r5, [r3, #u1_cycinf_cycatr]
	ldr	r7, [r3, #u4_cycinf_cyctim]

	ands	r6, r5, #TA_PHS
	beq	.set_phs_sta_cyc

	ldr	r7, [r3, #u4_cycinf_cycphs]

.set_phs_sta_cyc:
	str	r7, [r4, #u4_cycctrl_cyctim]

	ldr	r5, =__start_cycque_head

	ldr	r6, [r5, #0]
	cmp	r6, #0
	bne	.reg_cycque_sta_cyc

	str	r0, [r5, #0]
	str	r0, [r4, #u4_cycctrl_prev]
	str	r0, [r4, #u4_cycctrl_next]

	b	.err_e_ok_sta_cyc

.reg_cycque_sta_cyc:
	mov	r4, #SIZE_cycctrl
	ldr	r5, =__start_cycctrl
	mul	r7, r6, r4
	add	r7, r7, r5

	ldr	r8, [r7, #u4_cycctrl_prev]
	str	r0, [r7, #u4_cycctrl_prev]
	str	r8, [r4, #u4_cycctrl_prev]

	mul	r7, r8, r4
	add	r7, r7, r5

	ldr	r8, [r7, #u4_cycctrl_next]
	str	r0, [r7, #u4_cycctrl_next]
	str	r8, [r4, #u4_cycctrl_next]

.err_e_ok_sta_cyc:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_sta_cyc:
	mov	r0, #E_ID
	b	__ServiceCallExit

.reload_cyctim_sta_cyc:
	ldrb	r5, [r3, #u1_cycinf_cycatr]
	ldr	r7, [r3, #u4_cycinf_cyctim]

	ands	r6, r5, #TA_PHS
	bne	.err_e_ok_sta_cyc

	str	r7, [r4, #u4_cycctrl_cyctim]

	b	.err_e_ok_sta_cyc


@
@	_stp_cyc
@
@	Argument
@
	.globl	stp_cyc
stp_cyc:
	mov	r4, sp
	svc	#SST_stp_cyc
	bx	lr


@
@	_ssf_stp_cyc
@
@	Argument
@
	.globl	_ssf_stp_cyc
_ssf_stp_cyc:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_cycnum]

	cmp	r0, r3
	bgt	.err_e_id_stp_cyc

	cmp	r0, #0
	ble	.err_e_id_stp_cyc

	mov	r3, #SIZE_cycctrl
	ldr	r4, =__start_cycctrl
	mul	r5, r0, r3
	add	r5, r5, r4

	ldrh	r6, [r5, #u2_cycctrl_sts]
	ands	r7, r6, #TCYC_STA
	beq	.err_e_ok_stp_cyc

	mov	r6, #0
	str	r6, [r5, #u4_cycctrl_cyctim]

	ldr	r6, [r5, #u4_cycctrl_prev]
	ldr	r7, [r5, #u4_cycctrl_next]

	mul	r8, r6, r3
	add	r8, r8, r4
	str	r7, [r8, #u4_cycctrl_next]

	mul	r8, r7, r3
	add	r8, r8, r4
	str	r6, [r8, #u4_cycctrl_prev]

	ldr	r8, =__start_cycque_head

	ldr	r9, [r8, #0]
	cmp	r9, r0
	bne	.err_e_ok_stp_cyc

	cmp	r0, r7
	beq	.reload_que_top_stp_cyc

	str	r7, [r8, #0]

.err_e_ok_stp_cyc:
	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_stp_cyc:
	mov	r0, #E_ID
	b	__ServiceCallExit

.reload_que_top_stp_cyc:
	mov	r9, #0
	str	r9, [r8, #0]
	str	r9, [r5, #u4_cycctrl_prev]
	str	r9, [r5, #u4_cycctrl_next]

	b	.err_e_ok_stp_cyc


@
@	_ref_cyc
@
@	Argument
@
	.globl	ref_cyc
ref_cyc:
	mov	r4, sp
	svc	#SST_ref_cyc
	bx	lr


@
@	_ssf_ref_cyc
@
@	Argument
@
	.globl	_ssf_ref_cyc
_ssf_ref_cyc:
	@ ID のチェック
	ldr	r3, =__start_sit
	ldrb	r3, [r3, #u1_sit_cycnum]

	cmp	r0, r3
	bgt	.err_e_id_ref_cyc

	cmp	r0, #0
	ble	.err_e_id_ref_cyc

	cmp	r1, #0
	beq	.err_e_par_ref_cyc

	mov	r3, #SIZE_cycctrl
	ldr	r4, =__start_cycctrl

	mul	r3, r0, r3
	add	r3, r3, r4

	ldrh	r4, [r3, #u2_cycctrl_sts]
	strb	r4, [r1, #u1_rcyc_cycstat]

	ldr	r4, [r3, #u4_cycctrl_cyctim]
	str	r4, [r1, #u4_rcyc_lefttim]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_id_ref_cyc:
	mov	r0, #E_ID
	b	__ServiceCallExit

.err_e_par_ref_cyc:
	mov	r0, #E_PAR
	b	__ServiceCallExit
