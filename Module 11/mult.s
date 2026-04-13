#
#Program name: mult.s
#Program author: Eddy Wen
#Program Description: This program prompts the user to enter a multiplier and then the number of times to add in order to get a multiplication. 
#It utilizes recursion instead of iteration
#

.global main
.extern printf
.extern scanf

.section .data
prompt_m:   .asciz "Enter m (multiplier): "
prompt_n:   .asciz "Enter n (times to add): "
result_str: .asciz "Result: %d\n"
input_fmt:  .asciz "%d"

m_val: .word 0
n_val: .word 0

.section .text

# ---------------------------------
# int mult(int m, int n)
# r0 = m
# r1 = n
# returns r0 = result
# ---------------------------------
mult:
    push {lr}            @ save return address

    cmp r1, #1           @ if (n == 1)
    beq base_case

    push {r0, r1}        @ save m and n

    sub r1, r1, #1       @ n - 1
    bl mult              @ recursive call

    pop {r2, r3}         @ restore original m (r2), n (r3)
    add r0, r2, r0       @ m + recursive result

    pop {lr}
    bx lr

base_case:
    @ return m (already in r0)
    pop {lr}
    bx lr


# ---------------------------------
# main function
# ---------------------------------
main:
    push {lr}

    # Prompt for m
    ldr r0, =prompt_m
    bl printf

    ldr r0, =input_fmt
    ldr r1, =m_val
    bl scanf

    # Prompt for n
    ldr r0, =prompt_n
    bl printf

    ldr r0, =input_fmt
    ldr r1, =n_val
    bl scanf

    # Load m and n
    ldr r0, =m_val
    ldr r0, [r0]     @ r0 = m

    ldr r1, =n_val
    ldr r1, [r1]     @ r1 = n

    # Call mult(m, n)
    bl mult

    # Print result
    mov r1, r0       @ result → r1
    ldr r0, =result_str
    bl printf

    mov r0, #0       @ return 0
    pop {lr}
    bx lr
