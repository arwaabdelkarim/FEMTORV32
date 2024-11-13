`timescale 1ns / 1ps
`include "defines.v"
/******************************************************************************* 
* 
* Module: CPU.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: The CPU module is the main processing unit, integrating 
               the control unit, ALU, branch, and memory operations for 
               a single-cycle RISC-V processor. It fetches instructions 
               from memory, decodes them, and executes them by coordinating 
               data flow between the register file, ALU, immediate generator, 
               and data memory, with branching and jumping capabilities 
               based on control signals and flags. The program counter (PC) 
               updates each cycle, conditionally advancing based on branching 
               and jump instructions, ensuring program flow control.

* Change history: 26/10/2024 Created module at home
                  27/10/2024 Edited module at home 
******************************************************************************/

module CPU(
    input clk,
    input rst
    );
    
    wire [31:0] PC;
    wire [31:0] PC_4;
    wire [31:0] Instruction;
        
    wire Z_Flag;
    wire S_Flag;
    wire V_Flag;
    wire C_Flag;
    
    wire Branch;
    wire Jump;
    wire MemRead;
    wire MemtoReg;
    wire [1:0] ALUOp; 
    wire MemWrite; 
    wire ALUSrc_1;
    wire ALUSrc_2;
    wire RegWrite;
    wire [1:0] RegWriteSel;
 

    reg PC_en;
    wire [3:0] ALU_sel;
    
    wire [4:0] opcode;
    wire[31:0] rs1;
    wire[31:0] rs2;
    wire[31:0] rd;
    wire [31:0] Read_data1;
    wire [31:0] Read_data2;
    wire[2:0] func3;
    wire func7;
    
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] Immediate;
    wire [31:0] ALU_out;
    
    wire [31:0] Data_out;
    reg [31:0] Wr_data;
    
    wire [31:0] IF_ID_PC;
    wire [31:0] IF_ID_Inst;
    
    wire [31:0] ID_EX_PC;
    wire [31:0] ID_EX_RegR1;
    wire [31:0] ID_EX_RegR2;
    wire [31:0] ID_EX_Imm;
    wire [11:0] ID_EX_Ctrl;
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1;
    wire [4:0] ID_EX_Rs2;
    wire [4:0] ID_EX_Rd;
    wire ID_EX_Inst5;
    
    wire [31:0] EX_MEM_Target;
    wire [31:0] EX_MEM_ALU_out;
    wire [31:0] EX_MEM_ALUin2;
    wire [7:0] EX_MEM_Ctrl;
    wire [4:0] EX_MEM_Rd;
    wire [7:0] EX_MEM_ControlSignals;
    wire [3:0] EX_MEM_Flags; 
    wire [2:0] EX_MEM_Func3; 
    wire [31:0] EX_MEM_PC;
    wire [31:0] EX_MEM_Imm;
    
    wire [31:0] MEM_WB_Mem_out;
    wire [31:0] MEM_WB_ALU_out;
    wire [5:0] MEM_WB_Ctrl;
    wire [4:0] MEM_WB_Rd;
    wire [31:0] MEM_WB_PC;
    wire [31:0] MEM_WB_Imm;
    
    wire [1:0] forwardA;
    wire [1:0] forwardB;
    
    wire [31:0] signal;
    wire Br_taken;
    wire stall;
    wire [31:0] target_addr; 
    //wire [1:0] PCSrc;
    wire [31:0] PC_next;
    
    assign opcode = Instruction[`IR_opcode];
    assign rs1 = Instruction[`IR_rs1];
    assign rs2 = Instruction[`IR_rs2];
    assign rd = Instruction[`IR_rd];
    assign func3 = Instruction[`IR_funct3];
    assign func7 = Instruction[`IR_funct7];
    
    
    //IF STAGE
    assign PC_4 = PC + 4; 
    N_Bit_Register #(32) PCreg(.clk(clk), .rst(rst), .load(PC_en && !stall), .D(PC_next), .Q(PC));
    
