#
#Program Name: asgn4.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program prints out Hello World 
#

.text
.global main

main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  LDR r0, =helloWorld
  BL printf 

  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
  helloWorld: .asciz "Hello World\n"
