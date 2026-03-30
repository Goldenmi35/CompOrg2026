@Program Name: libFunctions.s
@Author Name: Eddy Wen
@Description: This is the library that contains the listed functions. Two of them check for alphabetical keys, one returns the greatest number, and one tries to get a student and numerical value then returns a grade
@
@

.text
.align 2
.global ChkAlphaLOG
.global ChkAlphaNOLOG
.global findMAXOf3
.global Grade

ChkAlphaLOG:
    @ Create a copy of the input character
    mov r1, r0
    
    @ Logical OR with 0x20 (32) forces the character to be lowercase
    @ This alows us to check both A-Z and a-z in one range check.
    orr r1, r1, #0x20
    
    @ Now we only need to check if 'a' <= r1 <= 'z'
    cmp r1, #'a'
    blt .not_alpha_log
    cmp r1, #'z'
    bgt .not_alpha_log
    
    mov r0, #'Y'
    bx lr
.not_alpha_log:
    mov r0, #'N'
    bx lr
.is_alpha_log:
    mov r0, #'Y'
    bx lr

@ 2. Non-logic based check
ChkAlphaNOLOG:
    cmp r0, #'A'
    blt .no_nolog
    cmp r0, #'Z'
    ble .yes_nolog
    cmp r0, #'a'
    blt .no_nolog
    cmp r0, #'z'
    ble .yes_nolog
.no_nolog:
    mov r0, #'N'
    bx lr
.yes_nolog:
    mov r0, #'Y'
    bx lr

@ 3. Max of 3
findMAXOf3:
    cmp r0, r1
    movlt r0, r1
    cmp r0, r2
    movlt r0, r2
    bx lr

@ 4. Grade
Grade:
    cmp r0, #0
    blt .grade_error
    cmp r0, #100
    bgt .grade_error
    cmp r0, #90
    bge .is_A
    cmp r0, #80
    bge .is_B
    cmp r0, #70
    bge .is_C
    mov r0, #'F'
    bx lr
.is_A: mov r0, #'A'
    bx lr
.is_B: mov r0, #'B'
    bx lr
.is_C: mov r0, #'C'
    bx lr
.grade_error:
    mov r0, #'E'
    bx lr
