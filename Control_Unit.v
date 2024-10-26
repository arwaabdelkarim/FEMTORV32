`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: Control_Unit.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: 

* Change history: 26/10/2024 Created module at home
**********************************************************************/

module Control_Unit(
    input [6:0] opcode,
    output reg Branch,
    output reg Jump,
    output reg MemRead,
    output reg [1:0] RegWriteSel,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc_1,
    output reg ALUSrc_2,
    output reg RegWrite
     );
     
     always @(*) begin
        case (opcode)
            7'b0110011: begin; //R-type
            
            end
            7'b0010011: begin; //I-type
            
            end
            7'b0000011: begin; //load
             
            end
            7'b0100011: begin; //S-type
            
            end
            7'b1100011: begin; //B-type
            
            end
            7'b1101111: begin; //jal
            
            end
            7'b1100111: begin; //jalr
            
            end
            7'b0110111: begin; //lui
            
            end
            7'b0010111: begin; //auipc
            
            end
            7'b1110011: begin; //ecall & ebreak
            
            end
            default: begin
            
            end
        endcase
     end


endmodule