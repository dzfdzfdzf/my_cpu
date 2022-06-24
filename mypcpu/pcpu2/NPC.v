`include "ctrl_encode_def.v"

module NPC(PC,
           hPC,
           NPCOp,
           IMM,
           NPC,
           aluout); // next pc module
    
    input  [31:0] PC;        // pc
    input  [31:0] hPC;       // beq之前的pc
    input  [2:0]  NPCOp;     // next pc operation
    input  [31:0] IMM;       // immediate
    input [31:0] aluout;
    output reg [31:0] NPC;   // next pc
    
    wire [31:0] PCPLUS4;
    
    assign PCPLUS4 = PC + 4; // pc + 4
    
    always @(*) begin
        case (NPCOp)
            `NPC_PLUS4:  begin NPC = PCPLUS4;
            //$display("%h,%h",PC,NPC);
            end
            `NPC_BRANCH:begin
            NPC = hPC+IMM;
            //  $display("%h,%h,%h",PC,hPC,NPC);
            end
            `NPC_JUMP:  begin NPC = hPC+IMM; //$display("%h,%h",PC,NPC);
            end
            `NPC_JALR:	 NPC = aluout;
            default:     NPC = PCPLUS4;
        endcase
        //$display("%h,%h,%h",PC,hPC,NPC);
    end // end always
    
endmodule
