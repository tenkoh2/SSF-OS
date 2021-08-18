CORE	= cortex-a9
ARCH	= armv8-a

BASEDIR	= ..
SRCDIR	= $(BASEDIR)\\src
INCDIR	= $(BASEDIR)\\inc
INCDIR2	= ..\\..\\マイクロ・カーネル\\inc

TOOLDIR	= C:\\SysGCC\\raspberry\\bin
CC	= $(TOOLDIR)\\arm-linux-gnueabihf-gcc.exe
AS	= $(TOOLDIR)\\arm-linux-gnueabihf-as.exe
LD	= $(TOOLDIR)\\arm-linux-gnueabihf-ld.exe
AR	= $(TOOLDIR)\\arm-linux-gnueabihf-ar.exe

CCFLAGS	=
ASFLAGS	= -mcpu=$(CORE) -march=$(ARCH) -I$(INCDIR) -I$(INCDIR2) -g -gdwarf-2
ARFLAGS	=

OBJS	= sbt.o sit.o sct.o entry.o

all: sbt.o sit.o sct.o entry.o

clean:
	rm *.o

sbt.o: sbt.s
	$(AS) $(ASFLAGS) -c -o sbt.o sbt.s

sit.o: sit.s
	$(AS) $(ASFLAGS) -c -o sit.o sit.s

sct.o: sct.s
	$(AS) $(ASFLAGS) -c -o sct.o sct.s

entry.o: entry.s
	$(AS) $(ASFLAGS) -c -o entry.o entry.s
