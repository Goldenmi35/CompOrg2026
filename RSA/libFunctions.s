    .text
    .global gcd
    .global isPrime

    .extern __aeabi_idiv

/* --------------------------------------------------
   int gcd(int a, int b)
-------------------------------------------------- */
gcd:
    push {r4, r5, lr}

gcd_loop:
    cmp r1, #0
    beq gcd_done

    mov r4, r0      @ save a
    mov r5, r1      @ save b

    mov r0, r4      @ r0 = a
    mov r1, r5      @ r1 = b
    bl __aeabi_idiv @ r0 = a / b

    mul r3, r0, r5  @ (a/b)*b
    sub r3, r4, r3  @ remainder = a - (a/b)*b

    mov r0, r5      @ a = b
    mov r1, r3      @ b = remainder

    b gcd_loop

gcd_done:
    pop {r4, r5, pc}

isPrime:
    push {r4, r5, r6, lr}

    mov r6, r0          @ save n

    cmp r0, #2
    blt not_prime
    cmp r0, #2
    beq prime

    mov r4, #2          @ i = 2

loop:
    mul r5, r4, r4
    cmp r5, r6
    bgt prime

    mov r0, r6          @ restore n
    mov r1, r4
    bl __aeabi_idiv     @ r0 = n / i

    mul r5, r0, r4
    sub r5, r6, r5      @ remainder

    cmp r5, #0
    beq not_prime

    add r4, r4, #1
    b loop

prime:
    mov r0, #1
    b done

not_prime:
    mov r0, #0

done:
    pop {r4, r5, r6, pc}



