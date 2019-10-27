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