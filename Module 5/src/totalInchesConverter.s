#
#Program Name: negateInput.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program negates the input 
#

.text
.global main

main:
  SUB sp, sp, #8
  STR lr, [sp, #4]

  #prompt for input
  LDR r0, = prompt
  BL printf 

  #scanf
  LDR r0, =input
  LDR r1, =num
  BL scanf

  #Set Constants
  MOV r5, #12

  #Compute the conversion to feet
  LDR r4, =num
  LDR r4, [r4]

  MOV r0, r4
  MOV r1, r5
  BL __aeabi_idiv
  MOV r6, r0

  #Print the Message
  LDR r0, =format
  MOV r1, r6
  BL printf

  #Find remaining inches
  MUL r7, r6, r5
  SUB r7, r4, r7

  #Print the message
  LDR r0, =format2
  MOV r1, r7
  BL printf
  
  #return to the OS
  LDR lr, [sp, #4]
  ADD sp, sp, #8
  MOV pc, lr

.data
  prompt: .asciz "Enter Total Inches:\n"
  num: .word 0
  input: .asciz "%d"
  format: .asciz "Feet: %d \n"
  format2: .asciz "Inches: %d \n" 
