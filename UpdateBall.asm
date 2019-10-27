UpdateBall:
// 2 params: r0 - register holding ball information, r1 - player y position
//returns updated ball information
	mov r3,r1	//player position

	and r4,r0,#255	//ball y
	lsr r0,#8
	and r5,r0,#255	//ball x
	lsr r0,#8
	and r6,#3	    //direction (bit 1 indicates moving left/right and 2 indicates up/down)

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