OUTPUT_ARCH(arm)
ENTRY(_start)
SECTIONS
{
	. = 0x8000;
	.text :		{ *(.text*) }
	. = ALIGN(2);

	.rodata :	{ *(.rodata*) }
	. = ALIGN(2);

	.data :		{ *(.data*) }
	. = ALIGN(2);

	.bss :		{ *(.bss*) }
	. = ALIGN(2);
}
