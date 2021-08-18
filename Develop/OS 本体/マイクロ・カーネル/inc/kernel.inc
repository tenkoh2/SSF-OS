TRUE			=	1
FALSE			=	0

@
@	SBT
@
u1_sbt_sts		=	0
u1_sbt_sch_ena		=	0
u1_sbt_highest_tsk	=	1
u2_sbt_syssts		=	2
u4_sbt_primap		=	4
u4_sbt_sysmplsz		=	8
pv4_sbt_sysmpl_head	=	12
u4_sbt_mplsz		=	16
pv4_sbt_mpl_head	=	20
u4_sbt_mpfsz		=	24
pv4_sbt_mpf_head	=	28
pv4_sbt_sysstk		=	32
u2_sbt_runtsk		=	36
u2_sbt_runapp		=	38
s1_sbt_sch_c_ena	=	40
u1_sbt_highest_ctsk	=	41
u2_sbt_runctsk		=	42
u4_sbt_cprimap		=	44
u2_sbt_susallcnt	=	48
u2_sbt_susoscnt		=	50
u4_sbt_disallmsk	=	52
u4_sbt_idmsk		=	56
u4_sbt_intmsk		=	60
u4_sbt_cpsr		=	64
u4_sbt_appmode		=	68
u4_sbt_intsts		=	72
u4_sbt_cntnst		=	76
u2_sbt_utim		=	80
u2_sbt_rfu1		=	82
u4_sbt_ltim		=	84


SBT_sts_syslvl		=	0x08
SBT_sts_syslvl_MASK	=	0x38
SBT_sts_intnst_MASK	=	0x07
SBT_sts_disdsp		=	0x04

SBT_sch_ena_ENA		=	0x80


@
@	SIT
@
u1_sit_hook		=	0
u1_sit_tsknum		=	1
u1_sit_ctsknum		=	2
u1_sit_rscnum		=	3
u1_sit_almnum		=	4
u1_sit_cntnum		=	5
u1_sit_semnum		=	6
u1_sit_mtxnum		=	7
u1_sit_mbfnum		=	8
u1_sit_mpfnum		=	9
u1_sit_mplnum		=	10
u1_sit_cycnum		=	11
u4_sit_tintfact		=	12
u4_sit_isysmplsz	=	16
pv4_sit_isysmpl_head	=	20
u4_sit_implsz		=	24
pv4_sit_impl_head	=	28
u4_sit_impfsz		=	32
pv4_sit_impf_head	=	36
pv4_sit_isysstk		=	40
pv4_sit_iidlstk		=	44


@
@	TCB
@
SIZE_tcb		=	24
u1_tcb_sts		=	0
u1_tcb_actcnt		=	1
u1_tcb_pri		=	2
u1_tcb_res		=	3
pv4_tcb_stack		=	4
u4_tcb_cpsr		=	8
u4_tcb_appid		=	12
u4_tcb_event		=	16
u4_tcb_waievent		=	20

TCB_sts_suspneded	=	0x00
TCB_sts_run		=	0x01
TCB_sts_ready		=	0x02
TCB_sts_waiting		=	0x04
TCB_sts_all		=	0x07
TCB_sts_ctxexist	=	0x40
TCB_sts_ictxexist	=	0x80

@
@	CTCB
@
SIZE_ctcb		=	56
u4_ctcb_tprev		=	0
u4_ctcb_tnext		=	4
u4_ctcb_waitick		=	8
u1_ctcb_sts		=	12
u1_ctcb_actcnt		=	13
u1_ctcb_slpcnt		=	14
u1_ctcb_suscnt		=	15
u1_ctcb_pri		=	16
u1_ctcb_bpri		=	17
u2_ctcb_rfu		=	18
u4_ctcb_rtnprm		=	20
u4_ctcb_taskwait	=	24
u4_ctcb_wobjid		=	28
s4_ctcb_stacd		=	32
pv4_ctcb_stack		=	36
u4_ctcb_cpsr		=	40
u4_ctcb_mtxid		=	44
u4_ctcb_prev		=	48
u4_ctcb_next		=	52

CTCB_sts_run		=	0x01
CTCB_sts_ready		=	0x02
CTCB_sts_wait		=	0x04
CTCB_sts_suspended	=	0x08
CTCB_sts_dormant	=	0x10
CTCB_sts_all		=	0x1f
CTCB_sts_statsk		=	0x20
CTCB_sts_ctxexist	=	0x40
CTCB_sts_ictxexist	=	0x80

