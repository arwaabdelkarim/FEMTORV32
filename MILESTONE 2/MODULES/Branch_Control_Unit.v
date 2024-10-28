`timescale 1ns / 1ps
`include "defines.v"
/******************************************************************************* 
* 
* Module: Branch_Control_Unit.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: The Branch_Control_Unit module determines whether a branch 
               should be taken by evaluating the instruction's func3 and 
               the ALU flags. Based on these conditions and the Branch_signal, 
               it outputs Br_anded to indicate if the branch condition is met.

* Change history: 26/10/2024 Created module at home
********************************************************************************/


module Branch_Control_Unit(
    input [2:0] func3,
    input Z_flag,
    input V_flag,
    input C_flag,
    input S_flag,
    input Branch_signal,
    output reg Br_anded
    );
    
    always @(*) begin
        case (func3)
            `BR_BEQ: Br_anded = Branch_signal & Z_flag; //beq
            `BR_BNE: Br_anded = Branch_signal & ~Z_flag; //bne
            `BR_BLT: Br_anded = Branch_signal & (S_flag != V_flag); //blt
            `BR_BGE: Br_anded = Branch_signal & (S_flag == V_flag); //bge
            `BR_BLTU: Br_anded = Branch_signal & ~C_flag; //bltu
            `BR_BGEU: Br_anded = Branch_signal & C_flag; //bgeu
            default: Br_anded = 1'b0;
        endcase
    end
endmodule
