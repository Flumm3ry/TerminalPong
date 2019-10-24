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

/* Uniinitialised data */
.section .bss
.comm buffer, BUFFERSIZE

.section .text
.globl _start

_start:
bl DisplayWelcomeMessage
bl GetInput
bl Exit


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
