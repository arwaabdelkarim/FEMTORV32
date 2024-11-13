`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: N_Bit_RCA.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: 
* 
* Change history: 21/10/2024 - Created module at home
**********************************************************************/


module N_Bit_RCA #(parameter n=8)(
    input [n-1:0] A, 
    input [n-1:0] B, 
    //input Cin, 
    output [n - 1 : 0] sum,
    output carry_out,
    output overflow
    ); 

    wire [n:0]carry;
    assign carry[0] = 1'b0; //Cin;
    genvar i;
    
    generate 
        for (i=0; i < n; i = i+1)begin 
            Full_Adder dut ( .A(A[i]), .B(B[i]), .Cin(carry[i]), .sum(sum[i]), .Cout(carry[i+1]));
        end 
    endgenerate 
    
    assign carry_out = carry[n];
    assign overflow = (carry[n] ^ carry[n-1]);
    
endmodule 