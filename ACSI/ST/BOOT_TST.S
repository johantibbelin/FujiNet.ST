;------------------------------------
; FujiNet boot test
;            - Just prints some text
;------------------------------------
; Written by: Johan Tibbelin(sjfroos)
;------------------------------------

;***	EQUs

hz200 = $4ba

start:
	move.l #0,-(sp)
	move.w #$20,-(sp)
	trap #1
	move.l d0,s_sp

	move.l #text,-(sp)
	move.w #9,-(sp)
	trap #1
	addq.l #6,sp

;**	wait 2 seconds

	move.l #400,d1
	add.l hz200,d1
.wait:	cmp.l hz200,d1
	bge .wait
	
	move.l s_sp,-(sp)
	move.w #$20,-(sp)
	trap #1
	addq.l #6,sp

	move.w #0,-(sp)
	trap #1

text:	dc.b 27,"E","  FujiNet Boot test",10,13,10,13,"Version: 0.01",0
s_sp:	ds.l 1
