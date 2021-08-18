/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_KERNEL_H_
#define	_KERNEL_H_

#define	E_OK		0

#define	SS_DISDSP	0x0004	/* �f�B�X�p�b�`�֎~��� */
#define	SS_DISINT	0x0001	/* ���荞�݋֎~��� */
#define	SS_LOCCPU	0x0005	/* CPU���b�N��� */
#define	SS_CNTEXE	0x0008	/* �J�E���^������ */

#define	SS_ERRHOOK	0x0100	/* ErrorHook���s��� */
#define	SS_PREHOOK	0x0200	/* PreTaskHook���s��� */
#define	SS_PSTHOOK	0x0400	/* PostTaskHook���s��� */
#define	SS_STHOOK	0x0800	/* StartupHook���s��� */
#define	SS_SDHOOK	0x1000	/* ShutdownHook���s��� */
#define	SS_TSKRUN	0x2000	/* �^�X�N���s��� */
#define	SS_CTSKRUN	0x4000	/* ���^�X�N���s��� */
#define	SS_CYCHDR	0x8000	/* �����n���h�����s��� */

#define	TA_ACT		0x02	/* �������s���� */

typedef	int	ER;

#include "osek.h"
#include "itron.h"

#endif	/* _KERNEL_H_ */
