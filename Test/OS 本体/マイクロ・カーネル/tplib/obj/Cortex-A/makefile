CORE	= Cortex-A
COREKND	= cortex-a9
ARCH	= armv8-a

DEVICE	= RPI3B+
DFILE	=

BASEDIR	= ../..
SRCDIR	= $(BASEDIR)/src
INCDIR	= $(BASEDIR)/include

TOOLDIR	= C:\\SysGCC\\raspberry\\bin
CC	= $(TOOLDIR)/arm-linux-gnueabihf-gcc.exe
AS	= $(TOOLDIR)/arm-linux-gnueabihf-as.exe
LD	= $(TOOLDIR)/arm-linux-gnueabihf-ld.exe
AR	= $(TOOLDIR)/arm-linux-gnueabihf-ar.exe

CCFLAGS	= -mfloat-abi=hard -mlittle-endian -fno-builtin -I$(INCDIR) \
	  -O0 -gdwarf-2 -g -S
ASFLAGS	= -mcpu=$(COREKND) -march=$(ARCH) -I$(INCDIR) -g -gdwarf-2
ARFLAGS	=

OBJS	= tp.o tpdata.o tpint.o tpreg.o

all:tp.a

clean:
	rm *.a
	rm *.o

tp.a: $(OBJS)
	$(AR) $(ARFLAGS) r libtp.a $(OBJS)

tp.o:
	$(CC) $(CCFLAGS) $(SRCDIR)/common/tp.c -o tp.o

tpint.o:
	$(CC) $(CCFLAGS) $(SRCDIR)/CPU/$(CORE)/$(DEVICE)/tpint.c -o tpint.o

tpreg.o:
	$(AS) $(ASFLAGS) $(SRCDIR)/CPU/$(CORE)/$(DEVICE)/tpreg.s -o tpreg.o

tpdata.o:
	$(AS) $(ASFLAGS) $(SRCDIR)/CPU/$(CORE)/$(DEVICE)/tpdata.s -o tpdata.o
