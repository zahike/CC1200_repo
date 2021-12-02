`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2021 10:15:21
// Design Name: 
// Module Name: CC1200_small_tb
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


module CC1200_small_tb();
reg clk ;
reg APBclk;
reg rstn;
initial begin 
clk = 1'b0;
APBclk = 1'b0;
rstn = 1'b0;
#100;
rstn = 1'b1;
end
always #4 clk = ~clk;
always #10 APBclk = ~APBclk;


reg         Start   ;      // input         Start,
reg         Stop   ;      // input         Stop,
wire        Busy    ;       // output        Busy,
reg  [31:0] DataOut ;    // input  [31:0] DataOut,
wire [31:0] DataIn  ;     // output [31:0] DataIn,
reg  [3:0]  WR      ;          // input  [3:0]  WR,
reg  [15:0] ClockDiv;   // input  [15:0] ClockDiv,

wire SCLK           ;               // output SCLK,
wire MOSI           ;               // output MOSI,
reg  MISO           ;               // input  MISO,
wire CS_n           ;               // output CS_n

wire [3:0] GPIO ;

reg [31:0] MISO_Reg;
always @(negedge SCLK) MISO_Reg <= {MISO_Reg[30:0],MISO_Reg[31]};

initial begin
Start    = 0;      // input         Start,
Stop     = 0;
DataOut  = 8'ha5;    // input  [31:0] DataOut,
WR       = 0;          // input  [3:0]  WR,
ClockDiv = 4;   // input  [15:0] ClockDiv,
MISO     = 0;               // input  MISO,
@(posedge rstn);
MISO_Reg = 32'h12345679;
#600;
MISO     = 1'b1;               // input  MISO,
#1000;
Start    = 1'b1;      // input         Start,
#20;
Start    = 1'b0;      // input         Start,
#1000;
MISO     = 1'b0;               // input  MISO,
force MISO     = MISO_Reg[31];               // input  MISO,
#2000;
Stop = 1'b1; 
#30000;
MISO_Reg = 32'h00000000;

end

reg [31:0]  S_APB_0_paddr    ; // input  [31:0] S_APB_0_paddr      ,
reg         S_APB_0_penable  ; // input         S_APB_0_penable    ,
wire [31:0] S_APB_0_prdata   ;  // output [31:0] S_APB_0_prdata     ,
wire        S_APB_0_pready   ;  // output        S_APB_0_pready     ,
reg         S_APB_0_psel     ; // input         S_APB_0_psel       ,
wire        S_APB_0_pslverr  ;  // output        S_APB_0_pslverr    ,
reg [31:0]  S_APB_0_pwdata   ; // input  [31:0] S_APB_0_pwdata     ,
reg         S_APB_0_pwrite   ; // input         S_APB_0_pwrite     ,

initial begin 
force CC1200SPI_Top_inst.GPIO_In = 4'h0;
@(posedge rstn);
#100;
WriteAXI (32'h00000018,32'h0000000f);  /// Enable GPIO
WriteAXI (32'h0000001c,32'h0000000a);  /// Write GPIO
#50;
WriteAXI (32'h00000018,32'h00000000);  /// Disable GPIO
force GPIO = 4'h5;
ReadAXI(32'h00000020);                  // read GPIO
#100;
release GPIO;
WriteAXI (32'h00000014,32'h00000004);  /// Set clock
WriteAXI (32'h00000010,32'h00000001);   // Set Byte Number
WriteAXI (32'h00000008,32'h00b3456d);   // Set data
WriteAXI (32'h00000000,32'h00000001);   // start
ReadAXI(32'h00000004);
while (S_APB_0_prdata) begin 
        ReadAXI(32'h00000004);          /// Check Busy
end
ReadAXI(32'h0000000c);
#10000; 
WriteAXI (32'h00000010,32'h00000000);   // Set Byte Number
WriteAXI (32'h00000000,32'h00000001);   // start
#10000;     
WriteAXI (32'h00000010,32'h0000000f);   // Set Byte Number
#10000; 
WriteAXI (32'h00000000,32'h00000002);   // Set Byte Number
#40000;
WriteAXI (32'h00000000,32'h00000004);   // Set Byte Number
#1000;
force CC1200SPI_Top_inst.GPIO_In = 4'h8;
#1000;
force CC1200SPI_Top_inst.GPIO_In = 4'h0;
//@( MOSI);
@(negedge MOSI);
#1;
//MISO_Reg = 32'h12345678;

end

reg [2:0] SPIcount;
always @(negedge SCLK or negedge rstn)
    if (!rstn) SPIcount <= 3'b000;
     else SPIcount <= SPIcount + 1;
reg [4:0] SPIwAdd;
always @(negedge SCLK or negedge rstn)
    if (!rstn) SPIwAdd <= 5'h00;
     else if (SPIcount == 3'b111) SPIwAdd <= SPIwAdd + 1;
reg [7:0] ShiftMOSI;
always @(posedge SCLK or negedge rstn)
    if (!rstn) ShiftMOSI <= 8'h00;
     else ShiftMOSI <= {ShiftMOSI[6:0],MOSI};
reg dSCLK;
always @(posedge clk or negedge rstn)
    if (!rstn) dSCLK <= 1'b0;
     else dSCLK <= SCLK;     
wire LoadSPIdata = (dSCLK && !SCLK && (SPIcount == 3'b000));     
reg [7:0] SPImem [0:31];
reg [7:0] Reg_SPImem;
always @(posedge clk) 
    if (dSCLK && SCLK && (SPIcount == 3'b111)) SPImem[SPIwAdd] <= ShiftMOSI;
//always @(posedge clk) 
//    Reg_SPImem <= SPImem[
reg [4:0] SPIRAdd;
always @(negedge SCLK or negedge rstn)
    if (!rstn) SPIRAdd <= 5'h00;
     else if (SPIcount == 3'b111) SPIRAdd <= SPIRAdd + 1;

initial begin 
#40000;
SPIwAdd = 5'h00;
#30000;
SPIRAdd = 5'h00;
//force MISO = 
//MISO_Reg = {SPImem[SPIRAdd],24'h000000};
while (1) begin
    MISO_Reg = {SPImem[SPIRAdd],24'h000000};
    @(SPIcount == 3'b111);
    @(SPIcount == 3'b000);
//    @(negedge LoadSPIdata);
end
end 
     
//CC1200SPI CC1200SPI_inst(
//.clk (clk ),
//.rstn(rstn),

//.Start   (Start   ),
//.Stop    (Stop    ),
//.Busy    (Busy    ),
//.DataOut (DataOut ),
//.DataIn  (DataIn  ),
//.WR      (WR      ),
//.ClockDiv(ClockDiv),

//.SCLK(SCLK),
//.MOSI(MOSI),
//.MISO(MISO),
//.CS_n(CS_n)
//    );

reg [31:0]  S_APB_1_paddr    ; // input  [31:0] S_APB_0_paddr      ,
reg         S_APB_1_penable  ; // input         S_APB_0_penable    ,
wire [31:0] S_APB_1_prdata   ;  // output [31:0] S_APB_0_prdata     ,
wire        S_APB_1_pready   ;  // output        S_APB_0_pready     ,
reg         S_APB_1_psel     ; // input         S_APB_0_psel       ,
wire        S_APB_1_pslverr  ;  // output        S_APB_0_pslverr    ,
reg [31:0]  S_APB_1_pwdata   ; // input  [31:0] S_APB_0_pwdata     ,
reg         S_APB_1_pwrite   ; // input         S_APB_0_pwrite     ,

reg [6:0] WData;
reg [6:0] WAdd;

initial begin 
WData = 7'h7f;
WAdd  = 7'h00;
@(posedge rstn);
#100;
repeat (128) begin
 Write1AXI({21'h000001,WAdd,2'b00},{20'h00000,WData[3:0],1'b0,WData});
 WAdd  = WAdd  + 1;
 WData = WData - 1;
 @(posedge APBclk);
    end

//repeat (128) begin
// Read1AXI((32'h00000080+WData));
// WData = WData + 1;
// @(posedge APBclk);
//    end
#40000;
 Write1AXI(32'h00000000,32'h00000001);
end

wire Tran     ;
wire Next_read;
wire [11:0] data2SPI;

Test_Mem Test_Mem_inst(
.APBclk(APBclk),                    // input  APBclk,
.clk   (clk   ),                       // input  clk,
.rstn  (rstn  ),                      // input  rstn,
                           // 
.APB_S_0_paddr  (S_APB_1_paddr  ),      // input  [31:0] APB_S_0_paddr,
.APB_S_0_penable(S_APB_1_penable),    // input         APB_S_0_penable,
.APB_S_0_prdata (S_APB_1_prdata ),     // output [31:0] APB_S_0_prdata,
.APB_S_0_pready (S_APB_1_pready ),     // output        APB_S_0_pready,
.APB_S_0_psel   (S_APB_1_psel   ),       // input         APB_S_0_psel,
.APB_S_0_pslverr(S_APB_1_pslverr),    // output        APB_S_0_pslverr,
.APB_S_0_pwdata (S_APB_1_pwdata ),     // input  [31:0] APB_S_0_pwdata,
.APB_S_0_pwrite (S_APB_1_pwrite ),     // input         APB_S_0_pwrite,
                           // 
.TranSPIen     (Tran     ),                      // output Tran,
.data2SPI (data2SPI ),                 // output [11:0] data2SPI
.next_read(Next_read)                  // input  next_read

    );

CC1200SPI_Top CC1200SPI_Top_inst(
.APBclk(APBclk),
.clk   (clk   ),
.rstn  (rstn  ),

.APB_S_0_paddr  (S_APB_0_paddr   ) ,
.APB_S_0_penable(S_APB_0_penable ) ,
.APB_S_0_prdata (S_APB_0_prdata  ) ,
.APB_S_0_pready (S_APB_0_pready  ) ,
.APB_S_0_psel   (S_APB_0_psel    ) ,
.APB_S_0_pslverr(S_APB_0_pslverr ) ,
.APB_S_0_pwdata (S_APB_0_pwdata  ) ,
.APB_S_0_pwrite (S_APB_0_pwrite  ) ,

.GetDataEn(Tran),  //input        GetDataEn,
.GetData  (data2SPI  ),    //input [11:0] GetData,
.Next_data(Next_read),  //output       Next_data,

.SCLK(SCLK),
.MOSI(MOSI),
.MISO(MISO),
.CS_n(CS_n)
    );

//////////////////////////////////////////////////
/////////////// Read/write tasks /////////////////
//////////////////////////////////////////////////

task ReadAXI;
input [31:0] addr;
begin 
    S_APB_0_paddr    = 0; // input  [31:0] S_APB_0_paddr      ,
    S_APB_0_penable  = 0; // input         S_APB_0_penable    ,
    S_APB_0_psel     = 0; // input         S_APB_0_psel       ,
    S_APB_0_pwdata   = 0; // input  [31:0] S_APB_0_pwdata     ,
    S_APB_0_pwrite   = 0; // input         S_APB_0_pwrite     ,
    @(posedge APBclk);
    S_APB_0_paddr   = addr;
    S_APB_0_psel    = 1'b1;
    @(posedge APBclk);
    S_APB_0_penable    = 1'b1;
    while (~S_APB_0_pready) begin
        @(posedge APBclk);    
        if (S_APB_0_pready) begin 
                S_APB_0_psel  = 1'b0;
                S_APB_0_penable  = 1'b0;
                end
    end
end 
endtask 


task WriteAXI;
input [31:0] addr;
input [31:0] data;
begin 
    S_APB_0_paddr    = 0; // input  [31:0] S_APB_0_paddr      ,
    S_APB_0_penable  = 0; // input         S_APB_0_penable    ,
    S_APB_0_psel     = 0; // input         S_APB_0_psel       ,
    S_APB_0_pwdata   = 0; // input  [31:0] S_APB_0_pwdata     ,
    S_APB_0_pwrite   = 0; // input         S_APB_0_pwrite     ,


    @(posedge APBclk);
    S_APB_0_paddr   = addr;
    S_APB_0_pwdata  = data;
    S_APB_0_pwrite  = 1'b1;
    S_APB_0_psel    = 1'b1;
    @(posedge APBclk);
    S_APB_0_penable  = 1'b1;
    while (~S_APB_0_pready) begin
        @(posedge APBclk);    
        if (S_APB_0_pready) begin 
                S_APB_0_psel  = 1'b0;
                S_APB_0_penable  = 1'b0;
                end
    end
end 
endtask 


task Read1AXI;
input [31:0] addr;
begin 
    S_APB_1_paddr    = 0; // input  [31:0] S_APB_1_paddr      ,
    S_APB_1_penable  = 0; // input         S_APB_1_penable    ,
    S_APB_1_psel     = 0; // input         S_APB_1_psel       ,
    S_APB_1_pwdata   = 0; // input  [31:0] S_APB_1_pwdata     ,
    S_APB_1_pwrite   = 0; // input         S_APB_1_pwrite     ,
    @(posedge APBclk);
    S_APB_1_paddr   = addr;
    S_APB_1_psel    = 1'b1;
    @(posedge APBclk);
    S_APB_1_penable    = 1'b1;
    while (~S_APB_1_pready) begin
        @(posedge APBclk);    
        if (S_APB_1_pready) begin 
                S_APB_1_psel  = 1'b0;
                S_APB_1_penable  = 1'b0;
                end
    end
end 
endtask 


task Write1AXI;
input [31:0] addr;
input [31:0] data;
begin 
    S_APB_1_paddr    = 0; // input  [31:0] S_APB_1_paddr      ,
    S_APB_1_penable  = 0; // input         S_APB_1_penable    ,
    S_APB_1_psel     = 0; // input         S_APB_1_psel       ,
    S_APB_1_pwdata   = 0; // input  [31:0] S_APB_1_pwdata     ,
    S_APB_1_pwrite   = 0; // input         S_APB_1_pwrite     ,


    @(posedge APBclk);
    S_APB_1_paddr   = addr;
    S_APB_1_pwdata  = data;
    S_APB_1_pwrite  = 1'b1;
    S_APB_1_psel    = 1'b1;
    @(posedge APBclk);
    S_APB_1_penable  = 1'b1;
    while (~S_APB_1_pready) begin
        @(posedge APBclk);    
        if (S_APB_1_pready) begin 
                S_APB_1_psel  = 1'b0;
                S_APB_1_penable  = 1'b0;
                end
    end
end 
endtask 

endmodule
