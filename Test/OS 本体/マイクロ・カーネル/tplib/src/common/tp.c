#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include	"tplib.h"

extern t_tpdata	TpData;
char		refcpcnt;
char		rstcpcnt;
int		msgidx;

void	tp_init(char *, bool);
void	tp_refcp(int);
void	tp_cp(int);
void	tp_check(int, int, char *);
void	tp_exit(void);
void	_tp_cmpcp(void);
void	tp_printf(char *, ...);
void	tp_end(void);

void
tp_init(char *tpnum, bool tpflag)
{
	int	i;

	TpData.result_flag = tpflag;
	TpData.fail_flag = TRUE;

	for (i = 0; i < MAXCPNUM; i++) {
		TpData.refcp[i] = 0;
	}

	for (i = 0; i < MAXCPNUM; i++) {
		TpData.rstcp[i] = 0;
	}

	for (i = 0; i < MSGLENGS; i++) {
		TpData.tpmsg[i] = 0;
	}

	refcpcnt = 0;
	rstcpcnt = 0;
	msgidx = 0;

	tp_printf(tpnum);
}

void
tp_refcp(int cpnum)
{
	TpData.refcp[refcpcnt++] = cpnum;
}

void
tp_cp(int cpnum)
{
	TpData.rstcp[rstcpcnt++] = cpnum;
}

void
tp_check(int src, int des, char *msg)
{
	if (src != des) {
		TpData.fail_flag = FALSE;
		if (TpData.result_flag) {
			tp_printf("\n %s compare failed. %d should be %d\n", msg, src, des);
		}
	}
}

void
tp_exit(void)
{
	FILE	*log;

	if (log = fopen("tp.log", "a")) {
		tp_end();
	}

	_tp_cmpcp();

	if (TpData.fail_flag) {
		tp_printf("\tPASSED\n");
		fputs(TpData.tpmsg, log);
	}
	else {
		tp_printf("\tFAILED\n");
		fputs(TpData.tpmsg, log);
	}

	fclose(log);

	tp_end();
}

void
_tp_cmpcp(void)
{
	char	i, j;
	bool	flag = TRUE;

	for (i = 0; (i < refcpcnt) || (i < rstcpcnt); i++) {
		if (TpData.refcp[i] != TpData.rstcp[i]) {
			TpData.fail_flag = flag = FALSE;
		}
	}
	if ((!flag) && (TpData.result_flag)) {
		for (i = 0; (i < refcpcnt) || (i < rstcpcnt); i++) {
			if (TpData.refcp[i] == 0) {
				tp_printf("\n----\t%d", TpData.rstcp[i]);
			}
			else if (TpData.rstcp[i] == 0) {
				tp_printf("\n%d\t----", TpData.refcp[i]);
			}
			else {
				tp_printf("\n%d\t%d", TpData.refcp[i], TpData.rstcp[i]);
			}
		}
	}
}

void
tp_printf(char *msg, ...)
{
	va_list list;
	int 	i, len, type_d, type_x;
	char	c, *type_s, buf[64];

	va_start(list, msg);

	while ((c = *msg++) != '\0') {
		if (c != '%') {
			TpData.tpmsg[msgidx++] = c;
		}
		else {
			c = *msg++;
			switch (c) {
			case 'd':
				type_d = va_arg(list, int);
				sprintf(buf, "%d", type_d);
				len = strlen(buf);
				for (i = 0; i < len; i++) {
					TpData.tpmsg[msgidx++] = buf[i];
				}
				break;
			case 'x':
				type_x = va_arg(list, int);
				sprintf(buf, "%x", type_x);
				len = strlen(buf);
				for (i = 0; i < len; i++) {
					TpData.tpmsg[msgidx++] = buf[i];
				}
				break;
			case 's':
				type_s = va_arg(list, char *);
				len = strlen(type_s);
				for (i = 0; i < len; i++) {
					TpData.tpmsg[msgidx++] = type_s[i];
				}
				break;
			default:
				tp_end();
			}
		}
	}
}

void
tp_end(void)
{
	for(;;);
}
