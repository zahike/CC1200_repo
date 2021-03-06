`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2021 15:13:42
// Design Name: 
// Module Name: CC1200_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CC1200_Top(
input  sys_clock,
inout [14:0] DDR_addr,
inout [2:0] DDR_ba,
inout  DDR_cas_n,
inout  DDR_ck_n,
inout  DDR_ck_p,
inout  DDR_cke,
inout  DDR_cs_n,
inout [3:0] DDR_dm,
inout [31:0] DDR_dq,
inout [3:0] DDR_dqs_n,
inout [3:0] DDR_dqs_p,
inout  DDR_odt,
inout  DDR_ras_n,
inout  DDR_reset_n,
inout  DDR_we_n,
inout  FIXED_IO_ddr_vrn,
inout  FIXED_IO_ddr_vrp,
inout [53:0] FIXED_IO_mio,
inout  FIXED_IO_ps_clk,
inout  FIXED_IO_ps_porb,
inout  FIXED_IO_ps_srstb,
//Pmod Header JB
input [3:0] sw,
input [3:0] btn,
inout [2:1] jb_p,
inout [2:1] jb_n,
inout [4:1] jc_p,
inout [4:1] jc_n,

inout SCLK,
inout MOSI,
input MISO,
inout CS_n
//output SCLK,
//output MOSI,
//input  MISO,
//output CS_n

    );
wire clk;    
wire rstn = ~btn[0];
/////////////////////////////////////////////////////////// 
/////////////////// CC1200 Block design /////////////////// 
/////////////////////////////////////////////////////////// 
// Outputs
wire [3:0] GPIO_OutEn;		//output [3:0] GPIO_OutEn_0;
wire [3:0] GPIO_Out;		//output [3:0] GPIO_Out_0;
wire  SCLK_0;		//output  SCLK_0;
wire  MOSI_0;		//output  MOSI_0;
wire  MISO_0; 		//input  MISO_0;
wire  CS_n_0;		//output  CS_n_0;
wire  SCLK_I;		//output  SCLK_0;
wire  MOSI_I;		//output  MOSI_0;
wire  MISO_I; 		//input  MISO_0;
wire  CS_n_I;		//output  CS_n_0;
// Inputs
wire [3:0] GPIO_In;		//input [3:0] GPIO_In_0;

CC1200_BD CC1200_BD_inst
(
.sys_clock(sys_clock),        //input  sys_clock
.DDR_addr(DDR_addr),        //inout [14:0] DDR_addr
.DDR_ba(DDR_ba),        //inout [2:0] DDR_ba
.DDR_cas_n(DDR_cas_n),        //inout  DDR_cas_n
.DDR_ck_n(DDR_ck_n),        //inout  DDR_ck_n
.DDR_ck_p(DDR_ck_p),        //inout  DDR_ck_p
.DDR_cke(DDR_cke),        //inout  DDR_cke
.DDR_cs_n(DDR_cs_n),        //inout  DDR_cs_n
.DDR_dm(DDR_dm),        //inout [3:0] DDR_dm
.DDR_dq(DDR_dq),        //inout [31:0] DDR_dq
.DDR_dqs_n(DDR_dqs_n),        //inout [3:0] DDR_dqs_n
.DDR_dqs_p(DDR_dqs_p),        //inout [3:0] DDR_dqs_p
.DDR_odt(DDR_odt),        //inout  DDR_odt
.DDR_ras_n(DDR_ras_n),        //inout  DDR_ras_n
.DDR_reset_n(DDR_reset_n),        //inout  DDR_reset_n
.DDR_we_n(DDR_we_n),        //inout  DDR_we_n
.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),        //inout  FIXED_IO_ddr_vrn
.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),        //inout  FIXED_IO_ddr_vrp
.FIXED_IO_mio(FIXED_IO_mio),        //inout [53:0] FIXED_IO_mio
.FIXED_IO_ps_clk(FIXED_IO_ps_clk),        //inout  FIXED_IO_ps_clk
.FIXED_IO_ps_porb(FIXED_IO_ps_porb),        //inout  FIXED_IO_ps_porb
.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),        //inout  FIXED_IO_ps_srstb
.GPIO_OutEn_0(GPIO_OutEn),        //output [3:0] GPIO_OutEn_0
.GPIO_Out_0  (GPIO_Out  ),        //output [3:0] GPIO_Out_0
.GPIO_In_0   (GPIO_In   ),        //input [3:0] GPIO_In_0
.SCLK_0(SCLK_0),        //output  SCLK_0
.MOSI_0(MOSI_0),        //output  MOSI_0
.MISO_0(MISO_0),        //input  MISO_0
.CS_n_0(CS_n_0),		//output  CS_n_0

.reset_rtl(rstn),
.clk(clk)
);    


assign jb_p[1] = (sw[0]&&GPIO_OutEn[0]) ? GPIO_Out[0] : 1'bz;
assign jb_n[1] = (sw[0]&&GPIO_OutEn[1]) ? GPIO_Out[1] : 1'bz;
assign jb_p[2] = (sw[0]&&GPIO_OutEn[2]) ? GPIO_Out[2] : 1'bz;
assign jb_n[2] = (sw[0]&&GPIO_OutEn[3]) ? GPIO_Out[3] : 1'bz;
assign GPIO_In = {jb_n[2],jb_p[2],jb_n[1],jb_p[1]};

assign SCLK = (sw[0]) ? SCLK_0 : 1'bz; 
assign MOSI = (sw[0]) ? MOSI_0 : 1'bz; 
assign CS_n = (sw[0]) ? CS_n_0 : 1'bz; 

assign  SCLK_I = SCLK;		//output  SCLK_0;
assign  MOSI_I = MOSI;		//output  MOSI_0;
assign  MISO_I = MISO;  	//input  MISO_0;
assign  CS_n_I = CS_n;		//output  CS_n_0;

assign MISO_0 = MISO;
/*
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ila_0 ila_0_inst (
	.clk(clk), // input wire clk

	.probe0(sw), // input wire [3:0]  probe0  
    .probe1(GPIO_OutEn), // input wire [3:0]  probe1 
    .probe2(GPIO_In), // input wire [3:0]  probe2 
    .probe3(SCLK_I), // input wire [0:0]  probe3 
    .probe4(MOSI_I), // input wire [0:0]  probe4 
    .probe5(MISO_I), // input wire [0:0]  probe5 
    .probe6(CS_n_I) // input wire [0:0]  probe6
);
*/
////----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG

//ila_1 ila_1_inst (
//	.clk(clk), // input wire clk


//	.probe0(GPIO_OutEn), // input wire [3:0]  probe0  
//	.probe1(GPIO_Out  ), // input wire [3:0]  probe1 
//	.probe2(GPIO_In   ), // input wire [3:0]  probe2 
//	.probe3(MISO), // input wire [0:0]  probe3 
//	.probe4(MOSI), // input wire [0:0]  probe4 
//	.probe5(SCLK), // input wire [0:0]  probe5 
//	.probe6(CS_n) // input wire [0:0]  probe6
//);

endmodule
