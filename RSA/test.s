    .text
    .global run_tests
    .extern gcd
    .extern isPrime
    .extern printf

.data
gcd_fmt:     .asciz "gcd(%d, %d) = %d\n"
prime_fmt:   .asciz "%d is prime? %d\n"

.text

run_tests:
    push {r4-r7, lr}

    /* ---- GCD TEST ---- */
    mov r0, #480
    mov r1, #180
    bl gcd
    mov r4, r0          @ save result

    ldr r0, =gcd_fmt
    mov r1, #480
    mov r2, #180
    mov r3, r4
    bl printf

    /* ---- PRIME TEST (7) ---- */
    mov r0, #7
    bl isPrime
    mov r4, r0

    ldr r0, =prime_fmt
    mov r1, #7
    mov r2, r4
    bl printf

    /* ---- PRIME TEST (10) ---- */
    mov r0, #10
    bl isPrime
    mov r4, r0

    ldr r0, =prime_fmt
    mov r1, #10
    mov r2, r4
    bl printf

    pop {r4-r7, pc}
