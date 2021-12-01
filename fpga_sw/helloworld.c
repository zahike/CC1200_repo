/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "CC1200.h"

u32 *CC1200 = XPAR_APB_M_0_BASEADDR;
u32 *MEM    = XPAR_APB_M_1_BASEADDR;

int writeSCC120 (int add, int data);
int readSCC120 (int add);
int writeLCC120 (int add, int data);
int readLCC120 (int add);

void CC1200_init();
void RxCC1200_init();

int main()
{
	int loop;
	int data;
	int gpio;
	int i,j;
    init_platform();

    xil_printf("Hello World\n\r");

    for (i=0;i<128;i++){
    	MEM[128+i] = 256*i+i;
    }

    CC1200[6] = 1;
    CC1200[7] = 0;
    usleep(100);
    CC1200[7] = 1;
    CC1200[5] = 16;

    CC1200[4] = 4;        // switch to command mode
    CC1200[2] = 0x300000; // Reset chip
    CC1200[0] = 1;
	loop = 1;
	while (loop)
	{
		loop = CC1200[1];
	};

    CC1200[2] = 0x3d0000;  // check if module in reset
    data = 0;
    while (data != 0x0f)
    {
		CC1200[0] = 1;
		loop = 1;
		while (loop)
		{
			loop = CC1200[1];
		};
		data = CC1200[3] & 0xff;
		if (data != 0x0f) {
			xil_printf("Chip not set\n\r");
		}
    }

    xil_printf("Chip reset succesfuly \n\r");



//    CC1200_init();
	RxCC1200_init();

    xil_printf("Read normal registers\n\r");

    usleep(100);

    for (int i=0;i<0x30;i++)
    {
    	data = (readSCC120(i) & 0xff);
    	xil_printf("                  0x%04x   0x%02x \n\r",i,data);
    }


    for (int i=0x2F00;i<0x2FFF;i++)
    {
    	data = (readLCC120(i) & 0xff);
    	xil_printf("                  0x%04x   0x%02x \n\r",i,data);
    }

    CC1200[4] = 4;        // switch to command mode
//    CC1200[2] = 0x350000; // set chip to Tx
    CC1200[2] = 0x340000; // set chip to Rx
    CC1200[0] = 1;
	loop = 1;
	while (loop)
	{
		loop = CC1200[1];
	};

    CC1200[2] = 0x3d0000;  // check if module in Tx
    data = 0;
//    while (data != 0x20)
    while (data != 0x10)
    {
		CC1200[0] = 1;
		loop = 1;
		while (loop)
		{
			loop = CC1200[1];
		};
		data = CC1200[3] & 0xf0;
//		if (data != 0x20)
//		{
//			xil_printf("Chip is not in Tx\n\r");
//		}
		if (data != 0x10)
		{
			xil_printf("Chip is not in Rx\n\r");
		}
    }
//	xil_printf("Switch to Tx seccesfuly in Tx\n\r");
	xil_printf("Switch to Rx seccesfuly in Rx\n\r");

//	CC1200[0] = 2; // Enable Tx
	CC1200[0] = 4; // Enable Rx
//	MEM[0] = 1;		// send data from FIFO

    xil_printf("GoodBye World\n\r");

    cleanup_platform();
    return 0;
}
