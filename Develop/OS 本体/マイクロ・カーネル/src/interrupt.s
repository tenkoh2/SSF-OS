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
@	_EnableAllInterrupts
@
@	Argument
@
	.globl	EnableAllInterrupts
EnableAllInterrupts:
	mov	r4, sp
	svc	#SST_EnableAllInterrupts
	bx	lr


@
@	_ssf_EnableAllInterrupts
@
@	Argument
@
	.globl	_ssf_EnableAllInterrupts
_ssf_EnableAllInterrupts:
	ldr	r2, =__start_sbt

	ldr	r0, [r2, #u4_sbt_disallmsk]
	msr	spsr, r0

	b	__ServiceCallExit


@
@	_DisableAllInterrupts
@
@	Argument
@
	.globl	DisableAllInterrupts
DisableAllInterrupts:
	mov	r4, sp
	svc	#SST_DisableAllInterrupts
	bx	lr


@
@	_ssf_DisableAllInterrupts
@
@	Argument
@
	.globl	_ssf_DisableAllInterrupts
_ssf_DisableAllInterrupts:
	ldr	r2, =__start_sbt

	mrs	r0, spsr
	str	r0, [r2, #u4_sbt_disallmsk]
	and	r0, r0, #~MASK_IF
	msr	spsr, r0

	b	__ServiceCallExit


@
@	_ResumeAllInterrupts
@
@	Argument
@
	.globl	ResumeAllInterrupts
ResumeAllInterrupts:
	mov	r4, sp
	svc	#SST_ResumeAllInterrupts
	bx	lr


@
@	_ssf_ResumeAllInterrupts
@
@	Argument
@
	.globl	_ssf_ResumeAllInterrupts
_ssf_ResumeAllInterrupts:
	ldr	r2, =__start_sbt

	ldrh	r0, [r2, #u2_sbt_susallcnt]
	cmp	r0, #0
	beq	.end_ResumeAllInterrupts

	subs	r0, #1
	bne	.end_resume_msk_ResumeAllInterrupts

	ldr	r1, [r2, #u4_sbt_idmsk]
	msr	spsr, r1

.end_resume_msk_ResumeAllInterrupts:
	strh	r0, [r2, #u2_sbt_susallcnt]

.end_ResumeAllInterrupts:
	b	__ServiceCallExit


@
@	_SuspnedAllInterrupts
@
@	Argument
@
	.globl	SuspendAllInterrupts
SuspendAllInterrupts:
	mov	r4, sp
	svc	#SST_SuspendAllInterrupts
	bx	lr


@
@	_ssf_SuspendAllInterrupts
@
@	Argument
@
	.globl	_ssf_SuspendAllInterrupts
_ssf_SuspendAllInterrupts:
	ldr	r2, =__start_sbt

	ldrh	r0, [r2, #u2_sbt_susallcnt]
	mov	r1, #0xffff
	cmp	r0, r1
	beq	.end_SuspendAllInterrupts

	cmp	r0, #0
	bne	.end_store_cpsr_SuspendAllInterrupts

	mrs	r1, spsr
	str	r1, [r2, #u4_sbt_idmsk]
	and	r1, r1, #~MASK_IF
	msr	spsr, r1

.end_store_cpsr_SuspendAllInterrupts:
	add	r0, #1
	strh	r0, [r2, #u2_sbt_susallcnt]

.end_SuspendAllInterrupts:
	b	__ServiceCallExit


@
@	_ResumeOSInterrupts
@
@	Argument
@
	.globl	ResumeOSInterrupts
ResumeOSInterrupts:
	mov	r4, sp
	svc	#SST_ResumeOSInterrupts
	bx	lr


@
@	_ssf_ResumeOSInterrupts
@
@	Argument
@
	.globl	_ssf_ResumeOSInterrupts
_ssf_ResumeOSInterrupts:
	ldr	r2, =__start_sbt

	ldrh	r0, [r2, #u2_sbt_susoscnt]
	cmp	r0, #0
	beq	.end_ResumeOSInterrupts

	subs	r0, #1
	bne	.end_resume_msk_ResumeOSInterrupts

	ldr	r1, [r2, #u4_sbt_intmsk]
	msr	spsr, r1

.end_resume_msk_ResumeOSInterrupts:
	strh	r0, [r2, #u2_sbt_susoscnt]

.end_ResumeOSInterrupts:
	b	__ServiceCallExit


@
@	SuspendOSInterrupt
@
@	Argument
@
	.globl	SuspnedOSInterrupts
SuspendOSInterrupts:
	mov	r4, sp
	svc	#SST_SuspendOSInterrupts
	bx	lr


@
@	_ssf_SuspendOSInterrupts
@
@	Argument
@
	.globl	_ssf_SuspendOSInterrupts
_ssf_SuspendOSInterrupts:
	ldr	r2, =__start_sbt

	ldrh	r0, [r2, #u2_sbt_susoscnt]
	mov	r1, #0xffff
	cmp	r0, r1
	beq	.end_SuspendOSInterrupts

	cmp	r0, #0
	bne	.end_store_cpsr_SuspendOSInterrupts

	mrs	r1, spsr
	str	r1, [r2, #u4_sbt_intmsk]
	and	r1, r1, #~MASK_IF
	msr	spsr, r1

.end_store_cpsr_SuspendOSInterrupts:
	add	r0, #1
	strh	r0, [r2, #u2_sbt_susoscnt]

.end_SuspendOSInterrupts:
	b	__ServiceCallExit
