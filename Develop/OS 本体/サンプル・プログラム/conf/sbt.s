	.bss
	.align	2

	.globl	__start_sbt
__start_sbt:
@	.byte			@ スケジューラ起動フラグ
@	.byte			@ 最高優先度
@	.hword			@ システム・ステータス
@	.word			@ 優先度マップ
@	.word			@ システム・メモリ・プール・サイズ
@	.word			@ システム・メモリ・プールの先頭アドレス
@	.word			@ 可変長メモリ・プール・サイズ
@	.word			@ 可変長メモリ・プールの先頭アドレス
@	.word			@ 固定長メモリ・プール・サイズ
@	.word			@ 固定長メモリ・プールの先頭アドレス
@	.word			@ システム・スタック
@	.hword			@ 実行中タスクID
@	.hword			@ 実行中アプリケーションID
@	.byte			@ 準タスクのスケジューラ起動フラグ
@	.byte			@ 準タスク最高優先度
@	.hword			@ 実行中準タスクID
@	.word			@ 準タスク優先度マップ
@	.hword			@ SuspendAllInterrupts カウント
@	.hword			@ SuspendOSInterrupts カウント
@	.word			@ 割り込み状態(DisableAllInterrupts/EnableAllInterrupts 用)
@	.word			@ 割り込み状態(SuspendAllInterrupts/ResumeAllInterrupts 用)
@	.word			@ 割り込み状態(SuspendOSInterrupts/ResumeOSInterrupts 用)
@	.word			@ CPSR
@	.word			@ アプリケーション・モード
@	.word			@ 割り込み状態(μITRON4.0用)
@	.word			@ カウンタ処理ネスト数
@	.hword			@ システム時刻(上位16bit)
@	.hword			@ 予約領域
@	.word			@ システム時刻(下位32bit)
	.skip	88

	.globl	__start_tcb
__start_tcb:
	@ ダミー！
@	.byte			@ タスク状態
@	.byte			@ 起動カウント
@	.byte			@ 現在優先度
@	.byte			@ 先頭の所有リソース
@	.word			@ スタック・アドレス
@	.word			@ CPSR レジスタ
@	.word			@ アプリケーションID
@	.word			@ イベント
@	.word			@ 待ちイベントのパターン
	.skip	24
	@ ここまでダミー

@	.byte			@ タスク状態
@	.byte			@ 起動カウント
@	.byte			@ 現在優先度
@	.byte			@ 先頭の所有リソース
@	.word			@ スタック・アドレス
@	.word			@ CPSR レジスタ
@	.word			@ アプリケーションID
@	.word			@ イベント
@	.word			@ 待ちイベントのパターン
	.skip	24

@	.byte			@ タスク状態
@	.byte			@ 起動カウント
@	.byte			@ 現在優先度
@	.byte			@ 先頭の所有リソース
@	.word			@ スタック・アドレス
@	.word			@ CPSR レジスタ
@	.word			@ アプリケーションID
@	.word			@ イベント
@	.word			@ 待ちイベントのパターン
	.skip	24

	.globl	__start_ctcb
__start_ctcb:
	@ ダミー！
@	.word			@ タイマ・キュー環状リンク用タスクID
@	.word			@ タイマ・キュー環状リンク用タスクID
@	.word			@ 待ち時間
@	.byte			@ タスク状態
@	.byte			@ 起動カウント
@	.byte			@ スリープ・ネスト数
@	.byte			@ サスペンド・ネスト数
@	.byte			@ 現在優先度
@	.byte			@ ベース優先度
@	.hword			@ 予約領域
@	.word			@ サービス・コール戻り値
@	.word			@ 待ち要因
@	.word			@ 待ちオブジェクトID
@	.word			@ sta_tsk による起動コード
@	.word			@ スタック・アドレス
@	.word			@ CPSR レジスタ
@	.word			@ ロックしているミューテックスID(先頭ID)
@	.word			@ 環状リンク用タスクID
@	.word			@ 環状リンク用タスクID
	.skip	56
	@ ここまでダミー

@	.word			@ タイマ・キュー環状リンク用タスクID
@	.word			@ タイマ・キュー環状リンク用タスクID
@	.word			@ 待ち時間
@	.byte			@ タスク状態
@	.byte			@ 起動カウント
@	.byte			@ スリープ・ネスト数
@	.byte			@ サスペンド・ネスト数
@	.byte			@ 現在優先度
@	.byte			@ ベース優先度
@	.hword			@ 予約領域
@	.word			@ サービス・コール戻り値
@	.word			@ 待ち要因
@	.word			@ 待ちオブジェクトID
@	.word			@ sta_tsk による起動コード
@	.word			@ スタック・アドレス
@	.word			@ CPSR レジスタ
@	.word			@ ロックしているミューテックスID(先頭ID)
@	.word			@ 環状リンク用タスクID
@	.word			@ 環状リンク用タスクID
	.skip	56


	.globl	__start_rdybuf
