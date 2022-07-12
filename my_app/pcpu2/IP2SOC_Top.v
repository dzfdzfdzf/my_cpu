`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:50:42 06/22/2022 
// Design Name: 
// Module Name:    IP2SOC_Top 
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
module IP2SOC_Top(
		input RSTN,
		input[3:0] BTN_y,
		input[15:0] SW,
		input clk_100mhz,
		output CR,
		output seg_clk,
		output seg_sout,
		output SEG_PEN,
		output seg_clrn,
		output led_clk,
		output led_sout,
		output LED_PEN,
		output led_clrn,
		output RDY,
		output readn,
		output [4:0] BTN_x,
		output[3:0]Red, 
		output[3:0]Green, 
		output[3:0]Blue,
		output HSYNC, VSYNC
    );
wire [4:0] U9_Key_out;
wire [3:0] U9_pulse_out;
wire [3:0] U9_BTN_OK;
wire [15:0] U9_SW_OK;
wire U9_rst; 

wire [4:0] M4_Ctrl;
wire [31:0]M4_Ai;
wire [31:0]M4_Bi;
wire [7:0]M4_blink;
assign M4_Ctrl={U9_SW_OK[7:5],U9_SW_OK[15],U9_SW_OK[0]};

wire [31:0] U8_clkdiv;
wire U8_Clk_CPU;

wire U1_MIO_ready;
wire U1_mem_w;
wire [31:0]U1_PC_out;
wire [31:0]U1_Addr_out;
wire[31:0]U1_Data_out;
wire U1_CPU_MIO;
wire [3:0]U1_DMWType;
reg [31:0]U1_Datain;

wire [31:0]U2_spo;

wire [31:0]U3_douta;

wire [31:0]U4_Cpu_data4bus;
wire [31:0]U4_ram_data_in;
wire[9:0]U4_ram_addr;
wire U4_data_ram_we;
wire U4_GPIOf0000000_we;
wire U4_GPIOe0000000_we;
wire U4_counter_we;
wire [31:0]U4_Peripheral_in; 

wire U10_counter0_OUT,U10_counter1_OUT,U10_counter2_OUT;
wire [31:0]U10_counter_out;

wire[1:0] U7_counter_set;
wire[15:0]U7_LED_out;       
wire[13:0] U7_GPIOf0;

wire[63:0]U5_point_in;
//wire[31:0] U5_data1;
//assign U5_data1={1'b0,1'b0,U1_PC_out[31:2]};
wire [31:0]U5_data1;
assign U5_point_in={U8_clkdiv[31:0],U8_clkdiv[31:0]};
wire [7:0]U5_point_out;
wire [7:0]U5_LE_out;
wire [31:0]U5_Disp_num;
wire[18:0] U11_addr;
//wire[11:0]U11_pixel=12'b111100001111;
wire[11:0]U11_pixel;
reg U12_wea;
reg[11:0]U12_dina;
reg[18:0]U12_addra;
SAnti_jitter U9(.RSTN(RSTN),.clk(clk_100mhz),.Key_y(BTN_y),.Key_x(BTN_x),.SW(SW),.Key_out(U9_Key_out),.Key_ready(RDY)
,.pulse_out(U9_pulse_out),.BTN_OK(U9_BTN_OK),.SW_OK(U9_SW_OK),.readn(readn),.CR(CR),.rst(U9_rst));


SEnter_2_32 M4(.clk(clk_100mhz),.BTN(U9_BTN_OK[2:0]),.Ctrl(M4_Ctrl),.D_ready(RDY),.Din(U9_Key_out),.readn(readn),.Ai(M4_Ai),.Bi(M4_Bi),.blink(M4_blink));


//clk_div U8(.clk(clk_100mhz),.rst(U9_rst),.SW2(U9_SW_OK[2]),.clkdiv(U8_clkdiv),.Clk_CPU(U8_Clk_CPU));
clk_div U8(.clk(clk_100mhz),.rst(U9_rst),.SW2(1'b1),.clkdiv(U8_clkdiv),.Clk_CPU(U8_Clk_CPU));

//SSeg7_Dev U6(.clk(clk_100mhz),.rst(U9_rst),.Start(U8_clkdiv[20]),.SW0(U9_SW_OK[0]),.flash(U8_clkdiv[25])
//,.Hexs(U5_Disp_num),.point(U5_point_out),.LES(U5_LE_out),.seg_clk(seg_clk),.seg_sout(seg_sout),.SEG_PEN(SEG_PEN),.seg_clrn(seg_clrn));
SSeg7_Dev U6(.clk(clk_100mhz),.rst(U9_rst),.Start(U8_clkdiv[20]),.SW0(1'b1),.flash(U8_clkdiv[25])
,.Hexs(U5_Disp_num),.point(U5_point_out),.LES(U5_LE_out),.seg_clk(seg_clk),.seg_sout(seg_sout),.SEG_PEN(SEG_PEN),.seg_clrn(seg_clrn));


//SCPU U1(.clk(U8_Clk_CPU),.reset(U9_rst),.MIO_ready(U1_MIO_ready),.inst_in(U2_spo),.Data_in(U4_Cpu_data4bus),.mem_w(U1_mem_w)
//,.DMWType(U1_DMWType),.PC_out(U1_PC_out),.Addr_out(U1_Addr_out),.Data_out(U1_Data_out),.CPU_MIO(U1_CPU_MIO),.INT(U10_counter0_OUT));

SCPU U1(.clk(U8_Clk_CPU),.reset(U9_rst),.MIO_ready(U1_MIO_ready),.inst_in(U2_spo),.Data_in(U1_Datain),.mem_w(U1_mem_w)
,.DMWType(U1_DMWType),.PC_out(U1_PC_out),.Addr_out(U1_Addr_out),.Data_out(U1_Data_out),.CPU_MIO(U1_CPU_MIO),.INT(U10_counter0_OUT));

ROM_B U2(.a(U1_PC_out[11:2]),.spo(U2_spo));


RAM_B U3(.addra(U4_ram_addr),.wea(U1_DMWType),.dina(U4_ram_data_in),.clka(~clk_100mhz),.douta(U3_douta));


MIO_BUS U4(.clk(clk_100mhz),.rst(U9_rst),.BTN(U9_BTN_OK),.SW(U9_SW_OK),.mem_w(U1_mem_w)
,.Cpu_data2bus(U1_Data_out),.addr_bus(U1_Addr_out),.ram_data_out(U3_douta),.led_out(U7_LED_out),.counter_out(U10_counter_out),
.counter0_out(U10_counter0_OUT),.counter1_out(U10_counter1_OUT),.counter2_out(U10_counter2_OUT),.Cpu_data4bus(U4_Cpu_data4bus),.ram_data_in(U4_ram_data_in)
,.ram_addr(U4_ram_addr),.data_ram_we(U4_data_ram_we),.GPIOf0000000_we(U4_GPIOf0000000_we)
,.GPIOe0000000_we(U4_GPIOe0000000_we),.counter_we(U4_counter_we),.Peripheral_in(U4_Peripheral_in));

Counter_x U10(.clk(~U8_Clk_CPU),.rst(U9_rst),.clk0(U8_clkdiv[6]),.clk1(U8_clkdiv[9]),.clk2(U8_clkdiv[11])
,.counter_we(U4_counter_we),.counter_val(U4_Peripheral_in),.counter_ch(U7_counter_set),.counter0_OUT(U10_counter0_OUT)
,.counter1_OUT(U10_counter1_OUT),.counter2_OUT(U10_counter2_OUT),.counter_out(U10_counter_out));

			
SPIO U7(.clk(~U8_Clk_CPU),.rst(U9_rst),.Start(U8_clkdiv[20]),.EN(U4_GPIOf0000000_we),.P_Data(U4_Peripheral_in),.counter_set(U7_counter_set)
,.LED_out(U7_LED_out),.led_clk(led_clk),.led_sout(led_sout),.led_clrn(led_clrn),.LED_PEN(LED_PEN),.GPIOf0(U7_GPIOf0));


//Multi_8CH32 U5(.clk(~U8_Clk_CPU),.rst(U9_rst),.EN(U4_GPIOe0000000_we),.Test(U9_SW_OK[7:5]),.point_in(U5_point_in),.LES({64{1'b0}})
//,.Data0(U4_Peripheral_in),.data1(U5_data1),.data2(U2_spo),.data3(U10_counter_out),.data4(U1_Addr_out),.data5(U1_Data_out)
//,.data6(U4_Cpu_data4bus),.data7(U1_PC_out),.point_out(U5_point_out),.LE_out(U5_LE_out),.Disp_num(U5_Disp_num));
Multi_8CH32 U5(.clk(~U8_Clk_CPU),.rst(U9_rst),.EN(U4_GPIOe0000000_we),.Test(3'b001),.point_in(U5_point_in),.LES({64{1'b0}})
,.Data0(U4_Peripheral_in),.data1(U5_data1),.data2(U2_spo),.data3(U10_counter_out),.data4(U1_Addr_out),.data5(U1_Data_out)
,.data6(U4_Cpu_data4bus),.data7(U1_PC_out),.point_out(U5_point_out),.LE_out(U5_LE_out),.Disp_num(U5_Disp_num));

VGAIO U11(.clk(clk_100mhz),.rst(U9_rst),.Pixel(U11_pixel),.red(Red),.green(Green),.blue(Blue),.HSYNC(HSYNC),.VSYNC(VSYNC),.addr(U11_addr));
//vram1 test(.clka(clk_100mhz),.addra(U11_addr),.douta(U11_pixel));
SCORE_ctrl U13(.clk(clk_100mhz),.rst(U9_rst),.score(U5_data1),.Addr(U1_Addr_out),.din(U1_Data_out));
vram2 U12(.clka(~clk_100mhz),.doutb(U11_pixel),.addra(U12_addra),.wea(U12_wea),.dina(U1_Data_out[11:0]),.addrb(U11_addr),.clkb(~clk_100mhz));

always @(*)
begin
	if(U1_Addr_out[31:28]==4'b1101&&U1_DMWType)
	begin
		U12_wea<=1;
		U12_addra<=U1_Addr_out[18:0];
	end
	else
		begin
		U12_wea<=0;
		U12_addra<=19'b0;
		end
end
always @(*)
begin 
	if(U1_Addr_out[31:28]==4'b1011)
		U1_Datain<=U8_clkdiv;
	else 
		U1_Datain<=U4_Cpu_data4bus;
	end
endmodule
