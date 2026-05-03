# FileName: <JHEDID>_team8_RSALib.s
# Authors: Rachel Cleary, Austin Limanek, Jeffrey Patton, Eddy Wen
# Date: 30 April 2026
# Description: A complete library of functions to enable the RSA encryption algorithm. Includes:
#   - checkPrime
#   - cprivexp
#   - cpubexp
#   - extendedGCD
#   - gcd
#   - isPrime
#   - modExp
#   - modInv
#   - modulo

.global cprivexp
.global cpubexp
.global decrypt
.global encrypt


# Author: Rachel Cleary
# Date: March 22, 2026
# Function: modulo
# Description: Returns the remainder after integer division.
#
# Input:
#   r0 = divident (int)
#   r1 = divisor (int)
# Output:
#   r0 = remainder (int)

.text
modulo:
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r0, [sp, #4]      @ save original dividend
    STR r1, [sp, #8]      @ save divisor

    BL __aeabi_idiv       @ r0 = dividend / divisor

    LDR r1, [sp, #8]      @ restore divisor
    MUL r2, r0, r1        @ r2 = quotient * divisor

    LDR r0, [sp, #4]      @ restore original dividend
    SUB r0, r0, r2        @ remainder = dividend - (quotient * divisor)

    LDR lr, [sp, #0]
    ADD sp, sp, #12
    MOV pc, lr
# END modulo



# Author: Eddy Wen
# Date: 29 April 2026
# Function: gcd
# Description: Find the greatest common denominator of two integers.
#
# Input:
#   r0 = a (int)
#   r1 = b (int)
# Output:
#   r0 = gcd (int)

.text
gcd:
    # Dict:
    #   r4 = a
    #   r5 = b

    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

gcd_loop:
    CMP r1, #0
    BEQ gcd_done

    MOV r4, r0      @ save a
    MOV r5, r1      @ save b
    BL __aeabi_idiv @ r0 = a / b

    MUL r3, r0, r5  @ (a/b)*b
    SUB r3, r4, r3  @ remainder = a - (a/b)*b

    MOV r0, r5      @ a = b
    MOV r1, r3      @ b = remainder

    B gcd_loop

gcd_done:
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr
# END gcd


# Author: Eddy Wen
# Date: 29 April 2026
# Function: checkPrime
# Description: Check whether an integer is prime.
#
# Input:
#   r0 = n (int)
# Output:
#   r0 = 1 if yes, 2 if no

.text
checkPrime:
    # Dict:
    #   r4 = loop counter
    #   r5 = remainder
    #   r6 = n

    SUB sp, sp, #16
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    MOV r6, r0          @ save n

    CMP r0, #2
    BLT not_prime
    CMP r0, #2
    BEQ prime

    MOV r4, #2          @ i = 2

loop:
    MUL r5, r4, r4
    CMP r5, r6
    BGT prime

    MOV r0, r6          @ restore n
    MOV r1, r4
    BL __aeabi_idiv     @ r0 = n / i

    MUL r5, r0, r4
    SUB r5, r6, r5      @ remainder

    CMP r5, #0
    BEQ not_prime

    ADD r4, r4, #1
    B loop

prime:
    MOV r0, #1
    B done

not_prime:
    MOV r0, #0

done:
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr
# END checkPrime


# Author: Austin Limanek
# Date: 3 April 2026
# Function: extendedGCD
# Description: Find the gcd and coefficients for modular inverse.
#
# Input:
#   r0 = coefficient a (int)
#   r1 = coefficient b (int)
# Output:
#   r0 = gcd (int)
#   r1 = x (can be negative, used for d) (int)
#   r2 = y intermediate value (int)

.text
extendedGCD:
    # Dict:
    #   r4 = a
    #   r5 = b
    #   r6 = gcd
    #   r7 = x1
    #   r8 = y1

    # Push lr to the stack along with input values.
    SUB sp, sp, #24
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    STR r8, [sp, #20]

    # Base cas: gcd a and coefficients are 1 and 0
    CMP r1, #0
    MOVEQ r1, #1
    MOVEQ r2, #0
    BEQ return @return(a, 1, 0)
    
    # Take the modulus a%b return to r0
    # Saving a in r4 and b into r5
    MOV r4, r0 @a
    MOV r5, r1 @b
    BL modulo

    # set up registers for recursion
    MOV r1, r0
    MOV r0, r5 
    BL extendedGCD @input(b, a%b)
    # return is (gcd, x1, y1) -> r0, r1, r2
    # store values in r6 -> r8
    MOV r6, r0 @gcd
    MOV r7, r1 @x1
    MOV r8, r2 @y1

    # Update coefficients
    # setting up to return (gcd, x, y)
    # x = y1
    # y = x1 - (a // b) * y1
    
    # a // b
    MOV r0, r4
    MOV r1, r5
    BL __aeabi_idiv
    
    # Calculate y and setting it to r2
    MUL r0, r0, r8
    MOV r2, r7
    SUB r2, r2, r0
    
    # Setting r0 and r1 to gcd and x=y1
    MOV r0, r6
    MOV r1, r8
    
    return:
    # Pop lr from stack pointer to return to the caller
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    ADD sp, sp, #24
    MOV pc, lr
# END extendedGCD


# Author: Austin Limanek
# Date: 3 April 2026
# Function: modInv
# Description: Find the modular inverse.
#
# Input:
#   r0 = e (int)
#   r1 = phi (int)
# Output:
#   r0 = d (int)

.text
modInv:
    # Push lr to the stack along with input values.
    SUB sp, sp, #8
    STR lr, [sp, #0]
    STR r4, [sp, #4]

    # Save phi in r4
    MOV r4, r1
    
    # input(e, phi) output r0, r1, r2 -> gcd, x, _
    BL extendedGCD

    # If not co-prime (gcd != 1) return -1
    CMP r0, #1
    BNE return_mi

    # prepare the output d = x % phi (ensures positive)
    MOV r0, r1
    MOV r1, r4
    BL modulo
    ADDMI r0, r0, r4 @This is a correction for the modulo
             @implementation being like a remainder

    return_mi:

    # Pop lr from stack pointer to return to the caller
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    ADD sp, sp, #8
    MOV pc, lr
# END modInv


# Author: Jeffrey Patton
# Date: 17 April 2026
# Function: modExp
# Description: Perform efficient modular exponentiation using
#   the binary right-to-left method. The exponent is converted
#   to binary, and for each bit equal to one, the base is iteratively
#   squared and the modulus it calculated, thus avoiding the
#   calculation of a large exponent.
#
# Input:
#   r0 = base (int)
#   r1 = exponenet (int)
#   r2 = modulus (int)
# Output:
#   r0 = remainder (int)

.text
modExp:
    # Dict:
    #   r4 = result (or remainder)
    #   r5 = base (or current power of base)
    #   r6 = exponent
    #   r7 = modulus
    #   r8 = nth bit of exp in binary

    # Push registers onto stack
    SUB sp, sp, #24
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]
    STR r8, [sp, #20]

    # Initialize loop
    MOV r4, #1 // result
    MOV r5, r0 // initial value of base
    MOV r6, r1 // exp (decrements each iteration)
    MOV r7, r2 // modulus (static)

    ExpBitLoop:
        CMP r6, #0
        BEQ EndExpBitLoop // exit when exp = 0

        # Get value of bit
        MOV r0, r6 // exp is dividend
        MOV r1, #2 // two is divisor
        BL modulo
        MOV r8, r0 // value of bit

        # Update value of exp
        MOV r0, r6
        MOV r1, #2
        BL __aeabi_idiv
        MOV r6, r0

        # Multiply if bit = 1
        CMP r8, #1
        BNE Square
            MUL r0, r4, r5
            MOV r1, r7
            BL modulo
            MOV r4, r0 // udpate result

        # Square value of base
        Square:
        MUL r0, r5, r5
        MOV r1, r7
        BL modulo
        MOV r5, r0 // update base

        B ExpBitLoop
    EndExpBitLoop:

    # Return result
    MOV r0, r4

    # Pop stack & return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    LDR r8, [sp, #20]
    ADD sp, sp, #24
    MOV pc, lr
# END modExp


# Author: Rachel Cleary
# Date: 17 April 2026
# Function: cpubexp
# Description: This function validates the RSA public key inputs p, q, and e.
#   It verifies that p and q are prime, computes:
#       n   = p * q
#       phi = (p - 1)(q - 1)
#   It then checks that e is coprime with phi using gcd.
#   If any input is invalid, the function returns:
#       r0 = -1
#
# Input:
#   r0 = p (int)
#   r1 = q (int)
#   r2 = e (int)
# Output:
#   r0 = n (int)
#   r1 = phi (int)
#   r2 = e (int)

.text
cpubexp:
    # Dict:
    #   r4 = p (input)
    #   r5 = q (input)
    #   r6 = e (input)
    #   r7 = n = p * q
    #   r8 = phi = (p - 1)(q - 1)
    #   r9 = (q - 1) temporary value

        @ Create stack frame
        SUB     sp, sp, #28
        STR     lr, [sp, #0]
        STR     r4, [sp, #4]
        STR     r5, [sp, #8]
        STR     r6, [sp, #12]
        STR     r7, [sp, #16]
        STR     r8, [sp, #20]
        STR     r9, [sp, #24]

        @ Save inputs
        MOV     r4, r0
        MOV     r5, r1
        MOV     r6, r2

        @ Check p >= 2
        CMP     r4, #2
        BLT     pqRangeError

        @ Check q >= 2
        CMP     r5, #2
        BLT     pqRangeError

        @ Verify p is prime
        MOV     r0, r4
        BL      isPrime
        CMP     r0, #1
        BNE     pqPrimeError

        @ Verify q is prime
        MOV     r0, r5
        BL      isPrime
        CMP     r0, #1
        BNE     pqPrimeError

        @ Compute n = p * q
        MUL     r7, r4, r5

        @ Compute phi = (p - 1)(q - 1)
        SUB     r8, r4, #1
        SUB     r9, r5, #1
        MUL     r8, r8, r9

        @ Check e > 1
        CMP     r6, #1
        BLE     eRangeError

        @ Check e < phi
        CMP     r6, r8
        BGE     eRangeError

        @ Verify gcd(e, phi) == 1
        MOV     r0, r6
        MOV     r1, r8
        BL      gcd
        CMP     r0, #1
        BNE     eCoprimeError

        @ Return n, phi, e
        MOV     r0, r7
        MOV     r1, r8
        MOV     r2, r6
        B       cpubexp_done

pqRangeError:
        MOV     r0, #-1
        B cpubexp_done

pqPrimeError:
        MOV     r0, #-2
        B cpubexp_done

eRangeError:
        MOV     r0, #-3
        B cpubexp_done

eCoprimeError:
        MOV     r0, #-4

cpubexp_done:

        @ Restore registers
        LDR     lr, [sp, #0]
        LDR     r4, [sp, #4]
        LDR     r5, [sp, #8]
        LDR     r6, [sp, #12]
        LDR     r7, [sp, #16]
        LDR     r8, [sp, #20]
        LDR     r9, [sp, #24]
        ADD     sp, sp, #28
        MOV     pc, lr
# END cpubexp


# Author: Rachel Cleary
# Date: 17 April 2026
# Function: isPrime
# Description: Returns 1 if input n is prime, otherwise returns 0.
#
# Input:
#   r0 = n (int)
# Output:
#   r0 = 1 if prime (int)
#   r0 = 0 if not prime (int)

.text
isPrime:
    # Dict:
	#r4 = n (input number)
	#r5 = divisor (loop counter)

        @ Create stack frame
        SUB     sp, sp, #20
        STR     lr, [sp, #0]
        STR     r4, [sp, #4]
        STR     r5, [sp, #8]
        STR     r6, [sp, #12]
        STR     r7, [sp, #16]

        @ Save n
        MOV     r4, r0

        @ n < 2 is not prime
        CMP     r4, #2
        BLT     isPrime_not_prime

        @ n == 2 is prime
        CMP     r4, #2
        BEQ     isPrime_prime

        @ Start divisor at 2
        MOV     r5, #2

isPrime_loop:

        @ If divisor == n, number is prime
        CMP     r5, r4
        BEQ     isPrime_prime

        @ Compute n mod divisor
        MOV     r0, r4
        MOV     r1, r5
        BL      modulo

        @ If remainder == 0, not prime
        CMP     r0, #0
        BEQ     isPrime_not_prime

        @ Increment divisor
        ADD     r5, r5, #1
        B       isPrime_loop

isPrime_prime:

        MOV     r0, #1
        B       isPrime_done

isPrime_not_prime:

        MOV     r0, #0

isPrime_done:

        @ Restore registers
        LDR     lr, [sp, #0]
        LDR     r4, [sp, #4]
        LDR     r5, [sp, #8]
        LDR     r6, [sp, #12]
        LDR     r7, [sp, #16]
        ADD     sp, sp, #20
        MOV     pc, lr
# END isPrime


# Author: Rachel Cleary
# Date: 17 April 2026
# Function: cprivexp
# Description: This function computes the RSA private exponent d using
#   a brute-force approach. It searches for a value d such that:
#       (e * d) mod phi = 1
#   where phi = (p - 1)(q - 1).
#   If no valid d is found, the function returns -1.
#
# Input:
#   r0 = e      (public exponent, int)
#   r1 = phi (computed as (p - 1)(q - 1))
# Output:
#   r0 = d      (private exponent, int)

.text
cprivexp:
    # Dict:
	#r4 = e (input public exponent)
	#r5 = phi (input)
	#r6 = d (candidate private exponent)

        @ Create stack frame
        SUB     sp, sp, #16
        STR     lr, [sp, #0]
        STR     r4, [sp, #4]
        STR     r5, [sp, #8]
        STR     r6, [sp, #12]

        @ Save inputs
        MOV     r4, r0
        MOV     r5, r1

        @ Initialize d = 1
        MOV     r6, #1

cprivexp_loop:

        @ Check if d >= phi
        CMP     r6, r5
        BGE     cprivexp_not_found

        @ Compute e * d
        MUL     r0, r4, r6

        @ Compute (e * d) mod phi
        MOV     r1, r5
        BL      modulo

        @ Check if result == 1
        CMP     r0, #1
        BEQ     cprivexp_found

        @ Increment d
        ADD     r6, r6, #1
        B       cprivexp_loop

cprivexp_found:

        @ Return d
        MOV     r0, r6
        B       cprivexp_done

cprivexp_not_found:

        @ Return -1 if no inverse exists
        MOV     r0, #-1

cprivexp_done:

        @ Restore registers
        LDR     lr, [sp, #0]
        LDR     r4, [sp, #4]
        LDR     r5, [sp, #8]
        LDR     r6, [sp, #12]
        ADD     sp, sp, #16
        MOV     pc, lr
# END cprivexp


# Author: Jeffrey Patton
# Date: 17 April 2026
# Function: encrypt
# Description: Prompt user for secret message, compute
#   ciphertext, and write to file "encrypted.txt"
#
# Input:
#   r0 = public exponent (e, int)
#   r1 = modulus (n, int)
# Output: none

.text
encrypt:
    # Dict:
    #   r4 = base address of char array
    #   r5 = loop counter
    #   r7 = system call
    #   r8 = output file descriptor
    #   r9 = public exponent
    #  r10 = modulus

    # Push registers onto stack
    SUB sp, sp, #28
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r7, [sp, #12]
    STR r8, [sp, #16]
    STR r9, [sp, #20]
    STR r10, [sp, #24]

    # Move input to safe registers
    MOV r9, r0
    MOV r10, r1

    # Prompt user for message; store in buffer
    LDR r0, =msgPrompt
    BL printf
    LDR r0, =msgFormat
    LDR r1, =msgBuffer
    BL scanf

    # Open output file
    LDR r0, =inputFile // use label from "decrypt"
    # r1 = flags (write only, create if needed, overwrite if exists)
    LDR r1, =0x0241 // 01101_{8} = 0241_{16}
    # r2 = permissions (anyone can read or write)
    LDR r2, =0x01B6 // 0666_{8} = 01B6_{16}
    MOV r7, #5 // syscall for "open"
    SVC #0 // trigger syscall
    CMP r0, #0
    BLT OpenFailure
        MOV r8, r0


    # Initialize loop
    LDR r4, =msgBuffer // base array address
    MOV r5, #0 // loop counter

    CharLoop:
        # Continue loop?
        LDRB r1, [r4, r5] // is character null?
        CMP r1, #0
        BEQ EndCharLoop

        # Update address
        ADD r1, r4, r5
        LDRB r0, [r1] // load ASCII decimal value
        MOV r1, r9
        MOV r2, r10
        BL modExp // calculate ciphertext

        # Format ciphertext
        MOV r2, r0
        LDR r0, =ciphTextBuffer
        LDR r1, =ciphTextFormat
        BL sprintf

        # Write ciphertext
        LDR r1, =ciphTextBuffer
        MOV r2, r0 // num bytes to write
        MOV r0, r8
        MOV r7, #4 // syscall for "write"
        SVC #0

        # Update counter
        ADD r5, r5, #1
        B CharLoop
    EndCharLoop:
        # Write newline at end of encrypted file
        LDR r1, =newline
        MOV r2, #1
        MOV r0, r8
        MOV r7, #4
        SVC #0

        # Close output file
        MOV r0, r8
        MOV r7, #6
        SVC #0
		CMP r0, #0
        BLT CloseFailure

        # Print "success" message
        LDR r0, =outputMsg // use label from "decrypt"
        LDR r1, =inputFile
        BL printf
        B EndEncrypt

    # If failed to open file
    OpenFailure:
        LDR r0, =openError
        LDR r1, =inputFile
        BL printf
        B EndEncrypt

    # If failed to close file
    CloseFailure:
        LDR r0, =closeError
        LDR r1, =inputFile
        BL printf

    EndEncrypt:
    # Pop stack & return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r7, [sp, #12]
    LDR r8, [sp, #16]
    LDR r9, [sp, #20]
    LDR r10, [sp, #24]
    ADD sp, sp, #28
    MOV pc, lr

.data
    ciphTextBuffer: .space 32
    ciphTextFormat: .asciz "%d "
    closeError: .asciz "\nError: could not close %s.\n\n"
    msgBuffer: .space 251 // reserve 251 bytes (+1 for null terminator)
    msgFormat: .asciz "%250[^\n]" // read all chars/spaces up to (but not including) newline
    msgPrompt: .asciz "\nEnter the message to be encrypted (max 250 chars):\n"
    openError: .asciz "\nError: could not open %s for writing.\n\n"
    # outputFile: .asciz "encrypted.txt"
    # outputMsg: .asciz "\nMessage successfully written to %s\n\n"
	newline: .asciz "\n"
# END encrypt


# Author: Austin Limanek
# Date: 28 April 2026
# Function: decrypt
# Description: Receive a cipher text and a private key,
#   decrypt the cipher and print the message.
#
# Input:
#   r0 = private exponent (d, int)
#   r1 = modulus (n, int
# Output: none

.text
decrypt:
    # Dictionary:
    #   r4 = input FILE*
    #   r5 = output FILE*
    #   r9 = private exponent d
    #   r10 = modulus n
    
    # Push registers onto stack
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r9, [sp, #12]
    STR r10, [sp, #16]

    # Save input values
    MOV r9, r0          @ private exponent d
    MOV r10, r1         @ modulus n

    LDR r0, =inputFile
    LDR r1, =readMode
    BL fopen
    MOV r4, r0          @ input FILE*

    CMP r4, #0
    BEQ OpenInputFailed

    LDR r0, =outputFile
    LDR r1, =writeMode
    BL fopen
    MOV r5, r0          @ output FILE*

    CMP r5, #0
    BEQ OpenOutputFailed

    DecryptLoop:
        MOV r0, r4
        LDR r1, =intFormat
        LDR r2, =cipherBuffer
        BL fscanf

        CMP r0, #1
        BNE EndDecryptLoop

        LDR r0, =cipherBuffer
        LDR r0, [r0]        @ r0 = ciphertext
        
        MOV r1, r9          @ d
        MOV r2, r10         @ n
        BL modExp

        MOV r2, r0          @ decrypted ASCII char
        MOV r0, r5          @ output FILE*
        LDR r1, =charFormat
        BL fprintf

        B DecryptLoop
	
    EndDecryptLoop:
    # Write newline at end of decrypted file
    MOV r0, r5
    LDR r1, =newlineFormat
    BL fprintf

    # Close output file
    MOV r0, r5
    BL fclose

    # Close input file
    MOV r0, r4
    BL fclose

    # Print success message
    LDR r0, =outputMsg
    LDR r1, =outputFile
    BL printf

    B DecryptReturn

    OpenOutputFailed:
    # If output file failed, close input file first
    MOV r0, r4
    BL fclose

    LDR r0, =outputOpenError
    BL printf
    B DecryptReturn

    OpenInputFailed:
    LDR r0, =inputOpenError
    BL printf


    DecryptReturn:
    # Pop stack & return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r9, [sp, #12]
    LDR r10, [sp, #16]
    ADD sp, sp, #20
    MOV pc, lr

.data
    charFormat:      .asciz "%c"
    cipherBuffer:    .word 0
    inputFile:       .asciz "encrypted.txt"
    inputOpenError:  .asciz "\nError: could not open encrypted.txt for reading.\n\n"
    intFormat:       .asciz "%d"
    outputFile:      .asciz "decrypted.txt"
    outputMsg:       .asciz "\nMessage successfully written to %s\n\n"
    outputOpenError: .asciz "\nError: could not open decrypted.txt for writing.\n\n"
    readMode:        .asciz "r"
    writeMode:       .asciz "w"
	newlineFormat: .asciz "\n"
# END decrypt


# Tell linker: code does not need an executable stack (to prevent error)
.section .note.GNU-stack,"",%progbits
