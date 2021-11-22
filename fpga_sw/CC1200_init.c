/*
 * CC1200_init.c
 *
 *  Created on: Nov 21, 2021
 *      Author: udi
 */

#include "CC1200.h"

void CC1200_init()
{
	writeSCC120(0x0000,   0x06);
	writeSCC120(0x0001,   0x06);
	writeSCC120(0x0002,   0x30);
	writeSCC120(0x0003,   0x3C);
	writeSCC120(0x0004,   0x93);
	writeSCC120(0x0005,   0x0B);
	writeSCC120(0x0006,   0x51);
	writeSCC120(0x0007,   0xDE);
	writeSCC120(0x0008,   0xA8);
	writeSCC120(0x0009,   0x03);
	writeSCC120(0x000A,   0x47);
	writeSCC120(0x000B,   0x2F);
	writeSCC120(0x000C,   0x1E);
	writeSCC120(0x000D,   0x14);
	writeSCC120(0x000E,   0x8A);
	writeSCC120(0x000F,   0x00);
	writeSCC120(0x0010,   0x01);
	writeSCC120(0x0011,   0x42);
	writeSCC120(0x0012,   0x05);
	writeSCC120(0x0013,   0xC9);
	writeSCC120(0x0014,   0x99);
	writeSCC120(0x0015,   0x99);
	writeSCC120(0x0016,   0x2F);
	writeSCC120(0x0017,   0xF8);
	writeSCC120(0x0018,   0x00);
	writeSCC120(0x0019,   0xB1);
	writeSCC120(0x001A,   0x60);
	writeSCC120(0x001B,   0x12);
	writeSCC120(0x001C,   0x84);
	writeSCC120(0x001D,   0x00);
	writeSCC120(0x001E,   0x00);
	writeSCC120(0x001F,   0x0B);
	writeSCC120(0x0020,   0x14);
	writeSCC120(0x0021,   0x08);
	writeSCC120(0x0022,   0x21);
	writeSCC120(0x0023,   0x00);
	writeSCC120(0x0024,   0x00);
	writeSCC120(0x0025,   0x00);
	writeSCC120(0x0026,   0x00);
	writeSCC120(0x0027,   0x43);
	writeSCC120(0x0028,   0x00);
	writeSCC120(0x0029,   0x0F);
	writeSCC120(0x002A,   0x20);
	writeSCC120(0x002B,   0x7F);
	writeSCC120(0x002C,   0x56);
	writeSCC120(0x002D,   0x0F);
	writeSCC120(0x002E,   0x01);
	
	writeLCC120(0x2F00,   0x00);
	writeLCC120(0x2F01,   0x23);
	writeLCC120(0x2F02,   0x0B);
	writeLCC120(0x2F03,   0x00);
	writeLCC120(0x2F04,   0x00);
	writeLCC120(0x2F05,   0x00);
	writeLCC120(0x2F06,   0x01);
	writeLCC120(0x2F07,   0x00);
	writeLCC120(0x2F08,   0x00);
	writeLCC120(0x2F09,   0x00);
	writeLCC120(0x2F0A,   0x00);
	writeLCC120(0x2F0B,   0x00);
	writeLCC120(0x2F0C,   0x5E);
	writeLCC120(0x2F0D,   0x00);
	writeLCC120(0x2F0E,   0x00);
	writeLCC120(0x2F0F,   0x02);
	writeLCC120(0x2F10,   0xEE);
	writeLCC120(0x2F11,   0x10);
	writeLCC120(0x2F12,   0x04);
	writeLCC120(0x2F13,   0xA3);
	writeLCC120(0x2F14,   0x00);
	writeLCC120(0x2F15,   0x20);
	writeLCC120(0x2F16,   0x40);
	writeLCC120(0x2F17,   0x0E);
	writeLCC120(0x2F18,   0x28);
	writeLCC120(0x2F19,   0x03);
	writeLCC120(0x2F1A,   0x00);
	writeLCC120(0x2F1B,   0x33);
	writeLCC120(0x2F1C,   0xF7);
	writeLCC120(0x2F1D,   0x0F);
	writeLCC120(0x2F1E,   0x00);
	writeLCC120(0x2F1F,   0x00);
	writeLCC120(0x2F20,   0x6E);
	writeLCC120(0x2F21,   0x1C);
	writeLCC120(0x2F22,   0xAC);
	writeLCC120(0x2F23,   0x14);
	writeLCC120(0x2F24,   0x00);
	writeLCC120(0x2F25,   0x00);
	writeLCC120(0x2F26,   0x00);
	writeLCC120(0x2F27,   0xB5);
	writeLCC120(0x2F28,   0x00);
	writeLCC120(0x2F29,   0x02);
	writeLCC120(0x2F2A,   0x00);
	writeLCC120(0x2F2B,   0x00);
	writeLCC120(0x2F2C,   0x10);
	writeLCC120(0x2F2D,   0x00);
	writeLCC120(0x2F2E,   0x00);
	writeLCC120(0x2F2F,   0x0D);
	writeLCC120(0x2F30,   0x01);
	writeLCC120(0x2F31,   0x01);
	writeLCC120(0x2F32,   0x0E);
	writeLCC120(0x2F33,   0xA0);
	writeLCC120(0x2F34,   0x03);
	writeLCC120(0x2F35,   0x04);
	writeLCC120(0x2F36,   0x03);
	writeLCC120(0x2F37,   0x00);
	writeLCC120(0x2F38,   0x00);
	writeLCC120(0x2F39,   0x00);
	writeLCC120(0x2F64,   0x00);
	writeLCC120(0x2F65,   0x00);
	writeLCC120(0x2F66,   0x00);
	writeLCC120(0x2F67,   0x00);
	writeLCC120(0x2F68,   0x00);
	writeLCC120(0x2F69,   0x00);
	writeLCC120(0x2F6A,   0x00);
	writeLCC120(0x2F6B,   0x00);
	writeLCC120(0x2F6C,   0x00);
	writeLCC120(0x2F6D,   0x00);
	writeLCC120(0x2F6E,   0x00);
	writeLCC120(0x2F6F,   0x00);
	writeLCC120(0x2F70,   0x00);
	writeLCC120(0x2F71,   0x80);
	writeLCC120(0x2F72,   0x00);
	writeLCC120(0x2F73,   0x41);
	writeLCC120(0x2F74,   0x00);
	writeLCC120(0x2F75,   0xFF);
	writeLCC120(0x2F76,   0x00);
	writeLCC120(0x2F77,   0x00);
	writeLCC120(0x2F78,   0x00);
	writeLCC120(0x2F79,   0x00);
	writeLCC120(0x2F7A,   0xD1);
	writeLCC120(0x2F7B,   0x00);
	writeLCC120(0x2F7C,   0x3F);
	writeLCC120(0x2F7D,   0x00);
	writeLCC120(0x2F7E,   0x00);
	writeLCC120(0x2F7F,   0x30);
	writeLCC120(0x2F80,   0x7F);
	writeLCC120(0x2F81,   0x00);
	writeLCC120(0x2F82,   0x00);
	writeLCC120(0x2F83,   0x00);
	writeLCC120(0x2F84,   0x00);
	writeLCC120(0x2F85,   0x00);
	writeLCC120(0x2F86,   0x02);
	writeLCC120(0x2F87,   0x00);
	writeLCC120(0x2F88,   0x00);
	writeLCC120(0x2F89,   0x00);
	writeLCC120(0x2F8A,   0x00);
	writeLCC120(0x2F8B,   0x00);
	writeLCC120(0x2F8C,   0x00);
	writeLCC120(0x2F8D,   0x01);
	writeLCC120(0x2F8E,   0x00);
	writeLCC120(0x2F8F,   0x20);
	writeLCC120(0x2F90,   0x11);
	writeLCC120(0x2F91,   0x00);
	writeLCC120(0x2F92,   0x10);
	writeLCC120(0x2F93,   0x00);
	writeLCC120(0x2F94,   0x00);
	writeLCC120(0x2F95,   0x00);
	writeLCC120(0x2F96,   0x00);
	writeLCC120(0x2F97,   0x00);
	writeLCC120(0x2F98,   0x00);
	writeLCC120(0x2F99,   0x00);
	writeLCC120(0x2F9A,   0x00);
	writeLCC120(0x2F9B,   0x0B);
	writeLCC120(0x2F9C,   0x40);
	writeLCC120(0x2F9D,   0x00);
	writeLCC120(0x2F9E,   0x00);
	writeLCC120(0x2F9F,   0x00);
	writeLCC120(0x2FA0,   0x00);
	writeLCC120(0x2FA1,   0x00);
	writeLCC120(0x2FA2,   0x00);
	writeLCC120(0x2FD2,   0x00);
	writeLCC120(0x2FD3,   0x00);
	writeLCC120(0x2FD4,   0x00);
	writeLCC120(0x2FD5,   0x00);
	writeLCC120(0x2FD6,   0x00);
	writeLCC120(0x2FD7,   0x00);
	writeLCC120(0x2FD8,   0x0F);
	writeLCC120(0x2FD9,   0x00);
	writeLCC120(0x2FDA,   0x00);
	writeLCC120(0x2FE0,   0x00);
	writeLCC120(0x2FE1,   0x00);
	writeLCC120(0x2FE2,   0x00);
	writeLCC120(0x2FE3,   0x00);
	writeLCC120(0x2FE4,   0x00);
	writeLCC120(0x2FE5,   0x00);
	writeLCC120(0x2FE6,   0x00);
	writeLCC120(0x2FE7,   0x00);
	writeLCC120(0x2FE8,   0x00);
	writeLCC120(0x2FE9,   0x00);
	writeLCC120(0x2FEA,   0x00);
	writeLCC120(0x2FEB,   0x00);
	writeLCC120(0x2FEC,   0x00);
	writeLCC120(0x2FED,   0x00);
	writeLCC120(0x2FEE,   0x00);
	writeLCC120(0x2FEF,   0x00);
	writeLCC120(0x2FF0,   0x00);
	writeLCC120(0x2FF1,   0x00);
	writeLCC120(0x2FF2,   0x00);
	writeLCC120(0x2FF3,   0x00);
	writeLCC120(0x2FF4,   0x00);
	writeLCC120(0x2FF5,   0x00);
	writeLCC120(0x2FF6,   0x00);
	writeLCC120(0x2FF7,   0x00);
	writeLCC120(0x2FF8,   0x00);
	writeLCC120(0x2FF9,   0x00);
	writeLCC120(0x2FFA,   0x00);
	writeLCC120(0x2FFB,   0x00);
	writeLCC120(0x2FFC,   0x00);
	writeLCC120(0x2FFD,   0x00);
	writeLCC120(0x2FFE,   0x00);
	writeLCC120(0x2FFF,   0x00);

};
