@
@	F-OS
@	(C) 2019 Fukuda, Kouji
@

.include	"kernel.inc"

	.text
	.align	2

@
@	Argument
@	r4 :	Task ID (Queue Top)
@	r5 :	Task ID (Self Task)
@	r6 :	Object's wait task address
@	lr :	Return address
@
	.globl	__que_search
__que_search:
	mov	r7, #SIZE_ctcb
	ldr	r8, =__start_ctcb
	mul	r10, r5, r7
	add	r10, r10, r8

	cmp	r4, #0
	beq	.reload_quetop_que_search

	mov	r3, #0
	ldrb	r12, [r10, #u1_ctcb_pri]

.loop_que_search:
	mul	r9, r4, r7
	add	r9, r9, r8
	ldrb	r11, [r9,  #u1_ctcb_pri]
	cmp	r11, r12
	bgt	.end_search_que_search

	ldr	r2, [r9, #u4_ctcb_next]
	add	r3, r3, #1

	cmp	r2, r4
	mov	r4, r2
	bne	.loop_que_search

.end_search_que_search:
	str	r5, [r9, #u4_ctcb_next]
	mul	r9, r4, r7
	add	r9, r9, r8
	str	r5, [r9, #u4_ctcb_prev]

	cmp	r3, #0
	beq	.reload_quetop_top_que_search

	bx	lr

.reload_quetop_que_search:
	str	r5, [r10, #u4_ctcb_prev]
	str	r5, [r10, #u4_ctcb_next]

.reload_quetop_top_que_search:
	str	r5, [r6, #0]

	bx	lr


@
@	Argument
@	r6 :	Task ID
@	lr :	Return address
@
@	Return
@	r1 :	Task Pri
@
	.globl	__del_waique
__del_waique:
	mov	r7, #SIZE_ctcb
	ldr	r5, =__start_ctcb

	mul	r0,  r6, r7
	add	r0,  r0, r5
	mov	r10, #0
	ldr	r8,  [r0, #u4_ctcb_next]
	ldr	r9,  [r0, #u4_ctcb_prev]
	ldrb	r1,  [r0, #u1_ctcb_pri]
	str	r10, [r0, #u4_ctcb_next]
	str	r10, [r0, #u4_ctcb_prev]

	cmp	r6, r8
	beq	.reload_que_top_del_waique

	mul	r6, r8, r7
	add	r6, r6, r5
	str	r9, [r6, #u4_ctcb_prev]
	mul	r6, r9, r7
	add	r6, r6, r5
	str	r8, [r6, #u4_ctcb_next]

	mov	r10, r8

.reload_que_top_del_waique:
	str	r10, [r3, #u4_semctrl_wtskid]

	bx	lr


@
@	Argument
@	r6 :	Task ID
@	lr :	Return address
@
	.globl	__del_timque
__del_timque:
	mov	r10, #SIZE_ctcb
	ldr	r5, =__start_ctcb
	mul	r3, r6, r10
	add	r3, r3, r5

	lsl	r10, r6, #16

	ldr	r4, [r3, #u4_ctcb_tprev]
	cmp	r4, r10
	bxeq	lr

	mov	r6, #0
	ldr	r8,  [r3, #u4_ctcb_tnext]
	ldr	r9,  [r3, #u4_ctcb_tprev]
	str	r6,  [r3, #u4_ctcb_tnext]
	str	r6,  [r3, #u4_ctcb_tprev]

	cmp	r4, r8
	beq	.reload_timque_top_del_timque

	mul	r6, r8, r10
	add	r6, r6, r5
	str	r9, [r6, #u4_ctcb_tprev]
	mul	r6, r9, r10
	add	r6, r6, r5
	str	r8, [r6, #u4_ctcb_tnext]

	mov	r6, r8

.reload_timque_top_del_timque:
	ldr	r3, =__start_timerque_head
	str	r6, [r3, #0]

	bx	lr
