/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_CYC_H_
#define	_CYC_H_

#define	TCYC_STP	0x00	/* 周期ハンドラが動作していない */
#define	TCYC_STA	0x01	/* 周期ハンドラが動作している */

typedef struct t_rcyc {
	unsigned char	cycstat;		/* 周期ハンドラの動作状態 */
	unsigned char	rfu1;		/* 予約領域 */
	unsigned short	rfu2;		/* 予約領域 */
	unsigned int	lefttim;		/* 次に起動するまでの時間 */
} T_RCYC;

extern ER	sta_cyc(unsigned int);
extern ER	stp_cyc(unsigned int);
extern ER	ref_cyc(unsigned int, T_RCYC *);

#endif	/* _CYC_H_ */
