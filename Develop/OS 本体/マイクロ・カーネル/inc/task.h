/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_TASK_H_
#define	_TASK_H_

#define	TA_DISDSP	0x04	/* 非プリエンプティブ属性 */

#define	TTS_RUN		0x01	/* RUNNING状態 */
#define	TTS_RDY		0x02	/* READY状態 */
#define	TTS_WAI		0x04	/* WAITING状態 */
#define	TTS_SUS		0x08	/* SUSPENDED状態 */

#define	RUNNING		0x01
#define	WAITING		0x02
#define	READY		0x04
#define	SUSPENDED	0x08

#define	INVALID_TASK	0xffff

typedef	unsigned int	TaskType;
typedef	TaskType *	TaskRefType;
typedef	unsigned char	TaskStateType;
typedef	TaskStateType *	TaskStateRefType;

extern StatusType	ActivateTask(TaskType);
extern StatusType	TerminateTask(void);
extern StatusType	ChainTask(TaskType);
extern StatusType	Schedule(void);
extern StatusType	GetTaskID(TaskRefType);
extern StatusType	GetTaskState(TaskType, TaskStateRefType);

#endif	/* _TASK_H_ */
