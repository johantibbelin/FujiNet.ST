;------------------------------------
; 	Acsi2esp32
;
;  Small test program, that tests:
;
;	-IRQ signal
;	-Data request (DRQ)
;	-Read/write
;  
;
;-------------------------------------
; Written by: Johan Tibbelin (sjfroos)
;-------------------------------------
; Begun: 2022-05-12
;-------------------------------------

init:


;**	Correct basepage
;       and setup stack

	move.l 4(sp),a5
	move.l $0c(a5),d0
	add.l $14(a5),d0
	add.l $1c(a5),d0
	add.l #$1000,d0
	add.l #$100,d0
	move.l a5,d1
	add.l d0,d1

	and.l #-2,d1

	move.l d1,sp
	move.l d0,-(sp)
	move.l a5,-(sp)
	move.w d0,-(sp)
	move.w #$4a,-(sp)
	trap #1
	lea 12(sp),sp

;**	Enter supervisor mode

	clr.l -(sp)
	move.w #$20,-(sp)
	trap #1
	addq.l #6,sp
	move.l d0,s_sp

;**	poling for DMA IRQ
	
irqtst: btst.b #5,$fffa01	
	beq .print

;**	Wait Vsync x2

	move.w #37,-(sp)
	trap #14
	addq.l #2,sp

	move.w #37,-(sp)
	trap #14
	addq.l #2,sp

;**	Test for space

	cmp.b #$39,$fffc02
	beq quit

	jmp irqtst

.print:	move.l #text,-(sp)
	move.w #9,-(sp)
	trap #1
	addq.l #6,sp	
	jmp irqtst

quit:

;**	Enter user mode and quit

	move.l s_sp,-(sp)
	move.w #$20,-(sp)
	trap #1
	addq.l #6,sp

	move.w #0,-(sp)
	trap #1

;----------------------------------------
; Variables etc
;----------------------------------------

;**	User stack pointer
s_sp:	ds.l 1
text:	dc.b "DMA IRQ detected.",10,13,0