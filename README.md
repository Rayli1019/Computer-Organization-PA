# Computer Organization – NTUST
This repository contains my projects for the **Computer Organization** course at NTUST.  

All Programming Assignments (PA) are graded with a ranking system. Only the **comprehensive score** (based on *area* and *slack*) allows a perfect score. Across the three projects, I achieved two perfect scores of 100, and one score of 98 (slightly higher area than some classmates, but still excellent).  

---

## PA1: Multiplier & Divider
In this project, we implemented a **multiplier** and a **divider** using registers, ALU, and control blocks in Verilog.  

- To minimize area, I replaced the 32-bit ALU adder with a **4-bit carry look-ahead adder**, reducing area by about **32%**.  
  - This optimization slightly reduced slack (~20%), but the trade-off was worthwhile.  
- For the divider, I applied the **two’s complement method** from digital logic, which allowed me to keep the area increase minimal while maintaining almost the same slack.  

As a result, my design ranked **first place** in the class for **area, slack, and functionality**.  

#### Final Score: **100 / 100**

### Architecture – Multiplier & Divider
<p align="center"><img src="/image/multiplier_structure.png" width="390" height="400"></p> 
<p align="center"><img src="/image/divider_structure.png" width="390" height="400"></p>  

---

## PA2: Single-Cycle CPU
This project required designing a **single-cycle CPU** consisting of:  
- ALU  
- Data Memory  
- Instruction Memory  
- Instruction Decoder  
- Controller  

The CPU supports the following instructions:  

| Instruction | Example | Description |
| --- | --- | --- |
| Add unsigned | `Addu $Rd,$Rs,$Rt` | `$Rd = $Rs + $Rt` |
| Sub unsigned | `Subu $Rd,$Rs,$Rt` | `$Rd = $Rs − $Rt` |
| Shift left logical | `Sll $Rd,$Rs,Shamt` | `$Rd = $Rs << Shamt` |
| OR | `Or $Rd,$Rs,$Rt` | `$Rd = $Rs \\| $Rt` |
| Add immediate unsigned | `Addiu $Rt,$Rs,Imm` | `$Rt = $Rs + Imm` |
| Store word | `Sw $Rt,Imm($Rs)` | `Mem[$Rs + Imm] = $Rt` |
| Load word | `Lw $Rt,Imm($Rs)` | `$Rt = Mem[$Rs + Imm]` |
| OR immediate | `Ori $Rt,$Rs,Imm` | `$Rt = $Rs \\| Imm` |
| Branch on equal | `Beq $Rs,$Rt,Imm` | `if ($Rs == $Rt) → PC = PC + 4 + Imm × 4` |
| Jump | `J Imm` | `PC = {NextPC[31:28], Imm × 4}` |

### Optimizations
- **Control Block & ALU Control**: Optimized by reducing **opcode/function encoding** from 6 bits to 3 bits, leveraging structural regularity.  
- **+4 Adder**: Since instruction memory ranged only from `0–128`, I replaced the 32-bit +4 adder with an **8-bit carry look-ahead adder**, reducing unnecessary area while meeting requirements.  

#### Final Score: **98 / 100**

### Architecture – Single-Cycle CPU
<p align="center"><img src="/image/Single Cycle CPU.png" width="585" height="600"></p>  

---

## PA3: Pipelined CPU (Final Project)
The final project was to design a **pipelined CPU**. Similar to PA2, it required ALU, memory, instruction decoder, and control logic, but also introduced **data hazards** and **control hazards**, which needed careful handling to ensure correctness.  

### Optimizations
- **Control Block & ALU Control**: Same 6-bit → 3-bit optimization as PA2.  
- **+4 Adder**: Reused the optimized **8-bit carry look-ahead adder**.  
- **Sign Extension**: Moved to the second pipeline stage to reduce register size while keeping slack stable.  
- **Final MUX**: Relocated to the fourth stage for similar efficiency reasons.  

Thanks to these optimizations, I achieved a **perfect score (100/100)** and ranked **first in the class**.  

### Supported Instructions
| Instruction | Example | Description |
| --- | --- | --- |
| Add unsigned | `Addu $Rd,$Rs,$Rt` | `$Rd = $Rs + $Rt` |
| Sub unsigned | `Subu $Rd,$Rs,$Rt` | `$Rd = $Rs − $Rt` |
| Shift left logical | `Sll $Rd,$Rs,Shamt` | `$Rd = $Rs << Shamt` |
| OR | `Or $Rd,$Rs,$Rt` | `$Rd = $Rs \\| $Rt` |
| Add immediate unsigned | `Addiu $Rt,$Rs,Imm` | `$Rt = $Rs + Imm` |
| Store word | `Sw $Rt,Imm($Rs)` | `Mem[$Rs + Imm] = $Rt` |
| Load word | `Lw $Rt,Imm($Rs)` | `$Rt = Mem[$Rs + Imm]` |
| OR immediate | `Ori $Rt,$Rs,Imm` | `$Rt = $Rs \\| Imm` |

#### Final Score: **100 / 100** (Ranked #1)

### Architecture – Pipelined CPU
<p align="center"><img src="/image/pipeline cpu.png" width="585" height="600"></p>  
