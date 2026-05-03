# FileName: <JHEDID>_team8_RSA.s
# Authors: Jeffrey Patton,  Rachel Cleary
# Date: 30 April 2026
# Description: Contains main function to perform RSA encryption
#   on a message of up to 250 characters. User selects one of
#   four actions: 1. generate keys, 2. encrypt a message,
#   3. decrypt a message, or 4. quit.
#
#   The encrypted message is written to "encrypted.txt" in the
#   user's working directory. The decrypted message is written
#   to "decrypted.txt," also in the working directory.
#
#   During encryption and decryption, an efficient method of
#   modular exponentiation is used, allowing for large inputs
#   when generating the public/private keys. 


.text
.global main

main:
    # Dict:
    # r4 = temp storage
    # r5 = temp storage

    # Push registers onto stack
    SUB sp, sp, #16
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]

    # Prompt for user action
    # Re-prompt if input invalid
    LDR r0, =menuMsg
    BL printf

    MenuLoop:
        LDR r0, =menuPrompt
        BL printf

        # Scan input
        LDR r0, =numFormat
        SUB sp, sp, #4
        MOV r1, sp
        BL scanf
        LDR r1, [sp]
        ADD sp, sp, #4

        # Input successfully parsed?
        CMP r0, #1
        BNE InvalidInput

            # Route execution
            CMP r1, #1
            BEQ GenKeysLoop
            CMP r1, #2
            BEQ EncryptMsg
            CMP r1, #3
            BEQ DecryptMsg
            CMP r1, #4
            BEQ EndPgm

        InvalidInput:
        LDR r0, =consumeLine
        BL scanf // drain input buffer
        LDR r0, =menuError
        BL printf
        B MenuLoop // prompt user again


    # Generate public and private keys
    GenKeysLoop:
        # Prompt for p
        LDR r0, =promptP
        BL printf

        # Scan input
        LDR r0, =numFormat
        SUB sp, sp, #4 // make space on stack
        MOV r1, sp
        BL scanf
        LDR r4, [sp] 

        # Prompt for q
        LDR r0, =promptQ
        BL printf

        # Scan input
        LDR r0, =numFormat
        MOV r1, sp
        BL scanf
        LDR r5, [sp]

        # Prompt for e
        LDR r0, =promptE
        BL printf

        # Scan input
        LDR r0, =numFormat
        MOV r1, sp
        BL scanf
        LDR r2, [sp]
        ADD sp, sp, #4 // return stack memory

        # Calculate modulus & totient
        MOV r0, r4 // p
        MOV r1, r5 // q
        BL cpubexp // r2 = e

        # Check error codes
        CMP r0, #-1
        BNE Error2
            LDR r0, =errorRangePQ
            BL printf
            B GenKeysLoop

        Error2:
        CMP r0, #-2
        BNE Error3
            LDR r0, =errorPrime
            BL printf
            B GenKeysLoop

        Error3:
        CMP r0, #-3
        BNE Error4
            LDR r0, =errorRangeE
            BL printf
            B GenKeysLoop

        Error4:
        CMP r0, #-4
        BNE ValidPub
            LDR r0, =errorCoprime
            BL printf
            B GenKeysLoop

        ValidPub:
        # Print public key
        MOV r4, r2 // e
        MOV r5, r1 // phi
        MOV r1, r0 // n
        LDR r0, =publicKey
        BL printf

        # Calculate private key
        MOV r0, r4
        MOV r1, r5
        BL cprivexp

        CMP r0, #-1
        BNE ValidPriv
            LDR r0, =errorPriv
            BL printf
            B GenKeysLoop

        ValidPriv:
        MOV r1, r0
        LDR r0, =privateKey
        BL printf

        B EndPgm


    # Encrypt a message
    EncryptMsg:
    # Prompt for n
    LDR r0, =promptN
    BL printf

    LDR r0, =numFormat
    SUB sp, sp, #4
    MOV r1, sp
    BL scanf
    LDR r4, [sp]

    # Prompt for e
    LDR r0, =promptE
    BL printf

    LDR r0, =numFormat
    MOV r1, sp
    BL scanf
    LDR r5, [sp]
    ADD sp, sp, #4

    
        # Consume leftover newline after scanf
    LDR r0, =charFormat
    SUB sp, sp, #4
    MOV r1, sp
    BL scanf
    ADD sp, sp, #4

    # Call encrypt(e, n)
    MOV r0, r5      @ e
    MOV r1, r4      @ n
    BL encrypt

    B EndPgm



    # Decrypt a message
    DecryptMsg:
    # Prompt for n
    LDR r0, =promptN
    BL printf

    LDR r0, =numFormat
    SUB sp, sp, #4
    MOV r1, sp
    BL scanf
    LDR r4, [sp]

    # Prompt for d
    LDR r0, =promptD
    BL printf

    LDR r0, =numFormat
    MOV r1, sp
    BL scanf
    LDR r5, [sp]
    ADD sp, sp, #4

    # Call decrypt(d, n)
    MOV r0, r5    @ d
    MOV r1, r4    @ n
    BL decrypt
    B EndPgm

EndPgm:
    # Pop stack & return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr
    

.data
    consumeLine: .asciz "%*[^\n]%*c"
    charFormat: .asciz "%c"
    errorCoprime: .asciz " === Error: e and the totient must be coprime! ===\n\n"
    errorPrime: .asciz " === Error: p and q must both be prime! ===\n\n"
    errorPriv: .asciz " === Error: could not calculate modular inverse of totient! ===\n\n"
    errorRangeE: .asciz " === Error: e must be > 1 and less than the totient! ===\n\n"
    errorRangePQ: .asciz " === Error: p and q must both be > 1! ===\n\n"

    menuError: .asciz "\n Invalid selection!"
    menuMsg: .asciz "\n What would you like to do?\n\t1. Generate a key pair\n\t2. Encrypt a message\n\t3. Decrypt a message\n\t4. End program"
    menuPrompt: .asciz "\n\n Enter 1, 2, 3, or 4: "
    numFormat: .asciz "%d"

    privateKey: .asciz " Private key: %d\n"
    promptE: .asciz " Enter a value for the public key exponent (e): "
    promptP: .asciz " Enter a positive integer (p): "
    promptQ: .asciz " Enter a positive integer (q), coprime with p: "
    promptN: .asciz " Enter the modulus (n): "
    promptD: .asciz " Enter the private key exponent (d): "
    publicKey: .asciz " Public key:\n\tmodulus = %d\n\texponent = %d\n"
# END main

# Tell linker: code does not need an executable stack (to prevent error)
.section .note.GNU-stack,"",%progbits

