#
#Program Name: negateInput.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program converts feet/inches to total inches 
#

.text
.global main

main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  #Set constant
  MOV r5, #12

  #prompt for feet
  LDR r0, = prompt
  BL printf 

  #get feet
  LDR r0, =input
  LDR r1, =feet
  BL scanf

  #Extract the feet value
  LDR r1, =feet
  LDR r1, [r1]
  MOV r3, r1
 
  MUL r6, r5, r3
  MOV r1, r6

  #prompt for inches
  LDR r0, =prompt2
  BL printf
  
  #get inches
  LDR r0, =input
  LDR r1, =inches
  BL scanf

  #Extract the inches value
  LDR r1, =inches
  LDR r1, [r1]
  ADD r1, r1, r6 

  #Print the Message
  LDR r0, =format
  BL printf

  #return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
  prompt: .asciz "Enter Feet:\n"
  prompt2: .asciz "Enter inches:\n"
  feet: .word 0
  inches: .word 0
  input: .asciz "%d"
  format: .asciz "Total Inches: %d \n" 
