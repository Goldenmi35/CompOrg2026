#
#Program Name: userPrompt.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program converts from C to F 
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
  MUL r1, r1, r4
 
  #Divide by 5
  MOV r0, r1 
  MOV r1, r5
  BL __aeabi_idiv
  MOV r1, r0 

  #Now add 32
  ADD r1, r1, r6

  #Print the Message
  LDR r0, =format
  BL printf

  #return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
  prompt: .asciz "Enter Degree in C:\n"
  num: .word 0
  input: .asciz "%d"
  format: .asciz "In F: %d \n" 
