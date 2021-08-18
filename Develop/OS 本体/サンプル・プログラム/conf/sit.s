	.data
	.align	2

	.globl	__start_sit
__start_sit:
	.byte	0x00		@ Hook ルーチン
	.byte	0x02		@ タスク数
	.byte	0x02		@ 準タスク数
	.byte	0x02		@ リソース数
	.byte	0x02		@ アラーム数
	.byte	0x01		@ カウンタ数
	.byte	0x01		@ セマフォ数
	.byte	0x02		@ ミューテックス数
	.byte	0x01		@ メッセージ・バッファ数
	.byte	0x01		@ 固定長メモリ・プール数
	.byte	0x01		@ 可変長メモリ・プール数
	.byte	0x02		@ 周期ハンドラ数
	.word	0x00000001	@ タイマ割り込み要因
	.word	0x00000400	@ 初期システム・メモリ・プール・サイズ
	.word	0x3b3ff000	@ 初期システム・メモリ・プール・先頭アドレス
	.word	0x00000400	@ 初期可変長メモリ・プール・サイズ
	.word	0x3b3ff400	@ 初期可変長メモリ・プール先頭アドレス
	.word	0x00000400	@ 初期固定長メモリ・プール・サイズ
	.word	0x3b3ff800	@ 初期固定長メモリ・プール先頭アドレス
	.word	0x3b3ff000	@ 初期システムスタック


	.extern	taskM1
	.extern	__stack_taskM1
	.extern	taskL1
	.extern	__stack_taskL1
	.global	__start_tib
__start_tib:
	@ ダミー！
	.byte	0x00		@ タスク属性
	.byte	0x00		@ 初期優先度
	.byte	0x00		@ アプリケーション・モード
	.byte	0x00		@ 予約領域
	.word	0x00000000	@ インターナル・リソース
	.word	0x00000000	@ 最大起動数
	.word	0x00000000	@ 保護時間
	.word	0x00000000	@ タスク起動時引数
	.word	0x00000000	@ タスク起動アドレス
	.word	0x00000000	@ 起動時スタック・アドレス
	.word	0x00000000	@ アプリケーションID
	@ ここまでダミー

	.byte	0x00		@ タスク属性
	.byte	0x10		@ 初期優先度
	.byte	0x01		@ アプリケーション・モード
	.byte	0x00		@ 予約領域
	.word	0x00000001	@ インターナル・リソース
	.word	0x000000ff	@ 最大起動数
	.word	0x00000000	@ 保護時間
	.word	0x00000000	@ タスク起動時引数
	.word	taskM1		@ タスク起動アドレス
	.word	__stack_taskM1	@ 起動時スタック・アドレス
	.word	0x00000000	@ アプリケーションID

	.byte	0x04		@ タスク属性
	.byte	0x08		@ 初期優先度
	.byte	0x00		@ アプリケーション・モード
	.byte	0x00		@ 予約領域
	.word	0x00000000	@ インターナル・リソース
	.word	0x000000ff	@ 最大起動数
	.word	0x00000000	@ 保護時間
	.word	0x00000000	@ タスク起動時引数
	.word	taskL1		@ タスク起動アドレス
	.word	__stack_taskL1	@ 起動時スタック・アドレス
	.word	0x00000000	@ アプリケーションID


	.extern	ctaskM1
	.extern	__stack_ctaskM1
	.extern	ctaskL1
	.extern	__stack_ctaskL1
	.globl	__start_ctib
