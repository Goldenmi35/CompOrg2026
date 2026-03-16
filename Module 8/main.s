#
#Program Name: main.s
#Program Author: Eddy Wen
#Date: 03/14/2026
#Purpose: This program tests the functions in libFunctions.s

.section .text
.global main
.extern miles2kilometers
.extern kph
.extern CToF
.extern InchesToFeet

main:
  SUB sp, sp, #4
  STR lr, [sp, #0] 

  @Get miles as input
  ldr r0, =prompt_miles
  bl printf

  ldr r0, =fmt_in
  ldr r1, =miles
  bl scanf
  
  @calls miles2kilometers
  ldr r0, =miles
  ldr r0, [r0]
  bl miles2kilometers

  @print the result
  mov r1, r0
  ldr r0, =out_km
  bl printf 

  @input the hours
  ldr r0, =prompt_hours
  bl printf

  ldr r0, =fmt_in
  ldr r1, =hours
  bl scanf
  
  ldr r0, =prompt_miles
  bl printf

  ldr r0, =fmt_in
  ldr r1, =miles
  bl scanf

  ldr r0, =hours
  ldr r0, [r0]

  ldr r1, =miles
  ldr r1, [r1]
  
  bl kph

  @print kph
  mov r1, r0
  ldr r0, =out_kph
  bl printf

  @celsius input
  ldr r0, =prompt_celsius
  bl printf

  ldr r0, =fmt_in
  ldr r1, =celsius
  bl scanf

  ldr r0, =celsius
  ldr r0, [r0]

  bl CToF

  mov r1, r0
  ldr r0, =out_f
  bl printf

  @inches input
  ldr r0, =prompt_inches
  bl printf

  ldr r0, =fmt_in
  ldr r1, =inches
  bl scanf

  ldr r0, =inches
  ldr r0, [r0]

  bl InchesToFeet

  mov r1, r0
  ldr r0, =out_ft
  bl printf

  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.section .data
prompt_miles:	.asciz "Enter miles: "
prompt_hours:	.asciz "Enter hours: "
prompt_celsius:	.asciz "Enter celsius: "
prompt_inches:	.asciz "Enter inches: "

fmt_in:	.asciz "%d" 

out_km:	.asciz "Kilometers: %d\n"
out_kph: .asciz "Speed (km\h): %d\n"
out_f:	.asciz "Fahrenheit: %d\n"
out_ft:	.asciz "Feet: %d\n"

miles:	.word 0
hours:	.word 0
celsius: .word 0
inches:	.word 0