//   Inst_Mem IM(.addr(PC[7:0]),.Data_out(Instruction));
    wire isdatamem;
    wire MEM_MemRead;
    wire MEM_MemWrite;
    wire [2:0] MEM_func3;
    wire [7:0] MEM_Addr;
    wire [31:0] MEM_Data_in;
    wire [31:0] MEM_Data_out;
    
    assign isdatamem = (MEM_WB_Ctrl[4] || MEM_WB_Ctrl[5]);
    assign MEM_MemRead = ~MEM_WB_Ctrl[4];
    assign MEM_MemWrite = MEM_WB_Ctrl[4];
    assign MEM_func3 = isdatamem ? EX_MEM_Func3 : 3'b010;
    assign MEM_Addr = isdatamem ? EX_MEM_ALU_out[7:0] : PC[7:0];
    assign MEM_Data_in = EX_MEM_ALUin2;
   
    Memory mem(.clk(clk), .MemRead(MEM_MemRead), .MemWrite(MEM_MemWrite), .func3(MEM_func3), .Addr(MEM_Addr), .Data_in(MEM_Data_in), .Data_out(MEM_Data_out));
    
    assign Instruction = isdatamem ? 32'b0000000_00000_00000_000_00000_0110011 : MEM_Data_out;
    assign Data_out = isdatamem ? MEM_Data_out : 32'b0;
    assign signal = Br_taken ? 32'b0000000_00000_00000_000_00000_0110011 : Instruction;
    
    hazard_detection HD(.IF_ID_Rs1(IF_ID_Inst[19:15]), .IF_ID_Rs2(IF_ID_Inst[24:20]), .ID_EX_Rd(ID_EX_Rd),.ID_EX_MemRead(ID_EX_Ctrl[9]), .EX_MEM_MemRead(EX_MEM_Ctrl[5]), .EX_MEM_MemWrite(EX_MEM_Ctrl[4]), .stall(stall));
   
    //IF_ID
    n_bit_reg_IF_ID #(64) IF_ID(.clk(clk), .rst(rst), .load(!stall), .D({PC, signal}), .DEF({32'b0, 32'b00000000000000000000000000110011}), .Q({IF_ID_PC, IF_ID_Inst}));
//    N_Bit_Register #(64) IF_ID(.clk(clk), .rst(rst), .load(!stall), .D({PC, signal}), .Q({IF_ID_PC, IF_ID_Inst}));
    
    Reg_File #(32) RF(.clk(clk),.rst(rst),.Wr_en(MEM_WB_Ctrl[2]),.rs1(IF_ID_Inst[19:15]),.rs2(IF_ID_Inst[24:20]),.rd(MEM_WB_Rd),.Wr_data(Wr_data),.Read_data1(Read_data1),.Read_data2(Read_data2));

    Imm_Gen IMG(.IR(IF_ID_Inst), .Imm(Immediate));
    
    Control_Unit CU (.opcode(IF_ID_Inst[6:2]), .Branch(Branch),.Jump(Jump),.MemRead(MemRead),.MemtoReg(MemtoReg),.ALUOp(ALUOp),.MemWrite(MemWrite),.ALUSrc_1(ALUSrc_1),.ALUSrc_2(ALUSrc_2),.RegWrite(RegWrite),.RegWriteSel(RegWriteSel));
  
    wire [11:0] control_signals;
    assign control_signals = (Br_taken) ? 12'b0 : {Jump, Branch, MemRead, MemWrite, MemtoReg, RegWrite, RegWriteSel, ALUSrc_1, ALUSrc_2, ALUOp};
    
    //ID_EX
    N_Bit_Register #(160) ID_EX (.clk(clk),.rst(rst),.load(!stall), 
                              .D({control_signals, IF_ID_PC,Read_data1,Read_data2, Immediate, 
                              {IF_ID_Inst[30], IF_ID_Inst[14:12]}, IF_ID_Inst[5], IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7]}),  
                              .Q({ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2, ID_EX_Imm, ID_EX_Func, ID_EX_Inst5, ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd}));
    
    //EX STAGE
    ALU_Control_Unit ALUCU(.ALUOp(ID_EX_Ctrl[1:0]), .IR_30(ID_EX_Func[3]),.func3(ID_EX_Func[2:0]),.IR_5(ID_EX_Inst5),.ALUSel(ALU_sel));
    
    // the forwarding unit
    ForwardUnit FU (.ID_EX_Rs1(ID_EX_Rs1),.ID_EX_Rs2(ID_EX_Rs2),.EX_MEM_Rd(EX_MEM_Rd), .MEM_WB_Rd(MEM_WB_Rd), .EX_MEM_RegWrite(EX_MEM_Ctrl[2]), .MEM_WB_RegWrite(MEM_WB_Ctrl[2]), .forwardA(forwardA), .forwardB(forwardB));
    
    wire [31:0] ALU_in1;
    wire [31:0] ALU_in2;
    assign ALU_in1 = forwardA[0] ? Wr_data : (forwardA[1] ? EX_MEM_ALU_out : ID_EX_RegR1);
    assign ALU_in2 = forwardB[0] ? Wr_data : (forwardB[1] ? EX_MEM_ALU_out : ID_EX_RegR2);
    
    //ALU_mux1
    assign ALU_A = (ID_EX_Ctrl[3] == 0) ? ALU_in1 : ID_EX_PC; // for auipc
    
    //ALU_mux2
    assign ALU_B = (ID_EX_Ctrl[2] == 0) ? ALU_in2 : ID_EX_Imm;

    assign target_addr = ID_EX_PC + ID_EX_Imm;
    
    ALU_32 ALU(.ALU_A(ALU_A),.ALU_B(ALU_B), .shamt(ID_EX_Rs2),.IR_5(ID_EX_Inst5), .ALU_out(ALU_out), .Cflag(C_Flag), .Zflag(Z_Flag), .Vflag(V_Flag), .Sflag(S_Flag),.ALUsel(ALU_sel));
    
    assign EX_MEM_ControlSignals = (stall || Br_taken) ? 8'b0 : ID_EX_Ctrl[11:4]; 
     