TA_ACT			=	0x02

TTS_RUN			=	0x01
TTS_RDY			=	0x02
TTS_WAI			=	0x04
TTS_SUS			=	0x08
TTS_WAS			=	0x0c
TTS_DMT			=	0x10


@
@	TIB
@
SIZE_tib		=	32
u1_tib_atr		=	0
u1_tib_ipri		=	1
u1_tib_appmode		=	2
u1_tib_rfu1		=	3
u4_tib_ires		=	4
u4_tib_actcnt		=	8
u4_tib_time		=	12
s4_tib_exinf		=	16
pv4_tib_task		=	20
pv4_tib_istack		=	24
u4_tib_appid		=	28

CTIB_atr_disdsp		=	0x04


@
@	CTIB
@
SIZE_ctib		=	20
u1_ctib_atr		=	0
u1_ctib_ipri		=	1
u2_ctib_rfu1		=	2
u4_ctib_actcnt		=	4
s4_ctib_exinf		=	8
pv4_ctib_task		=	12
pv4_ctib_istack		=	16

TIB_atr_disdsp		=	0x04


@
@	IIB
@
SIZE_iib		=	8
u1_iib_atr		=	0
u1_iib_rfu1		=	1
u2_iib_rfu2		=	2
pv4_iib_isr		=	4


SIZE_rdybuf		=	12
u2_rdybuf_widx		=	0
u2_rdybuf_ridx		=	2
u4_rdybuf_bufsize	=	4
pu4_rdybuf_rdybuf	=	8


SIZE_rdybufinf		=	8
u4_rdybufinf_bufsize	=	0
pu4_rdybufinf_rdybuf	=	4


SIZE_timerque		=	4
u4_timerque_head	=	0


SIZE_seminf		=	12
u1_seminf_atr		=	0
u1_seminf_rfu1		=	1
u2_seminf_rfu2		=	2
u4_seminf_isemcnt	=	4
u4_seminf_maxsem	=	8


SIZE_semctrl		=	8
u4_semctrl_wtskid	=	0
u4_semctrl_semcnt	=	4


SIZE_rsem		=	8
u4_rsem_wtskid		=	0
u4_rsem_semcnt		=	4


SIZE_rib		=	2
u1_rib_atr		=	0
u1_rib_ceilpri		=	1

RIB_ATR_STANDARD	=	0x00
RIB_ATR_INTERNAL	=	0x02


SIZE_rcb		=	8
u4_rcb_tid		=	0
u4_rcb_rid		=	4


SIZE_mib		=	4
u2_mib_mtxatr		=	0
u2_mib_ceilpri		=	2

TA_INHERIT		=	0x02
TA_CEILING		=	0x03


SIZE_mcb		=	8
u4_mcb_wtskid		=	0
u4_mcb_tskid		=	4


SIZE_rmtx		=	8
u4_rmtx_htskid		=	0
u4_rmtx_wtskid		=	4


SIZE_mbfinf		=	16
u1_mbfinf_mbfatr	=	0
u1_mbfinf_rfu1		=	1
u2_mbfinf_rfu2		=	2
u4_mbfinf_maxmsz	=	4
u4_mbfinf_mbfsz		=	8
pv4_mbfinf_mbf		=	12


SIZE_mbfctrl		=	24
u4_mbfctrl_stskid	=	0
u4_mbfctrl_rtskid	=	4
u4_mbfctrl_smsgcnt	=	8
u4_mbfctrl_fmbfsz	=	12
u4_mbfctrl_sndaddr	=	16
u4_mbfctrl_rcvaddr	=	20


SIZE_rmbf		=	16
u4_rmbf_stskid		=	0
u4_rmbf_rtskid		=	4
u4_rmbf_smsgcnt		=	8
u4_rmbf_fmbfsz		=	12


SIZE_mpfinf		=	16
u1_mpfinf_mpfatr	=	0
u1_mpfinf_rfu1		=	1
u2_mpfinf_rfu2		=	2
u4_mpfinf_blkcnt	=	4
u4_mpfinf_blksz		=	8
pv4_mpfinf_mpf		=	12


SIZE_mpfctrl		=	12
u4_mpfctrl_wtskid	=	0
u4_mpfctrl_fblkcnt	=	4
pv4_mplctrl_mpf		=	8


SIZE_rmpf		=	8
u4_rmpf_wtskid		=	0
u4_rmpf_fblkcnt		=	4


u4_mpf_size		=	0
u4_mpf_next		=	4


