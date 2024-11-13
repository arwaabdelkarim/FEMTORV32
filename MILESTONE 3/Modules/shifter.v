`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 05:07:19 PM
// Design Name: 
// Module Name: shifter
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


module shifter(
    input   wire [31:0] a,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	input   wire [1:0]  type
);
    
    always @(*) begin
        case (type) 
            2'b00: r = a >> shamt ; // shift right logical (pad with zeros)
            2'b01: r =  a << shamt; // shift left logical (pad with zeros)
            2'b10: r = ($signed(a) >>> shamt); // shift right arith 
            default: r = a;
        endcase
    end

endmodule
