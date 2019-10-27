/* Pong in assembly terminal */

/* constantes */
.equ BUFFERSIZE,2
.equ SCREENBUFFERSIZE,30    // 4x6 board. 1 byte for each cell and 1 for each new line character

/* Initialised data */
.section .data
welcomeMsg:
	.ascii "Welcome to pong\n"
welcomeLen = .- welcomeMsg
inputPromt:
	.ascii "Enter a character to play:\n"
inputPromtLen = .- inputPromt
gameOverMsg:
	.ascii "GAME OVER!\n"
gameOverLen = .- gameOverMsg

/* Uniinitialised data */
.section .bss
.comm buffer, 		BUFFERSIZE          //buffer for holding user input
.comm screenBuffer,	SCREENBUFFERSIZE

.section .text
.globl _start

_start:
    mov r4,#1	//player starting position

    mov r5,#2	//ball starting x
    lsl r5,#8
    orr r5,#1	//ball starting y

    push {r7}
    bl DisplayWelcomeMessage
    pop {r7}

    GameLoop:
        mov r0,r4
        mov r1,r5
        push {r4-r11}
        bl DrawScreen
        pop {r4-r11}

        push {r3,r7}
        bl GetInput
        pop {r3,r7}
        mov r3,r0

        mov r0,r4
        mov r1,r3
        push {r3,r4}
        bl UpdatePlayer
        pop {r3,r4}
        mov r4,r0

        mov r0,r5
        mov r1,r4
        push {r3-r5}
        bl UpdateBall
        pop {r3-r5}
        mov r5,r0

        mov r0,r5
        push {r3}
        bl CheckLose
        pop {r3}
        cmp r0,#1

    bne GameLoop        //only loop if the user hasnt lost yet

b Exit
