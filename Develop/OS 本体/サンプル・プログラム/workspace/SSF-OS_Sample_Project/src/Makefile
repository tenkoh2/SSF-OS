CORE	= cortex-a9
ARCH	= armv8-a

BASEDIR	= ..
SRCDIR	= $(BASEDIR)\\src
INCDIR	= $(BASEDIR)\\inc
INCDIR2	= ..\\..\\..\\..\\マイクロ・カーネル\\inc
OBJDIR	= ..\\..\\..\\conf
USRDIR	= ..\\..\\..\\..\\ユーザ・オウン・コーディング部\\obj

TOOLDIR	= C:\\SysGCC\\raspberry\\bin
CC	= $(TOOLDIR)\\arm-linux-gnueabihf-gcc.exe
AS	= $(TOOLDIR)\\arm-linux-gnueabihf-as.exe
LD	= $(TOOLDIR)\\arm-linux-gnueabihf-ld.exe
AR	= $(TOOLDIR)\\arm-linux-gnueabihf-ar.exe

CCFLAGS	= -O0 -g -gdwarf-2
ASFLAGS	= -mcpu=$(CORE) -march=$(ARCH) -I$(INCDIR) -I$(INCDIR2)
ARFLAGS	=

all: SSF-OS_Sample_Project.elf

clean: 
	rm *.o
	rm *.elf

SSF-OS_Sample_Project.elf:	$(OBJDIR)\\entry.o $(OBJDIR)\\sit.o $(OBJDIR)\\sbt.o $(OBJDIR)\\sct.o $(USRDIR)\\boot.o $(USRDIR)\\interrupt.o $(USRDIR)\\stack.o SSF-OS_Sample_Project.o
	$(LD) -T $(OBJDIR)\\link.lds $^ -o $@ -L..\\..\\..\\..\\マイクロ・カーネル\\obj -lfos


.SUFFIXES: .elf

.c.o:
	$(CC) $(CFLAGS) -I..\\..\\..\\..\\マイクロ・カーネル\\inc -c $< -o $@
