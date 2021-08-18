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
	@ 復帰先と使用レジスタをスタックに積む
	push	{lr}
	stmfd	sp!, {r4-r5}

	@ 割り込みからサービス・コールが呼ばれているか？
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	ands	r5, r5, #SBT_sts_intnst_MASK
	bne	.from_interrupt

	@ TCB に現在のsp を保存
	ldrb	r4, [r4, #u2_sbt_runtsk]
	mov	r5, #SIZE_tcb
	mul	r5, r4, r5
	sub	r4, sp, #12
	str	sp, [r5, #pv4_tcb_stack]

.from_interrupt:
	@ レジスタを戻して呼び出し元に復帰
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
	@ 割り込み禁止
	msr	cpsr_c, #MASK_AIF

	@ スーパ・バイザ・モードのスタックに引数を積む
	stmfd	sp!, {r0-r3}

	@ 発行コンテキストを調べる
	ldr	r0, =__start_sbt
	ldrb	r3, [r0, #u1_sbt_sts]
	ands	r1, r3, #SBT_sts_intnst_MASK
	bne	.call_from_interrupt_svcent

	@ タスク・スタックに切り替え
@	cps	#MODE_USR
@	mov	r2, sp
	mov	r2, r4
@	cps	#MODE_SVC

	@ 発行コンテキストを調べる
	ldrh	r1, [r0, #u2_sbt_runtsk]
	cmp	r1, #0
	beq	.call_from_ctsk_svcent

	ldr	r0, =__start_tcb
	mov	r3, #SIZE_tcb
	mul	r3, r3, r1
	add	r3, r3, r0

	@ コンテキスト・セーブ
	mrs	r1, spsr
	str	r1, [r3, #u4_tcb_cpsr]
	stmfd	r2!, {r4-r12, lr}
	str	r2, [r3, #pv4_tcb_stack]

.end_save_context:
	@ 引数復元
	ldmfd	sp!, {r0-r3}

	@ システム・レベルを加算
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	add	r5, r5, #SBT_sts_syslvl
	strb	r5, [r4, #u1_sbt_sts]

	@ サービス・コール本体処理のアドレスを取得
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

	@ サービス・コール出口処理のアドレスを設定
	ldr	lr, =__ServiceCallExit

	@ サービス・コール本体処理に分岐
	bx	r4

.call_from_interrupt_svcent:
	@ 割り込みスタックに切り替え
@	cps	#MODE_IRQ
@	mov	r2, sp
	mov	r2, r4
@	cps	#MODE_SVC

	@ コンテキスト・セーブ
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

	@ コンテキスト・セーブ
	mrs	r1, spsr
	str	r1, [r3, #u4_ctcb_cpsr]
	stmfd	r2!, {r4-r12, lr}
	str	r2, [r3, #pv4_ctcb_stack]

	b	.end_save_context


	.globl	__ServiceCallExit
__ServiceCallExit:
	@ 発行コンテキストを調べる
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	ands	r5, r5, #SBT_sts_intnst_MASK
	bne	.call_from_interrupt_svcext

	@ 発行コンテキストを調べる
	ldrh	r5, [r4, #u2_sbt_runtsk]
	cmp	r5, #0
	beq	.call_from_ctsk_svcext

	ldr	r2, =__start_tcb
	mov	r3, #SIZE_tcb
	mul	r3, r3, r5
	add	r3, r3, r2

	@ システム・レベルを減算
	ldrb	r5, [r4, #u1_sbt_sts]
	subs	r5, r5, #SBT_sts_syslvl
	strb	r5, [r4, #u1_sbt_sts]

	bleq	__Scheduler

	@ コンテキスト・ロード
	mov	r4, #0
	ldr	r2, [r3, #pv4_tcb_stack]
	str	r4, [r3, #pv4_tcb_stack]
	ldmfd	r2!, {r4-r12, lr}
	ldr	r5, [r3, #u4_tcb_cpsr]
	msr	spsr, r5

	mov	r3, r14

	@ タスク・スタックに切り替え
	cps	#MODE_USR
	mov	sp, r2

	mov	pc, r3

.call_from_interrupt_svcext:
	@ システム・レベルを減算
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	sub	r5, r5, #SBT_sts_syslvl
	strb	r5, [r4, #u1_sbt_sts]

	@ コンテキスト・ロード
	mov	r3, #0
	ldr	r2, [r4, #pv4_sbt_sysstk]
	str	r3, [r4, #pv4_sbt_sysstk]
	ldmfd	r2!, {r4-r12, lr}
	ldr	r3, [r4, #u4_sbt_cpsr]
	msr	spsr, r3

	mov	r3, r14

	@ 割り込みスタックに切り替え
	cps	#MODE_IRQ
	mov	sp, r2

	movs	pc, r3

.call_from_ctsk_svcext:
	ldrh	r5, [r4, #u2_sbt_runctsk]
	ldr	r2, =__start_ctcb
	mov	r6, #SIZE_ctcb
	mul	r6, r6, r5
	add	r6, r6, r2

	@ システム・レベルを減算
	ldr	r4, =__start_sbt
	ldrb	r5, [r4, #u1_sbt_sts]
	subs	r5, r5, #SBT_sts_syslvl
	strb	r5, [r4, #u1_sbt_sts]

	bleq	__Scheduler

	@ コンテキスト・ロード
	mov	r3, #0
	ldr	r2, [r6, #pv4_ctcb_stack]
	str	r3, [r6, #pv4_ctcb_stack]
	ldmfd	r2!, {r4-r12, lr}
	ldr	r3, [r6, #u4_ctcb_cpsr]
	msr	spsr, r3

	mov	r3, r14

	@ タスク・スタックに切り替え
	cps	#MODE_USR
	mov	sp, r2

	mov	pc, r3
