`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:17:59 06/28/2022 
// Design Name: 
// Module Name:    encode 
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
module encode(
		input [3:0]in,
		output reg[15:0]out
    );
wire[3:0]temp;
assign temp=in-9;
always@(*)
begin
if(in<=9)
begin
out<={12'b111111110011,in};
end
else
begin
out<={12'b111111110100,temp};
end
end
endmodule
