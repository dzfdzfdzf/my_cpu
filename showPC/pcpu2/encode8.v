`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:28:34 06/28/2022 
// Design Name: 
// Module Name:    encode8 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module encode8(
	input[31:0]PC,
	input[31:0]INS,
	input choice,
	output [512:0]OUT,
	output [7:0]ADDR
    );
	 
wire[31:0]PC_temp;
assign PC_temp=PC>>2;
reg[3:0]PC1[7:0];
wire[15:0]out1[7:0];
wire [15:0]out2[7:0];
assign ADDR=68;
encode en1(PC1[0],out1[0]);
encode en2(PC1[1],out1[1]);
encode en3(PC1[2],out1[2]);
encode en4(PC1[3],out1[3]);
encode en5(PC1[4],out1[4]);
encode en6(PC1[5],out1[5]);
encode en7(PC1[6],out1[6]);
encode en8(PC1[7],out1[7]);
encode en9(INS[31:28],out2[0]);
encode en10(INS[27:24],out2[1]);
encode en11(INS[23:20],out2[2]);
encode en12(INS[19:16],out2[3]);
encode en13(INS[15:12],out2[4]);
encode en14(INS[11:8],out2[5]);
encode en15(INS[7:4],out2[6]);
encode en16(INS[3:0],out2[7]);
always@(*)
begin
if(choice==1'b0)
begin
PC1[0]<=PC[31:28];
PC1[1]<=PC[27:24];
PC1[2]<=PC[23:20];
PC1[3]<=PC[19:16];
PC1[4]<=PC[15:12];
PC1[5]<=PC[11:8];
PC1[6]<=PC[7:4];
PC1[7]<=PC[3:0];
end
else 
begin
PC1[0]<=PC_temp[31:28];
PC1[1]<=PC_temp[27:24];
PC1[2]<=PC_temp[23:20];
PC1[3]<=PC_temp[19:16];
PC1[4]<=PC_temp[15:12];
PC1[5]<=PC_temp[11:8];
PC1[6]<=PC_temp[7:4];
PC1[7]<=PC_temp[3:0];
end
end
assign OUT={128'b0,out2[7],out2[6],out2[5],out2[4],out2[3],out2[2],out2[1],out2[0],16'b1111111100111010,16'b1111111101010011,16'b1111111101001110,16'b1111111101001001,16'b0,out1[7],out1[6],out1[5],out1[4],out1[3],out1[2],out1[1],out1[0],16'b1111111100111010,16'b1111111101000011,16'b1111111101010000};
endmodule
