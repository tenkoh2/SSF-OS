.ifdef  REG22
    .option reg_mode 5 5
.else
.ifdef  REG26
    .option reg_mode 7 7
.endif
.endif

	.text
	.align	4
	.globl	__tp_getreg
__tp_getreg:
	ld.bu	0[r6], r10
	jmp	[lp]

	.text
	.align	4
	.globl	__tp_setreg
__tp_setreg:
	st.b	r7, 0[r6]
	jmp	[lp]
