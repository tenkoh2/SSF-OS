	.text
	.align	2

	.extern	_start
	.extern	__ServiceCallEntry
	.globl	__kernel_vector
__kernel_vector:
	ldr	pc, _vector_Reset		@ リセット・ベクタ
	ldr	pc, _vector_Undef		@ 未定義例外
	ldr	pc, _vector_SVC			@ スーパ・バイザ・コール例外
	ldr	pc, _vector_PreFe		@ プリフェッチ・アボート例外
	ldr	pc, _vector_Data		@ データ・アボート例外
	ldr	pc, _vector_Reserved		@ 予約
	ldr	pc, _vector_IRQ			@ IRQ 割り込み
	ldr	pc, _vector_FIQ			@ FIQ 割り込み

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
