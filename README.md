# CPU and Hardware Accelerators

This repository contains modules for CPUs and hardware accelerators, designed and synthesized using VHDL as part of a laboratory course on Intel's Cyclone V FPGA (DE10-Standard Board). Each lab focuses on distinct aspects of digital design, progressing from fundamental concepts to advanced implementations like multi-cycle CPU.

---

## Labs Overview

### **Lab 1: VHDL Concurrent Code - ALU**
- **Objective**: Learn VHDL basics, focusing on concurrent code, design hierarchy, and digital architecture fundamentals.
- **Tasks**:
  - Implement an ALU based on a predefined ISA with arithmetic, shift, and boolean operations.
  - Develop status bits for conditions like overflow, carry, zero, and negative.
  - Create a generic ripple carry adder and barrel shifter without forbidden operators.
  - Test the system using ModelSim and analyze timing.

---

### **Lab 2: VHDL Sequential Code - Behavioral Modeling**
- **Objective**: Build a synchronous digital system using sequential VHDL for detecting valid sub-series in data streams.
- **Tasks**:
  - Design and implement the system architecture.
  - Create a behavioral model and testbench to validate functionality.
  - Analyze outputs and timing diagrams.

---

### **Lab 3: Digital System Design - Multi-Cycle CPU**
- **Objective**: Design a multi-cycle CPU using controller-based architecture and validate its performance.
- **Tasks**:
  - Implement a multi-cycle CPU with separate datapath and control units.
  - Follow the provided ISA and specifications to execute a given assembly program.
  - Test and analyze the design using timing diagrams and simulations.

---

### **Lab 4: FPGA Implementation and Memory Analysis**
- **Objective**: Synthesize and deploy digital systems on an FPGA, analyzing performance and resource usage.
- **Tasks**:
  1. **Simulation**:
     - Synthesize the ALU design from Lab 1 for Cyclone V FPGA.
     - Validate performance with timing and logic analysis.
  2. **Hardware Implementation**:
     - Test the system on the DE10-Standard FPGA board.
     - Utilize LEDs, pushbuttons, switches, and 7-segment displays for input/output integration.
  3. **Performance Metrics**:
     - Determine maximum operating clock frequency (f_max).
     - Analyze critical paths and logic usage using Quartus.

---

## Final Project: Single-Cycle MIPS CPU  
- **Goal**: Create a fully functional single-cycle MIPS processor with memory-mapped I/O and optional peripherals like a USART interface.  
- **Specifications**:
  - **Core Features**: Memory, GPIO, timers, binary division accelerator, and interrupt controller.
  - **I/O Devices**: Pushbuttons, switches, LEDs, and 7-segment displays.
  - **Tools**: MARS simulator for assembly code testing and VHDL memory integration.

---

This repository serves as a comprehensive resource for learning and implementing CPU architectures and hardware accelerators, emphasizing modularity, scalability, and practical FPGA deployment.
