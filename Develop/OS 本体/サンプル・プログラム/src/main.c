#define	SYSREG_CACR	(*(volatile unsigned int *)(0xE000EF9C))

void
main(void)
{
	SYSREG_CACR	&= 0xfffffff8;

	while(1) {
		;
	}

	return;
}
