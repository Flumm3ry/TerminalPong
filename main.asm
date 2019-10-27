/* Pong in assembly terminal */

/* constantes */
.equ STD,	1
.equ EXIT,	1
.equ READ,	3
.equ WRITE,	4
.equ BUFFERSIZE,2
.equ SCREENBUFFERSIZE,30
.equ UP_CHAR,	119
.equ DWN_CHAR,	115
.equ WHITE_SPACE,42
.equ PLAYER,	108
.equ BALL,	48
.equ NEW_LINE,	10

/* Initialised data */
.section .data
welcomeMsg:
	.ascii "Welcome to pong\n"
welcomeLen = .- welcomeMsg
inputPromt:
	.ascii "Enter a character to play:\n"
inputPromtLen = .- inputPromt
gameOverMsg:
	.ascii "GAME OVER!\n"
gameOverLen = .- gameOverMsg

/* Uniinitialised data */
.section .bss
.comm buffer, 		BUFFERSIZE
.comm screenBuffer,	SCREENBUFFERSIZE

.section .text
.globl _start

_start:

mov r4,#1	//player starting position

mov r5,#2	//ball starting x
lsl r5,#8
orr r5,#1	//ball starting y

push {r7}
bl DisplayWelcomeMessage
pop {r7}

GameLoop:
mov r0,r4
mov r1,r5
push {r4-r11}
bl DrawScreen
pop {r4-r11}

push {r3,r7}
bl GetInput
pop {r3,r7}
mov r3,r0

mov r0,r4
mov r1,r3
push {r3,r4}
bl UpdatePlayer
pop {r3,r4}
mov r4,r0

mov r0,r5
mov r1,r4
push {r3-r5}
bl UpdateBall
pop {r3-r5}
mov r5,r0

mov r0,r5
push {r3}
bl CheckLose
pop {r3}
cmp r0,#1

bne GameLoop

b Exit

CheckLose:
	and r3,r0,#0xFF00
	lsr r3,#8
	
	mov r0,#0
	cmp r3,#0
	addeq r0,#1
bx lr

UpdateBall:
	mov r3,r1	//player position
	
	and r4,r0,#255	//ball y
	lsr r0,#8
	and r5,r0,#255	//ball x
	lsr r0,#8
	and r6,#3	//direction (bit 1 indicates moving left/right and 2 indicates up/down)
	
	//if the ball is in the top row, make sure it is moving down
	cmp r4,#0
	bne cont1
	bic r6,#1
	b cont2	

	//if the ball is in the bottom row, make sure it is moving up
	cont1:
	cmp r4,#3
	bne cont2
	orr r6,#1

	// if the ball hits the right wall, make sure it is moving left
	cont2:
	cmp r5,#5
	bne cont3
	orr r6,#2
	b moveBall
	
	//check to see if the player hits the ball or looses when the ball is on the far left
	cont3:
	cmp r5,#1
	bne moveBall
	cmp r4,r3
	bne moveBall
	bic r6,#2

	// move the ball in the directions indicated by the updated direction bits
	moveBall:
	tst r6,#1
	addeq r4,#1
	subne r4,#1
	tst r6,#2
	addeq r5,#1
	subne r5,#1

	//reconstruct the ball information into one register to return as a parameter
	mov r0,r6
	lsl r0,#16
	orr r0,r5
	lsl r0,#8
	orr r0,r4
bx lr


UpdatePlayer:
	mov r3,r0	//player position
	mov r4,r1	//user input
	
	cmp r4,#1
	beq movePlayerUp
	bhi movePlayerDown
	blo exitUpdatePlayer	

	movePlayerUp:
		cmp r3,#0
		subne r3,#1
	b exitUpdatePlayer

	movePlayerDown:
		cmp r3,#3
		addne r3,#1

	exitUpdatePlayer:
		mov r0,r3
bx lr


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


DisplayWelcomeMessage:
	mov r0, #STD
	ldr r1, =welcomeMsg
	ldr r2, =welcomeLen
	mov r7, #WRITE
	swi 0
bx lr


GetInput:
	mov r0, #STD
	ldr r1, =inputPromt
	ldr r2, =inputPromtLen
	mov r7, #WRITE
	swi 0

	mov r0, #STD
	ldr r1, =buffer
	mov r2, #BUFFERSIZE
	mov r7, #READ
	swi 0
	ldrb r3, [r1]
	
	mov r0,#0
	cmp r3,#UP_CHAR
	addeq r0,#1
	
	cmp r3,#DWN_CHAR
	addeq r0,#2
bx lr

Exit:
	mov r0, #STD
	ldr r1, =gameOverMsg
	ldr r2, =gameOverLen
	mov r7, #WRITE
	swi 0

	mov r0, #0
	mov r7, #1
	swi 0
