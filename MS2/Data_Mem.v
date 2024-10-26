`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: Data_Mem.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: Recieves an adress from the ALU, if the read signal 
               is on, the function will use the given func3 to 
               read the required number of bytes and whether to sign 
               extend or not, if the MemWrite signal is on it will 
               use the funct3 to write the required number of bits.
* 
* Change history: 25/10/2024 Created module at home
**********************************************************************/

module Data_Mem(
    input clk,
    input MemRead,
    input MemWrite,
    input [2:0] func3,
    input [7:0] Addr,
    input [31:0] Data_in,
    output reg [31:0] Data_out
    );
    reg [7:0] Mem [0:255];
    always @ (posedge clk) begin
        if (MemWrite) begin
            case(func3)
                3'b000: Mem[Addr] <= Data_in[7:0]; //SB
                3'b001: begin
                    Mem[Addr] <= Data_in[7:0];
                    Mem[Addr+1] <= Data_in[15:8]; //SH 
                end
                3'b010: begin
                    Mem[Addr] <= Data_in[7:0];
                    Mem[Addr+1] <= Data_in[15:8];
                    Mem[Addr+2] <= Data_in[23:16];
                    Mem[Addr+3] <= Data_in[31:24]; //SW
                end
            endcase
        end   
        else 
            Mem[Addr] <= Mem[Addr];    
    end
    
    always @(*)begin
        if(MemRead)begin
            case(func3)
                3'b000: Data_out = {{24{Mem[Addr][7]}}, Mem[Addr]}; //lb
                3'b001: Data_out = {{16{Mem[Addr][7]}}, Mem[Addr+1], Mem[Addr]}; //lh
                3'b010: Data_out = {Mem[Addr+3], Mem[Addr+2], Mem[Addr+1], Mem[Addr]}; //lw
                3'b100: Data_out = {24'b0, Mem[Addr]}; //lbu
                3'b101: Data_out = {16'b0, Mem[Addr+1], Mem[Addr]}; //lbu
            endcase
        end
        else 
            Data_out <= 32'b0;
    end
endmodule 
