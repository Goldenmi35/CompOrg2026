#
#Program Name: swap.s
#Author: Eddy Wen
#Date:02/14/2026
#Purpose: This program swaps two registers using only XOR 
#

.text
.global main

main:
  SUB sp, sp, #4
  STR lr, [sp, #0]

  #TEST 1
  MOV r4, #15
  MOV r5, #25
  #print before swap
  LDR r0, = prompt
  MOV r1, r4
  MOV r2, r5
  BL printf 
  
  #swap
  EOR r4, r4, r5
  EOR r5, r5, r4
  EOR r4, r4, r5

  #print after swap
  LDR r0, =prompt2
  MOV r1, r4
  MOV r2, r5
  BL printf

  #TEST 2
  MOV r4, #3
  MOV r5, #80
  #print before swap
  LDR r0, = prompt
  MOV r1, r4
  MOV r2, r5
  BL printf 
  
  #swap
  EOR r4, r4, r5
  EOR r5, r5, r4
  EOR r4, r4, r5

  #print after swap
  LDR r0, =prompt2
  MOV r1, r4
  MOV r2, r5
  BL printf

  #TEST 3
  MOV r4, #45
  MOV r5, #9
  #print before swap
  LDR r0, = prompt
  MOV r1, r4
  MOV r2, r5
  BL printf 
  
  #swap
  EOR r4, r4, r5
  EOR r5, r5, r4
  EOR r4, r4, r5

  #print after swap
  LDR r0, =prompt2
  MOV r1, r4
  MOV r2, r5
  BL printf

  #return to the OS
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
  prompt: .asciz "Before Swap: R1: %d R2: %d\n"
  prompt2: .asciz "After Swap: R1: %d R2: %d\n"
  num: .word 0
