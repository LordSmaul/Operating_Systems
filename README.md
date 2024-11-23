# Operating-Systems

This folder contains all the programming assignments from my Operating Systems class. All of the programs were tested on a VM using a Debian Linux distribution and QEMU as the emulator for the processor; the Data Display Debugger (ddd) was also included for debugging purposes. The assembly code was written in the ARMv8 Instruction Set Architecture. Makefiles are provided for each program for efficient compilation, running, and debugging code.
___
**Here is a breakdown of each program and their purpose. All relevant documentation is included in each file.**

Program 1: Basic practice with ARMv8 ISA and VM setup - use a library provided by the professor to create simple program that will boot in qemu and print a string surrounded by a box in the middle of the screen.

Program 2: Cooperative multitasking - writing a dispatch() function that switches between four running processes. Uses the box drawing elements from the previous code.

Program 3: Preemptive multitasking - modifying the previous program so that the processes can be interrupted, effectively demonstrating a very basic overview of time slicing.
