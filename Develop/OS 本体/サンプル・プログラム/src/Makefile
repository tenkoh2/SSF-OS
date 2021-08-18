CORE	= cortex-a9
ARCH	= armv8-a

BASEDIR	= ..
SRCDIR	= $(BASEDIR)\\src
INCDIR	= $(BASEDIR)\\inc
LIBDIR	= C:\\sysgcc\\raspberry\\bin\\..\\lib\\gcc\\arm-linux-gnueabihf\\8\\..\\..\\..\\..\\arm-linux-gnueabihf\\lib

TOOLDIR	= C:\\SysGCC\\raspberry\\bin
CC	= $(TOOLDIR)\\arm-linux-gnueabihf-gcc.exe
AS	= $(TOOLDIR)\\arm-linux-gnueabihf-as.exe
LD	= $(TOOLDIR)\\arm-linux-gnueabihf-ld.exe
AR	= $(TOOLDIR)\\arm-linux-gnueabihf-ar.exe
OBJCOPY	= $(TOOLDIR)\\arm-linux-gnueabihf-objcopy.exe

CCFLAGS	= -mfloat-abi=soft -mlittle-endian \
	  -nostdinc -fno-builtin \
	  -O0 -g -gdwarf-2
ASFLAGS	= -mcpu=$(CORE) -march=$(ARCH) -I$(INCDIR)
ARFLAGS	=

OBJS	= startup.o main.o

all: main.img

clean:
	rm *.o
	rm *.elf
	rm *.img

main.elf: $(OBJS)
	$(LD) -static -nostdlib -T link.lds $(LIBDIR)\\libgcc.a main.o startup.o -o main.elf

main.img: main.elf
	$(OBJCOPY) -O binary main.elf main.img

startup.o: startup.S
	$(CC) $(CCFLAGS) -c -g -o startup.o startup.S

main.o: main.c
	$(CC) $(CCFLAGS) -c -g -o main.o main.c
