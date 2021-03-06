@ startup
	.align	2
	.global	_start
_start:
	ldr	r0, =0x000000d3
	msr	cpsr, r0
	ldr	sp, =0x64000000

	mrc	p14, 0, r0, c2, c0, 0

	mov	r0, #0
	mcr	p15, 0, r0, c8, c7, 0
	mcr	p15, 0, r0, c7, c5, 6
	mcr	p15, 0, r0, c8, c7, 0
	mcr	p15, 0, r0, c7, c5, 6

	mov	r0, #0
	mcr	p15, 0, r0, c7, c5, 0
	mov	r10, #0
	mcr	p15, 2, r10, c0, c0, 0
@	isb
	mrc	p15, 1, r1, c0, c0, 0
	and	r2, r1, #7
	add	r2, r2, #4
	ldr	r4, =0x3FF
	ands	r4, r4, r1, lsr #3
	clz	r5, r4
	ldr	r7, =0x7FFF
	ands	r7, r7, r1, LSR #13

Loop2:
	mov	r9, r4
Loop3:
	orr	r11, r10, r9, lsl r5
	orr	r11, r11, r7, lsl r2
	mcr	p15, 0, r11, c7, c6, 2
	subs	r9, r9, #1
	bge	Loop3
	subs	r7, r7, #1
	bge	Loop2

	mcr	p15, 0, r0, c7, c5, 0

	mcr	p15, 2, r0, c0, c0, 0
	mcr	p15, 2, r0, c0, c0, 0
	mrc	p15, 1, r0, c0, c0, 0
	mcr	p15, 0, r0, c7, c6, 2
	mcr	p15, 0, r0, c10, c6, 2

	mcr	p15, 0, r0, c1, c0, 2
	orr	r0, r0, #(0xF << 20)
	mcr	p15, 0, r0, c1, c0, 2
@	isb
	mov	r0, #0x40000000
	vmsr	fpexc, r0

	mrc	p15, 0, r0, c1, c0, 2
	mcr	p15, 0, r0, c1, c0, 2

@==================================================================
@ TLBと分岐予測器アレイの無効化
@==================================================================
	mov	r0, #0				@ 初期値を設定
	mcr	p15, 0, r0, c8, c7, 0		@ TLB全体無効化
	mcr	p15, 0, r0, c7, c5, 6		@ 分岐予測器アレイ無効化

	mcr	p15, 0, r1, c8, c7, 0		@ TLB全体無効化の書き込み

	mcr	p15, 0, r1, c7, c5, 6		@ 分岐予測器アレイ全体無効化の書き込み

	mov	r0, #0				@ 初期値を設定
	mcr	p15, 0, r0, c7, c5, 0		@ 命令キャッシュ全体の無効化

@
@	データキャッシュの無効化を行います。
@
	mov	r10, #0				@ データキャッシュを選択
	mcr	p15, 2, r10, c0, c0, 0		@ キャッシュサイズ選択レジスタ（CSSELR）でデータキャッシュを選択
@	isb					  命令同期バリア命令で再フェッチ
	mrc	p15, 1, r1, c0, c0, 0		@ CCSIDRを読み込み
	and	r2, r1, #7			@ キャッシュラインサイズを取得（b001=8ワード/ライン）
	add	r2, r2, #4			@ DCISWレジスタのセット番号のシフト数を求める
	ldr	r4, =0x3FF			@ 最大ウェイ数マスク設定値を設定
	ands	r4, r4, r1, LSR #3		@ r4レジスタにウェイ数を設定
	clz	r5, r4				@ DCISWレジスタのウェイ番号のシフト数を求める
	ldr	r7, =0x7FFF			@ セット数マスク設定値を設定
	ands	r7, r7, r1, LSR #13		@ r7レジスタにセット数を設定
						@ 0x7F=12Kbyte/0xFF=32Kbyte/0x1FF=64Kbyte

Loop4:
	mov	r9, r4				@ r9レジスタにウェイ数を設定
