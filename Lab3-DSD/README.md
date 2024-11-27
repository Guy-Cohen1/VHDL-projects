# Lab 3: Multi-Cycle CPU Design with VHDL

This repository contains details and instructions for **Lab 3** of the CPU Architecture course. In this lab, we focus on designing and simulating a **multi-cycle CPU** using **controller-based processing**. The lab emphasizes both architectural design and functional validation.

---

## **Lab Objectives**
1. Implement **concurrent and sequential logic principles** using advanced simulation methods learned in Labs 1 and 2.
2. Design a **controller-based processing machine** using the **Control and Datapath separation methodology**.
3. Gain experience with **functional validation** and **verification** of architectural designs.
4. Prepare for **Lab 4**, which involves FPGA-based synthesis of the design.

---

## **Assignment Definition**
The task involves designing a **multi-cycle CPU** to execute a given program using a controller-based processing machine. The design must adhere to the principles taught in the "Central Processing Unit Architecture - Theory" course and use:

1. **Finite State Machine (FSM) methodology** for control logic.
2. Advanced functional verification techniques.

---

### **Key Components**
1. **Datapath**:
   - Implements operations required by the CPU's instruction set architecture (ISA).
   - Includes registers, ALU, program counter, and other essential components.
   
2. **Control Unit**:
   - Directs the operation of the datapath based on the current instruction and state.
   - Designed using FSM principles for clarity and modularity.

3. **Memory**:
   - **Single-Port RAM** modules:
     - **Unregistered output**: Used for the **Register File** and **Program Memory**.
     - **Registered output**: Used for the **Data Memory**.
   - Provided as pre-written VHDL files.

4. **DUT (Device Under Test)**:
   - Combines the datapath, control unit, and memory into a complete system capable of executing programs.

---

### **Simulation Overview**
Simulation is conducted using **file-based input and output**. The DUT is tested by:

1. Providing input files for program code and data.
2. Generating an output file with results after program execution.
3. Comparing output files with expected results.

---

## **Requirements**
1. **Documentation**:
   - Add detailed comments to VHDL code to explain design decisions.
   - Include:
     - **readme.txt**: A list of VHDL files and their functionality.
     - **pre3.pdf**: Report with waveforms and a brief explanation of the top module.
     - **designGraph.pdf**: A fully detailed FSM graph of the control unit.

2. **Waveform Analysis**:
   - Use **ModelSim** to analyze waveforms.
   - Highlight significant regions using clouds and annotations (as shown in Figure 4).
   - Customize waveform colors for better clarity.

3. **Submission**:
   - Submit a ZIP file named `id1_id2.zip` containing:
     - **DUT** folder: VHDL files for the multi-cycle CPU.
     - **TB** folder: Testbench files for:
       - Datapath
       - Control Unit
       - Complete DUT
     - **SIM** folder: Simulation files for waveform and list formats.
     - **DOC** folder: Documentation files as described above.

---

## **Simulation Requirements**
- Testbench files must include:
  1. Datapath testbench.
  2. Control unit testbench.
  3. DUT testbench with signals from both the datapath and control unit.
- Functional validation must ensure:
  - Proper execution of the ISA.
  - Correct state transitions in the FSM.
  - Accurate outputs in the file-based simulation.

---

This lab bridges theoretical concepts with practical implementation, providing a comprehensive understanding of multi-cycle CPU design. 