__start_ctib:
	@ ダミー！
	.byte	0x00		@ タスク属性
	.byte	0x00		@ 初期優先度
	.hword	0x0000		@ 予約領域
	.word	0x00000000	@ 最大起動数
	.word	0x00000000	@ タスク起動時引数
	.word	0x00000000	@ タスク起動アドレス
	.word	0x00000000	@ 起動時スタック・アドレス
	@ ここまでダミー

	.byte	0x00		@ タスク属性
	.byte	0x10		@ 初期優先度
	.hword	0x0000		@ 予約領域
	.word	0x000000ff	@ 最大起動数
	.word	0x00000000	@ タスク起動時引数
	.word	ctaskM1		@ タスク起動アドレス
	.word	__stack_ctaskM1	@ 起動時スタック・アドレス

	.byte	0x02		@ タスク属性
	.byte	0x18		@ 初期優先度
	.hword	0x0000		@ 予約領域
	.word	0x000000ff	@ 最大起動数
	.word	0x00000000	@ タスク起動時引数
	.word	ctaskL1		@ タスク起動アドレス
	.word	__stack_ctaskL1	@ 起動時スタック・アドレス


	.extern	_isr1
	.globl	__start_iib
__start_iib:
	@ ダミー！
	.byte	0x00		@ 割り込みハンドラ属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x00000000	@ 割り込みハンドラ起動アドレス
	@ ここまでダミー

	.byte	0x00		@ 割り込みハンドラ属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	isr1		@ 割り込みハンドラ起動アドレス


	.extern	__rdybuf_08
	.extern	__rdybuf_16
	.extern	__rdybuf_24
	.globl	__start_rdybufinf
__start_rdybufinf:
	@ 優先度0
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度1
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度2
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度3
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度4
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度5
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度6
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度7
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度8
	.word	0x00000001	@ レディ・バッファ・サイズ
	.word	__rdybuf_08	@ レディ・バッファ・アドレス

	@ 優先度9
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度10
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度11
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度12
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度13
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度14
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度15
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度16
	.word	0x00000001	@ レディ・バッファ・サイズ
	.word	__rdybuf_16	@ レディ・バッファ・アドレス

	@ 優先度17
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度18
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度19
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度20
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度21
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度22
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度23
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度24
	.word	0x00000001	@ レディ・バッファ・サイズ
	.word	__rdybuf_24	@ レディ・バッファ・アドレス

	@ 優先度25
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度26
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度27
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度28
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度29
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度30
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス

	@ 優先度31
	.word	0x00000000	@ レディ・バッファ・サイズ
	.word	0x00000000	@ レディ・バッファ・アドレス


	.globl	__start_seminf
__start_seminf:
	@ ダミー！
	.byte	0x00		@ セマフォ属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x00000000	@ 初期資源数
	.word	0x00000000	@ 最大資源数
	@ ここまでダミー

	.byte	0x00		@ セマフォ属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x0000000a	@ 初期資源数
	.word	0x0000000a	@ 最大資源数


	.globl	__start_rib
__start_rib:
	@ ダミー！
	.byte	0x00		@ リソース属性
	.byte	0x00		@ シーリング・プライオリティ
	@ ここまでダミー

	.byte	0x02		@ リソース属性
	.byte	0x18		@ シーリング・プライオリティ

	.byte	0x00		@ リソース属性
	.byte	0x18		@ シーリング・プライオリティ


	.globl	__start_mib
__start_mib:
	@ ダミー！
	.hword	0x0000		@ ミューテックス属性
	.hword	0x0000		@ 上限優先度
	@ ここまでダミー

	.hword	0x0002		@ ミューテックス属性
	.hword	0x0000		@ 上限優先度

	.hword	0x0003		@ ミューテックス属性
	.hword	0x0008		@ 上限優先度


	.extern	__mbf_01
	.globl	__start_mbfinf
__start_mbfinf:
	@ ダミー！
	.byte	0x00		@ メッセージ・バッファ属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x00000000	@ 最大メッセージ・サイズ
	.word	0x00000000	@ メッセージ・バッファ・サイズ
	.word	0x00000000	@ メッセージ・バッファ・アドレス
	@ ここまでダミー

	.byte	0x02		@ メッセージ・バッファ属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x00000010	@ 最大メッセージ・サイズ
	.word	0x00000400	@ メッセージ・バッファ・サイズ
	.word	__mbf_01	@ メッセージ・バッファ・アドレス


	.globl	__start_mpfinf
