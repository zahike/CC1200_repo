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

//.GPIO(GPIO),

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

endmodule
