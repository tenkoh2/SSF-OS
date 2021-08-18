/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_TASKSYNC_H_
#define	_TASKSYNC_H_

extern ER	slp_tsk(void);
extern ER	tslp_tsk(unsigned int);
extern ER	wup_tsk(unsigned int);
extern ER	can_wup(unsigned int);
extern ER	rel_wai(unsigned int);
extern ER	sus_tsk(unsigned int);
extern ER	rsm_tsk(unsigned int);
extern ER	dly_tsk(unsigned int);

#endif	/* _TASKSYNC_H_ */
