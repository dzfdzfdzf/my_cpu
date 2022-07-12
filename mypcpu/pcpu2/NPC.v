`include "ctrl_encode_def.v"

module NPC(PC,
           hPC,
           NPCOp,
           IMM,
           NPC,
           aluout); // next pc module
    
    input  [31:0] PC;        // pc
    input  [31:0] hPC;       // 控制冒险对应的PC(即EX阶段的PC)
    input  [2:0]  NPCOp;     // next pc operation
    input  [31:0] IMM;       // immediate
    input [31:0] aluout;
    output reg [31:0] NPC;   // next pc
    
    wire [31:0] PCPLUS4;
    
    assign PCPLUS4 = PC + 4; // pc + 4
    
    always @(*) begin
        case (NPCOp)
            `NPC_PLUS4: NPC = PCPLUS4;
            `NPC_BRANCH:NPC = hPC+IMM;
            `NPC_JUMP:  NPC = hPC+IMM; 
            `NPC_JALR:	 NPC = aluout;
            default:     NPC = PCPLUS4;
        endcase

    end 
    
endmodule
