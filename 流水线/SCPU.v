`include "ctrl_encode_def.v"
module SCPU(
    input      clk,            // clock
    input      reset,          // reset
    input [31:0]  inst_in,     // instruction
    input [31:0]  Data_in,     // data from data memory
   
    output    mem_w,          // output: memory write signal
    output [31:0] PC_out,     // PC address
      // memory write
    output [31:0] Addr_out,   // ALU output
    output [31:0] Data_out,// data to data memory
    //output        MEM_Read;
    input  [4:0] reg_sel,    // register selection (for debug use)
    output [31:0] reg_data,  // selected register data (for debug use)
    output [2:0] dmType
);
    wire        MemWrite;
    wire        RegWrite;    // control signal to register write
    wire [5:0]  EXTOp;       // control signal to signed extension
    wire [4:0]  ALUOp;       // ALU opertion
    wire [2:0]  NPCOp;       // next PC operation
    wire [2:0]  NPCOp_temp;
    wire [2:0]  DMType;
    wire [1:0]  WDSel;       // (register) write data selection
    // wire [1:0]  GPRSel;      // general purpose register selection
    wire        MEMRead;
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
    assign Addr_out=out3[68:37];
    assign Data_out=out3[36:5];
    assign dmType=out3[71:69];
    assign mem_w=out3[72:72];
	//assign dmType=DMType;
	// assign iimm_shamt=inst_in[24:20];
	// assign iimm=inst_in[31:20];
	// assign simm={inst_in[31:25],inst_in[11:7]};
	// assign bimm={inst_in[31],inst_in[7],inst_in[30:25],inst_in[11:8]};
	// assign uimm=inst_in[31:12];
	// assign jimm={inst_in[31],inst_in[19:12],inst_in[20],inst_in[30:21]}; 
    // assign Op = inst_in[6:0];  // instruction
    // assign Funct7 = inst_in[31:25]; // funct7
    // assign Funct3 = inst_in[14:12]; // funct3
    // assign rs1 = inst_in[19:15];  // rs1
    // assign rs2 = inst_in[24:20];  // rs2
    // assign rd = inst_in[11:7];  // rd
    // assign Imm12 = inst_in[31:20];// 12-bit immediate
    // assign IMM = inst_in[31:12];  // 20-bit immediate

    //IF/ID
    assign in1={136'b0,PC_out,inst_in};
    assign rs1 = out1[19:15];  // rs1
    assign rs2 = out1[24:20];  // rs2
    assign rd = out1[11:7];  // rd
    assign iimm_shamt=out1[24:20];
	assign iimm=out1[31:20];
	assign simm={out1[31:25],out1[11:7]};
	assign bimm={out1[31],out1[7],out1[30:25],out1[11:8]};
	assign uimm=out1[31:12];
	assign jimm={out1[31],out1[19:12],out1[20],out1[30:21]}; 
    assign Op = out1[6:0];  // instruction
    assign Funct7 = out1[31:25]; // funct7
    assign Funct3 = out1[14:12]; // funct3
    assign Imm12 = out1[31:20];// 12-bit immediate
    assign IMM = out1[31:12];  // 20-bit immediate

    //ID/EX
    assign in2={50'b0,MEMRead,WDSel,RegWrite,MemWrite,NPCOp,DMType,ALUSrc,ALUOp,out1[63:32],RD1,RD2,immout,rd};   
    //                 1       2      1         1       3     3      1     5         32PC    32  32   32    5
    assign B = (out2[138:138]) ? out2[36:5] : out2[68:37];
    assign NPCOp_temp=((out2[144:142]==3'b001)&&(!Zero))? 3'b000 : out2[144:142];
    //EX/MEM
    //assign in3=[122'b0,out2[146:146],out2[145:145],out2[144:142],out2[141:139],Zero,aluout,out2[68:37],out2[4:0]];
    //RegWrite,MemWrite,NPCOp,DMType,zero,aluout,Rd2,rd
    //1         1        3     3     1      32   32  5
    assign in3={91'b0,out2[149:149],out2[132:101],out2[148:147],out2[146:146],out2[145:145],out2[141:139],aluout,out2[68:37],out2[4:0]};
                      //MEMRead        pc,             WDSel,      RegWrite,      MemWrite,     DMType,    aluout,  Rd2,        rd
                      //1              32               2              1              1            3          32     32          5
    assign in4={96'b0,out3[107:76],out3[75:74],out3[73:73],Data_in,out3[68:37],out3[4:0]};
                         //pc          WDSel      RegWrite,  Data_in, aluout,       rd
                        //32            2              1        32     32         5

   // instantiation of control unit
	ctrl U_ctrl(
		.Op(Op), .Funct7(Funct7), .Funct3(Funct3), //.Zero(Zero), 
		.RegWrite(RegWrite), .MemWrite(MemWrite),
		.EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), 
		.ALUSrc(ALUSrc), .DMType(DMType),//,.GPRSel(GPRSel), 
        .WDSel(WDSel),.MEMRead(MEMRead)
	);
 // instantiation of pc unit
	PC U_PC(.clk(clk), .rst(reset), .NPC(NPC), .PC_write(PC_write), .PC(PC_out) );
	NPC U_NPC(.PC(PC_out),.hPC(out2[132:101]),.NPCOp(NPCOp_temp), .IMM(out2[36:5]), .NPC(NPC), .aluout(aluout));
	EXT U_EXT(
		.iimm_shamt(iimm_shamt), .iimm(iimm), .simm(simm), .bimm(bimm),
		.uimm(uimm), .jimm(jimm),
		.EXTOp(EXTOp), .immout(immout)
	);
	RF U_RF(
		.clk(clk), .rst(reset),
		.RFWr(out4[69:69]), 
		.A1(rs1), .A2(rs2), .A3(out4[4:0]), 
		.WD(WD), 
		.RD1(RD1), .RD2(RD2)
		//.reg_sel(reg_sel),
		//.reg_data(reg_data)
	);
// instantiation of alu unit
	alu U_alu(.A(out2[100:69]), .B(B), .ALUOp(out2[137:133]), .C(aluout), .Zero(Zero), .PC(out2[132:101]));
// gre_array
    GRE_array  IF_ID(clk,reset,write_enable1,flush1,in1,out1);
    GRE_array  ID_EX(clk,reset,write_enable2,flush2,in2,out2);
    GRE_array  EX_MEM(clk,reset,write_enable3,flush3,in3,out3);
    GRE_array  MEM_WB(clk,reset,write_enable4,flush4,in4,out4);

//please connnect the CPU by yourself
// always @(*)begin 
//     if(NPCOp_temp!=3'b000)
//     $display(PC_out,out1[63:32],out2[132:101],NPC);

//  end
always @ (*)
begin
	case(out4[71:70])
		`WDSel_FromALU: WD<=out4[36:5];
		`WDSel_FromMEM: WD<=out4[68:37];
		`WDSel_FromPC: WD<=out4[103:72]+4;
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
    else if((out2[146:146]&&out2[4:0]&&(out2[4:0]==rs1||out2[4:0]==rs2))
    ||(out3[73:73]&&out3[4:0]&&(out3[4:0]==rs1||out3[4:0]==rs2))
    ||(out2[149:149]&&out2[4:0]&&(out2[4:0]==rs1||out2[4:0]==rs2)))
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
