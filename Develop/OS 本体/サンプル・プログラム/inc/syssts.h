/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_SYSSTS_H_
#define	_SYSSTS_H_

extern ER	get_tid(unsigned int *);
extern ER	loc_cpu(void);
extern ER	unl_cpu(void);
extern ER	dis_dsp(void);
extern ER	ena_dsp(void);
extern bool	sns_ctx(void);
extern bool	sns_loc(void);
extern bool	sns_dsp(void);
extern bool	sns_dpn(void);

#endif	/* _SYSSTS_H_ */
