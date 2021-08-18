@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__ServiceCallExit


@
@	_get_tid
@
@	Argument
@
	.globl	get_tid
get_tid:
	mov	r4, sp
	svc	#SST_get_tid
	bx	lr


@
@	_ssf_get_tid
@
@	Argument
@
	.globl	_ssf_get_tid
_ssf_get_tid:
	cmp	r0, #0
	beq	.err_e_par_get_tid

	ldr	r2, =__start_sbt
	ldrh	r1, [r2, #u2_sbt_runctsk]
	str	r1, [r0, #0]

	mov	r0, #E_OK
	b	__ServiceCallExit

.err_e_par_get_tid:
	mov	r0, #E_PAR
	b	__ServiceCallExit


@
@	_loc_cpu
@
@	Argument
@
	.globl	loc_cpu
loc_cpu:
	mov	r4, sp
	svc	#SST_loc_cpu
	bx	lr


@
@	_ssf_loc_cpu
@
@	Argument
@
	.globl	_ssf_loc_cpu
_ssf_loc_cpu:
	ldr	r2, =__start_sbt

	mrs	r0, spsr
	str	r0, [r2, #u4_sbt_intsts]
	and	r0, r0, #~MASK_IF
	msr	spsr, r0

	ldrb	r0, [r2, #u1_sbt_sts]
	orr	r0, r0, #SBT_sts_disdsp
	strb	r0, [r2, #u1_sbt_sts]

	ldrh	r0, [r2, #u2_sbt_syssts]
	orr	r0, r0, #SS_LOCCPU
	strh	r0, [r2, #u2_sbt_syssts]

	mov	r0, #E_OK
	b	__ServiceCallExit


@
@	_unl_cpu
@
@	Argument
@
	.globl	unl_cpu
unl_cpu:
	mov	r4, sp
	svc	#SST_unl_cpu
	bx	lr


@
@	_ssf_unl_cpu
@
@	Argument
@
	.globl	_ssf_unl_cpu
_ssf_unl_cpu:
	ldr	r2, =__start_sbt

	ldrb	r0, [r2, #u1_sbt_sts]
	and	r0, r0, #~SBT_sts_disdsp
	strb	r0, [r2, #u1_sbt_sts]

	ldrh	r0, [r2, #u2_sbt_syssts]
	and	r0, r0, #~SS_LOCCPU
	strh	r0, [r2, #u2_sbt_syssts]

	ldr	r0, [r2, #u4_sbt_intsts]
	msr	spsr, r0

	mov	r0, #E_OK
	b	__ServiceCallExit


@
@	_dis_dsp
@
@	Argument
@
	.globl	dis_dsp
dis_dsp:
	mov	r4, sp
	svc	#SST_dis_dsp
	bx	lr


@
@	_ssf_dis_dsp
@
@	Argument
@
	.globl	_ssf_dis_dsp
_ssf_dis_dsp:
	ldr	r2, =__start_sbt

	ldrb	r0, [r2, #u1_sbt_sts]
	orr	r0, r0, #SBT_sts_disdsp
	strb	r0, [r2, #u1_sbt_sts]

	ldrh	r0, [r2, #u2_sbt_syssts]
	orr	r0, r0, #SS_DISDSP
	strh	r0, [r2, #u2_sbt_syssts]

	mov	r0, #E_OK
	b	__ServiceCallExit


@
@	_ena_dsp
@
@	Argument
@
	.globl	ena_dsp
ena_dsp:
	mov	r4, sp
	svc	#SST_ena_dsp
	bx	lr


@
@	_ssf_ena_dsp
@
@	Argument
@
	.globl	_ssf_ena_dsp
_ssf_ena_dsp:
	ldr	r2, =__start_sbt

	ldrb	r0, [r2, #u1_sbt_sts]
	and	r0, r0, #~SBT_sts_disdsp
	strb	r0, [r2, #u1_sbt_sts]

	ldrh	r0, [r2, #u2_sbt_syssts]
	and	r0, r0, #~SS_DISDSP
	strh	r0, [r2, #u2_sbt_syssts]

	mov	r0, #E_OK
	b	__ServiceCallExit


@
@	_sns_ctx
@
@	Argument
@
	.globl	sns_ctx
sns_ctx:
	mov	r4, sp
	svc	#SST_sns_ctx
	bx	lr


@
@	_ssf_sns_ctx
@
@	Argument
@
	.globl	_ssf_sns_ctx
_ssf_sns_ctx:
	ldr	r2, =__start_sbt

	mov	r0, #FALSE

	ldrb	r1, [r2, #u1_sbt_sts]
	ands	r1, r1, #(SBT_sts_syslvl_MASK | SBT_sts_intnst_MASK)
	beq	.return_sns_ctx

	mov	r0, #TRUE

.return_sns_ctx:
	b	__ServiceCallExit


@
@	_sns_loc
@
@	Argument
@
	.globl	sns_loc
sns_loc:
	mov	r4, sp
	svc	#SST_sns_loc
	bx	lr


@
@	_ssf_sns_loc
@
@	Argument
@
	.globl	_ssf_sns_loc
_ssf_sns_loc:
	ldr	r2, =__start_sbt

	mov	r0, #FALSE

	ldrb	r1, [r2, #u2_sbt_syssts]
	and	r1, r1, #SS_LOCCPU
	cmp	r1, #SS_LOCCPU
	bne	.return_sns_loc

	mov	r0, #TRUE

.return_sns_loc:
	b	__ServiceCallExit


@
@	_sns_dsp
@
@	Argument
@
	.globl	sns_dsp
sns_dsp:
	mov	r4, sp
	svc	#SST_sns_dsp
	bx	lr


@
@	_ssf_sns_dsp
@
@	Argument
@
	.globl	_ssf_sns_dsp
_ssf_sns_dsp:
	ldr	r2, =__start_sbt

	mov	r0, #FALSE

	ldrb	r1, [r2, #u2_sbt_syssts]
	and	r1, r1, #SS_LOCCPU
	cmp	r1, #SS_DISDSP
	bne	.return_sns_dsp

	mov	r0, #TRUE

.return_sns_dsp:
	b	__ServiceCallExit


@
@	_sns_dpn
@
@	Argument
@
	.globl	sns_dpn
sns_dpn:
	mov	r4, sp
	svc	#SST_sns_dpn
	bx	lr


@
@	_ssf_sns_dpn
@
@	Argument
@
	.globl	_ssf_sns_dpn
_ssf_sns_dpn:
	ldr	r2, =__start_sbt

	mov	r0, #FALSE

	ldrb	r1, [r2, #u2_sbt_syssts]
	ands	r1, r1, #SS_LOCCPU
	beq	.return_sns_dpn

	mov	r0, #TRUE

.return_sns_dpn:
	b	__ServiceCallExit
