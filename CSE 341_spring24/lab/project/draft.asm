.MODEL SMALL
.STACK 100H
.DATA
    ; DEFINE YOUR VARIABLES
    msg1 db "Select an input mode. . .$"    
    msg2 db "Press, $"
    msg3 db "   1 for Binary$"
    msg4 db "   2 for Octal$"
    msg5 db "   3 for Decimal$"
    msg6 db "   4 for Hexadecimal$"
    msg7 db "Choice: $"
    msg8 db "Press ENTER to go back. Press ANY OTHER KEY to terminate the current session$"
    msg9 db "Enter the first number: $"
    msg10 db "Enter the second number: $"
    msg11 db "Result: $"
    msg12 db "------------------------------$"
    
    integer1 dw 0
    integer2 dw 0
    
    fraction1 dw 0
    fraction2 dw 0
    
    result dw 0
    
    operation db 0
    
    ; Output arrays
    
    binResult db 16 dup(0)
    octResult db 6 dup(0)
    decResult db 5 dup(0)
    hexResult db 4 dup(0)
    
    firstIdx dw 0
    mltpl dw 1
    divisor dw 1
    
ends

.CODE  
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX
        
        call inputMsg
        mov ah, 1
        int 21h
        call newLine
        call Hline
        
        cmp al, 31h
        je binary
        cmp al, 32h
        je octal
        cmp al, 33h
        je decimal
        cmp al, 34h
        je hexadecimal
        
        jmp exit
       
    binary:
        call newLine
        call takeBinaryInput
        call performOperation
        jmp exit
        
    octal:
        call newLine
        call takeOctalInput
        call performOperation
        jmp exit
        
    decimal:
        call newLine
        call takeDecimalInput
        call performOperation
        jmp exit
        
    hexadecimal:
        call newLine
        call takeHexadecimalInput
        call performOperation
        jmp exit
        
    exit:
        ; Terminate
        mov ax, 4c00h
        int 21h
    
    ; Function to take input message
    inputMsg proc
        push ax
        push dx
        xor ax, ax
        xor dx, dx
        mov ah, 9
        lea dx, msg1    
        int 21h
        call newLine
        lea dx, msg2    
        int 21h
        call newLine
        lea dx, msg3    
        int 21h
        call newLine
        lea dx, msg4    
        int 21h
        call newLine
        lea dx, msg5    
        int 21h
        call newLine
        lea dx, msg6    
        int 21h
        call newLine
        lea dx, msg7    
        int 21h
        pop dx
        pop ax
        ret
    inputMsg endp

    ; Function to take first number input
    takeFirstNumber proc
        ; Code to take first number input goes here
        ret
    takeFirstNumber endp

    ; Function to take second number input
    takeSecondNumber proc
        ; Code to take second number input goes here
        ret
    takeSecondNumber endp

    ; Function to perform mathematical operation
    performOperation proc
        ; Code to perform operation goes here
        ret
    performOperation endp

    ; Function to display result
    displayResult proc
        ; Code to display result goes here
        ret
    displayResult endp

    ; Function to handle new line
    newLine proc
        ; Code to handle new line goes here
        ret 
    newLine endp
    
    ; Function to draw horizontal line
    Hline proc
        ; Code to draw horizontal line goes here
        ret
    Hline endp
END MAIN 
