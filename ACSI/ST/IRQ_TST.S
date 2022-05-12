;------------------------------------
; 	ACSI2ESP32
;
;  Smal test program, that tests:
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

;**     Enter supervisor and save stack pointer

	clr.l -(sp)
	move.w #$20,-(sp)
	trap #1
	addq.l #6,sp
	move.l d0,s_sp


;----------------------------------------
; Variables etc
;----------------------------------------

;**	User stack pointer
s_sp:	ds.l 1