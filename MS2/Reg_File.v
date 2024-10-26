`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: Reg_File.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: This module takes in 3 5 bits, representing 
               2 source and 1 destination registers as well 
               as n bit data to be written, and a write 
               enable. It has 2 n bit outputs, the data that
               is read from the 2 source registers.
* 
* Change history: 21/10/2024 - Created module at home
**********************************************************************/ 

module Reg_File #(parameter n = 32)(
    input clk,
    input rst,
    input Wr_en,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd, 
    input [n-1:0] Wr_data,
    output [n-1:0] Read_data1,
    output [n-1:0] Read_data2
    );
    
    reg [n-1:0] Register [31:0];
    integer i;
    always @ (posedge clk or posedge rst)begin
        if (rst)begin
            for(i = 0; i < n; i = i + 1)begin
                Register[i] <= 32'b0;
            end
        end
        else if (Wr_en == 1'b1)begin
            if(rd != 0)
                Register[rd] <= Wr_data;
            else 
                Register[rd] <= 32'b0;
        end
    end
    assign Read_data1 = Register[rs1];
    assign Read_data2 = Register[rs2];
endmodule
