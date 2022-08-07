//
//
//  PPI8255.h
//  PPI8255 io chip emulator for arm32.
//
//  Created by Fredrik Ahlström on 2015-05-28.
//  Copyright © 2015-2022 Fredrik Ahlström. All rights reserved.
//

#ifndef PPI8255_HEADER
#define PPI8255_HEADER

typedef struct {
	u8 ppiPortAOut;
	u8 ppiPortBOut;
	u8 ppiPortCOut;
	u8 ppiControl;
	u8 ppiPortAIn;
	u8 ppiPortBIn;
	u8 ppiPortCIn;
	u8 ppiPadding;
	u32 ppiPortAOutFptr;
	u32 ppiPortBOutFptr;
	u32 ppiPortCOutFptr;
	u32 ppiPortAInFptr;
	u32 ppiPortBInFptr;
	u32 ppiPortCInFptr;
} ppi8255;


void PPI8255Reset(ppi8255 *chip, int chiptype);
void PPI8255W(ppi8255 *chip, u8 value, u8 adress);
void PPI8255R(ppi8255 *chip, u8 adress);


#endif
