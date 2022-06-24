`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:33 06/20/2022 
// Design Name: 
// Module Name:    addbit 
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
module addbit(
input a,
input b,
input c,
output s,
output co
    );
wire s1,c1,c2,c3;
and (c1,a,b),(c2,b,c),(c3,a,c);
xor(s1,a,b),(s,s1,c);
or(co,c1,c2,c3);

endmodule
