`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:45:59 06/27/2022 
// Design Name: 
// Module Name:    SCORE_ctrl 
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
module SCORE_ctrl(
	input clk,
	input rst,
	input [31:0]din,
	input [31:0]Addr,
	output [31:0]score
    );

reg [31:0] temp;
  always @(posedge clk, posedge rst)
    if (rst) begin    //  reset
      temp<=32'b0;
    end
      
    else 
      if (Addr[31:28]==4'b1100) begin
        temp<=din;
      end
   assign score=temp; 
endmodule
