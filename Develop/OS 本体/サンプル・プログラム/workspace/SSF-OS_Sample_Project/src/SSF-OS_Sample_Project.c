/*
 ============================================================================
 Name        : SSF-OS.c
 Author      : tenkoh
 Version     :
 Copyright   : Fukuda, Kouji
 Description : Hello World in C, Ansi-style
 ============================================================================
 */

#include "kernel.h"

void
taskM1(void)
{
	ActivateTask(2);
}

void
taskL1(void)
{
}

void
ctaskM1(int exinf)
{
	int i;
	act_tsk(2);
	for (i = 0; i < 10; i++) {
		wai_sem(1);
	}
	wai_sem(1);
}

void
ctaskL1(int exinf)
{
	sig_sem(1);

	asm("msr	cpsr_c, #0x0");
	while (*(volatile unsigned int *)(0x2000B898) & 0x80000000);
	*(volatile unsigned int *)(0x2000B8A0) = 0xfffffff1;
}

void
isr1(void)
{
}

void
cychdr1(void)
{
}

void
cychdr2(void)
{
}
