/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_INTERRUPT_H_
#define	_INTERRUPT_H_

extern void	EnableAllInterrupts(void);
extern void	DisableAllInterrupts(void);
extern void	ResumeAllInterrupts(void);
extern void	SuspendAllInterrupts(void);
extern void	ResumeOSInterrupts(void);
extern void	SuspendOSInterrupts(void);

#endif	/* _INTERRUPT_H_ */
