@Program name: main.s
@Author name: Eddy Wen
@Program Description: Program contains two functions. One is a prime generator and the second is a number guessing game. The prime checker prompts the user for a value and then lists the prime values between 3 and the n provided. The number guessing game prompts the user for a max value and generates a random number in between 1 and n. The user then must guess what that number is with the program giving hints on whether the guess was too high or low. 
@

.global main
.extern printf, scanf, rand, srand, time

.section .data
@ ---- Shared formats ----
input_fmt:        .asciz "%d"
prime_fmt:        .asciz "%d "

@ ---- Prime program ----
prompt_n:         .asciz "Enter n: "

@ ---- Guessing game ----
prompt_max:       .asciz "\nEnter maximum value: "
prompt_guess:     .asciz "Enter your guess: "
high_msg:         .asciz "Too high\n"
low_msg:          .asciz "Too low\n"
correct_msg:      .asciz "Correct!\n"
count_msg:        .asciz "Total guesses: %d\n"

.section .text

main:
    push {lr}

    @ =========================
    @ PART 1: PRIME NUMBERS
    @ =========================

    @ prompt for n
    ldr r0, =prompt_n
    bl printf

    sub sp, sp, #4
    mov r1, sp
    ldr r0, =input_fmt
    bl scanf
    ldr r4, [sp]        @ r4 = n
    add sp, sp, #4

    mov r5, #3          @ i = 3

prime_outer:
    cmp r5, r4
    bgt prime_done

    mov r6, #1          @ isPrime = 1
    mov r7, #2          @ j = 2

prime_inner:
    mov r8, r5
    lsrs r9, r5, #1     @ r9 = i/2

    cmp r7, r9
    bgt prime_check

    mov r10, r5         @ temp = i

prime_rem_loop:
    cmp r10, r7
    blt prime_rem_done
    sub r10, r10, r7
    b prime_rem_loop

prime_rem_done:
    cmp r10, #0
    bne prime_next_j

    mov r6, #0          @ not prime
    b prime_check

prime_next_j:
    add r7, r7, #1
    b prime_inner

prime_check:
    cmp r6, #1
    bne prime_next_i

    mov r1, r5
    ldr r0, =prime_fmt
    bl printf

prime_next_i:
    add r5, r5, #1
    b prime_outer

prime_done:

    @ =========================
    @ PART 2: GUESSING GAME
    @ =========================

    @ seed random
    mov r0, #0
    bl time
    bl srand

    @ prompt max
    ldr r0, =prompt_max
    bl printf

    sub sp, sp, #4
    mov r1, sp
    ldr r0, =input_fmt
    bl scanf
    ldr r4, [sp]        @ r4 = max (reuse safely)
    add sp, sp, #4

    @ target = rand() % max + 1
    bl rand
    mov r1, r4

mod_loop:
    cmp r0, r1
    blt mod_done
    sub r0, r0, r1
    b mod_loop

mod_done:
    add r5, r0, #1      @ r5 = target
    mov r6, #0          @ guess count

guess_loop:
    ldr r0, =prompt_guess
    bl printf

    sub sp, sp, #4
    mov r1, sp
    ldr r0, =input_fmt
    bl scanf
    ldr r7, [sp]        @ guess
    add sp, sp, #4

    add r6, r6, #1

    cmp r7, r5
    beq guess_correct
    bgt guess_high

guess_low:
    ldr r0, =low_msg
    bl printf
    b guess_loop

guess_high:
    ldr r0, =high_msg
    bl printf
    b guess_loop

guess_correct:
    ldr r0, =correct_msg
    bl printf

    mov r1, r6
    ldr r0, =count_msg
    bl printf

    pop {lr}
    bx lr
