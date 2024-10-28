`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: Full_Adder.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: A Full Adder, outputs the sum and the carry out.
* 
* Change history: 21/10/2024 - Created module at home
**********************************************************************/


module Full_Adder(
    input A, 
    input B, 
    input Cin, 
    output sum,
    output Cout
    );
    
    assign {Cout,sum} = A + B + Cin;
    
endmodule
