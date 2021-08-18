@
@	SSF-OS
@	(C) 2020 Fukuda, Kouji
@

BASE_ADDR_INTERRUPT_REG_1	=	0x3f00
BASE_ADDR_INTERRUPT_REG_2	=	0xb000
IRQ_BASIC_PENDING		=	0x200
IRQ_PENDING_1			=	0x204
IRQ_PENDING_2			=	0x208
FIQ_CONTROL			=	0x20c

	.text
	.align	2

	.globl	_kernel_int_factor
_kernel_int_factor:
	mov	r0, #0
	mov	r1, #BASE_ADDR_INTERRUPT_REG_1
	lsl	r1, r1, #16
	mov	r3, #BASE_ADDR_INTERRUPT_REG_2
	add	r1, r1, r3
	ldr	r3, [r1, #IRQ_BASIC_PENDING]
	mov	r2, #1
	ands	r4, r3, r2
	beq	.int_fact_1

	@ ARM Timer IRQ
	mov	r0, #65
	bx	lr

.int_fact_1:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_2

	@ ARM Mailbox IRQ
	mov	r0, #65
	bx	lr

.int_fact_2:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_3

	@ ARM Doorbell 0 IRQ
	mov	r0, #66
	bx	lr

.int_fact_3:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_4

	@ ARM Doorbell 1 IRQ
	mov	r0, #67
	bx	lr

.int_fact_4:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_69

	@ GPU0 halted IRQ
	mov	r0, #68
	bx	lr

.int_fact_69:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_70

	@ GPU1 halted IRQ
	mov	r0, #69
	bx	lr

.int_fact_70:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_71

	@ Illegal access type 1 IRQ
	mov	r0, #70
	bx	lr

.int_fact_71:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_72

	@ Illegal access type 0 IRQ
	mov	r0, #71
	bx	lr

.int_fact_72:
	lsl	r2, r2, #3
	ands	r4, r3, r2
	beq	.int_fact_5

	@ GPU IRQ 7
	mov	r0, #7
	bx	lr

.int_fact_5:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_6

	@ GPU IRQ 9
	mov	r0, #9
	bx	lr

.int_fact_6:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_7

	@ GPU IRQ 10
	mov	r0, #10
	bx	lr

.int_fact_7:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_8

	@ GPU IRQ 18
	mov	r0, #18
	bx	lr

.int_fact_8:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_9

	@ GPU IRQ 19
	mov	r0, #19
	bx	lr

.int_fact_9:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_10

	@ GPU IRQ 53
	mov	r0, #53
	bx	lr

.int_fact_10:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_11

	@ GPU IRQ 54
	mov	r0, #54
	bx	lr

.int_fact_11:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_12

	@ GPU IRQ 55
	mov	r0, #55
	bx	lr

.int_fact_12:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_13

	@ GPU IRQ 56
	mov	r0, #56
	bx	lr

.int_fact_13:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_14

	@ GPU IRQ 57
	mov	r0, #57
	bx	lr

.int_fact_14:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_15

	@ GPU IRQ 62
	mov	r0, #62
	bx	lr

.int_fact_15:
	ldr	r3, [r1, #IRQ_PENDING_1]
	mov	r2, #1

	ands	r4, r3, r2
	beq	.int_fact_16

	@ IRQ 0
	mov	r0, #0
	bx	lr

.int_fact_16:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_17

	@ IRQ 1
	mov	r0, #1
	bx	lr

.int_fact_17:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_18

	@ IRQ 2
	mov	r0, #2
	bx	lr

.int_fact_18:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_19

	@ IRQ 3
	mov	r0, #3
	bx	lr

.int_fact_19:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_20

	@ IRQ 4
	mov	r0, #4
	bx	lr

.int_fact_20:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_21

	@ IRQ 5
	mov	r0, #5
	bx	lr

.int_fact_21:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_22

	@ IRQ 6
	mov	r0, #6
	bx	lr

.int_fact_22:
	lsl	r2, r2, #2
	ands	r4, r3, r2
	beq	.int_fact_23

	@ IRQ 8
	mov	r0, #8
	bx	lr

.int_fact_23:
	lsl	r2, r2, #2
	ands	r4, r3, r2
	beq	.int_fact_24

	@ IRQ 11
	mov	r0, #11
	bx	lr

.int_fact_24:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_25

	@ IRQ 12
	mov	r0, #12
	bx	lr

.int_fact_25:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_26

	@ IRQ 13
	mov	r0, #13
	bx	lr

.int_fact_26:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_27

	@ IRQ 14
	mov	r0, #14
	bx	lr

.int_fact_27:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_28

	@ IRQ 15
	mov	r0, #15
	bx	lr

.int_fact_28:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_29

	@ IRQ 16
	mov	r0, #16
	bx	lr

.int_fact_29:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_30

	@ IRQ 17
	mov	r0, #17
	bx	lr

.int_fact_30:
	lsl	r2, r2, #3
	ands	r4, r3, r2
	beq	.int_fact_31

	@ IRQ 20
	mov	r0, #20
	bx	lr

.int_fact_31:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_32

	@ IRQ 21
	mov	r0, #21
	bx	lr

.int_fact_32:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_33

	@ IRQ 22
	mov	r0, #22
	bx	lr

.int_fact_33:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_34

	@ IRQ 23
	mov	r0, #23
	bx	lr

.int_fact_34:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_35

	@ IRQ 24
	mov	r0, #24
	bx	lr

.int_fact_35:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_36

	@ IRQ 25
	mov	r0, #25
	bx	lr

.int_fact_36:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_37

	@ IRQ 26
	mov	r0, #26
	bx	lr

.int_fact_37:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_38

	@ IRQ 27
	mov	r0, #27
	bx	lr

.int_fact_38:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_39

	@ IRQ 28
	mov	r0, #28
	bx	lr

.int_fact_39:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_40

	@ IRQ 29
	mov	r0, #29
	bx	lr

.int_fact_40:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_41

	@ IRQ 30
	mov	r0, #30
	bx	lr

.int_fact_41:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_42

	@ IRQ 31
	mov	r0, #31
	bx	lr

.int_fact_42:
	ldr	r3, [r1, #IRQ_PENDING_1]
	mov	r2, #1

	ands	r4, r3, r2
	beq	.int_fact_43

	@ IRQ 32
	mov	r0, #32
	bx	lr

.int_fact_43:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_44

	@ IRQ 33
	mov	r0, #33
	bx	lr

.int_fact_44:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_45

	@ IRQ 34
	mov	r0, #34
	bx	lr

.int_fact_45:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_46

	@ IRQ 35
	mov	r0, #35
	bx	lr

.int_fact_46:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_47

	@ IRQ 36
	mov	r0, #36
	bx	lr

.int_fact_47:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_48

	@ IRQ 37
	mov	r0, #37
	bx	lr

.int_fact_48:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_49

	@ IRQ 38
	mov	r0, #38
	bx	lr

.int_fact_49:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_50

	@ IRQ 39
	mov	r0, #39
	bx	lr

.int_fact_50:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_51

	@ IRQ 40
	mov	r0, #40
	bx	lr

.int_fact_51:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_52

	@ IRQ 41
	mov	r0, #41
	bx	lr

.int_fact_52:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_53

	@ IRQ 42
	mov	r0, #42
	bx	lr

.int_fact_53:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_54

	@ IRQ 43
	mov	r0, #43
	bx	lr

.int_fact_54:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_55

	@ IRQ 44
	mov	r0, #44
	bx	lr

.int_fact_55:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_56

	@ IRQ 45
	mov	r0, #45
	bx	lr

.int_fact_56:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_57

	@ IRQ 46
	mov	r0, #46
	bx	lr

.int_fact_57:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_58

	@ IRQ 47
	mov	r0, #47
	bx	lr

.int_fact_58:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_59

	@ IRQ 48
	mov	r0, #48
	bx	lr

.int_fact_59:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_60

	@ IRQ 49
	mov	r0, #49
	bx	lr

.int_fact_60:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_61

	@ IRQ 50
	mov	r0, #50
	bx	lr

.int_fact_61:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_62

	@ IRQ 51
	mov	r0, #51
	bx	lr

.int_fact_62:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_63

	@ IRQ 52
	mov	r0, #52
	bx	lr

.int_fact_63:
	lsl	r2, r2, #6
	ands	r4, r3, r2
	beq	.int_fact_64

	@ IRQ 58
	mov	r0, #58
	bx	lr

.int_fact_64:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_65

	@ IRQ 59
	mov	r0, #59
	bx	lr

.int_fact_65:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_66

	@ IRQ 60
	mov	r0, #60
	bx	lr

.int_fact_66:
	lsl	r2, r2, #1
	ands	r4, r3, r2
	beq	.int_fact_67

	@ IRQ 61
	mov	r0, #61
	bx	lr

.int_fact_67:
	lsl	r2, r2, #2
	ands	r4, r3, r2
	beq	.int_fact_68

	@ IRQ 63
	mov	r0, #63
	bx	lr

.int_fact_68:
	mov	r0, #-1
	bx	lr
