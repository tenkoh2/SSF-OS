	.bss
	.align	2

	.globl	__start_sbt
__start_sbt:
@	.byte			@ �X�P�W���[���N���t���O
@	.byte			@ �ō��D��x
@	.hword			@ �V�X�e���E�X�e�[�^�X
@	.word			@ �D��x�}�b�v
@	.word			@ �V�X�e���E�������E�v�[���E�T�C�Y
@	.word			@ �V�X�e���E�������E�v�[���̐擪�A�h���X
@	.word			@ �ϒ��������E�v�[���E�T�C�Y
@	.word			@ �ϒ��������E�v�[���̐擪�A�h���X
@	.word			@ �Œ蒷�������E�v�[���E�T�C�Y
@	.word			@ �Œ蒷�������E�v�[���̐擪�A�h���X
@	.word			@ �V�X�e���E�X�^�b�N
@	.hword			@ ���s���^�X�NID
@	.hword			@ ���s���A�v���P�[�V����ID
@	.byte			@ ���^�X�N�̃X�P�W���[���N���t���O
@	.byte			@ ���^�X�N�ō��D��x
@	.hword			@ ���s�����^�X�NID
@	.word			@ ���^�X�N�D��x�}�b�v
@	.hword			@ SuspendAllInterrupts �J�E���g
@	.hword			@ SuspendOSInterrupts �J�E���g
@	.word			@ ���荞�ݏ��(DisableAllInterrupts/EnableAllInterrupts �p)
@	.word			@ ���荞�ݏ��(SuspendAllInterrupts/ResumeAllInterrupts �p)
@	.word			@ ���荞�ݏ��(SuspendOSInterrupts/ResumeOSInterrupts �p)
@	.word			@ CPSR
@	.word			@ �A�v���P�[�V�����E���[�h
@	.word			@ ���荞�ݏ��(��ITRON4.0�p)
@	.word			@ �J�E���^�����l�X�g��
@	.hword			@ �V�X�e������(���16bit)
@	.hword			@ �\��̈�
@	.word			@ �V�X�e������(����32bit)
	.skip	88

	.globl	__start_tcb
__start_tcb:
	@ �_�~�[�I
@	.byte			@ �^�X�N���
@	.byte			@ �N���J�E���g
@	.byte			@ ���ݗD��x
@	.byte			@ �擪�̏��L���\�[�X
@	.word			@ �X�^�b�N�E�A�h���X
@	.word			@ CPSR ���W�X�^
@	.word			@ �A�v���P�[�V����ID
@	.word			@ �C�x���g
@	.word			@ �҂��C�x���g�̃p�^�[��
	.skip	24
	@ �����܂Ń_�~�[

@	.byte			@ �^�X�N���
@	.byte			@ �N���J�E���g
@	.byte			@ ���ݗD��x
@	.byte			@ �擪�̏��L���\�[�X
@	.word			@ �X�^�b�N�E�A�h���X
@	.word			@ CPSR ���W�X�^
@	.word			@ �A�v���P�[�V����ID
@	.word			@ �C�x���g
@	.word			@ �҂��C�x���g�̃p�^�[��
	.skip	24

@	.byte			@ �^�X�N���
@	.byte			@ �N���J�E���g
@	.byte			@ ���ݗD��x
@	.byte			@ �擪�̏��L���\�[�X
@	.word			@ �X�^�b�N�E�A�h���X
@	.word			@ CPSR ���W�X�^
@	.word			@ �A�v���P�[�V����ID
@	.word			@ �C�x���g
@	.word			@ �҂��C�x���g�̃p�^�[��
	.skip	24

	.globl	__start_ctcb
__start_ctcb:
	@ �_�~�[�I
@	.word			@ �^�C�}�E�L���[�󃊃��N�p�^�X�NID
@	.word			@ �^�C�}�E�L���[�󃊃��N�p�^�X�NID
@	.word			@ �҂�����
@	.byte			@ �^�X�N���
@	.byte			@ �N���J�E���g
@	.byte			@ �X���[�v�E�l�X�g��
@	.byte			@ �T�X�y���h�E�l�X�g��
@	.byte			@ ���ݗD��x
@	.byte			@ �x�[�X�D��x
@	.hword			@ �\��̈�
@	.word			@ �T�[�r�X�E�R�[���߂�l
@	.word			@ �҂��v��
@	.word			@ �҂��I�u�W�F�N�gID
@	.word			@ sta_tsk �ɂ��N���R�[�h
@	.word			@ �X�^�b�N�E�A�h���X
@	.word			@ CPSR ���W�X�^
@	.word			@ ���b�N���Ă���~���[�e�b�N�XID(�擪ID)
@	.word			@ �󃊃��N�p�^�X�NID
@	.word			@ �󃊃��N�p�^�X�NID
	.skip	56
	@ �����܂Ń_�~�[

@	.word			@ �^�C�}�E�L���[�󃊃��N�p�^�X�NID
@	.word			@ �^�C�}�E�L���[�󃊃��N�p�^�X�NID
@	.word			@ �҂�����
@	.byte			@ �^�X�N���
@	.byte			@ �N���J�E���g
@	.byte			@ �X���[�v�E�l�X�g��
@	.byte			@ �T�X�y���h�E�l�X�g��
@	.byte			@ ���ݗD��x
@	.byte			@ �x�[�X�D��x
@	.hword			@ �\��̈�
@	.word			@ �T�[�r�X�E�R�[���߂�l
@	.word			@ �҂��v��
@	.word			@ �҂��I�u�W�F�N�gID
@	.word			@ sta_tsk �ɂ��N���R�[�h
@	.word			@ �X�^�b�N�E�A�h���X
@	.word			@ CPSR ���W�X�^
@	.word			@ ���b�N���Ă���~���[�e�b�N�XID(�擪ID)
@	.word			@ �󃊃��N�p�^�X�NID
@	.word			@ �󃊃��N�p�^�X�NID
	.skip	56


	.globl	__start_rdybuf
__start_rdybuf:
	@ �D��x0
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x1
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x2
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x3
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x4
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x5
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x6
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x7
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x8
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x9
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x10
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x11
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x12
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x13
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x14
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x15
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x16
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x17
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x18
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x19
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x20
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x21
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x22
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x23
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x24
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x25
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x26
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x27
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x28
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x29
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x30
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	@ �D��x31
@	.hword			@ ���C�g�E�C���f�b�N�X
@	.hword			@ ���[�h�E�C���f�b�N�X
@	.word			@ ���f�B�E�o�b�t�@�E�T�C�Y
@	.word			@ ���f�B�E�o�b�t�@�E�A�h���X
	.skip	12

	.globl	__start_semctrl
__start_semctrl:
	@ �_�~�[�I
@	.word			@ �҂��^�X�NID
@	.word			@ ������
	.skip	8
	@ �����܂Ń_�~�[

@	.word			@ �҂��^�X�NID
@	.word			@ ������
	.skip	8


	.globl	__start_rcb
__start_rcb:
	@ �_�~�[�I
@	.word			@ ���\�[�X���l�����Ă���^�X�N��ID
@	.word			@ ���̃��\�[�XID
	.skip	8
	@ �����܂Ń_�~�[

@	.word			@ ���\�[�X���l�����Ă���^�X�N��ID
@	.word			@ ���̃��\�[�XID
	.skip	8

@	.word			@ ���\�[�X���l�����Ă���^�X�N��ID
@	.word			@ ���̃��\�[�XID
	.skip	8


	.globl	__start_mcb
__start_mcb:
	@ �_�~�[�I
	.word			@ �҂��^�X�NID
@	.word			@ �~���[�e�b�N�X�����b�N���Ă��鏀�^�X�N��ID
@	.skip	8
	@ �����܂Ń_�~�[

@	.word			@ �҂��^�X�NID
@	.word			@ �~���[�e�b�N�X�����b�N���Ă��鏀�^�X�N��ID
	.skip	8

@	.word			@ �҂��^�X�NID
@	.word			@ �~���[�e�b�N�X�����b�N���Ă��鏀�^�X�N��ID
	.skip	8


	.globl	__start_mbfctrl
__start_mbfctrl:
	@ �_�~�[�I
@	.word			@ ���M�҂����^�X�NID
@	.word			@ ��M�҂����^�X�NID
@	.word			@ ���b�Z�[�W��
@	.word			@ �󂫃T�C�Y
@	.word			@ ���M�J�n�A�h���X
@	.word			@ ��M�J�n�A�h���X
	.skip	24
	@ �����܂Ń_�~�[

@	.word			@ ���M�҂����^�X�NID
@	.word			@ ��M�҂����^�X�NID
@	.word			@ ���b�Z�[�W��
@	.word			@ �󂫃T�C�Y
@	.word			@ ���M�J�n�A�h���X
@	.word			@ ��M�J�n�A�h���X
	.skip	24


	.globl	__start_mpfctrl
__start_mpfctrl:
	@ �_�~�[�I
@	.word			@ �������E�u���b�N�l���҂����^�X�NID
@	.word			@ �󂫃������E�u���b�N��
@	.word			@ �������E�u���b�N�擪�A�h���X
	.skip	12
	@ �����܂Ń_�~�[

@	.word			@ �������E�u���b�N�l���҂����^�X�NID
@	.word			@ �󂫃������E�u���b�N��
@	.word			@ �������E�u���b�N�擪�A�h���X
	.skip	12


	.globl	__start_mplctrl
__start_mplctrl:
	@ �_�~�[�I
@	.word			@ �������E�u���b�N�l���҂����^�X�NID
@	.word			@ �������E�u���b�N�擪�A�h���X
	.skip	8
	@ �����܂Ń_�~�[

@	.word			@ �������E�u���b�N�l���҂����^�X�NID
@	.word			@ �������E�u���b�N�擪�A�h���X
	.skip	8


	.globl __rdybuf_08
	.globl __rdybuf_16
	.globl __rdybuf_24
__rdybuf_08:	.skip	0x04
__rdybuf_16:	.skip	0x04
__rdybuf_24:	.skip	0x04


	.globl	__start_cntctrl
__start_cntctrl:
	@ �_�~�[�I
@	.word
@	.word
	.skip	8
	@ �����܂Ń_�~�[

@	.word
@	.word
	.skip	8


	.globl	__start_almctrl
__start_almctrl:
	@ �_�~�[�I
@	.word
@	.word
@	.word
@	.word
@	.word
	.skip	20
	@ �����܂Ń_�~�[

@	.word
@	.word
@	.word
@	.word
@	.word
	.skip	20

@	.word
@	.word
@	.word
@	.word
@	.word
	.skip	20


	.globl	__start_cycctrl
__start_cycctrl:
	@ �_�~�[�I
@	.hword
@	.hword
@	.word
@	.word
@	.word
	.skip	16
	@ �����܂Ń_�~�[

@	.hword
@	.hword
@	.word
@	.word
@	.word
	.skip	16

@	.hword
@	.hword
@	.word
@	.word
@	.word
	.skip	16


	.globl	__start_rdyque_head
__start_rdyque_head:	.skip	0x80


	.globl	__start_cycque_head
__start_cycque_head:	.skip	0x04


	.globl	__start_timerque_head
__start_timerque_head:	.skip	0x04


	.globl	__mbf_01
__mbf_01:	.skip	0x0400
