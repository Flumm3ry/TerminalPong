DrawScreen:
	mov r4,r0	//player y
	and r6,r1,#255	//ball y
	lsr r1,#8
	and r5,r1,#255	//ball x

	mov r8,#0		//current row
	mov r9,#0		//current position in screen buffer
	ldr r11,=screenBuffer
	outerloop:
		mov r7,#0	//current column
		innerloop:
			mov r10,#WHITE_SPACE
			cmp r7,#0
			bne checkball	//if we are not in the first row, it cannot be the player pos so check if ball pos
			cmp r4,r8	//if the player y matches the current row, draw it
			bne endofinnerloop
			mov r10,#PLAYER
			b endofinnerloop
			checkball:
				cmp r7,r5
				bne endofinnerloop	//if the Xs do not match go to the end of the loop
				cmp r8,r6
				bne endofinnerloop	//if the Ys do not match go to the end of the loop
				mov r10,#BALL
			endofinnerloop:
				strb r10,[r11,r9]
				add r9,#1
				add r7,#1
				cmp r7,#6
			bne innerloop
		mov r10,#NEW_LINE
		strb r10,[r11,r9]
		add r9,#1
		add r8,#1
		cmp r8,#4
	bne outerloop
	mov r10,#0
	add r9,#1
	strb r10,[r11,r9]

	mov r0,#STD
	ldr r1,=screenBuffer
	mov r2,#SCREENBUFFERSIZE
	mov r7,#WRITE
	swi 0
bx lr