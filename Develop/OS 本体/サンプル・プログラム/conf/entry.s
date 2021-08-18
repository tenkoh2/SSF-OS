	.text
	.align	2

	.extern	_start
	.extern	__ServiceCallEntry
	.globl	__kernel_vector
__kernel_vector:
	ldr	pc, _vector_Reset		@ ���Z�b�g�E�x�N�^
	ldr	pc, _vector_Undef		@ ����`��O
	ldr	pc, _vector_SVC			@ �X�[�p�E�o�C�U�E�R�[����O
	ldr	pc, _vector_PreFe		@ �v���t�F�b�`�E�A�{�[�g��O
	ldr	pc, _vector_Data		@ �f�[�^�E�A�{�[�g��O
	ldr	pc, _vector_Reserved		@ �\��
	ldr	pc, _vector_IRQ			@ IRQ ���荞��
	ldr	pc, _vector_FIQ			@ FIQ ���荞��

_illegal_ope:
	b	_illegal_ope

_vector_Reset:
	.word	_start

_vector_Undef:
	.word	_illegal_ope

_vector_SVC:
	.word	__ServiceCallEntry

_vector_PreFe:
	.word	_illegal_ope

_vector_Data:
	.word	_illegal_ope

_vector_Reserved:
	.word	_illegal_ope

_vector_IRQ:
	.word	__kernel_intentry

_vector_FIQ:
	.word	_illegal_ope

	.globl	__vector_end
__vector_end:
	mov	r0, r0
