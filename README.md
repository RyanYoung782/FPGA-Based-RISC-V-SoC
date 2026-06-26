# FPGA-Based-RISC-V-SoC
Full System-on-Chip implementation intended for synthesis on a Nexys A7 100T FPGA Board. Complete with UART, DMA, Interrupts, and PWM


# 1.) Motivation
This project is the intuitive extension of my previous RISC-V RV32IM Softcore project. I chose to pursue this project because I was very interested in how microcontrollers actually work at a fundamental levels. Because theory only got me so far in my microcontroller course work, I wanted to actually understand the protocols, structure, and work that goes into a full-fledged system-on-chip device. Because my softcore can compile and run risc-v assembly, I planned for this project to be able to run GCC compiled C with the proper linker to map onto the IMEM and DMEM architecture I describe for my FPGA. Furthermore, I hope to use this project as a baseline testing platform for future robotics, signal processing, and acceleration projects in the future. Instead of relying on a microcontroller, I can just use the SoC I built myself!

# 2.) Key Concepts Displayed
### a.) UART
This project will have a full UART state machine so that I can transfer data to and from my device without having to reprogram the board. The board will work similar to flashing an MCU with a program, but instead use UART to transfer a GCC objcpy artifact into the onboard BRAM. The UART bridge will be usable by both the Bootloader and the CPU to transfer data.
### b.) ROM Bootloader
A small custom written assembly bootloader will be used to write the program, and the associated .data and .text fields, into the FPGA BRAM. This bootloader will run whenever the reset button is pressed on the board. In terms of memory location, it will sit at a predefined reset vector location (0x00000000) and run until the UART is finished. After the UART transfer completes, the bootloader will hand over execution to the program starting at the base address of the IMEM space.
### c.) Interrupts
Interrupts will be added to move away from polling loops to higher efficiency, deterministic interrupt-driven development techniques. This is a very interesting part of the project for me because I've always understood what interrupts are, but never truly how they work under the hood. An interrupt controller entity will be necessary to decide which interrupt will be serviced at what point in the program execution. Along with this, the standard RISC-V interrupt protocol will be implemented to efficiently handle the trap execution and ISR. Note that all peripherals will come with interrupt enabling drivers that will execute at the beginning of any program compiled by the linker script, so we may choose to have polling or interrupt loops as we please.
### d.) Wishbone bus arbitration
Because multiple masters and servants will be all connected to a shared bus line, I decided to implement a wishbone bus protocol as opposed to an AXI- style system. Wishbone is simpler to implement than AXI, and for the scale of this project, AXI would be overkill and time consuming for this summer project. For future extensions with several masters (as opposed to the two in my case), an AXI-lite bus system may be more appropriate, but for the time and scale of the project, it is overkill.
### e.) PWM
For the sake of robotics projects, I hope to include a PWM state machine as a peripheral so that I can control different kinds of servos and motors. This extension will likely be one of the last added features because it is not a requirement for the MCU to function.
### f.) DMA
In the same vein as the PWM peripheral, DMA will be added last so that I can add complete bus arbitration (multi-master control) and a way to access memory without CPU intervention. This is another topic that I understand in theory, but will be very cool to see study under a microscope. I will likely have a driver to enable DMA in the code for a specific peripheral.

# 3.) Key Design Decisions
### a.) Fundamental Memory Mapping
#### i.) Bootloader ROM (2KB)
#### ii.) IMEM (32KB)
#### iii.) DMEM (32KB)
