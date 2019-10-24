/* Pong in assembly terminal */

/* constantes */
.equ STD,	1
.equ EXIT,	1
.equ WRITE,	4
.equ BUFFERSIZE,1

/* Initialised data */
.section .data
welcomeMsg:
	.ascii "Welcome to pong \n"
welcomeLen = .- welcomeMsg

/* Uniinitialised data */
.section .bss
.comm buffer, BUFFERSIZE

.section .text
.globl _start

_start:
bl DisplayWelcomeMessage
bl Exit


DisplayWelcomeMessage:
	mov r0, #STD
	ldr r1, =welcomeMsg
	ldr r2, =welcomeLen
	mov r7, #WRITE
	swi 0
bx lr

Exit:
	mov r0, #0
	mov r7, #1
	swi 0
	
