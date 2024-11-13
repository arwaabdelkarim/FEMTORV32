`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 10:28:14 PM
// Design Name: 
// Module Name: n_bit_reg_IF_ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module n_bit_reg_IF_ID #(parameter n = 32)(
    input clk, 
    input rst, 
    input load, 
    input [n-1:0] D,
    input [n-1:0] DEF,
    output [n-1:0] Q
    );
    wire [n-1:0]mux_out;
    genvar i;
    generate 
    for (i=0; i < n; i = i+1)
        begin 
             MUX_2X1 mux_dut (.A(D[i]), .B(Q[i]), .sel(load),  .out(mux_out[i]));
             dff_IF_ID DFF_IDF_dut (.clk(clk), .rst(rst), .D(mux_out[i]), .DEF(DEF[i]), .Q(Q[i]));
            
        end 
    endgenerate 
    
endmodule

