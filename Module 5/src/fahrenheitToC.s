#
#Program Name: fahrenheitToC.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program converts from F to C 
#

.text
.global main

main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  #prompt for input
  LDR r0, = prompt
  BL printf 

  #scanf
  LDR r0, =input
  LDR r1, =num
  BL scanf

  #Initialize the constants
  MOV r4, #9
  MOV r5, #5
  MOV r6, #32

  #Compute the conversion
  LDR r1, =num
  LDR r1, [r1]
  SUB r1, r1, r6
 
  #Multiply by 5
  MUL r1, r1, r5

  #Now divide by 9
  MOV r0, r1
  MOV r1, r4
  BL __aeabi_idiv
  MOV r1, r0

  #Print the Message
  LDR r0, =format
  BL printf

  #return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
  prompt: .asciz "Enter Degree in F:\n"
  num: .word 0
  input: .asciz "%d"
  format: .asciz "In C: %d \n" 
