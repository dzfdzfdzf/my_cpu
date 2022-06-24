module GRE_array (
    input Clk,Rst,write_enable,flush,
    input[0:200-1] in,
    output reg [0:200-1] out
);
    always @(negedge Clk) 
    begin
    if(write_enable)
        begin
            if(flush)
                out=0;
            else
                out=in;
        end
    end
    always@(*)
    begin
        if(Rst)
         begin
            out=0;
        end
    end

endmodule 