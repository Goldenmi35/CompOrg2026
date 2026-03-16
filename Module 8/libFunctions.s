#
#Program Name: libFunctions.s
#Author: Eddy Wen
#Date:03/14/2026
#Purpose: This library contains functions that translates from one unit to another unit.  
#

.section .text
.global miles2kilometers
.global kph
.global CToF
.global InchesToFeet
.extern __aeabi_idiv

#miles2kilometers(int miles) 
# km = (miles * 161) / 100
# r0 = miles
# return r0 = km
# We use the formula because it allows us to keep values in integers without going into floating points. A way to increase precision using integer arithmetic is using a larger numberator and denominator such as (160934/100000) 

miles2kilometers:
  mov r4, lr
  mov r1, #161
  mul r0, r0, r1

  mov r1, #100
  bl __aeabi_idiv

  mov lr, r4
  bx lr

# kph(int hours, int miles)
# r0 = hours
# r1 = miles
# return r0 = km/h

kph:
  mov r5, lr

  mov r6,r0
  mov r0, r1

  bl miles2kilometers

  mov r1,r6
  bl __aeabi_idiv

  mov lr, r5
  bx lr

# CToF(int celsius) 
# F = (C * 9/5) + 32

CToF:
  mov r4, lr
  mov r1, #9
  mul r0,r0,r1

  mov r1,#5
  bl __aeabi_idiv

  add r0, r0, #32
  mov lr, r4
  bx lr

# InchesToFeet(int inches)
# feet = inches / 12

InchesToFeet:
  mov r4, lr
  mov r1, #12
  bl __aeabi_idiv

  mov lr, r4
  bx lr
