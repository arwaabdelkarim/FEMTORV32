`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: DFF.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: 
* 
* Change history: 21/10/2024 - Created module at home
**********************************************************************/ 


module DFF(
    input clk, 
    input rst, 
    input D, 
    output reg Q
    );
    
    always @ (posedge clk or posedge rst)
        if (rst) begin
            Q <= 1'b0;
            end 
        else begin
            Q <= D;
     end
endmodule
