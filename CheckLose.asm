CheckLose:
	and r3,r0,#0xFF00
	lsr r3,#8

	mov r0,#0
	cmp r3,#0
	addeq r0,#1
bx lr