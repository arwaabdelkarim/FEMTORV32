`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: Imm_Gen.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: This module receives the 32 bit Instuction and extracts 
               the 32 bit immediate value from it depending on the Opcode
               of the incoming Instruction. It also takes into account the 
               sign extension of the immediate value.
* 
* Change history: 26/10/2024 Created module at home
**********************************************************************/

module Imm_Gen(
    input [31:0] Inst,
    output reg [31:0] gen_out
    );
    
    wire [6:0] opcode;
    assign opcode = Inst[6:0];
    
    always @(*) begin
        case (opcode)
            7'b0010011: begin //I-type
                if (Inst[14:12] == 3'b011)
                    gen_out = {20'b0,Inst[31:20]};
                else if (Inst[14:12] == 3'b001 || Inst[14:12] == 3'b101)
                         gen_out = {27'b0,Inst[24:20]};  
                else
                    gen_out = {{20{Inst[31]}},Inst[31:20]};
            end
            
            7'b0000011: begin //load
                gen_out = {{20{Inst[31]}},Inst[31:20]}; 
            end
            
            7'b0100011: begin //S-type
                gen_out = {{20{Inst[31]}},Inst[31:25],Inst[11:7]}; 
            end
            
            7'b1100011: begin //B-type
                if (Inst[14:12] == 3'b101 || Inst[14:12] == 3'b111)begin
                    gen_out = {19'b0,Inst[31],Inst[7],
                               Inst[30:25],Inst[11:8],1'b0}; 
                end 
                else
                    gen_out = {{19{Inst[31]}},Inst[31],Inst[7],
                                Inst[30:25],Inst[11:8],1'b0}; 
            end
            
            7'b1101111: begin //jal
                gen_out = {{11{Inst[31]}},Inst[31],Inst[19:12],
                            Inst[20],Inst[30:21],1'b0}; 
            end
            
            7'b1100111: begin //jalr
                gen_out = {{20{Inst[31]}},Inst[31:20]}; 
            end
            
            7'b0110111: begin //lui
                gen_out = {Inst[31:12], 12'b0}; 
            end
            
            7'b0010111:  begin //auipc
                gen_out = {Inst[31:12], 12'b0}; 
            end
           
            default: gen_out = 32'b0;
        endcase
    end

endmodule
