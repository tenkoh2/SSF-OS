/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_MPL_H_
#define	_MPL_H_

typedef struct t_rmpl {
	unsigned int	wtskid;		/* 待ち行列の先頭準タスクID */
	unsigned int	fmplsz;		/* 空き領域の合計サイズ */
	unsigned int	fblksz;		/* 獲得可能なメモリ・ブロック・サイズ */
} T_RMPL;

extern ER	get_mpl(unsigned int, unsigned int, void *);
extern ER	pget_mpl(unsigned int, unsigned int, void *);
extern ER	tget_mpl(unsigned int, unsigned int, void *, unsigned int);
extern ER	rel_mpl(unsigned int, void *);
extern ER	ref_mpl(unsigned int, T_RMPL *);

#endif	/* _MPL_H_ */
