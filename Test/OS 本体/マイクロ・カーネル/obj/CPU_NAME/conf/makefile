# for nmake (Can't use GNU make)

CORE	= CPU_NAME
DEVICE	= DEVICE_NAME
DFILE	=

BASEDIR	= ../../..
SRCDIR	= $(BASEDIR)/src/CPU/$(CORE)/$(DEVICE)
LIBDIR	= $(BASEDIR)/tplib
INCDIR	= $(SRCDIR)

TOOLDIR	= "C:\Program Files (x86)\Renesas Electronics\CubeSuite+\CA850\V3.50\Bin
CC	= $(TOOLDIR)/ca850"
AS	= $(TOOLDIR)/as850"
LD	= $(TOOLDIR)/ld850"

DEVDIR	= "C:\Program Files (x86)\Renesas Electronics\CubeSuite+\Device\V850\Devicefile"
DEV	= $(DEVDIR)/$(DFILE)

CCFLAGS	= -ansi -c -cnv850e -Xpro_epi_runtime=off -g -D__$(COREKND)__ -D__$(DEVICE)__ \
	  -I$(INCDIR) -I$(LIBDIR)/include
ASFLAGS	= -cnv850e -g

OBJS	= # ここにターゲットのファイルを記述する

all: $(OBJS)

clean:
	rm *.o

# ここに環境依存のファイルのメイク・ルールを記述する