//     Jump, Branch, MemRead, MemWrite, MemtoReg, RegWrite, RegWriteSel
    //EX_MEM
    N_Bit_Register #(180) EX_MEM (.clk(clk),.rst(rst),.load(1'b1),
                            .D({EX_MEM_ControlSignals, target_addr, {C_Flag, Z_Flag, V_Flag, S_Flag}, ALU_out, ALU_in2, ID_EX_Func[2:0], ID_EX_Rd, ID_EX_PC, ID_EX_Imm}),
                            .Q({EX_MEM_Ctrl, EX_MEM_Target, EX_MEM_Flags, EX_MEM_ALU_out, EX_MEM_ALUin2, EX_MEM_Func3, EX_MEM_Rd, EX_MEM_PC, EX_MEM_Imm}));
         
    //MEM STAGE
    Branch_Control_Unit BCU(.func3(EX_MEM_Func3), .Z_flag(EX_MEM_Flags[2]), .V_flag(EX_MEM_Flags[1]),.C_flag(EX_MEM_Flags[3]) , .S_flag(EX_MEM_Flags[0]), .Branch_signal(EX_MEM_Ctrl[6]), .Br_anded(Br_taken));

//    assign PCSrc = (Br_taken) ? 2'b10 : ((EX_MEM_Ctrl[7]) ? 2'b01 : 2'b00) ;
    
//   Data_Mem DM(.clk(clk), .MemRead(EX_MEM_Ctrl[5]), .MemWrite(EX_MEM_Ctrl[4]), .func3(EX_MEM_Func3), .Addr(EX_MEM_ALU_out[7:0]), .Data_in(EX_MEM_ALUin2), .Data_out(Data_out));
    
    // MEM_WB 
    N_Bit_Register #(139) MEM_WB (.clk(clk),.rst(rst),.load(1'b1),
                            .D({EX_MEM_Ctrl[5:0], Data_out, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_PC, EX_MEM_Imm}),
                            .Q({MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd, MEM_WB_PC, MEM_WB_Imm}));
                            
   //WB STAGE 
    always@(*) begin
          case(MEM_WB_Ctrl[1:0])
              2'b00: Wr_data = MEM_WB_Mem_out;
              2'b01: Wr_data = MEM_WB_ALU_out;
              2'b10: Wr_data = MEM_WB_PC + 4;
              2'b11: Wr_data = MEM_WB_Imm;
          endcase
      end
    
    // handles ecall/ebreak/fence
    always @* begin
        if ({Instruction[20], opcode} == 6'b0_11100)
            PC_en = 0; else PC_en = 1;
     end
//    assign PC_en = ({Instruction[20], opcode} == 6'b1_11100) ? 1'b0 : 1'b1;
    assign PC_next = (Br_taken) ? EX_MEM_Target : ((EX_MEM_Ctrl[7]) ? EX_MEM_ALU_out : PC_4) ;
    
//    always @ (posedge clk or posedge rst) begin
//        if(rst == 1)
//            PC <= 0;
////        else if (PC_en == 0)
////            PC <= PC;
//        else if (!stall)
//            PC <= PC_next; 
//        else begin 
//            if (!(Instruction[`IR_opcode] == 5'b11100 && Instruction[`IR_funct7] == 0)) begin
//                PC_next = (Br_taken) ? EX_MEM_ALU_out : ((EX_MEM_Ctrl[7]) ? EX_MEM_Target : PC_4) ;
////                case (PCSrc)
////                    2'b00: PC_next <= PC_4;
////                    2'b01: PC_next <= EX_MEM_ALU_out;
////                    2'b10: PC_next <= EX_MEM_Target;
////                    default: PC_next <= PC_4;
////                endcase 
////                if(Br_taken) 
////                    PC <= (PC+Immediate)%256;
////                else if(Jump)
////                    PC <= ALU_out;
////                else 
////                    PC <= PC_4;
//            end
//       end   
//    end

endmodule

    
