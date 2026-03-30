@Program Name: main.s
@Author: Eddy Wen
@Description: This is the main function which acts like a driver. Takes in some input and then outputs the function as way of error checking
@

.extern ChkAlphaLOG
.extern ChkAlphaNOLOG
.extern findMAXOf3
.extern Grade
.extern printf
.extern scanf

.text
.global main
.align 2

main:
    push {r4, lr}
    sub sp, sp, #16         @ Space for local variables

    @ --- ChkAlphaLOG ---
    ldr r0, =prompt_char
    bl printf
    ldr r0, =fmt_char
    mov r1, sp
    bl scanf
    ldrb r0, [sp]           @ Get char from stack
    bl ChkAlphaLOG          @ Call function in libFunctions.s
    mov r1, r0
    ldr r0, =res_alpha
    bl printf

    @ --- ChkAlphaNOLOG ---
    ldr r0, =prompt_char
    bl printf
    ldr r0, =fmt_char
    mov r1, sp
    bl scanf
    ldrb r0, [sp]
    bl ChkAlphaNOLOG
    mov r1, r0
    ldr r0, =res_alpha
    bl printf

    @ --- findMAXOf3 ---
    ldr r0, =prompt_nums
    bl printf
    ldr r0, =fmt_int; add r1, sp, #4; bl scanf
    ldr r0, =fmt_int; add r1, sp, #8; bl scanf
    ldr r0, =fmt_int; add r1, sp, #12; bl scanf
    ldr r0, [sp, #4]
    ldr r1, [sp, #8]
    ldr r2, [sp, #12]
    bl findMAXOf3
    mov r1, r0
    ldr r0, =res_max
    bl printf

    @ --- Grade ---
    ldr r0, =prompt_student
    bl printf
    ldr r0, =fmt_str
    ldr r1, =student_name
    bl scanf
    
    ldr r0, =prompt_score
    bl printf
    ldr r0, =fmt_int
    mov r1, sp
    bl scanf
    ldr r0, [sp]
    bl Grade
    
    cmp r0, #'E'
    beq .print_err
    
    mov r2, r0
    ldr r1, =student_name
    ldr r0, =res_grade
    bl printf
    b .done

.print_err:
    ldr r0, =err_msg
    bl printf

.done:
    add sp, sp, #16
    pop {r4, pc}

.data
    prompt_char:    .asciz "\nEnter a character: "
    prompt_nums:    .asciz "Enter 3 integers (space separated): "
    prompt_student: .asciz "Enter student name: "
    prompt_score:   .asciz "Enter student score: "
    fmt_char:       .asciz " %c"
    fmt_int:        .asciz "%d"
    fmt_str:        .asciz "%s"
    res_alpha:      .asciz "Result: %c\n"
    res_max:        .asciz "Maximum value: %d\n"
    res_grade:      .asciz "Student: %s, Grade: %c\n"
    err_msg:        .asciz "Error: Invalid Score\n"
    
    student_name:   .skip 64