__start_mpfinf:
	@ ダミー！
	.byte	0x00		@ 固定長メモリ・プール属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x00000000	@ ブロック数
	.word	0x00000000	@ ブロック・サイズ
	.word	0x00000000	@ 固定長メモリ・プール先頭アドレス
	@ ここまでダミー

	.byte	0x02		@ 固定長メモリ・プール属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x00000004	@ ブロック数
	.word	0x00000100	@ ブロック・サイズ
	.word	0x3b3ff400	@ 固定長メモリ・プール先頭アドレス


	.globl	__start_mplinf
__start_mplinf:
	@ ダミー！
	.byte	0x00		@ 可変長メモリ・プール属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x00000000	@ メモリ・プール・サイズ
	.word	0x00000000	@ メモリ・プール先頭アドレス
	@ ここまでダミー

	.byte	0x02		@ 可変長メモリ・プール属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x00000400	@ メモリ・プール・サイズ
	.word	0x3b3ff800	@ メモリ・プール先頭アドレス


	.globl	__start_time_cntque
__start_time_cntque:
	.word	0x00000001
	.word	0x00000000


	.globl	__start_alminf
__start_alminf:
	@ ダミー！
	.hword	0x0000		@ アラーム属性
	.hword	0x0000		@ カウンタID
	.hword	0x0000		@ タスクID
	.hword	0x0000		@ 予約領域
	.word	0x00000000	@ maxallowedvalue
	.word	0x00000000	@ ticksperbase
	.word	0x00000000	@ mincycle
	.word	0x00000000	@ イベント・マスク
	@ ここまでダミー

	.hword	0x0001		@ アラーム属性
	.hword	0x0001		@ カウンタID
	.hword	0x0001		@ タスクID
	.hword	0x0000		@ 予約領域
	.word	0xffffffff	@ maxallowedvalue
	.word	0x00000000	@ ticksperbase
	.word	0x00000001	@ mincycle
	.word	0x00000000	@ イベント・マスク

	.hword	0x0002		@ アラーム属性
	.hword	0x0001		@ カウンタID
	.hword	0x0002		@ タスクID
	.hword	0x0000		@ 予約領域
	.word	0xffffffff	@ maxallowedvalue
	.word	0x00000000	@ ticksperbase
	.word	0x00000001	@ mincycle
	.word	0xffffffff	@ イベント・マスク


	.extern	cychdr1
	.extern	cychdr2
	.globl	__start_cycinf
__start_cycinf:
	@ ダミー！
	.byte	0x00		@ 周期ハンドラ属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	0x00000000	@ 周期ハンドラ
	.word	0x00000000	@ 拡張情報
	.word	0x00000000	@ 起動周期
	.word	0x00000000	@ 起動位相
	@ ここまでダミー

	.byte	0x06		@ 周期ハンドラ属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	cychdr1		@ 周期ハンドラ
	.word	0x00000000	@ 拡張情報
	.word	0x00000010	@ 起動周期
	.word	0x00000008	@ 起動位相

	.byte	0x00		@ 周期ハンドラ属性
	.byte	0x00		@ 予約領域
	.hword	0x0000		@ 予約領域
	.word	cychdr2		@ 周期ハンドラ
	.word	0x00000000	@ 拡張情報
	.word	0x00000010	@ 起動周期
	.word	0x00000000	@ 起動位相


	.extern	__init_sem
	.extern	__init_mtx
	.extern	__init_mbf
	.extern	__init_mpf
	.extern	__init_mpl
	.extern	__init_cyc
	.globl	__kernel_init_obj
__kernel_init_obj:
	.word	__init_sem
	.word	__init_mtx
	.word	__init_mbf
	.word	__init_mpf
	.word	__init_mpl
	.word	__init_cyc
	.word	0x00000000
