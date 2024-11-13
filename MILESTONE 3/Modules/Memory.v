`timescale 1ns / 1ps
/******************************************************************* 
* 
* Module: Data_Mem.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: Recieves an adress from the ALU, if the read signal 
               is on, the function will use the given func3 to 
               read the required number of bytes and whether to sign 
               extend or not, if the MemWrite signal is on it will 
               use the funct3 to write the required number of bits.
* 
* Change history: 25/10/2024 Created module at home
**********************************************************************/

module Memory(
    input clk,
    input MemRead,
    input MemWrite,
    input [2:0] func3,
    input [7:0] Addr,
    input [31:0] Data_in,
    output reg [31:0] Data_out
    );
    reg [7:0] Mem [0:255];
    
    initial begin
//     {Mem[131], Mem[130], Mem[129], Mem[128]}    = 32'd17;    // Address 0: 20 in hex (32-bit word)
//    {Mem[135], Mem[134], Mem[133], Mem[132]}    = 32'd9;    // Address 0: 20 in hex (32-bit word)
//    {Mem[139], Mem[138], Mem[137], Mem[136]}    = 32'd25;    // Address 0: 20 in hex (32-bit word)

//          {Mem[3], Mem[2], Mem[1], Mem[0]} = 32'd17;
//          {Mem[7], Mem[6], Mem[5], Mem[4]} = 32'd9;  
//          {Mem[11], Mem[10], Mem[9], Mem[8]} = 32'd25;
          {Mem[3], Mem[2], Mem[1], Mem[0]} = 32'b00000000000000000010000010110111;
                {Mem[7], Mem[6], Mem[5], Mem[4]} = 32'b00000000000000000101000100010111;
                {Mem[11], Mem[10], Mem[9], Mem[8]} = 32'b00000000000000000000000001110011; //ecall
//                  {Mem[11], Mem[10], Mem[9], Mem[8]}= 32'b00000000000100000000000001110011;
                {Mem[15], Mem[14], Mem[13], Mem[12]}= 32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
                {Mem[19], Mem[18], Mem[17], Mem[16]} = 32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
                {Mem[23], Mem[22], Mem[21], Mem[20]} = 32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
                {Mem[27], Mem[26], Mem[25], Mem[24]} = 32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
                {Mem[31], Mem[30], Mem[29], Mem[28]} = 32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//        {Mem[3], Mem[2], Mem[1], Mem[0]} = 32'b00000000000000000000000000011000;
//        {Mem[7], Mem[6], Mem[5], Mem[4]} = 32'b00000000000000000000000000000010;
//        {Mem[11], Mem[10], Mem[9], Mem[8]} = 32'b00000000000000000000000010000010;
//        {Mem[15], Mem[14], Mem[13], Mem[12]} = 32'b00000000000000000000000000000011;

//        {Mem[3], Mem[2], Mem[1], Mem[0]} = 32'b00000000_00000000_00000000_00010001;
//        {Mem[7], Mem[6], Mem[5], Mem[4]} = 32'b00000000_00000000_00000000_00001001;
//        {Mem[11], Mem[10], Mem[9], Mem[8]} = 32'b00000000_00000000_00000000_00011001;
    end
    always @ (posedge clk) begin
        if (MemWrite) begin
            case(func3)
                3'b000: Mem[Addr] <= Data_in[7:0]; //SB
                3'b001: begin
                    Mem[Addr] <= Data_in[7:0];
                    Mem[Addr+1] <= Data_in[15:8]; //SH 
                end
                3'b010: begin
                    Mem[Addr] <= Data_in[7:0];
                    Mem[Addr+1] <= Data_in[15:8];
                    Mem[Addr+2] <= Data_in[23:16];
                    Mem[Addr+3] <= Data_in[31:24]; //SW
                end
            endcase
        end   
        else 
            Mem[Addr] <= Mem[Addr];    
    end
    
    always @(*)begin
        if(MemRead)begin
            case(func3)
                3'b000: Data_out = {{24{Mem[Addr][7]}}, Mem[Addr]}; //lb
                3'b001: Data_out = {{16{Mem[Addr][7]}}, Mem[Addr+1], Mem[Addr]}; //lh
                3'b010: Data_out = {Mem[Addr+3], Mem[Addr+2], Mem[Addr+1], Mem[Addr]}; //lw
                3'b100: Data_out = {24'b0, Mem[Addr]}; //lbu
                3'b101: Data_out = {16'b0, Mem[Addr+1], Mem[Addr]}; //lbu
                default: Data_out <= 32'b0;
            endcase
        end 
    end
    
    
endmodule 
