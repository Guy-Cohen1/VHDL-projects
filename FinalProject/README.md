# Final Project: MIPS-Based MCU Architecture  

This document defines the structure and requirements for the **Final Project** in the CPU Architecture course. The project involves designing, synthesizing, and testing an MCU architecture based on a single-cycle MIPS CPU.  

---

## **Table of Contents**  
1. [Aim of the Project](#1-aim-of-the-project)  
2. [Definition and Prior Knowledge](#2-definition-and-prior-knowledge)  
3. [Assignment Definition](#3-assignment-definition)  
4. [Required CPU Peripheral Support](#4-required-cpu-peripheral-support)  
5. [Interrupt Service BUS Protocol](#5-interrupt-service-bus-protocol)  
6. [Pin Planner](#6-pin-planner)  
7. [Host Interface](#7-host-interface)  
8. [Compiler, Simulator, and Memory](#8-compiler-simulator-and-memory)  
9. [CPU and MCU Test](#9-cpu-and-mcu-test)  
10. [Requirements](#11-requirements)  

---

## **1. Aim of the Project**  
- Design and synthesis of a **single-cycle MIPS CPU core** with support for:  
  - **Memory-Mapped I/O**  
  - **Interrupt capability**  
  - **Serial communication peripheral** (bonus).  
- Understanding the differences between CPU and MCU architectures.  
- Gaining knowledge of FPGA memory structures.  

---

## **2. Definition and Prior Knowledge**  
The project involves creating a **MIPS-based MCU** featuring a **Harvard architecture** for improved throughput and simplified logic. The CPU will execute the **full instruction set of a simple MIPS ISA**. The design will be implemented on the **Altera DE10-Standard FPGA board**.  

**Key Concepts:**  
- MIPS technical documentation and ISA details.  
- Harvard vs. Von Neumann architecture.  
- Memory Mapped I/O.  

---

## **3. Assignment Definition**  
The MCU architecture must include:  
- **32-bit MIPS ISA-compatible CPU** with data memory (DTCM) and instruction memory (ITCM).  
- A single clock for all components.  
- System **RESET** using push-button `KEY0`.  

**I/O Devices:**  
- **Input:**  
  - Ten switches (`SW9-SW0`).  
  - Four debounced push-buttons (`KEY3-KEY0`).  
- **Output:**  
  - Ten red LEDs (`LEDR9-LEDR0`).  
  - Six 7-segment displays (`HEX5-HEX0`).  

---

## **4. Required CPU Peripheral Support**  

### **Peripheral Features**:  
1. **GPIO Ports**  
   - Six output ports and one input port.  
   - Memory-mapped with a simple decoder and buffer registers.  

2. **Basic Timer with Output Compare Capability**  
   - Timer with compare registers (`BTCCRx`) for interrupt generation.  
   - Reset behavior: timer value set to `0` on RESET.  

3. **Binary Division Multicycle Accelerator**  
   - Operates on 32 clock cycles.  
   - Divides two unsigned binary numbers.  

4. **Interrupt Controller**  
   - Supports maskable and non-maskable interrupts.  
   - Reset of interrupt flags (`KEYiIFG`, `BTIFG`, `DIVIFG`, `RXIFG`, `TXIFG`) occurs automatically or manually, depending on the source.  

---

## **5. Interrupt Service BUS Protocol**  
1. **Interrupt Handling:**  
   - CPU processes interrupt requests within 2–3 clock cycles.  
   - Writes interrupt type to the **Data BUS**.  
   - Clears interrupt flags (`BTIFG`, `DIVIFG`).  
   - Updates `GIE` to disable further interrupts during service.  

2. **Returning from Interrupt:**  
   - Occurs during `reti` (return from interrupt).  
   - Restores the return address from `$k1`.  

---

## **6. Pin Planner**  
Only connect MCU I/O devices to FPGA pin locations. Remove Signal Tap connections during final compilation.  

---

## **7. Host Interface**  
A **JTAG-based code wrapper** will be provided for communication with L1 instruction (ITCM) and data (DTCM) caches. This interface enables uploading and downloading without reprogramming the FPGA.  

---

## **8. Compiler, Simulator, and Memory**  
- Use the **MARS Compiler** for assembling and simulating MIPS programs.  
- Export memory contents for VHDL compatibility.  

---

## **9. CPU and MCU Test**  
- **Mandatory Tests:** Execute given `.asm` assembly programs.  
- **Bonus Tests:** Implement a menu for RS-232 communication, including tasks like counting on LEDs and sending messages to a PC terminal.  

---

## **10. Requirements**  
1. Perform **ModelSim simulation** with maximum coverage.  
2. Analyze critical paths and maximum clock frequency.  
3. Load and test the design on the FPGA.  
4. Provide the following in `final.pdf`:  
   - Top-level block diagram.  
   - RTL Viewer outputs.  
   - Logic usage and port tables for each module.  
   - Timing analysis (max/min paths).  
   - Signal Tap screenshots for proof of work.  

