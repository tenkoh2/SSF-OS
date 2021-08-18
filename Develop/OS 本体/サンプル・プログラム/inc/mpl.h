/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_MPL_H_
#define	_MPL_H_

typedef struct t_rmpl {
	unsigned int	wtskid;		/* �҂��s��̐擪���^�X�NID */
	unsigned int	fmplsz;		/* �󂫗̈�̍��v�T�C�Y */
	unsigned int	fblksz;		/* �l���\�ȃ������E�u���b�N�E�T�C�Y */
} T_RMPL;

extern ER	get_mpl(unsigned int, unsigned int, void *);
extern ER	pget_mpl(unsigned int, unsigned int, void *);
extern ER	tget_mpl(unsigned int, unsigned int, void *, unsigned int);
extern ER	rel_mpl(unsigned int, void *);
extern ER	ref_mpl(unsigned int, T_RMPL *);

#endif	/* _MPL_H_ */
