/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_CTASK_H_
#define	_CTASK_H_

#define	TTS_RUN		0x01	/* RUNNING��� */
#define	TTS_RDY		0x02	/* READY��� */
#define	TTS_WAI		0x04	/* WAITING��� */
#define	TTS_SUS		0x08	/* SUSPENDED��� */
#define	TTS_WAS		0x0c	/* WAITING-SUSPENDED��� */
#define	TTS_DMT		0x10	/* DORMANT��� */

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
	unsigned char	tskstat;	/* �^�X�N��� */
	unsigned char	rfu1;		/* �\��̈� */
	unsigned short	tskpri;		/* ���^�X�N�̌��ݗD��x */
	unsigned short	tskbpri;	/* ���^�X�N�̃x�[�X�D��x */
	unsigned short	tskwait;	/* �҂��v�� */
	unsigned short	wobjid;		/* �҂��ΏۃI�u�W�F�N�gID */
	unsigned short	rfu2;		/* �\��̈� */
	unsigned int	lefttmo;	/* �^�C���A�E�g�܂ł̎��� */
	unsigned int	actcnt;		/* �N���v���L���[�C���O�� */
	unsigned int	wupcnt;		/* �N���v���L���[�C���O�� */
	unsigned int	suscnt;		/* �����҂��v���l�X�g�� */
} T_RTSK;

extern ER	act_tsk(unsigned int);
extern ER	can_act(unsigned int);
extern ER	sta_tsk(unsigned int, int);
extern void	ext_tsk(void);
extern ER	chg_pri(unsigned int, unsigned char);
extern ER	ref_tsk(unsigned int, T_RTSK *);

#endif	/* _CTASK_H_ */
