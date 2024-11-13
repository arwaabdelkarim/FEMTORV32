module hazard_detection(input [4:0] IF_ID_Rs1, 
                        input [4:0] IF_ID_Rs2, 
                        input [4:0] ID_EX_Rd, 
                        input ID_EX_MemRead, 
                        input EX_MEM_MemRead, 
                        input EX_MEM_MemWrite,
                        output reg  stall
                        );

                  
always @ (*) 
    begin
        if (EX_MEM_MemRead || EX_MEM_MemWrite)
                stall = 1'b1;
        else
            stall = 1'b0;
//        if( ( ( IF_ID_Rs1 == ID_EX_Rd) || (IF_ID_Rs2 == ID_EX_Rd)) && (ID_EX_MemRead) && (ID_EX_Rd != 0) )
//            stall = 1'b1;
////        else if (EX_MEM_MemRead || EX_MEM_MemWrite)
////                stall = 1'b1;
//        else
//            stall = 1'b0;
    end


endmodule
