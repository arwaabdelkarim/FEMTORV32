`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2024 03:21:14 PM
// Design Name: 
// Module Name: ForwardUnit
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

module ForwardUnit(input [4:0] ID_EX_Rs1, input [4:0] ID_EX_Rs2, input [4:0] EX_MEM_Rd, input [4:0] MEM_WB_Rd, 
                   input EX_MEM_RegWrite, input MEM_WB_RegWrite, output reg [1:0] forwardA, output reg [1:0] forwardB);
                   
always @ (*) 
    begin
        if ((EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1)))
            forwardA =  2'b10;
        else if ((MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1)) &&  ~(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1)))
            forwardA =  2'b01;
        else forwardA = 2'b00;
        
        if ((EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2)))
            forwardB =  2'b10;
        else if ((MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2)) &&  ~(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2)))
            forwardB =  2'b01;
        else
            forwardB = 2'b00;
    end

endmodule
