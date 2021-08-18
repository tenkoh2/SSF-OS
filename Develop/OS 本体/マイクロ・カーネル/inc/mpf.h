/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_MPF_H_
#define	_MPF_H_

typedef struct t_rmpf {
	unsigned int	wtskid;		/* �҂��s��̐擪���^�X�NID */
	unsigned int	fblkcnt;	/* �󂫃������E�u���b�N�� */
} T_RMPF;

extern ER	get_mpf(unsigned int, void *);
extern ER	pget_mpf(unsigned int, void *);
extern ER	tget_mpf(unsigned int, void *, unsigned int);
extern ER	rel_mpf(unsigned int, void *);
extern ER	ref_mpf(unsigned int, T_RMPF *);

#endif	/* _MPF_H_ */
