.global main
.section .data
prompt:         .asciz "Enter an integer (-1 to stop): "
scanFmt:        .asciz "%d"
resultFmt:      .asciz "Count = %d  Sum = %d  Average = %d\n"

.section .text
main:
  sub     sp, sp, #24
  str     lr, [sp, #20]

  mov     r4, #0              
  mov     r5, #0             

//This is the main loop in which the user will enter their inputs until the program gets a -1
loop_top:
  ldr r0, =prompt
  bl      printf

  ldr     r0, =scanFmt
  mov     r1, sp
  bl      scanf

  ldr     r6, [sp]
  cmp     r6, #-1
  beq     done_input

  add     r4, r4, #1
  add     r5, r5, r6
  b       loop_top

done_input:
        
  mov     r0, #0
  str     r4, [sp, #4]
  str     r5, [sp, #8]
  str     r0, [sp, #12]
  
  cmp r4, #0
  beq skip_err

  mov     r0, r5            
  mov     r1, r4              
  bl      __aeabi_idiv        

  str     r0, [sp, #12]

skip_err:
        
  ldr     r0, =resultFmt
  ldr     r1, [sp, #4]        
  ldr     r2, [sp, #8]        
  ldr     r3, [sp, #12]              
  bl      printf

  mov     r0, #0
  ldr     lr, [sp, #20]
  add     sp, sp, #24

