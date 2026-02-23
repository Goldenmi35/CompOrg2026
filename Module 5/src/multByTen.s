#
#Program Name: multByTen.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program multiplies the integer by 10. 
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
  LDR r4, =num
  LDR r4, [r4]
  
  LSL r5, r4, #3
  LSL r6, r4, #1
  ADD r1, r5, r6

  #Print the Message
  LDR r0, =format
  BL printf

  #return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
  prompt: .asciz "Enter Integer:\n"
  num: .word 0
  input: .asciz "%d"
  format: .asciz "Result: %d \n" 
