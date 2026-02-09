#
#Program Name: helloWorldMain.s
#Author: Eddy Wen
#Date:02/07/2026
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
