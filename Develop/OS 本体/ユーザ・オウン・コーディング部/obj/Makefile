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

OBJS	= boot.o interrupt.o stack.o

all: boot.o interrupt.o stack.o

clean:
	rm *.o

libusr.a: $(OBJS)
	$(AR) $(ARFLAGS) r libusr.a $(OBJS)

boot.o: ..\src\boot.s
	$(AS) $(ASFLAGS) -c -o boot.o $(SRCDIR)\\boot.s

interrupt.o: ..\src\interrupt.s
	$(AS) $(ASFLAGS) -c -o interrupt.o $(SRCDIR)\\interrupt.s

stack.o: ..\src\stack.s
	$(AS) $(ASFLAGS) -c -o stack.o $(SRCDIR)\\stack.s
