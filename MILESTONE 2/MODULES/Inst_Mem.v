`timescale 1ns / 1ps
/*************************************************************************************** 
* 
* Module: Inst_Mem.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: The Inst_Mem module is an instruction memory unit that outputs 
               a 32-bit instruction (Data_out) from a specified 32-bit address. 
               The memory (mem) is preloaded with instructions in an initial block,
               and the Data_out signal retrieves a 32-bit instruction by concatenating 
               four bytes starting from the address specified in addr.
               
* Change history: 
****************************************************************************************/

module Inst_Mem(
    input [31:0] addr,
    output [31:0] Data_out
    );
     reg [7:0] mem [0:255]; 
    initial begin 
//               {mem[3], mem[2], mem[1], mem[0]} = 32'b00000000101000000000010100010011;
//              {mem[7], mem[6], mem[5], mem[4]} = 32'b00000000000000000000000001110011;
//              {mem[11], mem[10], mem[9], mem[8]} = 32'b00000000100100000000010100010011;



    

            
//        {mem[3], mem[2], mem[1], mem[0]} = 32'b000000000000_00000_010_00001_0000011; //lw x1, 0(x0)
//        {mem[7], mem[6], mem[5], mem[4]} = 32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
//        {mem[11], mem[10], mem[9], mem[8]} = 32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
//        {mem[15], mem[14], mem[13], mem[12]} = 32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
//        {mem[19], mem[18], mem[17], mem[16]} = 32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4
//        {mem[23], mem[22], mem[21], mem[20]} = 32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
//        {mem[27], mem[26], mem[25], mem[24]} = 32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
//        {mem[31], mem[30], mem[29], mem[28]} = 32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
//        {mem[35], mem[34], mem[33], mem[32]} = 32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
//        {mem[39], mem[38], mem[37], mem[36]} = 32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
//        {mem[43], mem[42], mem[41], mem[40]} = 32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
//        {mem[47], mem[46], mem[45], mem[44]} = 32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
//        {mem[51], mem[50], mem[49], mem[48]} = 32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
    end 

      assign Data_out[7:0] = mem[addr];
      assign Data_out[15:8] = mem[addr+1];
      assign Data_out[23:16] = mem[addr+2];
      assign Data_out[31:24] = mem[addr+3];
endmodule
    
