#
#Program Name: quoteString.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program prints out a quote string

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
  helloWorld: .asciz "This is my output \"Hello World\"\n"
