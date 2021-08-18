@
@	Stupid, Slow and Fat OS
@	(C) 2020 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2

	.globl	ErrorHook
ErrorHook:
	bx	lr
