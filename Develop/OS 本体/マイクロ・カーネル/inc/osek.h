/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_OSEK_H_
#define	_OSEK_H_

#define	E_OS_ACCESS	1
#define	E_OS_CALLEVEL	2
#define	E_OS_ID		3
#define	E_OS_LIMIT	4
#define	E_OS_NOFUNC	5
#define	E_OS_RESOURCE	6
#define	E_OS_STATE	7
#define	E_OS_VALUE	8

typedef	int	StatusType;

#include "task.h"
#include "interrupt.h"
#include "resource.h"
#include "event.h"
#include "alarm.h"
#include "counter.h"
#include "osexectrl.h"

#endif	/* _OSEK_H_ */
