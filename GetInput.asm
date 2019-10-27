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
	ldrb r3, [r1]

	mov r0,#0
	cmp r3,#UP_CHAR
	addeq r0,#1

	cmp r3,#DWN_CHAR
	addeq r0,#2
bx lr