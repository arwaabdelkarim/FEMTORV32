`timescale 1ns / 1ps
`include "defines.v"
/******************************************************************************* 
* 
* Module: CPU.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: The CPU module is the main processing unit, integrating 
               the control unit, ALU, branch, and memory operations for 
               a single-cycle RISC-V processor. It fetches instructions 
               from memory, decodes them, and executes them by coordinating 
               data flow between the register file, ALU, immediate generator, 
               and data memory, with branching and jumping capabilities 
               based on control signals and flags. The program counter (PC) 
               updates each cycle, conditionally advancing based on branching 
               and jump instructions, ensuring program flow control.

* Change history: 26/10/2024 Created module at home
                  27/10/2024 Edited module at home 
******************************************************************************/

module CPU(
    input clk,
    input rst
    );
    
    reg [31:0] PC;
    wire [31:0] Instruction;
    
    wire Z_Flag;
    wire S_Flag;
    wire V_Flag;
    wire C_Flag;
    
    wire Branch;
    wire Jump;
    wire MemRead;
    wire MemtoReg;
    wire [1:0] ALUOp; 
    wire MemWrite; 
    wire ALUSrc_1;
    wire ALUSrc_2;
    wire Wr_en;
    wire [1:0] RegWriteSel;
 
    
    wire Br_anded;
    wire PC_en;
    wire [3:0] ALU_sel;
    
    wire [4:0] opcode;
    wire[31:0] rs1;
    wire[31:0] rs2;
    wire[31:0] rd;
    wire [31:0] Read_data1;
    wire [31:0] Read_data2;
    wire[2:0] func3;
    wire func7;
    
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] Immediate;
    wire [31:0] ALU_out;
    
    wire [31:0] Data_out;
    reg [31:0] Wr_data;
//    wire PC_Branch;
//    wire PC_4;
//    wire PC_next;
//    wire[31:0] PCInput;
    
    assign opcode = Instruction[`IR_opcode];
    assign rs1 = Instruction[`IR_rs1];
    assign rs2 = Instruction[`IR_rs2];
    assign rd = Instruction[`IR_rd];
    assign func3 = Instruction[`IR_funct3];
    assign func7 = Instruction[`IR_funct7];
    
    assign ALU_A = ALUSrc_1 ? Read_data1 : PC;
    assign ALU_B = ALUSrc_2 ? Immediate : Read_data2;
    assign PC_en = ({Instruction[20], opcode} == 6'b1_11100) ? 1'b0 : 1'b1;
    
    always@(*) begin
        case(RegWriteSel)
            2'b00: Wr_data = Data_out; //Mem_out;
            2'b01: Wr_data = ALU_out;
            2'b10: Wr_data = PC + 4;
            2'b11: Wr_data = Immediate;
        endcase
    end
    
    Control_Unit CU (.opcode(opcode), .Branch(Branch),.Jump(Jump),.MemRead(MemRead),.MemtoReg(MemtoReg),.ALUOp(ALUOp),.MemWrite(MemWrite),.ALUSrc_1(ALUSrc_1),.ALUSrc_2(ALUSrc_2),.RegWrite(Wr_en),.RegWriteSel(RegWriteSel));
    
    Inst_Mem IM(.addr(PC),.Data_out(Instruction));
    
    Reg_File #(.n(32)) RF(.clk(clk),.rst(rst),.Wr_en(Wr_en),.rs1(rs1),.rs2(rs2),.rd(rd),.Wr_data(Wr_data),.Read_data1(Read_data1),.Read_data2(Read_data2));
    
    Imm_Gen IMG(.IR(Instruction), .Imm(Immediate));
    
    ALU_Control_Unit ALUCU(.ALUOp(ALUOp), .IR_30(Instruction[30]),.func3(func3),.IR_5(Instruction[5]),.ALUSel(ALU_sel));
    
    ALU_32 ALU(.ALU_A(ALU_A),.ALU_B(ALU_B) ,.shamt(Instruction[`IR_shamt]),.IR_5(Instruction[5]),.ALU_out(ALU_out), .Cflag(C_Flag), .Zflag(Z_Flag), .Vflag(V_Flag), .Sflag(S_Flag),.ALUsel(ALU_sel));
    
    Branch_Control_Unit BCU(.func3(func3), .Z_flag(Z_Flag), .V_flag(V_Flag),.C_flag(C_Flag) , .S_flag(S_Flag), .Branch_signal(Branch), .Br_anded(Br_anded));
    
    Data_Mem DM(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .func3(func3), .Addr(ALU_out[7:0]), .Data_in(Read_data2), .Data_out(Data_out));
    

    always @ (posedge clk or posedge rst) begin
        if(rst == 1)
            PC <= 0;
        else if (PC_en == 0)
            PC <= PC;
        else begin 
            if (!(Instruction[`IR_opcode] == 5'b11100 && Instruction[`IR_funct7] == 0)) begin
                if(Br_anded) 
                    PC <= (PC+Immediate)%256;
                else if(Jump)
                    PC <= ALU_out;
                else 
                    PC <= PC + 4;
            end
       end   
    end

endmodule
