`timescale 1ns / 1ps
`include "defines.v"
/******************************************************************* 
* 
* Module: ALU_Control_Unit.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: 

* Change history: 26/10/2024 Created module at home
                  27/10/2024 Edited module at home 
**********************************************************************/


module ALU_Control_Unit(
    input [1:0] ALUOp,
    input IR_30,
    input IR_5,
    input [`IR_funct3] func3,
    output reg [3:0] ALUSel
    );
    
    wire [3:0] sel;
    assign sel = {IR_30, func3};
    
    always @(*) begin
        if (ALUOp == 2'b00) //LOAD or STORE or JAL or JALR (add)
            ALUSel = `ALU_ADD;
        else if (ALUOp == 2'b01) //branch (sub)
                ALUSel = `ALU_SUB;
        else if (ALUOp == 2'b10)begin
            if (IR_5 == 1)begin
                case (sel)
                    4'b0000: ALUSel = `ALU_ADD;
                    4'b1000: ALUSel = `ALU_SUB;
                    4'b0100: ALUSel = `ALU_XOR;
                    4'b0110: ALUSel = `ALU_OR; 
                    4'b0111: ALUSel = `ALU_AND; 
                    4'b0001: ALUSel = `ALU_SLL; 
                    4'b0101: ALUSel = `ALU_SRL; 
                    4'b1101: ALUSel = `ALU_SRA; 
                    4'b0010: ALUSel = `ALU_SLT; 
                    4'b0011: ALUSel = `ALU_SLTU; 
                    default: ALUSel = `ALU_PASS;
                endcase
            end
            else begin
                case(func3)
                    3'b000: ALUSel = `ALU_ADD; //ADDI
                    3'b100: ALUSel = `ALU_XOR; //XORI
                    3'b110: ALUSel = `ALU_OR; //ORI
                    3'b111: ALUSel = `ALU_AND; //ANDI
                    3'b001: ALUSel = `ALU_SLL; //SLLI
                    3'b101: begin
                        if (IR_30)
                            ALUSel = `ALU_SRA; //SRAI
                        else 
                            ALUSel = `ALU_SRL; //SRLI
                    end
                    3'b010: ALUSel = `ALU_SLT; //SLTI
                    3'b011: ALUSel = `ALU_SLTU; //SLTIU
                    default : ALUSel = `ALU_PASS;
                endcase
            end
        end
        else 
            ALUSel = `ALU_PASS; // AUIPC, LUI, ECALL, EBREAK
    end
endmodule
