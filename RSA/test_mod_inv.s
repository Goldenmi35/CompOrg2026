# FileName: test_mod_inv.s
# Author: Austin Limanek
# Data 3 April 2026
# Purpose: Check the functionality of mod_inv
#	and by extension extended_gcd
# Note: phi = 448 = (29-1)*(17-1) so p=29 and q=17
# 	this is just an example to show that
#	mod_inv is working appropriately.

.global main

.text
main:
	# Push link register from OS onto stack pointer
	SUB sp, sp, #8
	STR lr, [sp, #0]
	STR r4, [sp, #4]

	LDR r0, =65537
	MOV r1, #448
	
	BL mod_inv
	MOV r4, r0
	
	LDR r1, =65537
	MUL r0, r0, r1
	MOV r1, #448
	
	BL modulo

	CMP r0, #1
	LDREQ r0, =True
	LDRNE r0, =False
	BL printf

	LDR r0, =output
	MOV r1, r4
	BL printf

	# Pop link register from stack pointer and move lr
	# into the program counter and have good return code
	MOV r0, #0
	LDR lr, [sp, #0]
	LDR r4, [sp, #4]
	ADD sp, sp, #8
	MOV pc, lr 

.data
	True: .asciz "True\n"
	False: .asciz "False\n"
	output: .asciz "%d\n"

# End of test_mod_inv
