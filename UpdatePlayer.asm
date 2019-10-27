UpdatePlayer:
//2 parameters: r0 - player y position, r1 - User input selection
	mov r3,r0	//player position
	mov r4,r1	//user input

	cmp r4,#1
	beq movePlayerUp        //if the user input is 1, move the player up
	bhi movePlayerDown      //if the user input is 2, move the player down
	blo exitUpdatePlayer    //if the user input is 0, do not move the player

	movePlayerUp:
		cmp r3,#0
		subne r3,#1         //only move the player up if they are not already at the top
	b exitUpdatePlayer

	movePlayerDown:
		cmp r3,#3
		addne r3,#1         //onlly move the player down if they are not already at the bottom

	exitUpdatePlayer:
		mov r0,r3
bx lr