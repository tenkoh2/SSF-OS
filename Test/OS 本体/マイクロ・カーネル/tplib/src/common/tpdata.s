.ifdef  REG22
    .option reg_mode 5 5
.else
.ifdef  REG26
    .option reg_mode 7 7
.endif
.endif

#-----------------------------------------------------------------------------
#	TpData declaration for creating bss section
#-----------------------------------------------------------------------------
	.globl	_TpData
	.section ".tpdata", bss
	.lcomm	_TpData, 0x3104, 4
