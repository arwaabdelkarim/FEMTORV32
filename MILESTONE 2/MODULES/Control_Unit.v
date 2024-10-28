`timescale 1ns / 1ps
`include "defines.v"
/***************************************************************************   
* 
* Module: Control_Unit.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: The Control_Unit module generates control signals based 
               on the opcode to coordinate various processor operations, 
               such as memory access, ALU operation selection, register 
               writes, and branching. It determines the behavior of each 
               instruction type by setting specific control lines.

* Change history: 26/10/2024 Created module at home
                  27/10/2024 Edited module at home 
****************************************************************************/

module Control_Unit(
    input [4:0] opcode,
//    input IR_25, 
    output reg Branch,
    output reg Jump,
    output reg MemRead, 
    output reg MemtoReg, 
    output reg [1:0] ALUOp, 
    output reg MemWrite, 
    output reg ALUSrc_1,
    output reg ALUSrc_2,
    output reg RegWrite,
    output reg [1:0] RegWriteSel 
//    output reg PCWrite
    );
    
    always @(*) begin
        case (opcode)
            `OPCODE_Branch: begin
                Branch = 1'b1;
                Jump = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = `ALUOP_SUB;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b0;
                ALUSrc_2 = 1'b0;
                RegWrite = 1'b0;
                RegWriteSel = 2'b00;
//                PCWrite = 1'b1;
            end
            
            `OPCODE_Load: begin
                Branch = 1'b0;
                Jump = 1'b0;
                MemRead = 1'b1;
                MemtoReg = 1'b1;
                ALUOp = `ALUOP_ADD;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b1;
                ALUSrc_2 = 1'b1;
                RegWrite = 1'b1;
                RegWriteSel = 2'b00;
//                PCWrite = 1'b1;
            end
            `OPCODE_Store: begin
                Branch = 1'b0;
                Jump = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = `ALUOP_ADD;
                MemWrite = 1'b1;
                ALUSrc_1 = 1'b1;
                ALUSrc_2 = 1'b1;
                RegWrite = 1'b0;
                RegWriteSel = 2'b00;
//                PCWrite = 1'b1;
            end
            `OPCODE_JALR: begin
                Branch = 1'b1;
                Jump = 1'b1;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = `ALUOP_ADD;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b1;
                ALUSrc_2 = 1'b1;
                RegWrite = 1'b1;
                RegWriteSel = 2'b10;
//                PCWrite = 1'b1;
            end
            `OPCODE_JAL: begin
                Branch = 1'b1;
                Jump = 1'b1;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = `ALUOP_ADD;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b0;
                ALUSrc_2 = 1'b1;
                RegWrite = 1'b1;
                RegWriteSel = 2'b10;
//                PCWrite = 1'b1;
            end
            `OPCODE_Arith_I: begin
                Branch = 1'b0;
                Jump = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = `ALUOP_OW;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b1;
                ALUSrc_2 = 1'b1;
                RegWrite = 1'b1;
                RegWriteSel = 2'b01;
//                PCWrite = 1'b1;
            end
            `OPCODE_Arith_R: begin
                Branch = 1'b0;
                Jump = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = `ALUOP_OW;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b1;
                ALUSrc_2 = 1'b0;
                RegWrite = 1'b1;
                RegWriteSel = 2'b01;
//                PCWrite = 1'b1;
            end
            `OPCODE_AUIPC: begin
                Branch = 1'b0;
                Jump = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b11;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b0;
                ALUSrc_2 = 1'b1;
                RegWrite = 1'b1;
                RegWriteSel = 2'b01;
//                PCWrite = 1'b1;
            end
            `OPCODE_LUI: begin
                Branch = 1'b0;
                Jump = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b11;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b0;
                ALUSrc_2 = 1'b1;
                RegWrite = 1'b1;
                RegWriteSel = 2'b11;
//                PCWrite = 1'b1;
            end
            `OPCODE_SYSTEM: begin
                Branch = 1'b0;
                Jump = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = `ALUOP_OW;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b0;
                ALUSrc_2 = 1'b0;
                RegWrite = 1'b0;
                RegWriteSel = 2'b01;
//                PCWrite = ~IR_25;
            end
            `OPCODE_FENCE: begin
                Branch = 1'b0;
                Jump = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = `ALUOP_ADD;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b0;
                ALUSrc_2 = 1'b0;
                RegWrite = 1'b0;
                RegWriteSel = 2'b01;
//                PCWrite = ~IR_25;
            end
            default: begin
                Branch = 1'b0;
                Jump = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = `ALUOP_OW;
                MemWrite = 1'b0;
                ALUSrc_1 = 1'b0;
                ALUSrc_2 = 1'b0;
                RegWrite = 1'b0;
                RegWriteSel = 2'b01;
//                PCWrite = 1'b1;
            end
        endcase
    end
endmodule

