/*
 *	SSF-OS
 *	(C) 2020 Fukuda, Kouji
 */

#ifndef	_RESOURCE_H_
#define	_RESOURCE_H_

typedef	unsigned int	ResourceType;

extern StatusType	GetResource(ResourceType);
extern StatusType	ReleaseResource(ResourceType);

#endif	/* _RESOURCE_H_ */
