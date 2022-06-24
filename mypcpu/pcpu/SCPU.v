`include "ctrl_encode_def.v"
module SCPU(
    input      clk,            // clock
    input      reset,          // reset
    input [31:0]  inst_in,     // instruction
    input [31:0]  Data_in,     // data from data memory
    input  MIO_ready,
    output    mem_w,          // output: memory write signal
    output [31:0] PC_out,     // PC address
      // memory write
    output [31:0] Addr_out,   // ALU output
    output [31:0] Data_out,// data to data memory
    //output        MEM_Read;
    output [3:0] DMWType,
    output wire CPU_MIO,
    input wire INT
);
    assign CPU_MIO=0;
    wire        MemWrite;
    wire        RegWrite;    // control signal to register write
    wire [5:0]  EXTOp;       // control signal to signed extension
    wire [4:0]  ALUOp;       // ALU opertion
    wire [2:0]  NPCOp;       // next PC operation
    wire [2:0]  NPCOp_temp;
    wire [2:0]  DMRType;
    wire [1:0]  WDSel;       // (register) write data selection
    // wire [1:0]  GPRSel;      // general purpose register selection
    wire        MEMRead;
    wire        ALUSrc;      // ALU source for A
    wire        Zero;        // ALU ouput zero

    wire [31:0] NPC;         // next PC

    wire[31:0] IF_ID_PC;
    wire [4:0]  IF_ID_rs1;          // rs
    wire [4:0]  IF_ID_rs2;          // rt
    wire [4:0]  IF_ID_rd;          // rd
    wire [6:0]  IF_ID_Op;          // opcode
    wire [6:0]  IF_ID_Funct7;       // funct7
    wire [2:0]  IF_ID_Funct3;       // funct3
    wire [4:0] IF_ID_iimm_shamt;
	wire [11:0] IF_ID_iimm,IF_ID_simm,IF_ID_bimm;
	wire [19:0] IF_ID_uimm,IF_ID_jimm;
    wire [3:0] IF_ID_DMWType;
    // wire [11:0] IF_ID_Imm12;       // 12-bit immediate
    // wire [31:0] IF_ID_Imm32;       // 32-bit immediate
    // wire [19:0] IF_ID_IMM;         // 20-bit immediate (address)
    
    
    wire [4:0]  A3;          // register address for write
    reg [31:0] WD;          // register write data
    wire [31:0] RD1,RD2;         // register data specified by rs
    wire [31:0] B;           // operator for ALU B
	
	

     wire[4:0] ID_EX_rd;
    wire[31:0]ID_EX_immout;
    wire [31:0]ID_EX_RD1;
    wire [31:0]ID_EX_RD2;
    wire [31:0]ID_EX_PC;
    wire[4:0]ID_EX_ALUOp;
    wire ID_EX_ALUSrc;
    wire [2:0]ID_EX_DMRType;
    wire [2:0]ID_EX_NPCOp;
    wire ID_EX_MemWrite;
    wire ID_EX_RegWrite;
    wire[1:0]ID_EX_WDSel;
    wire ID_EX_MemRead;
    wire[3:0]ID_EX_DMWType;

    wire [4:0]EX_MEM_rd;
    wire [31:0]EX_MEM_RD2;
    wire[31:0]EX_MEM_aluout;
    wire[2:0]EX_MEM_DMRType;
    wire EX_MEM_MemWrite;
    wire EX_MEM_RegWrite;
    wire [1:0]EX_MEM_WDSel;
    wire[31:0]EX_MEM_PC;
    wire EX_MEM_MemRead;
    wire [3:0]EX_MEM_DMWType;

   wire [4:0]MEM_WB_rd;
   wire [31:0]MEM_WB_aluoout;
   wire [31:0]MEM_WB_Data_in;
   wire  MEM_WB_RegWrite;
   wire  [1:0]MEM_WB_WDSel;
   wire[31:0]MEM_WB_PC;
    wire[2:0]MEM_WB_DMRType;

	wire [31:0] immout;
    wire[31:0] aluout;
    reg write_enable1,write_enable2,write_enable3,write_enable4;
    reg flush1,flush2,flush3,flush4;
    wire[199:0]in1;
    wire[199:0]in2;
    wire[199:0]in3;
    wire[199:0]in4;
    wire[199:0]out1;
    wire[199:0]out2;
    wire[199:0]out3;
    wire[199:0]out4;
    reg PC_write;
    //assign Addr_out=aluout;
	// assign B = (ALUSrc) ? immout : RD2;
	//assign Data_out = RD2;
    assign Addr_out=EX_MEM_aluout;
    assign Data_out=EX_MEM_RD2;
    assign DMWType= EX_MEM_DMWType;
    assign mem_w=EX_MEM_MemWrite;
	//assign dmType=DMType;
    //IF/ID
    assign in1={136'b0,PC_out,inst_in};
    assign IF_ID_rs1 = out1[19:15];  // rs1
    assign IF_ID_rs2 = out1[24:20];  // rs2
    assign IF_ID_rd = out1[11:7];  // rd
    assign IF_ID_iimm_shamt=out1[24:20];
	assign IF_ID_iimm=out1[31:20];
	assign IF_ID_simm={out1[31:25],out1[11:7]};
	assign IF_ID_bimm={out1[31],out1[7],out1[30:25],out1[11:8]};
	assign IF_ID_uimm=out1[31:12];
	assign IF_ID_jimm={out1[31],out1[19:12],out1[20],out1[30:21]}; 
    assign IF_ID_Op = out1[6:0];  // instruction
    assign IF_ID_Funct7 = out1[31:25]; // funct7
    assign IF_ID_Funct3 = out1[14:12]; // funct3
    assign IF_ID_PC=out1[63:32];
    // assign IF_ID_Imm12 = out1[31:20];// 12-bit immediate
    // assign IF_ID_IMM = out1[31:12];  // 20-bit immediate

    //ID/EX
   
    assign in2={46'b0,IF_ID_DMWType,MEMRead,WDSel,RegWrite,MemWrite,NPCOp,DMRType,ALUSrc,ALUOp,IF_ID_PC,RD1,RD2,immout,IF_ID_rd};   
    //                      4          1       2      1         1       3     3      1     5     32PC    32  32    32     5
    assign ID_EX_rd=out2[4:0];
    assign ID_EX_immout=out2[36:5];
    assign ID_EX_RD2=out2[68:37];
    assign ID_EX_RD1=out2[100:69];
    assign ID_EX_PC=out2[132:101];
    assign ID_EX_ALUOp=out2[137:133];
    assign ID_EX_ALUSrc=out2[138:138];
    assign ID_EX_DMRType=out2[141:139];
    assign ID_EX_NPCOp=out2[144:142];
    assign ID_EX_MemWrite=out2[145:145];
    assign ID_EX_RegWrite=out2[146:146];
    assign ID_EX_WDSel=out2[148:147];
    assign ID_EX_MemRead=out2[149:149];
    assign ID_EX_DMWType=out2[153:150];
    assign B = (ID_EX_ALUSrc) ? ID_EX_immout : ID_EX_RD2;
    assign NPCOp_temp=((ID_EX_NPCOp==3'b001)&&(!Zero))? 3'b000 : ID_EX_NPCOp;
  
   
    assign in3={87'b0,ID_EX_DMWType,ID_EX_MemRead,ID_EX_PC,ID_EX_WDSel,ID_EX_RegWrite,ID_EX_MemWrite,ID_EX_DMRType,aluout,ID_EX_RD2,ID_EX_rd};
                      //  DMWType    MEMRead        pc,        WDSel,   RegWrite,      MemWrite,     DMType,     aluout,  Rd2,        rd
                      //    4          1              32          2           1              1            3           32     32          5
    assign EX_MEM_rd=out3[4:0];
    assign EX_MEM_RD2=out3[36:5];
    assign EX_MEM_aluout=out3[68:37];
    assign EX_MEM_DMRType=out3[71:69];
    assign EX_MEM_MemWrite=out3[72:72];
    assign EX_MEM_RegWrite=out3[73:73];
    assign EX_MEM_WDSel=out3[75:74];
    assign EX_MEM_PC=out3[107:76];
    assign EX_MEM_MemRead=out3[108:108];
    assign EX_MEM_DMWType=out3[112:109];
  
    assign in4={93'b0,EX_MEM_DMRType,EX_MEM_PC,EX_MEM_WDSel,EX_MEM_RegWrite,Data_in,EX_MEM_aluout,EX_MEM_rd};
                        // DMRTYPE      pc        WDSel      RegWrite,     Data_in,    aluout,       rd
                        //    3         32          2              1           32        32            5
    assign MEM_WB_rd=out4[4:0];
    assign MEM_WB_aluoout=out4[36:5];
    assign MEM_WB_Data_in=out4[68:37];
    assign MEM_WB_RegWrite=out4[69:69];
    assign MEM_WB_WDSel=out4[71:70];
    assign MEM_WB_PC=out4[103:72];
    assign MEM_WB_DMRType=out4[106:104];
   // instantiation of control unit
	ctrl U_ctrl(
		.Op(IF_ID_Op), .Funct7(IF_ID_Funct7), .Funct3(IF_ID_Funct3), //.Zero(Zero), 
		.RegWrite(RegWrite), .MemWrite(MemWrite),
		.EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), 
		.ALUSrc(ALUSrc), .DMRType(DMRType),.DMWType(IF_ID_DMWType),//,.GPRSel(GPRSel), 
        .WDSel(WDSel),.MEMRead(MEMRead)
	);
 // instantiation of pc unit
	PC U_PC(.clk(clk), .rst(reset), .NPC(NPC), .PC_write(PC_write), .PC(PC_out) );
	NPC U_NPC(.PC(PC_out),.hPC(ID_EX_PC),.NPCOp(NPCOp_temp), .IMM(ID_EX_immout), .NPC(NPC), .aluout(aluout));
	EXT U_EXT(
		.iimm_shamt(IF_ID_iimm_shamt), .iimm(IF_ID_iimm), .simm(IF_ID_simm), .bimm(IF_ID_bimm),
		.uimm(IF_ID_uimm), .jimm(IF_ID_jimm),
		.EXTOp(EXTOp), .immout(immout)
	);
	RF U_RF(
		.clk(clk), .rst(reset),
		.RFWr(MEM_WB_RegWrite), 
		.A1(IF_ID_rs1), .A2(IF_ID_rs2), .A3(MEM_WB_rd), 
		.WD(WD), 
		.RD1(RD1), .RD2(RD2)
	);
// instantiation of alu unit
	alu U_alu(.A(ID_EX_RD1), .B(B), .ALUOp(ID_EX_ALUOp), .C(aluout), .Zero(Zero), .PC(ID_EX_PC));
// gre_array
    GRE_array  IF_ID(clk,reset,write_enable1,flush1,in1,out1);
    GRE_array  ID_EX(clk,reset,write_enable2,flush2,in2,out2);
    GRE_array  EX_MEM(clk,reset,write_enable3,flush3,in3,out3);
    GRE_array  MEM_WB(clk,reset,write_enable4,flush4,in4,out4);

//please connnect the CPU by yourself
// always @(*)begin 
//     if(NPCOp_temp!=3'b000)
//     $display(PC_out,out1[63:32],ID_EX_PC,NPC);

//  end
always @ (*)
begin
	case( MEM_WB_WDSel)
		`WDSel_FromALU: WD<=MEM_WB_aluoout;
		`WDSel_FromMEM: 
        begin
            case(MEM_WB_DMRType)
                    `dm_word:begin
                           WD <=MEM_WB_Data_in;
                    end
                    `dm_halfword:begin
                            WD<= {{16{MEM_WB_Data_in[15]}},MEM_WB_Data_in[15:0]};
                    end
                    `dm_halfword_unsigned:begin
                            WD <= {16'b0,MEM_WB_Data_in[15:0]};
                        
                    end
                    `dm_byte:begin
                            WD <= {{24{MEM_WB_Data_in[7]}},MEM_WB_Data_in[7:0]};
                    end
                    `dm_byte_unsigned:begin
                            WD <= {24'b0,MEM_WB_Data_in[7:0]};
                    end
                    default:
                        WD<=MEM_WB_Data_in;
        endcase
        end
        `WDSel_FromPC: WD<=MEM_WB_PC+4;
        default:WD<=MEM_WB_aluoout;
	endcase
end
//TODO:Regread？
always @(*)
begin
    if(NPCOp_temp==3'b001||NPCOp_temp==3'b010||NPCOp_temp==3'b100) 
    begin
        flush2<=1;
        write_enable2<=1;
        write_enable1<=1;
        PC_write<=1;
        write_enable3<=1;
        write_enable4<=1;
        flush1<=0;
        flush3<=0;
        flush4<=0;
    end
    else if((ID_EX_RegWrite&&ID_EX_rd&&(ID_EX_rd==IF_ID_rs1||ID_EX_rd==IF_ID_rs2))
    ||(EX_MEM_RegWrite&&EX_MEM_rd&&(EX_MEM_rd==IF_ID_rs1||EX_MEM_rd==IF_ID_rs2))
    ||(ID_EX_MemRead&&ID_EX_rd&&(ID_EX_rd==IF_ID_rs1||ID_EX_rd==IF_ID_rs2)))
    begin
        flush2<=1;
        write_enable2<=1;
        write_enable1<=0;
        PC_write<=0;
        write_enable3<=1;
        write_enable4<=1;
        flush1<=0;
        flush3<=0;
        flush4<=0;
    end
    else
    begin
        flush2<=0;
        write_enable2<=1;
        write_enable1<=1;
        PC_write<=1;
        write_enable3<=1;
        write_enable4<=1;
        flush1<=0;
        flush3<=0;
        flush4<=0;
    end
    
end
endmodule
