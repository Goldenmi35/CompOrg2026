#
#Program Name: negateInput.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program negates the input 
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


  #Compute the conversion
  LDR r1, =num
  LDR r1, [r1]
  MVN r1, r1
  MOV r2, #1
  ADD r1, r1, r2

  #Print the Message
  LDR r0, =format
  BL printf

  #return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
  prompt: .asciz "Enter Integer to negate:\n"
  num: .word 0
  input: .asciz "%d"
  format: .asciz "Negated: %d \n" 
