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

;****
;	EQUs
;
;---
;	dma
;
floc 	= $43e
hz200	= $4ba
dma	= $ff8606
data	= $ff8604
gpip	= $fffa01
dma_lo	= $ff860d
dma_mid = $ff860b
dma_hi	= $ff8609	

;----
;	Floppy and drives
;
bootdev	= $446
hdv_init= $46a
hdv_bpb	= $472
hdv_rw	= $476
hdv_boot= $47a
drvbits	= $4c2

;*****
;	Program start

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

;	move.l #1,d1	
irqtst: move.w #256,$ff8606
;	btst.b #5,$fffa01
;	beq .print

;**	Wait 

;	move.l 2,d0
;.loop:	move.w #37,-(sp)
;	trap #14
;	addq.l #2,sp

;	move.w #37,-(sp)
;	trap #14
;	addq.l #2,sp

;**	Test for space

.tstkey:cmp.b #$39,$fffc02
	beq quit

;       dbra d0,.loop

	jmp .tstkey

.print:	move.l #text,-(sp)
	move.w #9,-(sp)
	trap #1
	addq.l #6,sp	
.wait:  btst.b #5,$fffa01
	bne .wait
	jmp .tstkey

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