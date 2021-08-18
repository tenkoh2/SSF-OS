/*
 *	Interrupt Function
 */

#include	"tplib.h"
#include	"CPU/CPU_NAME/DEVICE_NAME/tpintlib.h"

extern t_tpdata	TpData;

extern char _tp_getreg(int);
extern void _tp_setreg(int, char);

void	tp_enaint(int);
void	tp_disint(int);
void	tp_intsig(int);
void	tp_setintpri(int, char);

void
tp_enaint(int intnum)
{
	char icr;

	icr = _tp_getreg(intnum);
	icr &= ~ICR_MK;
	_tp_setreg(intnum, icr);
}

void
tp_disint(int intnum)
{
	char icr;

	icr = _tp_getreg(intnum);
	icr |= ICR_MK;
	_tp_setreg(intnum, icr);
}

void
tp_intsig(int intnum)
{
	char icr;

	icr = _tp_getreg(intnum);
	icr |= ICR_IF;
	_tp_setreg(intnum, icr);
}

void
tp_setintpri(int intnum, char pri)
{
	char icr;
	icr = _tp_getreg(intnum);
	icr |= pri;
	_tp_setreg(intnum, icr);
}
