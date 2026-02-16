#
#Program Name: userPrompt.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program prompts the user for an age and then prints it out.
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

  #Print the message
  LDR r0, = format
  LDR r1, = num
  LDR r1, [r1, #0]
  BL printf

  #return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
  prompt: .asciz "What is your age?\n"
  num: .word 0
  input: .asciz "%d"
  format: .asciz "Your Age Is %d \n" 
