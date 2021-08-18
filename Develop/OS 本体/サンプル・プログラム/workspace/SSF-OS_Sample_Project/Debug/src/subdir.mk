################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/SSF-OS_Sample_Project.c 

OBJS += \
./src/SSF-OS_Sample_Project.o 

C_DEPS += \
./src/SSF-OS_Sample_Project.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross GCC Compiler'
	arm-linux-gnueabihf-gcc -I../../../inc -O0 -g3 -Wall -c -fmessage-length=0 -gdwarf-2 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


