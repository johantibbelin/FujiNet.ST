	clr.l -(sp)
	move.w #$20,-(sp)
	trap #1
	addq.l #6,sp
	move.l d0,s_sp

start:  move.w #88,$43e ;floc

	move.w #$190,$ff8606
	move.w #$90,$ff8606
	move.w #$190,$ff8606
	bsr wait
	move.w #$90,$ff8606
	move.w #$190,$ff8606
	move.w #$90,$ff8606
	bsr wait
	jmp start

quit:	move.w #0,$43e
	move.l s_sp,-(sp)
	move.w #$20,-(sp)
	trap #1
	addq.l #6,sp

	move.w #0,-(sp)
	trap #1


wait:	move #100,d0
.loop:	move.w #$25,-(sp)
	trap #14
	addq.l #2,sp

	cmp.b #$39,$fffc02
	beq quit
	dbra d0,.loop
	rts

s_sp:	ds.l 1
