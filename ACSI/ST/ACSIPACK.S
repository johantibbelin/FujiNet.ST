;------------------------------------
; ACSI packet testing
;
; Written by: Johan Tibbelin (sjfroos)
;-------------------------------------

;***	EQUs

dma 	= $ffff8606
dmadata	= $ffff8604
dmaadrhi= $ffff8609
dmaadrmi= $ffff860b
dmaadrlo= $ffff860d
flock	= $43e
hz200	= $4ba
hdv_bpb	= $472
hdv_rw	= $476
hdv_boot= $47a
hdv_init= $46a
drv_bits= $4c2
gpio	= $fffffa01

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

;**	Reset dma - toggle

	move.w #$190,dma
	move.w #$090,dma
	move.w #$190,dma

	move.w #$88,dma ;A1 = 0
	move.w #$ffff,dmadata

	move.l #send_txt,-(sp)
	move.w #9,-(sp)
	trap #1
	addq.l #6,sp

;	wait key
	
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
packs_txt:
	dc.b 10,13,"Packet sent.",10,13,0
packr_txt:
	dc.b 10,13,"Packet recived.",10,13,0
s_sp:	ds.l 1
