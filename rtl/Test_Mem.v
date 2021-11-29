`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2021 07:39:36 AM
// Design Name: 
// Module Name: Test_Mem
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


module Test_Mem(
input  APBclk,
input  clk,
input  rstn,

input  [31:0] APB_S_0_paddr,
input         APB_S_0_penable,
output [31:0] APB_S_0_prdata,
output        APB_S_0_pready,
input         APB_S_0_psel,
output        APB_S_0_pslverr,
input  [31:0] APB_S_0_pwdata,
input         APB_S_0_pwrite,

output TranSPIen,
output [11:0] data2SPI,
input next_read

    );

reg  RegStart   ;
always @(posedge clk or negedge rstn)
    if (!rstn) RegStart <= 1'b0;
     else if (RegStart) RegStart <= 1'b0;
     else if (APB_S_0_penable && APB_S_0_psel && APB_S_0_pwrite && (APB_S_0_paddr[9:0] == 10'h000)) RegStart <= 1'b1;

reg Reg_tran;
reg [6:0] TranAddCounter;

always @(posedge clk or negedge rstn)
    if (!rstn) Reg_tran <= 1'b0;
     else if (RegStart) Reg_tran <= 1'b1;
     else if (TranAddCounter == 7'h0a) Reg_tran <= 1'b0;

assign  TranSPIen = Reg_tran;
     
always @(posedge clk or negedge rstn)
    if (!rstn) TranAddCounter <= 7'h00;
     else if (!Reg_tran) TranAddCounter <= 7'h00;
     else if (next_read) TranAddCounter <= TranAddCounter + 1;
     
     
wire [6:0] ReadAdd = (Reg_tran) ? TranAddCounter : APB_S_0_paddr[8:2];
     
reg [11:0] TestMem [0:127];
reg [11:0] Reg_TestMem;
always @(posedge clk)
    if (APB_S_0_penable && APB_S_0_psel && APB_S_0_pwrite && (APB_S_0_paddr[9] == 1'b1)) TestMem[APB_S_0_paddr[8:2]] <= APB_S_0_pwdata[11:0];
always @(posedge clk)
    Reg_TestMem <=  TestMem[ReadAdd];

assign data2SPI = Reg_TestMem;

assign APB_S_0_prdata = 
                        (APB_S_0_paddr[9]   == 1'b1 ) ? {20'h00000,Reg_TestMem}     : 
                        32'h00000000;

reg Reg_pready;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_pready <= 1'b0;
     else if (APB_S_0_penable && APB_S_0_psel) Reg_pready <= 1'b1;
     else Reg_pready <= 1'b0;

assign APB_S_0_pready = Reg_pready;

assign  APB_S_0_pslverr = 1'b0;  
       
endmodule
