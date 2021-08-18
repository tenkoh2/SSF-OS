CORE	= cortex-a9
ARCH	= armv8-a

BASEDIR	= ..
SRCDIR	= $(BASEDIR)\\src
INCDIR	= $(BASEDIR)\\inc

TOOLDIR	= C:\\SysGCC\\raspberry\\bin
CC	= $(TOOLDIR)\\arm-linux-gnueabihf-gcc.exe
AS	= $(TOOLDIR)\\arm-linux-gnueabihf-as.exe
LD	= $(TOOLDIR)\\arm-linux-gnueabihf-ld.exe
AR	= $(TOOLDIR)\\arm-linux-gnueabihf-ar.exe

CCFLAGS	=
ASFLAGS	= -mcpu=$(CORE) -march=$(ARCH) -I$(INCDIR) -g -gdwarf-2
ARFLAGS	=

OBJS	= _kernel_start.o _kernel_init_objs.o \
	  _dispatcher.o _dispatcher_t.o \
	  _ServiceCallEntry.o _kernel_intent.o \
	  queue.o \
	  task.o task_t.o \
	  interrupt.o tasksync_t.o \
	  resource.o event.o \
	  timer.o \
	  alarm.o counter.o \
	  cyc.o \
	  semaphore.o mutex.o msgbuf.o \
	  mpf.o mpl.o \
	  osexectrl.o syssts.o \
	  idle.o \
	  StartupHook.o ShutdownHook.o ErrorHook.o PreTaskHook.o PostTaskHook.o

all: libfos.a

clean:
	rm *.a
	rm *.o

libfos.a: $(OBJS)
	$(AR) $(ARFLAGS) r libfos.a $(OBJS)

_kernel_start.o: ..\src\_kernel_start.s
	$(AS) $(ASFLAGS) -o _kernel_start.o $(SRCDIR)\\_kernel_start.s

_kernel_init_objs.o: ..\src\_kernel_init_objs.s
	$(AS) $(ASFLAGS) -o _kernel_init_objs.o $(SRCDIR)\\_kernel_init_objs.s

_dispatcher.o: ..\src\_dispatcher.s
	$(AS) $(ASFLAGS) -o _dispatcher.o $(SRCDIR)\\_dispatcher.s

_dispatcher_t.o: ..\src\_dispatcher_t.s
	$(AS) $(ASFLAGS) -o _dispatcher_t.o $(SRCDIR)\\_dispatcher_t.s

_ServiceCallEntry.o: ..\src\_ServiceCallEntry.s
	$(AS) $(ASFLAGS) -o _ServiceCallEntry.o $(SRCDIR)\\_ServiceCallEntry.s

_kernel_intent.o: ..\src\_kernel_intent.s
	$(AS) $(ASFLAGS) -o _kernel_intent.o $(SRCDIR)\\_kernel_intent.s

queue.o: ..\src\queue.s
	$(AS) $(ASFLAGS) -o queue.o $(SRCDIR)\\queue.s

task.o: ..\src\task.s
	$(AS) $(ASFLAGS) -o task.o $(SRCDIR)\\task.s

task_t.o: ..\src\task_t.s
	$(AS) $(ASFLAGS) -o task_t.o $(SRCDIR)\\task_t.s

interrupt.o: ..\src\interrupt.s
	$(AS) $(ASFLAGS) -o interrupt.o $(SRCDIR)\\interrupt.s

tasksync_t.o: ..\src\tasksync_t.s
	$(AS) $(ASFLAGS) -o tasksync_t.o $(SRCDIR)\\tasksync_t.s

resource.o: ..\src\resource.s
	$(AS) $(ASFLAGS) -o resource.o $(SRCDIR)\\resource.s

event.o: ..\src\event.s
	$(AS) $(ASFLAGS) -o event.o $(SRCDIR)\\event.s

timer.o: ..\src\timer.s
	$(AS) $(ASFLAGS) -o timer.o $(SRCDIR)\\timer.s

alarm.o: ..\src\alarm.s
	$(AS) $(ASFLAGS) -o alarm.o $(SRCDIR)\\alarm.s

counter.o: ..\src\counter.s
	$(AS) $(ASFLAGS) -o counter.o $(SRCDIR)\\counter.s

cyc.o: ..\src\cyc.s
	$(AS) $(ASFLAGS) -o cyc.o $(SRCDIR)\\cyc.s

semaphore.o: ..\src\semaphore.s
	$(AS) $(ASFLAGS) -o semaphore.o $(SRCDIR)\\semaphore.s

mutex.o: ..\src\mutex.s
	$(AS) $(ASFLAGS) -o mutex.o $(SRCDIR)\\mutex.s

msgbuf.o: ..\src\msgbuf.s
	$(AS) $(ASFLAGS) -o msgbuf.o $(SRCDIR)\\msgbuf.s

mpf.o: ..\src\mpf.s
	$(AS) $(ASFLAGS) -o mpf.o $(SRCDIR)\\mpf.s

mpl.o: ..\src\mpl.s
	$(AS) $(ASFLAGS) -o mpl.o $(SRCDIR)\\mpl.s

osexectrl.o: ..\src\osexectrl.s
	$(AS) $(ASFLAGS) -o osexectrl.o $(SRCDIR)\\osexectrl.s

syssts.o: ..\src\syssts.s
	$(AS) $(ASFLAGS) -o syssts.o $(SRCDIR)\\syssts.s

idle.o: ..\src\idle.s
	$(AS) $(ASFLAGS) -o idle.o $(SRCDIR)\\idle.s

StartupHook.o: ..\src\StartupHook.s
	$(AS) $(ASFLAGS) -o StartupHook.o $(SRCDIR)\\StartupHook.s

ShutdownHook.o: ..\src\ShutdownHook.s
	$(AS) $(ASFLAGS) -o ShutdownHook.o $(SRCDIR)\\ShutdownHook.s

ErrorHook.o: ..\src\ErrorHook.s
	$(AS) $(ASFLAGS) -o ErrorHook.o $(SRCDIR)\\ErrorHook.s

PreTaskHook.o: ..\src\PreTaskHook.s
	$(AS) $(ASFLAGS) -o PreTaskHook.o $(SRCDIR)\\PreTaskHook.s

PostTaskHook.o: ..\src\PostTaskHook.s
	$(AS) $(ASFLAGS) -o PostTaskHook.o $(SRCDIR)\\PostTaskHook.s
