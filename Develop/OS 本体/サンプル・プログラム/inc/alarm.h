/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_ALARM_H_
#define	_ALARM_H_

typedef	unsigned int	TickType;
typedef	TickType *	TickRefType;

typedef struct t_AlarmBaseType {
	TickType	maxallowedvalue;
	TickType	ticksperbase;
	TickType	mincycle;
} AlarmBaseType;

typedef	AlarmBaseType *	AlarmBaseRefType;
typedef	unsigned int	AlarmType;

extern StatusType	GetAlarmBase(AlarmType, AlarmBaseRefType);
extern StatusType	GetAlarm(AlarmType, TickRefType);
extern StatusType	SetRelAlarm(AlarmType, TickType, TickType);
extern StatusType	SetAbsAlarm(AlarmType, TickType, TickType);
extern StatusType	CancelAlarm(AlarmType);

#endif	/* _ALARM_H_ */
