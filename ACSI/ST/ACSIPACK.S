;------------------------------------
; ACSI packet testing
;
; Written by: Johan Tibbelin (sjfroos)
;-------------------------------------

;***	EQUs

dma 	= $ff8606
dmadata	= $ff8604
dmaadrhi= $ff8609
dmaadrmi= $ff860b
dmaadrlo= $ff860d
flock	= $43e
hz200	= $4ba
hdv_bpb	= $472
hdv_rw	= $476
hdv_boot= $47a
hdv_init= $46a
drv_bits= $4c2
gpip	= $fffa01

;****	Program start

start:

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

;**	Print start message

	move.l #start_txt,-(sp)
	move.w #9,-(sp)
	trap #1
	addq.l #6,sp

	st flock ; disable fdc

	move.l #255,d6
	move.l d6,d7
;**	Reset dma - toggle

	swap d7
	move.w #$188,d7

write:	move.w #$088,dma
	move.w #$188,dma

;**	write data ($ff)
;	move.w #$18a,dma
	move.l d7,dmadata

;**	write text

	move.l #send_txt,-(sp)
	move.w #9,-(sp)
	trap #1
	addq.l #6,sp

;**	Wait ack

	moveq.l #2,d1
	add.l hz200,d1

del20mic:cmp.l hz200,d1
	bge del20mic

	move.l #600,d1
	add.l hz200,d1

del3sec:btst.b #5,gpip
	beq exit
	cmp.l hz200,d1
	bge del3sec

	moveq.l #-1,d0

	move.l #timeout_txt,-(sp)
	move.w #9,-(sp)
	trap #1
	addq.l #6,sp
	jmp nej

exit:	
	swap d7
	sub.w #1,d7
	swap d7
	move.l #irq_txt,-(sp)
	move.w #9,-(sp)
	trap #1
	addq.l #6,sp

waitlo:	btst.b #5,gpip
	bne waitlo

	move.l #irq_res,-(sp)
	move.w #9,-(sp)
	trap #1
	addq.l #6,sp

	move.l #80,d1
	add.l hz200,d1
.w2:	cmp.l hz200,d1
	bge .w2
	dbra d6,write

;**	wait key
	
nej	cmp.b #$39,$fffc02
	bne nej

	sf flock ; Enable fdc again

;	leave supervisor mode	

	move.l s_sp,-(sp)
	move.w #$20,-(sp)
	trap #1
	addq.l #6,sp

;***	quit

	move.w #0,-(sp)
	trap #1

;****	Data etc

start_txt:
	dc.b 27,'E',"ACSI packet send test",10,13,0
send_txt:
	dc.b 10,13,"Byte sent.",10,13,0
irq_txt:
	dc.b 10,13,"IRQ recived.",10,13,0
irq_res:
	dc.b 10,13,"IRQ restored.",10,13,0
packs_txt:
	dc.b 10,13,"Packet sent.",10,13,0
packr_txt:
	dc.b 10,13,"Packet recived.",10,13,0
timeout_txt:
	dc.b 10,13,"Timeout, ack not recieved.",10,13,0 
s_sp:	ds.l 1
buffer:	ds.b 1024
