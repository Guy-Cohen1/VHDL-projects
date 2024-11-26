# Lab 2: VHDL Sequential Code and Behavioral Modeling

Welcome to the repository for **Lab 2** of the CPU Architecture course. This lab focuses on designing and simulating a **synchronous digital system** using **sequential code** and **behavioral modeling** in VHDL. Below, you'll find an overview of the lab's objectives, tasks, and deliverables.

---

## **Lab Objective**
1. Develop proficiency in **VHDL Part 2**, including:
   - Sequential code.
   - Behavioral modeling techniques.
2. Gain additional experience using **ModelSim** for HDL simulation and debugging.
3. Build knowledge of synchronous digital system design and verification.
4. Enhance skills in analyzing and documenting architecture designs.

---

## **System Design Overview**
### **System Functionality**
The system detects valid subseries of values based on predefined conditions using the difference between consecutive inputs. The conditions are encoded in the **DetectionCode** signal, as shown below:

| DetectionCode | Condition                              |
|---------------|---------------------------------------|
| 0             | \( x[j-1] - x[j-2] = 1 \)            |
| 1             | \( x[j-1] - x[j-2] = 2 \)            |
| 2             | \( x[j-1] - x[j-2] = 3 \)            |
| 3             | \( x[j-1] - x[j-2] = 4 \)            |

The system design is implemented as a synchronous structure with a clear division of functionality across modules.

---

### **Design Constraints**
1. The **top-level design** must be structural, combining three VHDL modules.
2. The **Adder module** for condition checks must use **Behavioral modeling** but with only a single instantiation of `Adder.vhd` to minimize hardware usage.
3. The provided files `top.vhd`, `aux_package.vhd`, and `Adder.vhd` are mandatory and cannot be modified except where specified.

---

### **Key Modules**
1. **Adder-Based Condition Checker**:
   - Implements the detection logic based on differences between consecutive inputs.
   - Uses behavioral modeling for efficiency and clarity.

2. **Test Bench**:
   - Validates the design's functionality across all detection codes.
   - Simulates the design using input waveforms to verify timing and output correctness.

3. **Structural Top-Level Module**:
   - Combines the submodules into a complete system with clear and modular organization.

---

## **Test Bench and Timing**
1. Design a comprehensive **testbench** to cover all detection conditions.
2. Analyze and document input/output signals with a focus on:
   - Timing and transitions.
   - Behavior under different DetectionCode settings.
   - 
---

This lab emphasizes the design of efficient, modular, and scalable systems using VHDL. It is a stepping stone for mastering sequential logic design and behavioral modeling. Good luck!
