/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_EVENT_H_
#define	_EVENT_H_

typedef	unsigned int	EventMaskType;
typedef	EventMaskType *	EventMaskRefType;

extern StatusType	SetEvent(TaskType, EventMaskType);
extern StatusType	ClearEvent(EventMaskType);
extern StatusType	GetEvent(TaskType, EventMaskRefType);
extern StatusType	WaitEvent(EventMaskType);

#endif	/* _EVENT_H_ */
