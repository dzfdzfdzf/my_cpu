module Hazard_Detection(
    input ID_EX_MemRead,
    input [4:0]ID_EX_rd,
    input [4:0]IF_ID_rs1,
    input [4:0]IF_ID_rs2,
    input  EX_MEM_MemRead,
    input  [4:0]EX_MEM_rd,
    input ID_EX_RegWrite,
    input [2:0]NPCOp_temp,
    output reg PC_write,
    output reg write_enable1,
    output reg write_enable2,
    output reg flush1,
    output reg flush2
);
  always @(*) begin
    if(NPCOp_temp==3'b000&&ID_EX_MemRead&&((ID_EX_rd==IF_ID_rs1)||(ID_EX_rd==IF_ID_rs2)))
    begin
        PC_write<=0;
        write_enable1<=0;
        write_enable2<=1;
        flush2<=1;
        flush1<=0;
    end
    else if(NPCOp_temp==3'b000&&EX_MEM_MemRead&&((EX_MEM_rd==IF_ID_rs1)||(EX_MEM_rd==IF_ID_rs2)))
    begin
        PC_write<=0;
        write_enable1<=0;
        write_enable2<=1;
        flush2<=1;
        flush1<=0;
    end
     else if(NPCOp_temp==3'b000&&ID_EX_RegWrite&&ID_EX_rd&&(ID_EX_rd==IF_ID_rs1||ID_EX_rd==IF_ID_rs2))
     begin 
        //$display(ID_EX_rd);
        PC_write<=0;
        write_enable1<=0;
        write_enable2<=1;
        flush2<=1;
        flush1<=0;
    end
    else
    begin
        PC_write<=1;
        write_enable1<=1;
        write_enable2<=1;
        flush1<=0;
        flush2<=0;
    end
  end
endmodule