__start_rdybuf:
	@ 優先度0
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度1
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度2
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度3
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度4
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度5
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度6
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度7
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度8
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度9
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度10
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度11
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度12
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度13
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度14
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度15
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度16
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度17
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度18
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度19
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度20
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度21
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度22
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度23
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度24
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度25
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度26
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度27
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度28
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度29
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度30
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	@ 優先度31
@	.hword			@ ライト・インデックス
@	.hword			@ リード・インデックス
@	.word			@ レディ・バッファ・サイズ
@	.word			@ レディ・バッファ・アドレス
	.skip	12

	.globl	__start_semctrl
__start_semctrl:
	@ ダミー！
@	.word			@ 待ちタスクID
@	.word			@ 資源数
	.skip	8
	@ ここまでダミー

@	.word			@ 待ちタスクID
@	.word			@ 資源数
	.skip	8


	.globl	__start_rcb
__start_rcb:
	@ ダミー！
@	.word			@ リソースを獲得しているタスクのID
@	.word			@ 次のリソースID
	.skip	8
	@ ここまでダミー

@	.word			@ リソースを獲得しているタスクのID
@	.word			@ 次のリソースID
	.skip	8

@	.word			@ リソースを獲得しているタスクのID
@	.word			@ 次のリソースID
	.skip	8


	.globl	__start_mcb
__start_mcb:
	@ ダミー！
	.word			@ 待ちタスクID
@	.word			@ ミューテックスをロックしている準タスクのID
@	.skip	8
	@ ここまでダミー

@	.word			@ 待ちタスクID
@	.word			@ ミューテックスをロックしている準タスクのID
	.skip	8

@	.word			@ 待ちタスクID
@	.word			@ ミューテックスをロックしている準タスクのID
	.skip	8


	.globl	__start_mbfctrl
__start_mbfctrl:
	@ ダミー！
@	.word			@ 送信待ち準タスクID
@	.word			@ 受信待ち準タスクID
@	.word			@ メッセージ数
@	.word			@ 空きサイズ
@	.word			@ 送信開始アドレス
@	.word			@ 受信開始アドレス
	.skip	24
	@ ここまでダミー

@	.word			@ 送信待ち準タスクID
@	.word			@ 受信待ち準タスクID
@	.word			@ メッセージ数
@	.word			@ 空きサイズ
@	.word			@ 送信開始アドレス
@	.word			@ 受信開始アドレス
	.skip	24


	.globl	__start_mpfctrl
__start_mpfctrl:
	@ ダミー！
@	.word			@ メモリ・ブロック獲得待ち準タスクID
@	.word			@ 空きメモリ・ブロック数
@	.word			@ メモリ・ブロック先頭アドレス
	.skip	12
	@ ここまでダミー

@	.word			@ メモリ・ブロック獲得待ち準タスクID
@	.word			@ 空きメモリ・ブロック数
@	.word			@ メモリ・ブロック先頭アドレス
	.skip	12


	.globl	__start_mplctrl
__start_mplctrl:
	@ ダミー！
@	.word			@ メモリ・ブロック獲得待ち準タスクID
@	.word			@ メモリ・ブロック先頭アドレス
	.skip	8
	@ ここまでダミー

@	.word			@ メモリ・ブロック獲得待ち準タスクID
@	.word			@ メモリ・ブロック先頭アドレス
	.skip	8


	.globl __rdybuf_08
	.globl __rdybuf_16
	.globl __rdybuf_24
__rdybuf_08:	.skip	0x04
__rdybuf_16:	.skip	0x04
__rdybuf_24:	.skip	0x04


	.globl	__start_cntctrl
__start_cntctrl:
	@ ダミー！
@	.word
@	.word
	.skip	8
	@ ここまでダミー

@	.word
@	.word
	.skip	8


	.globl	__start_almctrl
__start_almctrl:
	@ ダミー！
@	.word
@	.word
@	.word
@	.word
@	.word
	.skip	20
	@ ここまでダミー

@	.word
@	.word
@	.word
@	.word
@	.word
	.skip	20

@	.word
@	.word
@	.word
@	.word
@	.word
	.skip	20


	.globl	__start_cycctrl
__start_cycctrl:
	@ ダミー！
@	.hword
@	.hword
@	.word
@	.word
@	.word
	.skip	16
	@ ここまでダミー

@	.hword
@	.hword
@	.word
@	.word
@	.word
	.skip	16

@	.hword
@	.hword
@	.word
@	.word
@	.word
	.skip	16


	.globl	__start_rdyque_head
__start_rdyque_head:	.skip	0x80


	.globl	__start_cycque_head
__start_cycque_head:	.skip	0x04


	.globl	__start_timerque_head
__start_timerque_head:	.skip	0x04


	.globl	__mbf_01
__mbf_01:	.skip	0x0400
