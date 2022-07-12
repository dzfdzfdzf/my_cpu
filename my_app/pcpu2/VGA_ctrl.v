`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:27:35 06/25/2022 
// Design Name: 
// Module Name:    VGA_ctrl 
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
module VGA_ctrl(
	input clk,
	input rst,
	output hs,
	output vs,
	output [3:0] red,
	output [3:0] green,
	output [3:0] blue,
	input [31:0] color,
	//output [9:0] x_ptr,
	//output [9:0] y_ptr,
	output reg[13:0] addrb
	//output valid
    );
	 wire[9:0]x_ptr;
	 wire[9:0]y_ptr;
	 wire valid;
   reg [9:0] cnt_x;
	reg [9:0] cnt_y;
	reg  judge;
	always @*begin 
	     if(color == 32'hffff0000)
		  judge <= 1;
	end
	
	always  @* begin
	     if(judge == 0)
		  addrb <= valid ? (14'd2048 + {1'b0,y_ptr[9:3], 6'b0} + {3'b0, y_ptr[9:3], 4'b0} + {7'b0, x_ptr[9:3]}) : 14'b0;
		  else 
		  addrb <= valid ? (14'd6848 + {1'b0,y_ptr[9:3], 6'b0} + {3'b0, y_ptr[9:3], 4'b0} + {7'b0, x_ptr[9:3]}) : 14'b0;
	end
	
	always @(posedge clk) begin
		if (rst) cnt_x <= 0; 
		else if (cnt_x == 10'd799) cnt_x <= 0;
		else cnt_x <= cnt_x + 1;
	end
	
	always @(posedge clk) begin
		if (rst) cnt_y <= 0;
		else if(cnt_x == 10'd799) begin
			if (cnt_y == 10'd524) cnt_y <= 0;
			else cnt_y <= cnt_y+1;
		end
	end
	
	assign hs = !((cnt_x >= 0) && (cnt_x < 96));
	assign vs = !((cnt_y >= 0) && (cnt_y < 2));
	assign valid = (cnt_x >= 96+40+8) && (cnt_x < 96+40+8+640) && (cnt_y >= 2+25+8) && (cnt_y < 2+25+8+480);

	assign red = valid ? color[11:8] : 0;
	assign green = valid ? color[7:4] : 0;
	assign blue = valid ? color[3:0] : 0;
	assign x_ptr = cnt_x - (96+40+8);
	assign y_ptr = cnt_y - (2+25+8);

	


endmodule
