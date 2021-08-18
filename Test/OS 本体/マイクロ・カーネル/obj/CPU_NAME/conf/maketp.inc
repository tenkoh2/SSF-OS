CORE	= CPU_NAME
COREDEV	= DEVICE_NAME
TOOL	= CA850
DEVICE	=
DFILE	=

BASEDIR	= ../../../..
OSDIR	=
SRCDIR	= $(BASEDIR)/src/common/$(TEST)/$(SVC)
OSLIBDIR=
TPLIBDIR= $(BASEDIR)/tplib/obj/$(COREDEV)
LIBDIR	= $(BASEDIR)/tplib
INCDIR	= $(SRCDIR)

TOOLLIB	= "C:\Program Files (x86)\Renesas Electronics\CubeSuite+\CA850\V3.50\Lib850\r32"
CYGTOOL	= /cygdrive/C/Program\ Files\ \(x86\)/Renesas\ Electronics/CubeSuite+/CA850/V3.50/Bin

OSLIB	= 
TPLIB	= tp

TOOLDIR	= "C:\Program Files (x86)\Renesas Electronics\CubeSuite+\CA850\V3.50\Bin
CC	= $(TOOLDIR)/ca850"
AS	= $(TOOLDIR)/as850"
LD	= $(TOOLDIR)/ld850"
ROM	= $(TOOLDIR)/romp850"
CYGROM	= $(CYGTOOL)/romp850

DEVDIR	= "C:\Program Files (x86)\Renesas Electronics\CubeSuite+\Device\V850\Devicefile"

CONFDIR	= $(BASEDIR)/obj/$(COREDEV)/conf
CONFOBJS= # ここにターゲット依存のオブジェクト・ファイルを記述する

DIR	= $(CONFDIR)/tp.dir

CCFLAGS	= -ansi -c -cpu $(DFILE) -devpath=$(DEVDIR) -Xr -Xpro_epi_runtime=off \
	  -g -D__$(COREDEV)__ -D__$(DEVICE)__ -I$(INCDIR) -I$(LIBDIR)/include -I$(OSDIR
ASFLAGS	= -cnv850e -g
LDFLAGS	= $(CONFOBJS) -F $(DEVDIR) -cpu $(DFILE) \
	  -L$(OSLIBDIR) -l$(OSLIB) -L$(TPLIBDIR) -l$(TPLIB) \
	  -lc -lm -lr $(TOOLLIB)/rompcrt.o -D $(DIR) -m=$(@F:.out=.map)
#ROMFLAGS= -F $(DEVDIR) -p .rompsec -m=$(@F:.out=.map)
ROMFLAGS= -F $(DEVDIR) -m=$(@F:.out=.map)

all : $(OBJS)

clean :
	rm *.o
	rm *.elf
	rm *.out
	rm *.map

#%.out : $(@F:.rom=.o) $(OSLIBDIR)/$(OSLIB) $(TPLIBDIR)/lib$(TPLIB).a
%.out : $(@F:.out=.o) $(TPLIBDIR)/lib$(TPLIB).a
	$(CC) $(CCFLAGS) -o $(@F:.out=.o) $(SRCDIR)/$(@F:.out=.c)
	$(LD) $(@F:.out=.o) $(LDFLAGS) -o $(@F:.out=.elf)
	$(CYGROM) $(@F:.out=.elf) $(ROMFLAGS) -o $(@F)
