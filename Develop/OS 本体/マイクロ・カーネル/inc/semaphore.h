/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_SEMAPHORE_H_
#define	_SEMAPHORE_H_

typedef struct t_rsem {
	unsigned int	wtskid;	/* 待ち行列の先頭準タスクID */
	unsigned int	semcnt;	/* 現在の資源数 */
} T_RSEM;

extern ER	sig_sem(unsigned int);
extern ER	wai_sem(unsigned int);
extern ER	pol_sem(unsigned int);
extern ER	twai_sem(unsigned int);
extern ER	ref_sem(unsigned int, T_RSEM *);

#endif	/* _SEMAPHORE_H_ */
