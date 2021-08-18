@
@	F-OS
@	(C) 2019 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2
	.extern	__start_sbt
	.extern	__start_tcb
	.extern	__start_ctcb
	.extern	__start_SVC_TBL

	.globl	__ServiceCallEntryTaskLevel
__ServiceCallEntryTaskLevel:
	@ ���A��Ǝg�p���W�X�^���X�^�b�N�ɐς�
	push	{lr}
	stmfd	sp!, {r4-r5}

	@ ���荞�݂���T�[�r�X�E�R�[�����Ă΂�Ă��邩�H
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	ands	r5, r5, #SBT_sts_intnst_MASK
	bne	.from_interrupt

	@ TCB �Ɍ��݂�sp ��ۑ�
	ldrb	r4, [r4, #u2_sbt_runtsk]
	mov	r5, #SIZE_tcb
	mul	r5, r4, r5
	sub	r4, sp, #12
	str	sp, [r5, #pv4_tcb_stack]

.from_interrupt:
	@ ���W�X�^��߂��ČĂяo�����ɕ��A
	ldmfd	sp!, {r4-r5}
	pop	{lr}
	bx	lr


@
@	Argument
@	r0   :	Service Call Arg
@	r1   :	Service Call Arg
@	r2   :	Service Call Arg
@	r3   :	Srevice Call Arg
@	[sp] :	lr
@
	.globl	__ServiceCallEntry
__ServiceCallEntry:
	@ ���荞�݋֎~
	msr	cpsr_c, #MASK_AIF

	@ �X�[�p�E�o�C�U�E���[�h�̃X�^�b�N�Ɉ�����ς�
	stmfd	sp!, {r0-r3}

	@ ���s�R���e�L�X�g�𒲂ׂ�
	ldr	r0, =__start_sbt
	ldrb	r3, [r0, #u1_sbt_sts]
	ands	r1, r3, #SBT_sts_intnst_MASK
	bne	.call_from_interrupt_svcent

	@ �^�X�N�E�X�^�b�N�ɐ؂�ւ�
@	cps	#MODE_USR
@	mov	r2, sp
	mov	r2, r4
@	cps	#MODE_SVC

	@ ���s�R���e�L�X�g�𒲂ׂ�
	ldrh	r1, [r0, #u2_sbt_runtsk]
	cmp	r1, #0
	beq	.call_from_ctsk_svcent

	ldr	r0, =__start_tcb
	mov	r3, #SIZE_tcb
	mul	r3, r3, r1
	add	r3, r3, r0

	@ �R���e�L�X�g�E�Z�[�u
	mrs	r1, spsr
	str	r1, [r3, #u4_tcb_cpsr]
	stmfd	r2!, {r4-r12, lr}
	str	r2, [r3, #pv4_tcb_stack]

.end_save_context:
	@ ��������
	ldmfd	sp!, {r0-r3}

	@ �V�X�e���E���x�������Z
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	add	r5, r5, #SBT_sts_syslvl
	strb	r5, [r4, #u1_sbt_sts]

	@ �T�[�r�X�E�R�[���{�̏����̃A�h���X���擾
	mrs	r4, spsr
	tst	r4, #T_bit
	ldrneh	r4, [lr,#-2]
	bicne	r4, r4, #0xff00
	ldreq	r4, [lr,#-4]
	biceq	r4, r4, #0xff000000

	ldr	r5, =__start_SVC_TBL
	lsl	r4, #2
	add	r4, r4, r5
	ldr	r4, [r4, #0]

	@ �T�[�r�X�E�R�[���o�������̃A�h���X��ݒ�
	ldr	lr, =__ServiceCallExit

	@ �T�[�r�X�E�R�[���{�̏����ɕ���
	bx	r4

.call_from_interrupt_svcent:
	@ ���荞�݃X�^�b�N�ɐ؂�ւ�
@	cps	#MODE_IRQ
@	mov	r2, sp
	mov	r2, r4
@	cps	#MODE_SVC

	@ �R���e�L�X�g�E�Z�[�u
	mrs	r1, spsr
	str	r1, [r0, #u4_sbt_cpsr]
	stmfd	r2!, {r4-r12, lr}
	str	r2, [r0, #pv4_sbt_sysstk]

	b	.end_save_context

.call_from_ctsk_svcent:
	ldrh	r1, [r0, #u2_sbt_runctsk]

	ldr	r0, =__start_ctcb
	mov	r3, #SIZE_ctcb
	mul	r3, r3, r1
	add	r3, r3, r0

	@ �R���e�L�X�g�E�Z�[�u
	mrs	r1, spsr
	str	r1, [r3, #u4_ctcb_cpsr]
	stmfd	r2!, {r4-r12, lr}
	str	r2, [r3, #pv4_ctcb_stack]

	b	.end_save_context


	.globl	__ServiceCallExit
__ServiceCallExit:
	@ ���s�R���e�L�X�g�𒲂ׂ�
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	ands	r5, r5, #SBT_sts_intnst_MASK
	bne	.call_from_interrupt_svcext

	@ ���s�R���e�L�X�g�𒲂ׂ�
	ldrh	r5, [r4, #u2_sbt_runtsk]
	cmp	r5, #0
	beq	.call_from_ctsk_svcext

	ldr	r2, =__start_tcb
	mov	r3, #SIZE_tcb
	mul	r3, r3, r5
	add	r3, r3, r2

	@ �V�X�e���E���x�������Z
	ldrb	r5, [r4, #u1_sbt_sts]
	subs	r5, r5, #SBT_sts_syslvl
	strb	r5, [r4, #u1_sbt_sts]

	bleq	__Scheduler

	@ �R���e�L�X�g�E���[�h
	mov	r4, #0
	ldr	r2, [r3, #pv4_tcb_stack]
	str	r4, [r3, #pv4_tcb_stack]
	ldmfd	r2!, {r4-r12, lr}
	ldr	r5, [r3, #u4_tcb_cpsr]
	msr	spsr, r5

	mov	r3, r14

	@ �^�X�N�E�X�^�b�N�ɐ؂�ւ�
	cps	#MODE_USR
	mov	sp, r2

	mov	pc, r3

.call_from_interrupt_svcext:
	@ �V�X�e���E���x�������Z
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	sub	r5, r5, #SBT_sts_syslvl
	strb	r5, [r4, #u1_sbt_sts]

	@ �R���e�L�X�g�E���[�h
	mov	r3, #0
	ldr	r2, [r4, #pv4_sbt_sysstk]
	str	r3, [r4, #pv4_sbt_sysstk]
	ldmfd	r2!, {r4-r12, lr}
	ldr	r3, [r4, #u4_sbt_cpsr]
	msr	spsr, r3

	mov	r3, r14

	@ ���荞�݃X�^�b�N�ɐ؂�ւ�
	cps	#MODE_IRQ
	mov	sp, r2

	movs	pc, r3

.call_from_ctsk_svcext:
	ldrh	r5, [r4, #u2_sbt_runctsk]
	ldr	r2, =__start_ctcb
	mov	r6, #SIZE_ctcb
	mul	r6, r6, r5
	add	r6, r6, r2

	@ �V�X�e���E���x�������Z
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	subs	r5, r5, #SBT_sts_syslvl
	strb	r5, [r4, #u1_sbt_sts]

	bleq	__Scheduler

	@ �R���e�L�X�g�E���[�h
	mov	r3, #0
	ldr	r2, [r6, #pv4_ctcb_stack]
	str	r3, [r6, #pv4_ctcb_stack]
	ldmfd	r2!, {r4-r12, lr}
	ldr	r3, [r6, #u4_ctcb_cpsr]
	msr	spsr, r3

	mov	r3, r14

	@ �^�X�N�E�X�^�b�N�ɐ؂�ւ�
	cps	#MODE_USR
	mov	sp, r2

	mov	pc, r3
