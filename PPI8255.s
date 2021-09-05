;@ PPI8255 io chip emulator.
#ifdef __arm__

#include "PPI8255.i"

	.global PPI8255Reset
	.global PPI8255R
	.global PPI8255PortAR
	.global PPI8255PortBR
	.global PPI8255PortCR
	.global PPI8255PortDR
	.global PPI8255W
	.global PPI8255PortAW
	.global PPI8255PortBW
	.global PPI8255PortCW
	.global PPI8255PortDW

	.syntax unified
	.arm

	.section .text
	.align 2
;@----------------------------------------------------------------------------
PPI8255Reset:				;@ ppiptr=r12=pointer to struct
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}

	mov r0,#0
	mov r2,#ppiSize/4
regLoop:
	subs r2,r2,#1
	strpl r0,[ppiptr,r2,lsl#2]
	bhi regLoop

	mov r0,#0xFF
	strb r0,[ppiptr,#ppiControl]

	ldmfd sp!,{lr}
	bx lr
;@----------------------------------------------------------------------------
PPI8255R:
;@----------------------------------------------------------------------------
	and r1,r1,#0x3
	ldr pc,[pc,r1,lsl#2]
	.long 0
ppiReadTable:
	.long PPI8255PortAR
	.long PPI8255PortBR
	.long PPI8255PortCR
	.long PPI8255PortDR
;@----------------------------------------------------------------------------
PPI8255PortAR:
;@----------------------------------------------------------------------------
	ldrb r1,[ppiptr,#ppiControl]
	tst r1,#0x10
	ldrbeq r0,[ppiptr,#ppiPortAOut]
	bxeq lr
	ldr r1,[ppiptr,#ppiPortAInFptr]
	cmp r1,#0
	bxne r1
	ldrbeq r0,[ppiptr,#ppiPortAIn]
	bx lr
;@----------------------------------------------------------------------------
PPI8255PortBR:
;@----------------------------------------------------------------------------
	ldrb r1,[ppiptr,#ppiControl]
	tst r1,#0x02
	ldrbeq r0,[ppiptr,#ppiPortBOut]
	bxeq lr
	ldr r1,[ppiptr,#ppiPortBInFptr]
	cmp r1,#0
	bxne r1
	ldrbeq r0,[ppiptr,#ppiPortBIn]
	bx lr
;@----------------------------------------------------------------------------
PPI8255PortCR:
;@----------------------------------------------------------------------------
	stmfd sp!,{r4,lr}
	ldrb r4,[ppiptr,#ppiControl]
	ands r4,r4,#0x09
	ldrne r1,[ppiptr,#ppiPortCInFptr]
	cmpne r1,#0
	ldrbeq r0,[ppiptr,#ppiPortCIn]
	blxne r1
	movs r4,r4,lsl#29
	orrcs r4,r4,#0xF0
	orrne r4,r4,#0x0F
	ldrb r2,[ppiptr,#ppiPortCOut]
	bic r2,r2,r4
	and r0,r0,r4
	orr r0,r0,r2
	ldmfd sp!,{r4,lr}
	bx lr
;@----------------------------------------------------------------------------
PPI8255PortDR:				;@ Allways returns 0xFF (depending on chip?)
;@----------------------------------------------------------------------------
	mov r0,#0xFF
	bx lr

;@----------------------------------------------------------------------------
PPI8255W:
;@----------------------------------------------------------------------------
	and r1,r1,#0x3
	ldr pc,[pc,r1,lsl#2]
	.long 0
ppiWriteTable:
	.long PPI8255PortAW
	.long PPI8255PortBW
	.long PPI8255PortCW
	.long PPI8255PortDW
;@----------------------------------------------------------------------------
PPI8255PortAW:
;@----------------------------------------------------------------------------
	strb r0,[ppiptr,#ppiPortAOut]
	ldrb r1,[ppiptr,#ppiControl]
	eor r1,r1,#0x10
	tst r1,#0x10
	ldrne r1,[ppiptr,#ppiPortAOutFptr]
	cmpne r1,#0
	bxeq lr
	bx r1
;@----------------------------------------------------------------------------
PPI8255PortBW:
;@----------------------------------------------------------------------------
	strb r0,[ppiptr,#ppiPortBOut]
	ldrb r1,[ppiptr,#ppiControl]
	eor r1,r1,#0x02
	tst r1,#0x02
	ldrne r1,[ppiptr,#ppiPortBOutFptr]
	cmpne r1,#0
	bxeq lr
	bx r1
;@----------------------------------------------------------------------------
PPI8255PortCChange:
	movs r1,r0,lsr#1
	and r1,r1,#0x07
	ldrb r0,[ppiptr,#ppiPortCOut]
	mov r2,#1
	biccc r0,r0,r2,lsl r1
	orrcs r0,r0,r2,lsl r1
;@----------------------------------------------------------------------------
PPI8255PortCW:
;@----------------------------------------------------------------------------
	strb r0,[ppiptr,#ppiPortCOut]
	ldrb r1,[ppiptr,#ppiControl]
	tst r1,#0x08
	orrne r0,r0,#0xF0
	tst r1,#0x01
	orrne r0,r0,#0x0F
	eor r1,r1,#0x09
	tst r1,#0x09
	ldrne r1,[ppiptr,#ppiPortCOutFptr]
	cmpne r1,#0
	bxeq lr
	bx r1
;@----------------------------------------------------------------------------
PPI8255PortDW:
;@----------------------------------------------------------------------------
	tst r0,#0x80
	beq PPI8255PortCChange
PPISetMode:								;@ this sets the mode for the 8255 PPI
	and r0,r0,#0x1B						;@ Bit4=Port A, Bit3=Port CH, Bit1=Port B, Bit0=Port CL, 0=out, 1=in.
	strb r0,[ppiptr,#ppiControl]
	bx lr

;@----------------------------------------------------------------------------
	.end
#endif // #ifdef __arm__
