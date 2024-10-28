/******************************************************************************* 
* 
* SIM: CPU_tb.v 
* Project: Arch_proj1 
* Author: Arwa Abdelkarim arwaabdelkarim@aucegypt.edu
          Farida Bey      farida.bey@aucegypt.edu
          
* Description: The CPU_tb module is a testbench for testing and simulating the 
               CPU model.

* Change history: 28/10/2024 Created module in the LAB 
******************************************************************************/
module CPU_tb();
    localparam period = 10;
    reg clk;
    reg rst;

    
    CPU  dut(.clk(clk),.rst(rst));
    
    initial begin
        clk =1'b0;
        forever #(period/10) clk = ~clk;
    end
    
    initial begin
        rst =1;
        #(period);
        rst =0;
        #500
        $finish;
        
    end

endmodule