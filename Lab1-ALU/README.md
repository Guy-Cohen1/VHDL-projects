# Lab 1: VHDL Concurrent Code - ALU Design

Welcome to the repository for **Lab 1** of the CPU Architecture course. This lab focuses on the design, implementation, and analysis of an ALU (Arithmetic Logic Unit) using **VHDL concurrent coding techniques**. Below, you'll find an overview of the lab's objectives, tasks, and deliverables.

---

## **Lab Objective**
1. Develop proficiency in **VHDL Part 1**, including:
   - Code structure and data types.
   - Operators, attributes, and concurrent code.
   - Design hierarchy, packages, and components.
2. Gain basic skills in **ModelSim**, a simulation environment for HDL designs.
3. Refresh knowledge of **digital systems and architecture design**.
4. Enhance skills in analyzing and understanding architectural structures.

---

## **System Design Overview**
### **Instruction Set Architecture (ISA)**
The ALU supports a variety of arithmetic, shift, and boolean operations defined by an **ALUFN** signal. Key operations include:
- Arithmetic: Addition, subtraction, negation.
- Shift: Logical left and right shifts.
- Boolean: NOT, OR, AND, XOR, NOR, NAND, and XNOR.

Refer to the ISA table for detailed operation mappings and functional descriptions.

---

### **Status Bits**
The ALU outputs four status bits based on operation results:
- **V (Overflow)**: Indicates signed overflow for addition and subtraction.
- **Z (Zero)**: Set when the result is zero.
- **C (Carry)**: Indicates a carry-out for unsigned operations.
- **N (Negative)**: Set when the result is negative in signed operations.

---

### **Micro-Architecture Design**
The system comprises three main submodules:
1. **Adder/Subtractor**: Implements arithmetic operations using a generic ripple carry adder.
2. **Shifter**: Performs shift operations using a barrel-shifter structure.
3. **Boolean Logic**: Executes bitwise operations.

Each submodule is designed to be parameterized for an **n-bit size**, supporting values of 4, 8, 16, and 32 (set in `tb.vhd`).

---

### **Key Modules**
1. **Adder/Subtractor**: 
   - Implements addition and subtraction with a ripple carry adder.
   - Features structural design with at least two levels.

2. **Barrel-Shifter**:
   - Implements n-bit shift operations without using restricted operators (`sll`, `srl`).
   - Designed using a generate statement for modularity.

3. **Test Bench**:
   - Simulates the ALU's functionality with a comprehensive suite of test cases.
   - Analyzes critical signals and timing through waveforms in ModelSim.

---

## **Requirements**
1. Design must follow the provided **top-level structure** and use specified `.vhd` files.
2. Submit a properly structured ZIP file (`id1_id2.zip`) containing:
   - **DUT**: Design files for the Device Under Test (excluding testbench).
   - **TB**: Testbench files for submodules and top-level system.
   - **SIM**: ModelSim files for waveform and simulation output.
   - **DOC**: Documentation files, including `readme.txt` and `pre1.pdf` with graphical module descriptions, waveforms, and analysis.

---

## **Deliverables**
- Fully functional VHDL design files.
- Simulation results with annotated waveforms.
- A clear and concise report detailing:
  - Design architecture.
  - Observed results and analysis.
  - Graphical and textual descriptions of modules.

---

This lab provides a solid foundation for designing and testing digital systems with VHDL, preparing you for advanced topics in CPU architecture.
