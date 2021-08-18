	.bss
	.align	8

	.globl	__stack_system
__stack_system_top:
	.skip	0x400
__stack_system:

	.globl	__stack_svc
__stack_svc_tp:
	.skip	0x400
__stack_svc:

	.globl	__stack_user
__stack_user_top:
	.skip	0x400
__stack_user:

	.globl	__stack_fiq
__stack_fiq_top:
	.skip	0x400
__stack_fiq:

	.globl	__stack_irq
__stack_irq_top:
	.skip	0x400
__stack_irq:

	.globl	__stack_abort
__stack_abort_top:
	.skip	0x400
__stack_abort:

	.globl	__stack_undefine
__stack_undefine_top:
	.skip	0x400
__stack_undefine:

	.globl	__stack_taskM1
__stack_taskM1_top:
	.skip	0x100
__stack_taskM1:

	.globl	__stack_taskL1
__stack_taskL1_top:
	.skip	0x100
__stack_taskL1:

	.globl	__stack_ctaskM1
__stack_ctaskM1_top:
	.skip	0x100
__stack_ctaskM1:

	.globl	__stack_ctaskL1
__stack_ctaskL1_top:
	.skip	0x100
__stack_ctaskL1:
