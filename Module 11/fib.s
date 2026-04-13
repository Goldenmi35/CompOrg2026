#
#Program name: fib.s
#Program author: Eddy Wen
#Program Description: This program prompts the user for an input n and will return the nth fibonacci number
#
#
#

.global main
.extern printf
.extern scanf

.section .data
prompt_n:   .asciz "Enter n: "
result_str: .asciz "Fibonacci(%d) = %d\n"
input_fmt:  .asciz "%d"

n_val: .word 0

.section .text

# ---------------------------------
# int fib(int n)
# r0 = n
# returns r0 = F(n)
# ---------------------------------
fib:
    push {r4, lr}

    cmp r0, #0
    beq fib_zero

    cmp r0, #1
    beq fib_one

    mov r4, r0           @ save n

    sub r0, r0, #1
    bl fib               @ fib(n-1)

    push {r0}            @ save fib(n-1)

    mov r0, r4
    sub r0, r0, #2
    bl fib               @ fib(n-2)

    pop {r1}             @ restore fib(n-1)

    add r0, r0, r1       @ fib(n-1) + fib(n-2)

    pop {r4, lr}
    bx lr

fib_zero:
    mov r0, #0
    pop {r4, lr}
    bx lr

fib_one:
    mov r0, #1
    pop {r4, lr}
    bx lr


# ---------------------------------
# main
# ---------------------------------
main:
    push {lr}

    # prompt
    ldr r0, =prompt_n
    bl printf

    # read n
    ldr r0, =input_fmt
    ldr r1, =n_val
    bl scanf

    # load n
    ldr r0, =n_val
    ldr r0, [r0]

    mov r2, r0           @ save n

    # call fib
    bl fib

    mov r1, r0           @ result
    mov r3, r1           @ temp store result

    # reload n
    ldr r2, =n_val
    ldr r2, [r2]

    # printf("Fibonacci(%d) = %d\n", n, result)
    ldr r0, =result_str
    mov r1, r2           @ n
    mov r2, r3           @ result
    bl printf

    mov r0, #0
    pop {lr}
    bx lr
