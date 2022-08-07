;@
;@  PPI8255.i
;@  PPI8255 io chip emulator for arm32.
;@
;@  Created by Fredrik Ahlström on 2015-05-28.
;@  Copyright © 2015-2022 Fredrik Ahlström. All rights reserved.
;@
;@ ASM header for the PPI825 emulator
;@

	ppiptr			.req r12

							;@ PPI8255.s
	.struct 0

	ppiRegisters:
	ppiPortAOut:		.byte 0
	ppiPortBOut:		.byte 0
	ppiPortCOut:		.byte 0
	ppiControl:			.byte 0
	ppiPortAIn:			.byte 0
	ppiPortBIn:			.byte 0
	ppiPortCIn:			.byte 0
	ppiPadding:			.byte 0
	ppiPortAOutFptr:	.long 0
	ppiPortBOutFptr:	.long 0
	ppiPortCOutFptr:	.long 0
	ppiPortAInFptr:		.long 0
	ppiPortBInFptr:		.long 0
	ppiPortCInFptr:		.long 0

	ppiSize:

;@----------------------------------------------------------------------------

