module PC(clk,
          rst,
          NPC,
          PC,
          PC_write);
    
    input              clk;
    input              rst;
    input       [31:0] NPC;
    input              PC_write;
    output reg  [31:0] PC;

    always @(posedge clk, posedge rst)
        if (rst)
            PC <= 32'h0000_0000;
            //      PC <= 32'h0000_3000;
        else if(PC_write)
            PC <= NPC;
//    always @(*) begin
//         $display("%h,%h",NPC,PC);
//    end    
    
endmodule
    
