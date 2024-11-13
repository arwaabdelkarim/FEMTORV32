`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: N_Bit_2X1_MUX.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: 
* 
* Change history: 21/10/2024 - Created module at home
**********************************************************************/ 



module N_Bit_2X1_MUX #(parameter n=32)(
    input [n-1:0] A,
    input [n-1:0] B, 
    input sel,
    output [n-1:0] mux_out
    );
    genvar i;
    generate 
        for(i = 0; i < n; i = i + 1) begin 
            MUX_2X1 dut (.A(A[i]),.B(B[i]),.sel(sel),.out(mux_out[i]));
        end
    endgenerate 
endmodule
