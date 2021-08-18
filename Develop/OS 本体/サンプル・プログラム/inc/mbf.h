/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_MBF_H_
#define	_MBF_H_

typedef struct t_rmbf {
	unsigned int	stskid;		/* 送信待ち先頭準タスクID */
	unsigned int	rtskid;		/* 受信待ち先頭準タスクID */
	unsigned int	smsgcnt;	/* メッセージ数 */
	unsigned int	fmbfsz;		/* 空き領域サイズ */
} T_RMBF;

extern ER	snd_mbf(unsigned int, void *, unsigned int);
extern ER	psnd_mbf(unsigned int, void *, unsigned int);
extern ER	tsnd_mbf(unsigned int, void *, unsigned int, unsigned int);
extern ER	rcv_mbf(unsigned int, void *);
extern ER	prcv_mbf(unsigned int, void *);
extern ER	trcv_mbf(unsigned int, void *, unsigned int);
extern ER	ref_mbf(unsigned int, T_RMBF *);

#endif	/* _MBF_H_ */
