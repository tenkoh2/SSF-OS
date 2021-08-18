/*
 * Test Program Header File
 */

#include	"tplib.h"

/* Task ID */

#define ID_TSK_MAIN		1		/* Main task ID */
#define ID_TSK_1		2
#define ID_TSK_2		3
#define ID_TSK_3		4
#define ID_TSK_4		5
#define ID_TSK_5		6
#define ID_TSK_6		7
#define ID_TSK_HIGHEST	1
#define ID_TSK_HH1		2
#define ID_TSK_HH2		3
#define ID_TSK_HH3		4
#define ID_TSK_HH4		5
#define ID_TSK_H1		6
#define ID_TSK_H2		7
#define ID_TSK_H3		8
#define ID_TSK_H4		9
#define ID_TSK_M1		10
#define ID_TSK_M2		11
#define ID_TSK_M3		12
#define ID_TSK_M4		13
#define ID_TSK_L1		14
#define ID_TSK_L2		15
#define ID_TSK_L3		16
#define ID_TSK_L4		17
#define ID_TSK_LL1		18
#define ID_TSK_LL2		19
#define ID_TSK_LL3		20
#define ID_TSK_LL4		21
#define ID_TSK_LOWEST	22


/* Isr ID */

#define	ID_ISR_H1		1
#define	ID_ISR_H2		2
#define	ID_ISR_M1		3
#define	ID_ISR_M2		4
#define	ID_ISR_L1		5
#define	ID_ISR_L2		6


/* Cyclic Handler ID */

#define	ID_CYC_1			1
#define	ID_CYC_2			2
#define	ID_CYC_3			3
#define	ID_CYC_PHS_1		4
#define	ID_CYC_PHS_2		5
#define	ID_CYC_PHS_3		6
#define	ID_CYC_STA_1		7
#define	ID_CYC_STA_2		8
#define	ID_CYC_STA_3		9
#define	ID_CYC_PHS_STA_1	10
#define	ID_CYC_PHS_STA_2	11
#define	ID_CYC_PHS_STA_3	12


/* Semaphore ID */

#define	ID_SEM_FIFO_1	1
#define	ID_SEM_FIFO_2	2
#define	ID_SEM_FIFO_3	3
#define	ID_SEM_FIFO_4	4
#define	ID_SEM_PRI_1	5
#define	ID_SEM_PRI_2	6
#define	ID_SEM_PRI_3	7
#define	ID_SEM_PRI_4	8


/* Mutex ID */

#define	ID_MTX_FIFO_1	1
#define	ID_MTX_FIFO_2	2
#define	ID_MTX_FIFO_3	3
#define	ID_MTX_FIFO_4	4
#define	ID_MTX_PRI_1	5
#define	ID_MTX_PRI_2	6
#define	ID_MTX_PRI_3	7
#define	ID_MTX_PRI_4	8
#define	ID_MTX_INH_1	9
#define	ID_MTX_INH_2	10
#define	ID_MTX_INH_3	11
#define	ID_MTX_INH_4	12
#define	ID_MTX_CEIL_1	13
#define	ID_MTX_CEIL_2	14
#define	ID_MTX_CEIL_3	15
#define	ID_MTX_CEIL_4	16


/* Message Buffer ID */

#define	ID_MBF_TFIFO_TFIFOR_1	1
#define	ID_MBF_TFIFO_TFIFOR_2	2
#define	ID_MBF_TFIFO_TFIFOR_3	3
#define	ID_MBF_TFIFO_TFIFOR_4	4
#define	ID_MBF_TFIFO_TPRIR_1	5
#define	ID_MBF_TFIFO_TPRIR_2	6
#define	ID_MBF_TFIFO_TPRIR_3	7
#define	ID_MBF_TFIFO_TPRIR_4	8
#define	ID_MBF_TPRI_TFIFOR_1	9
#define	ID_MBF_TPRI_TFIFOR_2	10
#define	ID_MBF_TPRI_TFIFOR_3	11
#define	ID_MBF_TPRI_TFIROR_4	12
#define	ID_MBF_TPRI_TPRIR_1		13
#define	ID_MBF_TPRI_TPRIR_2		14
#define	ID_MBF_TPRI_TPRIR_3		15
#define	ID_MBF_TPRI_TPRIR_4		16


/* Variable Size Memory Pool ID */

#define	ID_MPL_FIFO_1	1
#define	ID_MPL_FIFO_2	2
#define	ID_MPL_FIFO_3	3
#define	ID_MPL_FIFO_4	4
#define	ID_MPL_PRI_1	5
#define	ID_MPL_PRI_2	6
#define	ID_MPL_PRI_3	7
#define	ID_MPL_PRI_4	8


/* Task Priority */

#define PRI_MAIN	1		/* Main Task Priority */
#define	PRI_HIGHEST	2
#define PRI_HH		4
#define PRI_H		6
#define PRI_M		8
#define PRI_L		10
#define PRI_LL		12
#define	PRI_LOWEST	14

/* Message Buffer Size */

#define	MBFSZ_BUF_SOME	0x400
#define	MBFSZ_BUF_HALF	(MBFSZ_BUF_SOME/2)
#define	MBFSZ_BUF_QURT	(MBFSZ_BUF_SOME/4)
#define	MBFSZ_MSG_SOME	(MBFSZ_BUF_SOME/16)
#define	MBFSZ_MSG_MAX	MBFSZ_BUF_SOME


/* Variable Size Memory Pool Size */

#define	MPLSZ_SOME	0x400
#define	MPLSZ_HALF	(MPLSZ_SOME/2)
#define	MPLSZ_QURT	(MPLSZ_SOME/4)
#define	MPLSZ_BLK	(MBFSZ_BUF_SOME/16)
