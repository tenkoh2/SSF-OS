################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
C:/Project/OSくん/Develop/OS\ 本体/サンプル・プログラム/conf/entry.o \
C:/Project/OSくん/Develop/OS\ 本体/サンプル・プログラム/conf/sbt.o \
C:/Project/OSくん/Develop/OS\ 本体/サンプル・プログラム/conf/sct.o \
C:/Project/OSくん/Develop/OS\ 本体/サンプル・プログラム/conf/sit.o 


# Each subdirectory must supply rules for building sources it contributes
conf/entry: C:/Project/OSくん/Develop/OS\ 本体/サンプル・プログラム/conf/entry.s
	@echo 'Building file: $<'
	@echo 'Invoking: GCC Assembler'
	as  -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

conf/link: C:/Project/OSくん/Develop/OS\ 本体/サンプル・プログラム/conf/link.lds $(USER_OBJS)
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Linker'
	gcc  -o "$@" "$<" $(USER_OBJS) $(LIBS)
	@echo 'Finished building: $<'
	@echo ' '

conf/sbt: C:/Project/OSくん/Develop/OS\ 本体/サンプル・プログラム/conf/sbt.s
	@echo 'Building file: $<'
	@echo 'Invoking: GCC Assembler'
	as  -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

conf/sct: C:/Project/OSくん/Develop/OS\ 本体/サンプル・プログラム/conf/sct.s
	@echo 'Building file: $<'
	@echo 'Invoking: GCC Assembler'
	as  -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

conf/sit: C:/Project/OSくん/Develop/OS\ 本体/サンプル・プログラム/conf/sit.s
	@echo 'Building file: $<'
	@echo 'Invoking: GCC Assembler'
	as  -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


