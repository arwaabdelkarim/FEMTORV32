`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: N_Bit_Register.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: n-bit Register utilizing the D Flip-Flops.
* 
* Change history: 21/10/2024 - Created module at home
**********************************************************************/ 


module N_Bit_Register #(parameter n = 32)(
    input clk, 
    input rst, 
    input load, 
    input [n-1:0] D, 
    output [n-1:0] Q
    );
    wire [n-1:0]mux_out;
    genvar i;
    generate 
    for (i=0; i < n; i = i+1)
        begin 
             MUX_2X1 mux_dut (.A(D[i]), .B(Q[i]), .sel(load),  .out(mux_out[i]));
             DFF DFF_dut (.clk(clk), .rst(rst), .D(mux_out[i]), .Q(Q[i]));
        end 
    endgenerate 
    
endmodule

