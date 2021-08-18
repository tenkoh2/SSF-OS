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
	short	mode;		/* setbrk のモード */
	short	skip;		/* スキップ回数 */
	int		rstcp;	/* チェック・ポイント実測値 */
	void *	symbol1;	/* 命令コード保存用領域その1 */
	void *	symbol2;	/* 命令コード保存用領域その2 */
} t_setbrk;

typedef struct {
	char		tpmsg[MSGLENGS];	/* メッセージ書き込み領域 */
	bool		result_flag;		/* 詳細ログ/簡易ログ切り替え */
	bool		fail_flag;		/* FAIL 時に立つフラグ */
	char		RFU1;
	char		RFU2;
	t_setbrk	setbrk[SETBRKNUM];	/* tp_setbrk 用情報構造体 */
	int		refcp[MAXCPNUM];	/* チェック・ポイント期待値 */
	int		rstcp[MAXCPNUM];	/* チェック・ポイント実測値 */
} t_tpdata;
