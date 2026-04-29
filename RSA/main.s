    .text
    .global main
    .extern printf
    .extern scanf
    .extern isPrime
    .extern gcd
    .extern run_tests

.data
prompt:      .asciz "Enter a number (0-50, prime only): "
prompt2:     .asciz "Enter E (must be greater than 0 and less than %d)\n"
invalid:     .asciz "Invalid input. Try again.\n"
scan_fmt:    .asciz "%d"
result_fmt:  .asciz "GCD(%d, %d) = %d\n"
test:	     .asciz "This be a test\n"
mod_chk: .asciz "Mod: %d\n"
tot_chk: .asciz "Tot: %d\n"

.bss
num1: .skip 4
num2: .skip 4
num3: .skip 4
mod:  .skip 4
tot:  .skip 4

.text

main:
    push {r4-r7, lr}

    bl run_tests

/* -------- FIRST NUMBER -------- */
get_first:
    ldr r0, =prompt
    bl printf

    ldr r0, =scan_fmt
    ldr r1, =num1
    bl scanf

    ldr r4, =num1
    ldr r0, [r4]

    cmp r0, #0
    blt invalid_first
    cmp r0, #50
    bgt invalid_first

    ldr r0, [r4]
    bl isPrime
    cmp r0, #1
    bne invalid_first

    b get_second

invalid_first:
    ldr r0, =invalid
    bl printf
    b get_first


/* -------- SECOND NUMBER -------- */
get_second:
    ldr r0, =prompt
    bl printf

    ldr r0, =scan_fmt
    ldr r1, =num2
    bl scanf

    ldr r5, =num2
    ldr r0, [r5]

    cmp r0, #0
    blt invalid_second
    cmp r0, #50
    bgt invalid_second

    ldr r0, [r5]
    bl isPrime
    cmp r0, #1
    bne invalid_second

    b calc_mod 

invalid_second:
    ldr r0, =invalid
    bl printf
    b get_second

calc_mod: 
    ldr r4,=num1
    ldr r0, [r4]
    
    ldr r5,=num2
    ldr r1, [r5]

    mul r6, r0, r1 //this is the modulus. 
    ldr r0, =mod
    str r6, [r0]
    mov r1, r6
    ldr r0, =mod_chk
    bl printf

totient:
   ldr r4,=num1
   ldr r0, [r4]
   sub r0, r0, #1

   ldr r5,=num2
   ldr r1, [r5]
   sub r1, r1, #1

   mul r6, r0, r1 //This is the totient
   ldr r0, =tot
   str r6, [r0]
   mov r1, r6
   ldr r0, =tot_chk
   bl printf  
    
get_e: 
    ldr r0, =prompt2
    ldr r4, =tot
    ldr r1, [r4]
    bl printf

    ldr r0, =scan_fmt
    ldr r1, =num3
    bl scanf

    ldr r4, =num3
    ldr r0, [r4]
    
    ldr r4, =tot
    ldr r1, [r4]

    cmp r0, #0
    blt invalid_e
    cmp r0, r1
    bgt invalid_e

compute:

    ldr r4, =tot
    ldr r0, [r4]

    ldr r5, =num3
    ldr r1, [r5]

    bl gcd
    mov r6, r0          @ result
    cmp r6, #1
    bne invalid_e

    b next 

invalid_e:
    ldr r0, =invalid
    bl printf
    b get_e

next:
    mov r0, #0
    pop {r4-r7, pc}
