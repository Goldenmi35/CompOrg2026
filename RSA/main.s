    .text
    .global main
    .extern printf
    .extern scanf
    .extern isPrime
    .extern gcd
    .extern run_tests

.data
prompt:      .asciz "Enter a number (0-50, prime only): "
invalid:     .asciz "Invalid input. Try again.\n"
scan_fmt:    .asciz "%d"
result_fmt:  .asciz "GCD(%d, %d) = %d\n"
test:	     .asciz "This be a test\n"

.bss
num1: .skip 4
num2: .skip 4

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

    b compute

invalid_second:
    ldr r0, =invalid
    bl printf
    b get_second


/* -------- COMPUTE GCD -------- */
compute:

    ldr r4, =num1
    ldr r0, [r4]

    ldr r5, =num2
    ldr r1, [r5]

    bl gcd
    mov r6, r0          @ result

    ldr r0, =result_fmt
    ldr r1, [r4]
    ldr r2, [r5]
    mov r3, r6
    bl printf

    mov r0, #0
    pop {r4-r7, pc}
