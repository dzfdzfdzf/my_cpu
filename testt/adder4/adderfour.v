`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:37 06/20/2022 
// Design Name: 
// Module Name:    adderfour 
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
module adderfour(
		input[size-1:0]a,
		input[size-1:0]b,
		input ci,
		output[size-1:0]s,
		output co
    );
	 parameter size=4;
	 wire[2:0]ct;
	 addbit a1(.a(a[0]),.b(b[0]),.c(ci),.s(s[0]),.co(ct[0])),
	  a2(.a(a[1]),.b(b[1]),.c(ct[0]),.s(s[1]),.co(ct[1])),
	  a3(.a(a[2]),.b(b[2]),.c(ct[1]),.s(s[2]),.co(ct[2])),
	  a4(.a(a[3]),.b(b[3]),.c(ct[2]),.s(s[3]),.co(co));
	 


endmodule
