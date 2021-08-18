/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_KERNEL_H_
#define	_KERNEL_H_

#define	E_OK		0

#define	SS_DISDSP	0x0004	/* ディスパッチ禁止状態 */
#define	SS_DISINT	0x0001	/* 割り込み禁止状態 */
#define	SS_LOCCPU	0x0005	/* CPUロック状態 */
#define	SS_CNTEXE	0x0008	/* カウンタ処理中 */

#define	SS_ERRHOOK	0x0100	/* ErrorHook実行状態 */
#define	SS_PREHOOK	0x0200	/* PreTaskHook実行状態 */
#define	SS_PSTHOOK	0x0400	/* PostTaskHook実行状態 */
#define	SS_STHOOK	0x0800	/* StartupHook実行状態 */
#define	SS_SDHOOK	0x1000	/* ShutdownHook実行状態 */
#define	SS_TSKRUN	0x2000	/* タスク実行状態 */
#define	SS_CTSKRUN	0x4000	/* 準タスク実行状態 */
#define	SS_CYCHDR	0x8000	/* 周期ハンドラ実行状態 */

#define	TA_ACT		0x02	/* 自動実行属性 */

typedef	int	ER;

#include "osek.h"
#include "itron.h"

#endif	/* _KERNEL_H_ */