Loop5:
	orr	r11, r10, r9, LSL r5		@ ウェイ番号とキャッシュ番号を設定
	orr	r11, r11, r7, LSL r2		@ セット番号を設定
	mcr	p15, 0, r11, c7, c6, 2		@ DCISWレジスタでセット/ウェイによるデータキャッシュラインの無効化
	subs	r9, r9, #1			@ ウェイ番号を-1
	bge	Loop5				@ ウェイ毎の初期化を実施
	subs	r7, r7, #1			@ セット番号を-1
	bge	Loop4				@ セット毎の初期化を実施

	mcr	p15, 0, r1, c7, c5, 0		@ ICIALLUの書き込み

	mcr	p15, 2, r1, c0, c0, 0		@ CSSELR読み込み
	mcr	p15, 2, r1, c0, c0, 0		@ CSSELR書き込み

	mrc	p15, 1, r1, c0, c0, 0		@ CCSIDR読み込み

	mcr	p15, 0, r1, c7, c6, 2		@ セット/ウェイによるデータキャッシュ無効化の書き込み

	mcr	p15, 0, r1, c10, c6, 2		@ セット/ウェイによるデータキャッシュのクリーンの書き込み


@=====================================================================
@ NEON/VFPのアクセス許可
@ CP10/CP11の完全アクセス設定
@=====================================================================
	mrc	p15, 0, r0, c1, c0, 2		@ CPACRを読み込み
	orr	r0, r0, #(0xF << 20)		@ CP10/CP11完全アクセス設定
	mcr	p15, 0, r0, c1, c0, 2		@ CPACRを書き込み
@	isb					  命令同期バリアで再フェッチ

@=====================================================================
@ VFPをNEON動作開始
@=====================================================================
	mov	r0, #0x40000000
	vmsr	FPEXC, r0			@ 浮動小数点例外レジスタでENビットを書き込み

	mrc	p15, 0, r1, c1, c0, 2		@ CPACR読み込み
	mcr	p15, 0, r1, c1, c0, 2		@ CPACR書き込み

@	vmrs	R1, extsysreg			  NEON/VFPレジスタからArmレジスタの読み込み
@	vmsr	extsysreg, R1			  ArmレジスタからNEON/VFPレジスタの書き込み

@===================================================================
@ VBARを使用して、ベクタアドレスを変更
@===================================================================
@	ldr	r0,=Vectors
@	mcr	p15, 0, r0, c12, c0, 0

	mrc	p15, 0, r1, c12, c0, 0		@ VBAR読み込み
	mcr	p15, 0, r1, c12, c0, 0		@ VBAR書き込み

	mrc	p15, 0, r0, c1, c0, 0		@ SCTLRを読み込み
	orr	r0, r0, #(0x1 << 12)		@ 命令キッシュを稼働（SCTLR.I [12])
	orr	r0, r0, #(0x1 <<  2)		@ データキッシュを稼働（SCTLR.D [2])
	orr	r0, r0, #(0x1 << 11)		@ プログラムフロー予測を稼働（SCTLR.Z [11])
	orr	r0, r0, #(0x1 <<  0)		@ MMUを稼働（SCTLR.M [0])
	mcr	p15, 0, r0, c1, c0, 0		@ SCTLRを書き込み

@==================================================================
@ データプリフェッチ機能を許可します
@==================================================================
	mrc	p15, 0, r0, c1, c0, 1		@ ACTLRを読み込み
	orr	r0, r0, #(0x1 << 2)		@ データプリフェッチを稼働(ACTLR.DP[2])
	mcr	p15, 0, r0, c1, c0, 1		@ ACTLRを書き込み

	mrc	p15, 0, r1, c1, c0, 0		@ SCTLR読み込み
	mcr	p15, 0, r1, c1, c0, 0		@ SCTLR書き込み

	mrc	p15, 0, r1, c1, c0, 1		@ ACTLR読み込み
	mcr	p15, 0, r1, c1, c0, 1		@ ACTLR書き込み


@====================================================================
@ ドメインアクセス制御レジスタを全クライアント設定
@====================================================================
	ldr	r0, =0x55555555			@ 全クライアント設定
	mcr	p15, 0, r0, c3, c0, 0		@ ドメインアクセス制御レジスタ(DACR)書き込み

	mrc	p15, 0, r0, c1, c0, 0		@ SCTLRを読み込み
	orr	r0, r0, #0x1			@ MMUを稼働状態に設定 (SCTLR.M[0])
	mcr	p15, 0, r0, c1, c0, 0		@ SCTLRに書き込み

	ldr	r1, =0x000007ff
	mvn	r1, r1
	and	r0, r0, r1
	add	r0, r0, #0x90

	ldr	r1, [r0, #0]
	orr	r1, r1, #0x04
	str	r1, [r0, #0]

	mov	r0, #0
	mcr	p15, 0, r0 ,c7 ,c5, 0

	bl	main

	b	.
