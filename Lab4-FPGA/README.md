# Lab 4: FPGA-Based Digital Design

This document outlines the structure and requirements for **Lab 4** in the CPU Architecture course. This lab builds on previous assignments, focusing on synthesizing and testing a digital system on an FPGA platform.

---

## **Lab Objectives**
1. **Understand digital system synthesis** for FPGA implementation.
2. Evaluate design performance, including logic utilization, timing, and critical paths.
3. Perform hardware testing using the DE10-Standard FPGA board.
4. Learn to use Signal Tap Logic Analyzer for real-time FPGA debugging.

---

## **Assignment Definition**

The lab consists of two main tasks:

### **1. Performance Test Case**
This task evaluates the functionality and performance of a synchronous digital system. 

#### **Key Steps:**
1. **Simulation:**
   - Conduct ModelSim simulations for functional validation with maximum coverage (as done in Lab 1).

2. **Synthesis:**
   - Use Quartus to compile the design without pin assignments.
   - Perform timing analysis by setting the clock constraint to its maximum value.
   - Analyze the logic usage, including combinational logic and flip-flops.

3. **Analysis:**
   - Identify the **critical path** and explain the longest and shortest paths within the system.
   - Investigate frequency-limiting operations and provide explanations.

4. **Documentation:**
   - Include RTL Viewer results for each logic block.
   - Present logic usage and critical path findings.
   - Summarize any code optimizations for FPGA performance.

---

### **2. Hardware Test Case**
This task implements and tests the digital system on the DE10-Standard FPGA board, incorporating its I/O interfaces.

#### **System Requirements:**
1. **Input Interface:**
   - Use board switches (**SW9-SW0**) and debounced pushbuttons (**KEY3-KEY0**) for inputs.

2. **Output Interface:**
   - Display results using LEDs (**LEDR9-LEDR0**) and 7-segment displays (**HEX5-HEX0**).

3. **Hardware Implementation:**
   - Integrate and map the system to the DE10-Standard FPGA board as per the provided I/O interface diagram.

4. **Validation:**
   - Use Quartus Signal Tap Logic Analyzer to verify correct execution of arithmetic and shift operations.

---

## **Conclusion**
Lab 4 highlights FPGA-based design and validation, emphasizing both software and hardware integration. By completing this assignment, you will gain practical insights into FPGA design workflows, critical path analysis, and real-time debugging. 
