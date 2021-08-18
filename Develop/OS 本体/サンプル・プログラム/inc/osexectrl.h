/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_OSEXECTRL_H_
#define	_OSEXECTRL_H_

#define	OSDEFAULTAPPMODE	0x00000001

typedef	unsigned int	AppModeType;

extern AppModeType	GetActiveApplicationMode(void);
extern void		StartOS(AppModeType);
extern void		ShutdownOS(StatusType);

#endif	/* _OSEXECTRL_H_ */
