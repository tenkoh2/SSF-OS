@
@	F-OS
@	(C) 2019 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.globl	__idle_task
__idle_task:
.loop:
	b	.loop
