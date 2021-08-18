/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_MBF_H_
#define	_MBF_H_

typedef struct t_rmbf {
	unsigned int	stskid;		/* ���M�҂��擪���^�X�NID */
	unsigned int	rtskid;		/* ��M�҂��擪���^�X�NID */
	unsigned int	smsgcnt;	/* ���b�Z�[�W�� */
	unsigned int	fmbfsz;		/* �󂫗̈�T�C�Y */
} T_RMBF;

extern ER	snd_mbf(unsigned int, void *, unsigned int);
extern ER	psnd_mbf(unsigned int, void *, unsigned int);
extern ER	tsnd_mbf(unsigned int, void *, unsigned int, unsigned int);
extern ER	rcv_mbf(unsigned int, void *);
extern ER	prcv_mbf(unsigned int, void *);
extern ER	trcv_mbf(unsigned int, void *, unsigned int);
extern ER	ref_mbf(unsigned int, T_RMBF *);

#endif	/* _MBF_H_ */
