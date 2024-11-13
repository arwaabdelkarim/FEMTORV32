`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: MUX_2X1.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: 
* 
* Change history: 21/10/2024 - Created module at home
**********************************************************************/ 

module MUX_2X1( 
    input A,
    input B, 
    input sel, 
    output out
    );
    
assign out = (sel == 1'b0) ? B: A;
// A if 1, B if 0 

endmodule
