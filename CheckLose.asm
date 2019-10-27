CheckLose:
//1 param: r0 holds the ball information
//'Bool' value returned holding 0 if the user has not lost or 1 if they have
    mov r3,#0           //clear r3
	and r3,r0,#0xFF00   //get the x position from the ball info register

	mov r0,#0           // clear r0 so it can be returned as a parameter
	cmp r3,#0           // chcek if the x position is 0 meaning the game is over
	addeq r0,#1         //return 1 if the player has lost otherwise return 0
bx lr