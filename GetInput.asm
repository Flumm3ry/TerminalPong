GetInput:
//no parameters
//returns 0,1 or 2 indicating what the input recieved was
    //0 represents no input
    //1 to indicate the user wants to move up
    //2 indicates the user wants to move down
	mov r0, #STD
	ldr r1, =inputPromt
	ldr r2, =inputPromtLen
	mov r7, #WRITE
	swi 0

    //get the input and put it into the buffer
	mov r0, #STD
	ldr r1, =buffer
	mov r2, #BUFFERSIZE
	mov r7, #READ
	swi 0

    //load r3 with the first byte from the buffer
	ldrb r3, [r1]

    //clear r0 and populate it with the input indicated by whats held in r3
	mov r0,#0
	cmp r3,#UP_CHAR
	addeq r0,#1

	cmp r3,#DWN_CHAR
	addeq r0,#2
bx lr