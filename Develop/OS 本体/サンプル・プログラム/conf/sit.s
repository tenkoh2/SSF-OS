	.data
	.align	2

	.globl	__start_sit
__start_sit:
	.byte	0x00		@ Hook ���[�`��
	.byte	0x02		@ �^�X�N��
	.byte	0x02		@ ���^�X�N��
	.byte	0x02		@ ���\�[�X��
	.byte	0x02		@ �A���[����
	.byte	0x01		@ �J�E���^��
	.byte	0x01		@ �Z�}�t�H��
	.byte	0x02		@ �~���[�e�b�N�X��
	.byte	0x01		@ ���b�Z�[�W�E�o�b�t�@��
	.byte	0x01		@ �Œ蒷�������E�v�[����
	.byte	0x01		@ �ϒ��������E�v�[����
	.byte	0x02		@ �����n���h����
	.word	0x00000001	@ �^�C�}���荞�ݗv��
	.word	0x00000400	@ �����V�X�e���E�������E�v�[���E�T�C�Y
	.word	0x3b3ff000	@ �����V�X�e���E�������E�v�[���E�擪�A�h���X
	.word	0x00000400	@ �����ϒ��������E�v�[���E�T�C�Y
	.word	0x3b3ff400	@ �����ϒ��������E�v�[���擪�A�h���X
	.word	0x00000400	@ �����Œ蒷�������E�v�[���E�T�C�Y
	.word	0x3b3ff800	@ �����Œ蒷�������E�v�[���擪�A�h���X
	.word	0x3b3ff000	@ �����V�X�e���X�^�b�N


	.extern	taskM1
	.extern	__stack_taskM1
	.extern	taskL1
	.extern	__stack_taskL1
	.global	__start_tib
__start_tib:
	@ �_�~�[�I
	.byte	0x00		@ �^�X�N����
	.byte	0x00		@ �����D��x
	.byte	0x00		@ �A�v���P�[�V�����E���[�h
	.byte	0x00		@ �\��̈�
	.word	0x00000000	@ �C���^�[�i���E���\�[�X
	.word	0x00000000	@ �ő�N����
	.word	0x00000000	@ �ی쎞��
	.word	0x00000000	@ �^�X�N�N��������
	.word	0x00000000	@ �^�X�N�N���A�h���X
	.word	0x00000000	@ �N�����X�^�b�N�E�A�h���X
	.word	0x00000000	@ �A�v���P�[�V����ID
	@ �����܂Ń_�~�[

	.byte	0x00		@ �^�X�N����
	.byte	0x10		@ �����D��x
	.byte	0x01		@ �A�v���P�[�V�����E���[�h
	.byte	0x00		@ �\��̈�
	.word	0x00000001	@ �C���^�[�i���E���\�[�X
	.word	0x000000ff	@ �ő�N����
	.word	0x00000000	@ �ی쎞��
	.word	0x00000000	@ �^�X�N�N��������
	.word	taskM1		@ �^�X�N�N���A�h���X
	.word	__stack_taskM1	@ �N�����X�^�b�N�E�A�h���X
	.word	0x00000000	@ �A�v���P�[�V����ID

	.byte	0x04		@ �^�X�N����
	.byte	0x08		@ �����D��x
	.byte	0x00		@ �A�v���P�[�V�����E���[�h
	.byte	0x00		@ �\��̈�
	.word	0x00000000	@ �C���^�[�i���E���\�[�X
	.word	0x000000ff	@ �ő�N����
	.word	0x00000000	@ �ی쎞��
	.word	0x00000000	@ �^�X�N�N��������
	.word	taskL1		@ �^�X�N�N���A�h���X
	.word	__stack_taskL1	@ �N�����X�^�b�N�E�A�h���X
	.word	0x00000000	@ �A�v���P�[�V����ID


	.extern	ctaskM1
	.extern	__stack_ctaskM1
	.extern	ctaskL1
	.extern	__stack_ctaskL1
	.globl	__start_ctib
__start_ctib:
	@ �_�~�[�I
	.byte	0x00		@ �^�X�N����
	.byte	0x00		@ �����D��x
	.hword	0x0000		@ �\��̈�
	.word	0x00000000	@ �ő�N����
	.word	0x00000000	@ �^�X�N�N��������
	.word	0x00000000	@ �^�X�N�N���A�h���X
	.word	0x00000000	@ �N�����X�^�b�N�E�A�h���X
	@ �����܂Ń_�~�[

	.byte	0x00		@ �^�X�N����
	.byte	0x10		@ �����D��x
	.hword	0x0000		@ �\��̈�
	.word	0x000000ff	@ �ő�N����
	.word	0x00000000	@ �^�X�N�N��������
	.word	ctaskM1		@ �^�X�N�N���A�h���X
	.word	__stack_ctaskM1	@ �N�����X�^�b�N�E�A�h���X

	.byte	0x02		@ �^�X�N����
	.byte	0x18		@ �����D��x
	.hword	0x0000		@ �\��̈�
	.word	0x000000ff	@ �ő�N����
	.word	0x00000000	@ �^�X�N�N��������
	.word	ctaskL1		@ �^�X�N�N���A�h���X
	.word	__stack_ctaskL1	@ �N�����X�^�b�N�E�A�h���X


	.extern	_isr1
	.globl	__start_iib
__start_iib:
	@ �_�~�[�I
	.byte	0x00		@ ���荞�݃n���h������
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x00000000	@ ���荞�݃n���h���N���A�h���X
	@ �����܂Ń_�~�[

	.byte	0x00		@ ���荞�݃n���h������
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	isr1		@ ���荞�݃n���h���N���A�h���X


	.extern	__rdybuf_08
	.extern	__rdybuf_16
	.extern	__rdybuf_24
	.globl	__start_rdybufinf
__start_rdybufinf:
	@ �D��x0
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x1
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x2
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x3
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x4
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x5
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x6
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x7
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x8
	.word	0x00000001	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	__rdybuf_08	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x9
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x10
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x11
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x12
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x13
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x14
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x15
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x16
	.word	0x00000001	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	__rdybuf_16	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x17
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x18
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x19
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x20
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x21
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x22
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x23
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x24
	.word	0x00000001	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	__rdybuf_24	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x25
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x26
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x27
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x28
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x29
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x30
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X

	@ �D��x31
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���f�B�E�o�b�t�@�E�A�h���X


	.globl	__start_seminf
__start_seminf:
	@ �_�~�[�I
	.byte	0x00		@ �Z�}�t�H����
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x00000000	@ ����������
	.word	0x00000000	@ �ő厑����
	@ �����܂Ń_�~�[

	.byte	0x00		@ �Z�}�t�H����
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x0000000a	@ ����������
	.word	0x0000000a	@ �ő厑����


	.globl	__start_rib
__start_rib:
	@ �_�~�[�I
	.byte	0x00		@ ���\�[�X����
	.byte	0x00		@ �V�[�����O�E�v���C�I���e�B
	@ �����܂Ń_�~�[

	.byte	0x02		@ ���\�[�X����
	.byte	0x18		@ �V�[�����O�E�v���C�I���e�B

	.byte	0x00		@ ���\�[�X����
	.byte	0x18		@ �V�[�����O�E�v���C�I���e�B


	.globl	__start_mib
__start_mib:
	@ �_�~�[�I
	.hword	0x0000		@ �~���[�e�b�N�X����
	.hword	0x0000		@ ����D��x
	@ �����܂Ń_�~�[

	.hword	0x0002		@ �~���[�e�b�N�X����
	.hword	0x0000		@ ����D��x

	.hword	0x0003		@ �~���[�e�b�N�X����
	.hword	0x0008		@ ����D��x


	.extern	__mbf_01
	.globl	__start_mbfinf
__start_mbfinf:
	@ �_�~�[�I
	.byte	0x00		@ ���b�Z�[�W�E�o�b�t�@����
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x00000000	@ �ő僁�b�Z�[�W�E�T�C�Y
	.word	0x00000000	@ ���b�Z�[�W�E�o�b�t�@�E�T�C�Y
	.word	0x00000000	@ ���b�Z�[�W�E�o�b�t�@�E�A�h���X
	@ �����܂Ń_�~�[

	.byte	0x02		@ ���b�Z�[�W�E�o�b�t�@����
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x00000010	@ �ő僁�b�Z�[�W�E�T�C�Y
	.word	0x00000400	@ ���b�Z�[�W�E�o�b�t�@�E�T�C�Y
	.word	__mbf_01	@ ���b�Z�[�W�E�o�b�t�@�E�A�h���X


	.globl	__start_mpfinf
__start_mpfinf:
	@ �_�~�[�I
	.byte	0x00		@ �Œ蒷�������E�v�[������
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x00000000	@ �u���b�N��
	.word	0x00000000	@ �u���b�N�E�T�C�Y
	.word	0x00000000	@ �Œ蒷�������E�v�[���擪�A�h���X
	@ �����܂Ń_�~�[

	.byte	0x02		@ �Œ蒷�������E�v�[������
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x00000004	@ �u���b�N��
	.word	0x00000100	@ �u���b�N�E�T�C�Y
	.word	0x3b3ff400	@ �Œ蒷�������E�v�[���擪�A�h���X


	.globl	__start_mplinf
__start_mplinf:
	@ �_�~�[�I
	.byte	0x00		@ �ϒ��������E�v�[������
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x00000000	@ �������E�v�[���E�T�C�Y
	.word	0x00000000	@ �������E�v�[���擪�A�h���X
	@ �����܂Ń_�~�[

	.byte	0x02		@ �ϒ��������E�v�[������
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x00000400	@ �������E�v�[���E�T�C�Y
	.word	0x3b3ff800	@ �������E�v�[���擪�A�h���X


	.globl	__start_time_cntque
__start_time_cntque:
	.word	0x00000001
	.word	0x00000000


	.globl	__start_alminf
__start_alminf:
	@ �_�~�[�I
	.hword	0x0000		@ �A���[������
	.hword	0x0000		@ �J�E���^ID
	.hword	0x0000		@ �^�X�NID
	.hword	0x0000		@ �\��̈�
	.word	0x00000000	@ maxallowedvalue
	.word	0x00000000	@ ticksperbase
	.word	0x00000000	@ mincycle
	.word	0x00000000	@ �C�x���g�E�}�X�N
	@ �����܂Ń_�~�[

	.hword	0x0001		@ �A���[������
	.hword	0x0001		@ �J�E���^ID
	.hword	0x0001		@ �^�X�NID
	.hword	0x0000		@ �\��̈�
	.word	0xffffffff	@ maxallowedvalue
	.word	0x00000000	@ ticksperbase
	.word	0x00000001	@ mincycle
	.word	0x00000000	@ �C�x���g�E�}�X�N

	.hword	0x0002		@ �A���[������
	.hword	0x0001		@ �J�E���^ID
	.hword	0x0002		@ �^�X�NID
	.hword	0x0000		@ �\��̈�
	.word	0xffffffff	@ maxallowedvalue
	.word	0x00000000	@ ticksperbase
	.word	0x00000001	@ mincycle
	.word	0xffffffff	@ �C�x���g�E�}�X�N


	.extern	cychdr1
	.extern	cychdr2
	.globl	__start_cycinf
__start_cycinf:
	@ �_�~�[�I
	.byte	0x00		@ �����n���h������
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	0x00000000	@ �����n���h��
	.word	0x00000000	@ �g�����
	.word	0x00000000	@ �N������
	.word	0x00000000	@ �N���ʑ�
	@ �����܂Ń_�~�[

	.byte	0x06		@ �����n���h������
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	cychdr1		@ �����n���h��
	.word	0x00000000	@ �g�����
	.word	0x00000010	@ �N������
	.word	0x00000008	@ �N���ʑ�

	.byte	0x00		@ �����n���h������
	.byte	0x00		@ �\��̈�
	.hword	0x0000		@ �\��̈�
	.word	cychdr2		@ �����n���h��
	.word	0x00000000	@ �g�����
	.word	0x00000010	@ �N������
	.word	0x00000000	@ �N���ʑ�


	.extern	__init_sem
	.extern	__init_mtx
	.extern	__init_mbf
	.extern	__init_mpf
	.extern	__init_mpl
	.extern	__init_cyc
	.globl	__kernel_init_obj
__kernel_init_obj:
	.word	__init_sem
	.word	__init_mtx
	.word	__init_mbf
	.word	__init_mpf
	.word	__init_mpl
	.word	__init_cyc
	.word	0x00000000
