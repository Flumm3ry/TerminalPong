/* constantes */
.equ STD,	1
.equ WRITE,	4

DisplayWelcomeMessage:
//no parameters
//returns nothing
	mov r0, #STD
	ldr r1, =welcomeMsg
	ldr r2, =welcomeLen
	mov r7, #WRITE
	swi 0
bx lr