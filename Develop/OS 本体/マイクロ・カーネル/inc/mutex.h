/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_MUTEX_H_
#define	_MUTEX_H_

#define	TA_INHERIT	0x02
#define	TA_CEILING	0x03

typedef struct t_rmtx {
	unsigned int	htskid;		/* ミューテックスをロックしている準タスクのID */
	unsigned int	wtskid;		/* 待ち準タスクID */
} T_RMTX;

extern ER	loc_mtx(unsigned int);
extern ER	ploc_mtx(unsigned int);
extern ER	tloc_mtx(unsigned int, unsigned int);
extern ER	unl_mtx(unsigned int);
extern ER	ref_mtx(unsigned int, T_RMTX *);

#endif	/* _MUTEX_H_ */
