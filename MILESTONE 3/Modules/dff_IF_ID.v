`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 10:25:47 PM
// Design Name: 
// Module Name: dff_IF_ID
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


module dff_IF_ID(
    input clk, 
    input rst, 
    input D, 
    input DEF,
    output reg Q
    );
    
    always @ (posedge clk or posedge rst)
        if (rst) begin
            Q <= DEF;
            end 
        else begin
            Q <= D;
     end
endmodule

