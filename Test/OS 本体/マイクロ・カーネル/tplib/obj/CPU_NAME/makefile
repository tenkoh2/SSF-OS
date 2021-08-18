CORE	= CPU_NAME
COREKND	=
TOOL	= CA850
DEVICE	= DEVICE_NAME
DFILE	=

BASEDIR	= ../..
SRCDIR	= $(BASEDIR)/src
INCDIR	= $(BASEDIR)/include

TOOLDIR	= "C:\Program Files (x86)\Renesas Electronics\CubeSuite+\CA850\V3.50\Bin
TOOLLIB	= "C:\Program Files (x86)\Renesas Electronics\CubeSuite+\CA850\V3.50\Lib850\r32"
CC	= $(TOOLDIR)/ca850"
AS	= $(TOOLDIR)/as850"
LD	= $(TOOLDIR)/ld850"
AR	= $(TOOLDIR)/ar850"
ROM	= $(TOOLDIR)/romp850"

DEVDIR	= "C:\Program Files (x86)\Renesas Electronics\CubeSuite+\Device\V850\Devicefile"

CCFLAGS	= -ansi -c -cnv850e -Xpro_epi_runtime=off -Xr -g -I$(INCDIR) \
	  -D__$(COREKND)__ -D__$(DEVICE)__
ASFLAGS	= -cnv850e -g
ARFLAGS	= q

OBJS	= tp.o tpdata.o tpint.o tpreg.o

all:tp.a

clean:
	rm *.a
	rm *.o

tp.a: $(OBJS)
	$(AR) $(ARFLAGS) libtp.a $(OBJS)

tp.o:
	$(CC) $(CCFLAGS) $(SRCDIR)/common/tp.c

tpdata.o:
	$(AS) $(ASFLAGS) $(SRCDIR)/common/tpdata.s

tpint.o:
	$(CC) $(CCFLAGS) $(SRCDIR)/CPU/$(CORE)/$(DEVICE)/tpint.c

tpreg.o:
	$(AS) $(ASFLAGS) $(SRCDIR)/CPU/$(CORE)/$(DEVICE)/tpreg.s
