/* Pong in assembly terminal */

/* constantes */
.equ STD,	1
.equ EXIT,	1
.equ READ,	3
.equ WRITE,	4
.equ BUFFERSIZE,2
.equ UP_CHAR,	119
.equ DWN_CHAR,	115

/* Initialised data */
.section .data
welcomeMsg:
	.ascii "Welcome to pong\n"
welcomeLen = .- welcomeMsg
inputPromt:
	.ascii "Enter a character to play:\n"
inputPromtLen = .- inputPromt
Player:
	.ascii "l"
Ball:
	.ascii "O"

/* Uniinitialised data */
.section .bss
.comm buffer, BUFFERSIZE

.section .text
.globl _start

_start:

mov sp,$1000

bl DisplayWelcomeMessage
//push {r4-r8}
mov r0,#2
mov r1,#3
//push {r1}
//mov r1,sp
bl DrawScreen
//pop {r1}
//pop {r4-r8}
bl GetInput
bl Exit

DrawScreen:
	mov r4,r0	//player y	
	//ldrb r5,[r1]	//ball x
	mov r5,#2
	lsl r1,#8
	//ldrb r6,[r1]	//ball y
		mov r6,#0

	mov r8,#0		//current row
	outerloop:
		mov r7,#0	//current column
		innerloop:
			cmp r7,#0
			bne checkball	//if we are not in the first row, it cannot be the player pos so check if ball pos
			cmp r4,r8	//if the player y matches the current row, draw it
			bne endofinnerloop
			//Draw player
			add r9,#1
			b endofinnerloop
			checkball:
				cmp r7,r5
				bne endofinnerloop	//if the Xs do not match go to the end of the loop
				cmp r8,r6
				bne endofinnerloop	//if the Ys do not match go to the end of the loop
				//Draw ball
				add r10,#1
			endofinnerloop:
		add r7,#1
		cmp r7,#6
		bne innerloop
	add r8,#1
	cmp r8,#6
	bne outerloop
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
	ldrb r0, [r1]
bx lr

Exit:
	mov r0, #0
	mov r7, #1
	swi 0