MPF_TERMINATE		=	0xffffffff


SIZE_mplinf		=	12
u1_mplinf_mplatr	=	0
u1_mplinf_rfu1		=	1
u2_mplinf_rfu2		=	2
u4_mplinf_mplsz		=	4
pv4_mplinf_mpl		=	8


SIZE_mplctrl		=	8
u4_mplctrl_wtskid	=	0
pv4_mplctrl_mpl		=	4


SIZE_rmpl		=	12
u4_rmpl_wtskid		=	0
u4_rmpl_fmplsz		=	4
u4_rmpl_fblksz		=	8


SIZE_mplheader		=	8
u4_mpl_size		=	0
u4_mpl_next		=	4


MPL_TERMINATE		=	0xffffffff


SIZE_cycinf		=	20
u1_cycinf_cycatr	=	0
u1_cycinf_rfu1		=	1
u2_cycinf_rfu2		=	2
pv4_cycinf_cychdr	=	4
u4_cycinf_exinf		=	8
u4_cycinf_cyctim	=	12
u4_cycinf_cycphs	=	16


SIZE_cycctrl		=	16
u2_cycctrl_sts		=	0
u2_cycctrl_rfu1		=	2
u4_cycctrl_cyctim	=	4
u4_cycctrl_prev		=	8
u4_cycctrl_next		=	12


SIZE_rcyc		=	8
u1_rcyc_cycstat		=	0
u1_rcyc_rfu1		=	1
u2_rcyc_rfu2		=	2
u4_rcyc_lefttim		=	4


TA_STA			=	0x02
TA_PHS			=	0x04

TCYC_STP		=	0x00
TCYC_STA		=	0x01


SIZE_cntctrl		=	8
u4_cntctrl_alrmid	=	0
u4_cntctrl_cntvalue	=	4


SIZE_alminf		=	24
u2_alminf_almatr	=	0
u2_alminf_cntid		=	2
u2_alminf_tskid		=	4
u2_alminf_rfu1		=	6
u4_alminf_maxalwdval	=	8
u4_alminf_tickspbase	=	12
u4_alminf_mincycle	=	16
u4_alminf_eventmask	=	20

ALMINF_ATR_ACTTSK	=	0x01
ALMINF_ATR_SETEVT	=	0x02


SIZE_almctrl		=	20
u4_almctrl_sts		=	0
u4_almctrl_tick		=	4
u4_almctrl_cycle	=	8
u4_almctrl_next		=	12
u4_almctrl_prev		=	16


ALMCTRL_STS_STP		=	0x00
ALMCTRL_STS_STA		=	0x02


SIZE_almbsreftype	=	12
u4_almbsreftype_maxalwdval	=	0
u4_almbsreftype_tickspbase	=	4
u4_almbsreftype_mincycle	=	8


u1_rtsk_tskstat		=	0
u1_rtsk_rfu1		=	1
u2_rtsk_tskpri		=	2
u2_rtsk_tskbpri		=	4
u2_rtsk_tskwait		=	6
u2_rtsk_wobjid		=	8
u2_rtsk_rfu2		=	10
u4_rtsk_lefttmo		=	12
u4_rtsk_actcnt		=	16
u4_rtsk_wupcnt		=	20
u4_rtsk_suscnt		=	24


TA_TFIFO		=	0x00
TA_TPRI			=	0x01


TTW_SLP			=	0x0001
TTW_DLY			=	0x0002
TTW_SEM			=	0x0004
TTW_MTX			=	0x0080
TTW_SMBF		=	0x0100
TTW_RMBF		=	0x0200
TTW_MPF			=	0x2000
TTW_MPL			=	0x4000
TTW_ALL			=	0x6387


MASK_AIF		=	0
MASK_IF			=	0x000000c0

MODE_USR		=	0x10
MODE_FIQ		=	0x11
MODE_IRQ		=	0x12
MODE_SVC		=	0x13
MODE_ABT		=	0x17
MODE_UND		=	0x1b
MODE_SYS		=	0x1f

ADDR_svc		=	0
ID_kind_task		=	0
Core_ID			=	0

SS_DISDSP		=	0x0004
SS_DISINT		=	0x0001
SS_LOCCPU		=	0x0005
SS_CNTEXE		=	0x0008

SS_ERRHOOK		=	0x0100
SS_PREHOOK		=	0x0200
SS_PSTHOOK		=	0x0400
SS_STHOOK		=	0x0800
SS_SDHOOK		=	0x1000
SS_TSKRUN		=	0x2000
SS_CTSKRUN		=	0x4000
SS_CYCHDR		=	0x8000
SS_ALL			=	0xff00

