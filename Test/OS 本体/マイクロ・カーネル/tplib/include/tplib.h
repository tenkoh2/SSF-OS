/*
 * Test Program Library Header File
 */

#ifdef	__CPU_NAME__
#ifdef	__DEVICE_NAME__
#include	"CPU\CPU_NAME\DEVICE_NAME\tpintlib.h"
#endif	/* Device */
#endif	/* Core */

#ifndef	TRUE
#define	FALSE	0
#define	TRUE	!FALSE
#endif

#define	MAXCPNUM	256
#define	MAXVALNUM	256
#define	MSGLENGS	10240
#define	SETBRKNUM	16

typedef	char	bool;

typedef struct {
	short	mode;		/* setbrk �̃��[�h */
	short	skip;		/* �X�L�b�v�� */
	int		rstcp;	/* �`�F�b�N�E�|�C���g�����l */
	void *	symbol1;	/* ���߃R�[�h�ۑ��p�̈悻��1 */
	void *	symbol2;	/* ���߃R�[�h�ۑ��p�̈悻��2 */
} t_setbrk;

typedef struct {
	char		tpmsg[MSGLENGS];	/* ���b�Z�[�W�������ݗ̈� */
	bool		result_flag;		/* �ڍ׃��O/�ȈՃ��O�؂�ւ� */
	bool		fail_flag;		/* FAIL ���ɗ��t���O */
	char		RFU1;
	char		RFU2;
	t_setbrk	setbrk[SETBRKNUM];	/* tp_setbrk �p���\���� */
	int		refcp[MAXCPNUM];	/* �`�F�b�N�E�|�C���g���Ғl */
	int		rstcp[MAXCPNUM];	/* �`�F�b�N�E�|�C���g�����l */
} t_tpdata;
