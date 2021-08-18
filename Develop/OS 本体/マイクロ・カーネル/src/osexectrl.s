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
@	_GetActiveApplicationMode
@
@	Argument
@
	.globl	GetActiveApplicationMode
GetActiveApplicationMode:
	mov	r4, sp
	svc	#SST_GetActiveApplicationMode
	bx	lr


@
@	_ssf_GetActiveApplicationMode
@
@	Argument
@
	.globl	_ssf_GetActiveApplicationMode
_ssf_GetActiveApplicationMode:
	ldr	r2, =__start_sbt
	ldr	r0, [r2, #u4_sbt_appmode]

	b	__ServiceCallExit


@
@	_ShutdownOS
@
@	Argument
@
	.globl	ShutdownOS
ShutdownOS:
	mov	r4, sp
	svc	#SST_ShutdownOS
	bx	lr


@
@	_ssf_ShutdownOS
@
@	Argument
@
	.globl	_ssf_ShutdownOS
_ssf_ShutdownOS:
	ldr	r2, =__start_sbt
	ldrh	r1, [r2, #u2_sbt_syssts]
	and	r1, r1, #~SS_ALL
	orr	r1, r1, #SS_SDHOOK
	strh	r1, [r2, #u2_sbt_syssts]

	bl	ShutdownHook

	ldrh	r1, [r2, #u2_sbt_syssts]
	and	r1, r1, #~SS_SDHOOK
	strh	r1, [r2, #u2_sbt_syssts]

.shutdown:
	b	.shutdown
