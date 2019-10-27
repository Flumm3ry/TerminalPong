/* constantes */
.equ STD,	1
.equ EXIT,	1
.equ WRITE,	4

Exit:
//no parameters
//returns nothing
//Prints the game over message and exits the program
	mov r0, #STD
	ldr r1, =gameOverMsg
	ldr r2, =gameOverLen
	mov r7, #WRITE
	swi 0

	mov r0, #0
	mov r7, #EXIT
	swi 0