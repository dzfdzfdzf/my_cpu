`timescale 1ns / 1ps
module IP2SOC_Top(
	input RSTN,
	input [3:0] BTN_y,
	input [15:0]SW,
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
	output [4:0] BTN_x
    );
wire [4:0]Key_out;
wire rst;
wire Clk_CPU;
wire GPIOf0000000_we;
wire GPIOe0000000_we;
wire mem_w;
wire CPU_MIO;
wire MIO_ready;
wire data_ram_we;
wire counter_we;
wire [3:0]pulse_out;
wire [3:0]BTN_OK;
wire [15:0]SW_OK;
wire [31:0]Addr_out,Disp_num,Peripheral_in,Data_in,Data_out,Bi,Ai,spo,douta,ram_data_in,ram_data_out,Cpu_data4bus,PC_out,clkdiv,counter_out;
wire[9:0]ram_addr;
wire[15:0]LED_out;
wire[1:0] counter_set;
wire [7:0] point_out;
wire [7:0] LE_out;
wire [7:0]blink;
wire [13:0]GPIOf0;
wire counter0_OUT;
wire counter1_OUT;
wire counter2_OUT;
wire Clk_CPU_not;
wire [3:0]DMWType;
//wire wea;
assign Clk_CPU_not=~Clk_CPU;
SAnti_jitter U9(
.clk(clk_100mhz),
.RSTN(RSTN),
.readn(readn),
.Key_y(BTN_y),
.Key_x(BTN_x),
.SW(SW), 
.Key_out(Key_out),
.Key_ready(RDY),
.pulse_out(pulse_out),
.BTN_OK(BTN_OK),
.SW_OK(SW_OK),
.CR(CR),
.rst(rst)
);
clk_div U8(
.clk(clk_100mhz),
.rst(rst),
.SW2(SW_OK[2]),
.clkdiv(clkdiv),
.Clk_CPU(Clk_CPU)
);
SEnter_2_32 M4(
.clk(clk_100mhz),
.BTN(BTN_OK[2:0]),
.Ctrl({SW_OK[7:5],SW_OK[15],SW_OK[0]}),
.D_ready(RDY),
.Din(Key_out),
.readn(readn),
.Ai(Ai),	
.Bi(Bi),
.blink(blink)		
);
SSeg7_Dev U6(
.clk(clk_100mhz),
.rst(rst),
.Start(clkdiv[20]),
.SW0(SW_OK[0]),
.flash(clkdiv[25]),
.Hexs(Disp_num),	
.point(point_out),
.LES(LE_out),
.seg_clk(seg_clk),	
.seg_sout(seg_sout),	
.SEG_PEN(SEG_PEN),
.seg_clrn(seg_clrn)	
);
SCPU U1(
.clk(Clk_CPU),
.reset(rst),
.MIO_ready(MIO_ready),
.inst_in(spo),
.Data_in(Cpu_data4bus),	
.mem_w(mem_w),
.PC_out(PC_out),
.Addr_out(Addr_out),
.Data_out(Data_out), 
.CPU_MIO(CPU_MIO),
.INT(counter0_OUT),
.DMWType(DMWType)
);
ROM_B2 U2(
.a(PC_out[11:2]),
.spo(spo)
);
RAM_B2 U3(
.clka(~clk_100mhz),
.addra(ram_addr),
.wea(DMWType),
.dina(ram_data_in),
.douta(douta)
);
MIO_BUS U4(
.clk(clk_100mhz),
.rst(rst),
.BTN(BTN_OK),
.SW(SW_OK),
.mem_w(mem_w),
.addr_bus(Addr_out),
.Cpu_data4bus(Cpu_data4bus),
.Cpu_data2bus(Data_out),
.ram_data_in(ram_data_in),
.data_ram_we(data_ram_we),
.ram_addr(ram_addr),
.ram_data_out(douta),
.Peripheral_in(Peripheral_in),
.GPIOf0000000_we(GPIOf0000000_we),
.GPIOe0000000_we(GPIOe0000000_we),
.led_out(LED_out),
.counter_out(counter_out),
.counter2_out(counter2_OUT),
.counter1_out(counter1_OUT),
.counter0_out(counter0_OUT),
.counter_we(counter_we)
);
Counter_x U10(
.clk(Clk_CPU_not),
.rst(rst),
.clk0(clkdiv[6]),
.clk1(clkdiv[9]),
.clk2(clkdiv[11]),
.counter_we(counter_we),
.counter_val(Peripheral_in),
.counter_ch(counter_set),
.counter0_OUT(counter0_OUT),
.counter1_OUT(counter1_OUT),
.counter2_OUT(counter2_OUT),
.counter_out(counter_out)
);
SPIO U7(
.clk(Clk_CPU_not),
.rst(rst),
.EN(GPIOf0000000_we),
.Start(clkdiv[20]),
.P_Data(Peripheral_in),
.counter_set(counter_set),
.LED_out(LED_out),
.GPIOf0(GPIOf0),
.led_clk(led_clk),
.led_sout(led_sout),
.LED_PEN(LED_PEN),
.led_clrn(led_clrn)
);
Multi_8CH32 U5(
.clk(Clk_CPU_not),
.rst(rst),
.EN(GPIOe0000000_we),
.Test(SW_OK[7:5]),
.point_in({clkdiv[31:0],clkdiv[31:0]}),
.LES({64{1'b0}}),
.Data0(Peripheral_in),
.data1({{2'b0},PC_out[31:2]}),
.data2(spo),
.data3(counter_out),
.data4(Addr_out),
.data5(Data_out),
.data6(Cpu_data4bus),
.data7(PC_out),
.Disp_num(Disp_num),
.point_out(point_out),
.LE_out(LE_out)

);
endmodule
