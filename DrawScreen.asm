/* constantes */
.equ STD,	1
.equ WRITE,	4
.equ SCREENBUFFERSIZE,30    // 4x6 board. 1 byte for each cell and 1 for each new line character
.equ WHITE_SPACE,42         // '*'
.equ PLAYER,	108         // 'l'
.equ BALL,	48              // '0'
.equ NEW_LINE,	10          // '\n'

DrawScreen:
//2 parameters: r0 - player y position, r1 - ball position information
//no returns
	mov r4,r0	    //player y
	and r6,r1,#255	//ball y
	lsr r1,#8
	and r5,r1,#255	//ball x

	mov r8,#0		//current row
	mov r9,#0		//current position in screen buffer
	ldr r11,=screenBuffer   //store the screen buffer in r11 so it can be written to
	outerloop:
		mov r7,#0	//current column
		innerloop:
			mov r10,#WHITE_SPACE    //populate the register to write to the buffer with white space by default
			cmp r7,#0
			bne checkball	        //if we are not in the first row, it cannot be the player pos so check if ball pos
			cmp r4,r8
			bne endofinnerloop      //if the player y matches the current row, draw it
			mov r10,#PLAYER         //set the register to write to the buffer to the ascii value of the player
			b endofinnerloop
			checkball:
				cmp r7,r5
				bne endofinnerloop	//if the Xs do not match go to the end of the loop
				cmp r8,r6
				bne endofinnerloop	//if the Ys do not match go to the end of the loop
				mov r10,#BALL       //else, set the register to write to the buffer to the ascii value of the ball
			endofinnerloop:
				strb r10,[r11,r9]   //store the byte in the screen buffer at the right position
				add r9,#1           //increment the byte offset for the screen buffer
				add r7,#1           //increment the current column
				cmp r7,#6
			bne innerloop           //loop until the column number is 6
		mov r10,#NEW_LINE           //write a new line character at the end of each column
		strb r10,[r11,r9]
		add r9,#1                   //increment the byte offset for the screen buffer
		add r8,#1                   //increment the rown number
		cmp r8,#4
	bne outerloop                   //loop until the row number is 4
	mov r10,#0                      //ends the screen buffer with the null character
	strb r10,[r11,r9]

    //write the screen buffer to the screen
	mov r0,#STD
	ldr r1,=screenBuffer
	mov r2,#SCREENBUFFERSIZE
	mov r7,#WRITE
	swi 0
bx lr