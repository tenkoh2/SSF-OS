@
@	Stupid, Slow and Fat OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2

	.globl	PreTaskHook
PreTaskHook:
	bx	lr
