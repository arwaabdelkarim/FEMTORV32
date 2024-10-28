`timescale 1ns / 1ps
`include "defines.v"
/**************************************************************************  
* 
* Module:  ALU_32.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: The ALU_32 module performs arithmetic and logical operations 
               based on the ALUsel input, producing a 32-bit output ALU_out. 
               It also sets condition flags (carry, zero, sign, overflow) to 
               indicate the result's status, supporting various operations.

* Change history: 25/10/2024 Created module at home
*****************************************************************************/

module ALU_32(
	input   wire [31:0] ALU_A, ALU_B ,
	input   wire [4:0]  shamt,
	input   wire IR_5,
	output  reg  [31:0] ALU_out,
	output  wire  Cflag, Zflag, Vflag, Sflag,
	input   wire [3:0]  ALUsel
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    wire signed  [31:0] a_s;
    assign a_s = ALU_A;
    wire signed [4:0]  shamt_s;
    assign shamt_s =  shamt;
    assign op_b = (~ALU_B);
    
    assign {Cflag, add} = ALUsel[0] ? (ALU_A + op_b + 1'b1) : (ALU_A + ALU_B);
    
    assign Zflag = (add == 0);
    assign Sflag = add[31];
    assign Vflag = (ALU_A[31] ^ (op_b[31]) ^ add[31] ^ Cflag);
    
    //wire[31:0] sh;
    //shifter shifter_inst(.a(ALU_A), .shamt(shamt), .type(ALUsel[1:0]),  .r(sh));
    
    always @ * begin
        ALU_out = 0;
        (* parallel_case *)
        case (ALUsel)
            // arithmetic
            `ALU_ADD : ALU_out = add;
            `ALU_SUB : ALU_out = add;
            `ALU_PASS: ALU_out = ALU_B;
            // logic
            `ALU_OR:  ALU_out = ALU_A | ALU_B;
            `ALU_AND:  ALU_out = ALU_A & ALU_B;
            `ALU_XOR:  ALU_out = ALU_A ^ ALU_B;
            // shift
            `ALU_SRL:begin  
                        if(IR_5 == 1'b0)
                            ALU_out = ALU_A >> shamt;//ALU_out=sh;
                        else 
                            ALU_out = ALU_A >> ALU_B[4:0];    
            end
            `ALU_SLL:begin  
                        if(IR_5 == 1'b0)
                            ALU_out = ALU_A << shamt;
                        else 
                            ALU_out = ALU_A << ALU_B[4:0];
             end
            `ALU_SRA:begin 
                        if(IR_5 == 1'b0)
                            ALU_out = a_s >>> shamt_s;
                        else 
                            ALU_out = a_s >>> ALU_B[4:0];
             end
            // slt & sltu
            `ALU_SLT:  ALU_out = {31'b0,(Sflag != Vflag)}; 
            `ALU_SLTU:  ALU_out = {31'b0,(~Cflag)};            	
        endcase
    end
endmodule