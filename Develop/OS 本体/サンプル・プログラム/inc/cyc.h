/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_CYC_H_
#define	_CYC_H_

#define	TCYC_STP	0x00	/* �����n���h�������삵�Ă��Ȃ� */
#define	TCYC_STA	0x01	/* �����n���h�������삵�Ă��� */

typedef struct t_rcyc {
	unsigned char	cycstat;		/* �����n���h���̓����� */
	unsigned char	rfu1;		/* �\��̈� */
	unsigned short	rfu2;		/* �\��̈� */
	unsigned int	lefttim;		/* ���ɋN������܂ł̎��� */
} T_RCYC;

extern ER	sta_cyc(unsigned int);
extern ER	stp_cyc(unsigned int);
extern ER	ref_cyc(unsigned int, T_RCYC *);

#endif	/* _CYC_H_ */
