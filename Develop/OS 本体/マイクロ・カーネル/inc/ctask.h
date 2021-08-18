/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_CTASK_H_
#define	_CTASK_H_

#define	TTS_RUN		0x01	/* RUNNING状態 */
#define	TTS_RDY		0x02	/* READY状態 */
#define	TTS_WAI		0x04	/* WAITING状態 */
#define	TTS_SUS		0x08	/* SUSPENDED状態 */
#define	TTS_WAS		0x0c	/* WAITING-SUSPENDED状態 */
#define	TTS_DMT		0x10	/* DORMANT状態 */

#define	TTW_SLP		0x0001
#define	TTW_DLY		0x0002
#define	TTW_SEM		0x0004
#define	TTW_MTX		0x0080
#define	TTW_SMBF	0x0100
#define	TTW_RMBF	0x0200
#define	TTW_MPF		0x2000
#define	TTW_MPL		0x4000

#define	TSK_SELF	0

typedef struct t_rtsk {
	unsigned char	tskstat;	/* タスク状態 */
	unsigned char	rfu1;		/* 予約領域 */
	unsigned short	tskpri;		/* 準タスクの現在優先度 */
	unsigned short	tskbpri;	/* 準タスクのベース優先度 */
	unsigned short	tskwait;	/* 待ち要因 */
	unsigned short	wobjid;		/* 待ち対象オブジェクトID */
	unsigned short	rfu2;		/* 予約領域 */
	unsigned int	lefttmo;	/* タイムアウトまでの時間 */
	unsigned int	actcnt;		/* 起動要求キューイング数 */
	unsigned int	wupcnt;		/* 起床要求キューイング数 */
	unsigned int	suscnt;		/* 強制待ち要求ネスト数 */
} T_RTSK;

extern ER	act_tsk(unsigned int);
extern ER	can_act(unsigned int);
extern ER	sta_tsk(unsigned int, int);
extern void	ext_tsk(void);
extern ER	chg_pri(unsigned int, unsigned char);
extern ER	ref_tsk(unsigned int, T_RTSK *);

#endif	/* _CTASK_H_ */
