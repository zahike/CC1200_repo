`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2021 09:22:53
// Design Name: 
// Module Name: CC1200SPI_Top
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


module CC1200SPI_Top(
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

output [3:0]  GPIO_OutEn, 
output [3:0]  GPIO_Out,
input  [3:0]  GPIO_In,

input        GetDataEn,
input [11:0] GetData,
output       Next_data,

output SCLK,
output MOSI,
input  MISO,
output CS_n
    );


wire        Start        ; // output        Start,
wire        Busy         ; // input         Busy,
wire [31:0] DataOut      ; // output [31:0] DataOut,
wire [31:0] DataIn       ; // input  [31:0] DataIn,
wire [3:0]  WR           ; // output [3:0]  WR,
wire [15:0] ClockDiv     ; // output [15:0] ClockDiv,
wire        Trans        ; // output Trans

CC1200SPI_Regs CC1200SPI_Regs_inst(
.clk(APBclk),
.rstn(rstn),

.APB_S_0_paddr  (APB_S_0_paddr  ),
.APB_S_0_penable(APB_S_0_penable),
.APB_S_0_prdata (APB_S_0_prdata ),
.APB_S_0_pready (APB_S_0_pready ),
.APB_S_0_psel   (APB_S_0_psel   ),
.APB_S_0_pslverr(APB_S_0_pslverr),
.APB_S_0_pwdata (APB_S_0_pwdata ),
.APB_S_0_pwrite (APB_S_0_pwrite ),

.Start     (Start     ),         // output        Start,
.Busy      (Busy      ),          // input         Busy,
.DataOut   (DataOut   ),       // output [31:0] DataOut,
.DataIn    (DataIn    ),        // input  [31:0] DataIn,
.WR        (WR        ),            // output [3:0]  WR,
.ClockDiv  (ClockDiv  ),      // output [15:0] ClockDiv,
.GPIO_OutEn(GPIO_OutEn),    // output [3:0]  GPIO_OutEn, 
.GPIO_Out  (GPIO_Out  ),      // output [3:0]  GPIO_Out,
.GPIO_In   (GPIO_In   ),     // input  [3:0]  GPIO_In

.Trans     (Trans     )     // output Trans
    );

//////////////////////// Zynq Control SPI //////////////////////// 
wire [7:0] SPIDataIn;
reg [1:0] DevCS_n;
always @(posedge clk or negedge rstn)
    if (!rstn) DevCS_n <= 2'b00;
     else DevCS_n <= {DevCS_n[0],CS_n};
wire Load_Next;
reg [31:0] Send_Data;
always @(posedge clk or negedge rstn)
    if (!rstn) Send_Data <= 32'h00000000;
     else if (CS_n) Send_Data <= DataOut;
     else if ((DevCS_n == 2'b10) || Load_Next) Send_Data <= {Send_Data[23:0],8'h00}; 
reg [31:0] Get_Data;
always @(posedge clk or negedge rstn)
    if (!rstn) Get_Data <= 32'h00000000;
     else if (Load_Next) Get_Data <= {Get_Data[23:0],SPIDataIn}; 
assign DataIn = Get_Data;
reg [3:0] Send_Stop;
always @(posedge clk or negedge rstn)
    if (!rstn) Send_Stop <= 4'h0;
     else if (CS_n) Send_Stop <= WR;
     else if (WR == 4'hf) Send_Stop <= WR;
     else if (Load_Next) Send_Stop <= {Send_Stop[2:0],1'b0}; 
//////////////////////// End Of Zynq Control SPI //////////////////////// 

//Trans

//input        GetDataEn,
//input [11:0] GetData,
//output       Next_data,



wire [7:0] RegCommand = 8'h7F;
wire [31:0] RegVsync  = 32'h930b51de;
wire [31:0] RegHsync  = 32'h6cf4ae21;
//reg TransOn;

reg [1:0] DevTranStart;
always @(posedge clk or negedge rstn)
    if (!rstn) DevTranStart <= 2'b00;
     else DevTranStart <= {DevTranStart[0],(Trans && GetDataEn)};

reg [2:0] Tran_SPI_count;
always @(posedge clk or negedge rstn) 
    if (!rstn) Tran_SPI_count <= 3'b000;
     else if (!(Trans && GetDataEn)) Tran_SPI_count <= 3'b000;
     else if (Tran_SPI_count == 3'b101) Tran_SPI_count <= 3'b101;
     else if (DevTranStart == 2'b01) Tran_SPI_count <=3'b001;  
     else if (Load_Next) Tran_SPI_count <= Tran_SPI_count + 1;  

reg [1:0] SPIdatactrl;
always @(posedge clk or negedge rstn) 
    if (!rstn) SPIdatactrl <= 2'b00;
     else if (Tran_SPI_count != 3'b101) SPIdatactrl <= 2'b00;
     else if (SPIdatactrl == 2'b11) SPIdatactrl <= 2'b00;
     else if (Load_Next) SPIdatactrl <= SPIdatactrl + 1;
     
reg [11:0] SavePreData;
always @(posedge clk or negedge rstn) 
    if (!rstn) SavePreData <= 12'h000;
     else if (Load_Next) SavePreData <= GetData;
    
wire [7:0] Byte2SPI = (Tran_SPI_count != 3'b101) ? 8'h00                            :
                      (SPIdatactrl == 2'b00)     ? GetData[7:0]                     :
                      (SPIdatactrl == 2'b01)     ? {GetData[3:0],SavePreData[11:8]} :
                      (SPIdatactrl == 2'b10)     ? SavePreData[11:4]                : 8'h00;
                      
assign Next_data = (Tran_SPI_count != 3'b101) ? 1'b0 : 
                   (SPIdatactrl    ==  2'b10) ? 1'b0 : Load_Next ;

                     
wire SPIstart = (Trans) ? (DevTranStart == 2'b01) : Start;
wire SPIstop  = (Trans) ? (DevTranStart == 2'b00) : Send_Stop[2];

wire [7:0] SPIdata = (!Trans)                   ? Send_Data[23:16] :
                     (Tran_SPI_count == 3'b000) ? RegCommand       :
                     (Tran_SPI_count == 3'b001) ? RegVsync[31:24]  :
                     (Tran_SPI_count == 3'b010) ? RegVsync[23:16]  :
                     (Tran_SPI_count == 3'b011) ? RegVsync[15: 8]  :
                     (Tran_SPI_count == 3'b100) ? RegVsync[ 7: 0]  :
                     (Tran_SPI_count == 3'b101) ? Byte2SPI         : 
                     8'h00;
                   
                   
CC1200SPI CC1200SPI_inst(
.clk (clk),
.rstn(rstn),

.Start   (SPIstart            ),  // input         Start,
.Stop    (SPIstop      ),  // input         Stop,
.Busy    (Busy             ),  // output        Busy,
.DataOut (SPIdata ),  // input  [7:0] DataOut,
.DataIn  (SPIDataIn        ),  // output [7:0] DataIn,
.ClockDiv(ClockDiv         ),  // input  [15:0] ClockDiv,

.Load_Next(Load_Next),         //   output Load_Next,

.SCLK(SCLK),
.MOSI(MOSI),
.MISO(MISO),
.CS_n(CS_n)
    );
    
endmodule
