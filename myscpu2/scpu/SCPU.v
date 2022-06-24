`include "ctrl_encode_def.v"
module SCPU(input wire clk,              // clock
            input wire reset,            // reset
            input wire MIO_ready,
            input wire [31:0] inst_in,   // instruction
            input wire [31:0] Data_in,   // data from data memory
            output wire mem_w,           // output: memory write signal
            output wire[31:0] PC_out,   // PC address
            output wire[31:0] Addr_out, // ALU output
            output wire[31:0] Data_out, // data to data memory
            output [3:0] DMWType,
            output wire CPU_MIO,
            input wire INT
            );
    assign CPU_MIO=0;
    wire        RegWrite;    // control signal to register write
    wire [5:0]  EXTOp;       // control signal to signed extension
    wire [4:0]  ALUOp;       //  ALU opertion
    wire [2:0]  NPCOp;       // next PC operation
    wire [2:0]  DMRType;
    wire [1:0]  WDSel;       // (register) write data selection
    // wire [1:0]  GPRSel;      // general purpose register selection
    
    wire        ALUSrc;      // ALU source for A
    wire        Zero;        // ALU ouput zero
    
    wire [31:0] NPC;         // next PC
    
    wire [4:0]  rs1;          // rs
    wire [4:0]  rs2;          // rt
    wire [4:0]  rd;          // rd
    wire [6:0]  Op;          // opcode
    wire [6:0]  Funct7;       // funct7
    wire [2:0]  Funct3;       // funct3
    wire [11:0] Imm12;       // 12-bit immediate
    wire [31:0] Imm32;       // 32-bit immediate
    wire [19:0] IMM;         // 20-bit immediate (address)
    wire [4:0]  A3;          // register address for write
    reg [31:0] WD;          // register write data
    wire [31:0] RD1,RD2;         // register data specified by rs
    wire [31:0] B;           // operator for ALU B
    
    wire [4:0] iimm_shamt;
    wire [11:0] iimm,simm,bimm;
    wire [19:0] uimm,jimm;
    wire [31:0] immout;
    wire[31:0] aluout;
    assign Addr_out   = aluout;
    assign B          = (ALUSrc) ? immout : RD2;
    assign Data_out   = RD2;
    //assign dmType     = DMType;
    assign iimm_shamt = inst_in[24:20];
    assign iimm       = inst_in[31:20];
    assign simm       = {inst_in[31:25],inst_in[11:7]};
    assign bimm       = {inst_in[31],inst_in[7],inst_in[30:25],inst_in[11:8]};
    assign uimm       = inst_in[31:12];
    assign jimm       = {inst_in[31],inst_in[19:12],inst_in[20],inst_in[30:21]};
    
    assign Op     = inst_in[6:0];  // instruction
    assign Funct7 = inst_in[31:25]; // funct7
    assign Funct3 = inst_in[14:12]; // funct3
    assign rs1    = inst_in[19:15];  // rs1
    assign rs2    = inst_in[24:20];  // rs2
    assign rd     = inst_in[11:7];  // rd
    assign Imm12  = inst_in[31:20];// 12-bit immediate
    assign IMM    = inst_in[31:12];  // 20-bit immediate
    
    // instantiation of control unit
    ctrl U_ctrl(
    .Op(Op), .Funct7(Funct7), .Funct3(Funct3), .Zero(Zero),
    .RegWrite(RegWrite), .MemWrite(mem_w),
    .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp),
    .ALUSrc(ALUSrc), .DMRType(DMRType),.DMWType(DMWType),.WDSel(WDSel)
    );
    // instantiation of pc unit
    PC U_PC(.clk(clk), .rst(reset), .NPC(NPC), .PC(PC_out));
    NPC U_NPC(.PC(PC_out), .NPCOp(NPCOp), .IMM(immout), .NPC(NPC), .aluout(aluout));
    EXT U_EXT(
    .iimm_shamt(iimm_shamt), .iimm(iimm), .simm(simm), .bimm(bimm),
    .uimm(uimm), .jimm(jimm),
    .EXTOp(EXTOp), .immout(immout)
    );
    RF U_RF(
    .clk(clk), .rst(reset),
    .RFWr(RegWrite),
    .A1(rs1), .A2(rs2), .A3(rd),
    .WD(WD),
    .RD1(RD1), .RD2(RD2)
    //.reg_sel(reg_sel),
    //.reg_data(reg_data)
    );
    // instantiation of alu unit
    alu U_alu(.A(RD1), .B(B), .ALUOp(ALUOp), .C(aluout), .Zero(Zero), .PC(PC_out));
    
    //please connnect the CPU by yourself
    always @ (*)
    begin
        case(WDSel)
            `WDSel_FromALU: WD <= aluout;
            `WDSel_FromMEM:
            begin
                case(DMRType)
                    `dm_word:begin
                           WD <= Data_in;
                    end
                    `dm_halfword:begin
                            WD<= {{16{Data_in[15]}},Data_in[15:0]};
                    end
                    `dm_halfword_unsigned:begin
                            WD <= {16'b0,Data_in[15:0]};
                        
                    end
                    `dm_byte:begin
                            WD <= {{24{Data_in[7]}},Data_in[7:0]};
                    end
                    `dm_byte_unsigned:begin
                            WD <= {24'b0,Data_in[7:0]};
                    end
                    default:
                        WD<=Data_in;
                        
                endcase
            end
            `WDSel_FromPC: WD <= PC_out+4;
				default:WD <= aluout;
        endcase
    end
endmodule
