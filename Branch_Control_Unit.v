`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: Branch_Control_Unit.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: Using the Funct_3 of the given instruction and the flags 
               calculated in the ALU, the branch control unit will assess 
               these flags and will return a signal to branch or not.

* Change history: 26/10/2024 Created module at home
**********************************************************************/


module Branch_Control_Unit(
    input [2:0] func3,
    input Z_flag,
    input V_flag,
    input C_flag,
    input S_flag,
    input Branch_signal,
    output reg Anded
    );
    
    always @(*) begin
        case (func3)
            3'b000: Anded = Branch_signal & Z_flag; //beq
            3'b001: Anded = Branch_signal & ~Z_flag; //bne
            3'b100: Anded = Branch_signal & (S_flag != V_flag); //blt
            3'b101: Anded = Branch_signal & (S_flag == V_flag); //bge
            3'b110: Anded = Branch_signal & ~C_flag; //bltu
            3'b111: Anded = Branch_signal & C_flag; //bgeu
            default: Anded = 1'b0;
        endcase
    end
endmodule
