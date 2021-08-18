/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef _ITRON_H_
#define	_ITRON_H_

#define	E_PAR		-17
#define	E_ID		-18
#define	E_CTX		-25
#define	E_MACV		-26
#define	E_OACV		-27
#define	E_ILUSE		-28
#define	E_NOMEM		-33
#define	E_OBJ		-41
#define	E_NOEXS		-42
#define	E_QOVR		-43
#define	E_RLWAI		-49
#define	E_TMOUT		-50
#define	E_CLS		-52

#define	TMO_POL		0x00
#define	TMO_FEVR	0x01

#define	TA_TFIFO	0x00
#define	TA_TPRI		0x01

#define	TSK_NONE	0x00

#include "ctask.h"
#include "tasksync.h"
#include "semaphore.h"
#include "mutex.h"
#include "mbf.h"
#include "mpf.h"
#include "mpl.h"

#endif	/* _ITRON_H_ */
