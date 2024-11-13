`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: MUX_4X1.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: 

* Change history: 26/10/2024 Created module at home
                  27/10/2024 Edited module at home 
**********************************************************************/

module MUX_4X1(
    input [31:0] in_0,
    input [31:0] in_1,
    input [31:0] in_2,
    input [31:0] in_3,
    input [1:0] sel,
    output reg [31:0] out
    );
    
    always @(*) begin
        case(sel)
            0: out = in_0;
            1: out = in_1;
            2: out = in_2;
            3: out = in_3;
            default: out = in_0;
        endcase
    end
endmodule
