#
#Program Name: fact.s
#Program Author: Eddy Wen
#Program Description: This program prompts the user for a number and will return the factorial corresponding to user input. 
#
#
#

.global main
.extern printf
.extern scanf

.section .data
prompt_n:     .asciz "Enter n (>= 0): "
result_str:   .asciz "factorial(%d) = %d\n"
error_str:    .asciz "Error: n must be >= 0\n"
overflow_str: .asciz "Warning: n too large for 32-bit int (try n <= 12)\n"
input_fmt:    .asciz "%d"

n_val: .word 0

.section .text

# ---------------------------------
# int mult(int a, int b)
# r0 = a, r1 = b
# returns r0 = a * b (via addition)
# ---------------------------------
mult:
    push {r4, lr}

    mov r2, #0       @ result = 0
    mov r3, r1       @ counter = b

mult_loop:
    cmp r3, #0
    beq mult_done

    add r2, r2, r0   @ result += a
    sub r3, r3, #1
    b mult_loop

mult_done:
    mov r0, r2       @ return result

    pop {r4, lr}
    bx lr 

# ---------------------------------
# int fact(int n)
# r0 = n
# returns r0 = n!
# ---------------------------------
fact:
    push {r4, lr}

    cmp r0, #0
    beq fact_base

    cmp r0, #1
    beq fact_base

    mov r4, r0           @ save n

    sub r0, r0, #1
    bl fact              @ fact(n-1)

    mov r1, r0           @ r1 = fact(n-1)
    mov r0, r4           @ r0 = n

    bl mult              @ n * fact(n-1)

    pop {r4, lr}
    bx lr

fact_base:
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

    # check n < 0
    cmp r0, #0
    blt input_error

    mov r2, r0           @ save n

    # warn if n > 12 (32-bit overflow risk)
    cmp r0, #12
    ble compute
    ldr r0, =overflow_str
    bl printf

compute:
    ldr r0, =n_val
    ldr r0, [r0]

    bl fact

    mov r1, r0           @ result
    mov r3, r1           @ temp

    # reload n
    ldr r2, =n_val
    ldr r2, [r2]

    # printf
    ldr r0, =result_str
    mov r1, r2           @ n
    mov r2, r3           @ result
    bl printf

    mov r0, #0
    pop {lr}
    bx lr


input_error:
    ldr r0, =error_str
    bl printf

    mov r0, #0
    pop {lr}
    bx lr