T_bit			=	0x20

SST_ActivateTask	=	0x0000
SST_TerminateTask	=	0x0001
SST_CainTask		=	0x0002
SST_Schedule		=	0x0003
SST_GetTaskID		=	0x0004
SST_GetTaskState	=	0x0005
SST_EnableAllInterrupts	=	0x0006
SST_DisableAllInterrupts=	0x0007
SST_ResumeAllInterrupts	=	0x0008
SST_SuspendAllInterrupts=	0x0009
SST_ResumeOSInterrupts	=	0x000a
SST_SuspendOSInterrupts	=	0x000b
SST_GetResource		=	0x000c
SST_ReleaseResource	=	0x000d
SST_SetEvent		=	0x000e
SST_ClearEvent		=	0x000f
SST_GetEvent		=	0x0010
SST_WaitEvent		=	0x0011
SST_GetAlarmBase	=	0x0012
SST_GetAlarm		=	0x0013
SST_SetRelAlarm		=	0x0014
SST_SetAbsAlarm		=	0x0015
SST_CancelAlarm		=	0x0016
SST_IncrementCounter	=	0x0017
SST_GetActiveApplicationMode	=	0x0018
SST_ShutdownOS		=	0x001a
SST_act_tsk		=	0x001b
SST_can_act		=	0x001c
SST_sta_tsk		=	0x001d
SST_ext_tsk		=	0x001e
SST_chg_pri		=	0x001f
SST_ref_tsk		=	0x0020
SST_slp_tsk		=	0x0021
SST_tslp_tsk		=	0x0022
SST_wup_tsk		=	0x0023
SST_can_wup		=	0x0024
SST_rel_wai		=	0x0025
SST_sus_tsk		=	0x0026
SST_rsm_tsk		=	0x0027
SST_dly_tsk		=	0x0028
SST_sig_sem		=	0x0029
SST_wai_sem		=	0x002a
SST_pol_sem		=	0x002b
SST_twai_sem		=	0x002c
SST_ref_sem		=	0x002d
SST_loc_mtx		=	0x002e
SST_ploc_mtx		=	0x002f
SST_tloc_mtx		=	0x0030
SST_unl_mtx		=	0x0031
SST_ref_mtx		=	0x0032
SST_snd_mbf		=	0x0033
SST_psnd_mbf		=	0x0034
SST_tsnd_mbf		=	0x0035
SST_rcv_mbf		=	0x0036
SST_prcv_mbf		=	0x0037
SST_trcv_mbf		=	0x0038
SST_ref_mbf		=	0x0039
SST_get_mpf		=	0x003a
SST_pget_mpf		=	0x003b
SST_tget_mpf		=	0x003c
SST_rel_mpf		=	0x003d
SST_ref_mpf		=	0x003e
SST_get_mpl		=	0x003f
SST_pget_mpl		=	0x0040
SST_tget_mpl		=	0x0041
SST_rel_mpl		=	0x0042
SST_ref_mpl		=	0x0043
SST_get_tid		=	0x0044
SST_loc_cpu		=	0x0045
SST_unl_cpu		=	0x0046
SST_dis_dsp		=	0x0047
SST_ena_dsp		=	0x0048
SST_sns_ctx		=	0x0049
SST_sns_loc		=	0x004a
SST_sns_dsp		=	0x004b
SST_sns_dpn		=	0x004c
SST_sta_cyc		=	0x004d
SST_stp_cyc		=	0x004e
SST_ref_cyc		=	0x004f

INVALID_TASK		=	0xffff
TSK_SELF		=	0x0000

TMAX_MAXTASKID		=	255
TMAX_ACTCNT		=	255

E_OK			=	0

E_OS_ACCESS		=	1
E_OS_CALLEVEL		=	2
E_OS_ID			=	3
E_OS_LIMIT		=	4
E_OS_NOFUNC		=	5
E_OS_RESOURCE		=	6
E_OS_STATE		=	7
E_OS_VALUE		=	8

E_PAR			=	-17
E_ID			=	-18
E_CTX			=	-25
E_MACV			=	-26
E_OACV			=	-27
E_ILUSE			=	-28
E_NOMEM			=	-33
E_OBJ			=	-41
E_NOEXS			=	-42
E_QOVR			=	-43
E_RLWAI			=	-49
E_TMOUT			=	-50
E_CLS			=	-52
