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
	mov r7, #1
	swi 0