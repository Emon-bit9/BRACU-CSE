.MODEL SMALL
.STACK 100H
.DATA
    ; DEFINE YOUR VARIABLES
    msg1 db "select an input mode. . .$"    
    msg2 db "press, $"
    msg3 db "   1 for Binary$"
    msg4 db "   2 for Octal$"
    msg5 db "   3 for Decimal$"
    msg6 db "   4 for Hexadecimal$"
    msg7 db "choice: $"
    msg8 db "press ENTER to go back. press ANY OTHER KEY to terminate current session$"
    msg9 db "Bin: $"
    msg10 db "Oct: $"
    msg11 db "Dec: $"
    msg12 db "Hex: $"
    msg13 db "------------------------------$"
    
    integer dw 0;
    
    fraction dw 0; 
    
    
    ;output arrays
        
    binInt db 16 dup(0)
    
    binFrac db 4 dup(0)
    
    octInt db 6 dup(0)
    
    octFrac db 4 dup(0)
    
    decInt db 5 dup(0)
    
    decFrac db 4 dup(0)
    
    hexInt db 4 dup(0)
    
    hexFrac db 4 dup(0)
  
    
    firstIdx dw 0
    
    mltpl dw 1
    
    divisor dw 1
    
    
    ;input arrays
    
    dummy db 16 dup(0) 
    
    binArrInt db 16 dup(0)
    
    binArrFrac db 4 dup(0)
    
    octDummy db 6 dup(0) 
    
    octArrInt db 6 dup(0)
    
    octArrFrac db 4 dup(0)
    
    hexDummy db 4 dup(0) 
    
    hexArrInt db 4 dup(0)
    
    hexArrFrac db 4 dup(0)
 
ends
   
    
    
    
     
   
.CODE  
    MAIN PROC
        
        MOV AX, @DATA
        MOV DS, AX
        
        ; YOUR CODE STARTS HERE
        mov ax, data
    mov ds, ax
    mov es, ax

    
    
        
       ; start:
        
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
                
                call binToIF
                
                call makeOctArrays
                call newLine
                call printOct
                
                call makeDecArrays
                call newLine
                call printDec
                
                call makeHexArrays
                call newLine
                call printHex
                
                call newLine
                call Hline
                             
                             
            jmp exit
            octal:
                
                call newLine
                call takeOctalInput
                
                call octToIF
                
                call makeBinArrays
                call newLine
                call printBin
                
                call makeDecArrays
                call newLine
                call printDec
                
                call makeHexArrays
                call newLine
                call printHex
                
                call newLine
                call Hline
                
             
            jmp exit
            decimal:
                
                call newLine
                call takeDecimalInput
                
                call makeBinArrays
                call newLine
                call printBin
                
                call makeOctArrays
                call newLine
                call printOct
                
                call makeHexArrays
                call newLine
                call printHex
                
                call newLine
                call Hline
                
                
            jmp exit
            hexadecimal:
                
                call newLine
                call takeHexadecimalInput
                
                call hexToIF
                
                call makeBinArrays
                call newLine
                call printBin
                
                call makeOctArrays
                call newLine
                call printOct
                
                call makeDecArrays
                call newLine
                call printDec
                
                call newLine
                call Hline
             
        
        exit:
          
          ;call newLine
;          call exitmsg
;          mov ah, 1
;          int 21h
;          
;          cmp al, 0Dh
;          je start
                  
                  
        ;terminate
        mov ax, 4c00h
        int 21h
            
    endp
    
    
    
    ;BINARY
    
    takeBinaryInput proc
        
         mov ah, 9
         lea dx, msg9
         int 21h
         
         
         inputIntegerBin:
        
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
            xor si, si
            mov firstIdx, dx
            mov integer, dx
            mov fraction, dx    
            
            mov ah, 1
            mov cx, 16
            mov si, 0
            
            takeBinInt:
            
                int 21h
                
                cmp al, 0Dh
                je arrangeIntBin
                
                
                cmp al, 2Eh
                je arrangeIntBin
                
                
                sub al, 30h
                mov dummy[si], al
                inc si
                
                loop takeBinInt
                
             mov ah, 2
             mov dl, 2Eh
             int 21h
              
             arrangeIntBin:
                
                mov firstIdx, cx
                 
                 mov cx, 16
                 sub cx, firstIdx
                 mov si, 0
                 
                 cmp cx, 0
                 je inputFractionBin
                 
                 nextBinDigit:
                     
                     mov bl, dummy[si]
                     push si
                     add si, firstIdx
                     mov binArrInt[si], bl
                     pop si
                     inc si
                     
                     loop nextBinDigit
                     
                 cmp al, 0Dh
                 je exitProc1
                 
                                       
          ; taking the binary fraction part
          
          inputFractionBin:
                                       
                xor ax, ax
                xor bx, bx
                xor cx, cx
                xor dx, dx
                xor si, si
                   
                mov ah, 1
                mov cx, 4
                mov si, 0
                   
             takeBinFrac:
                 
                 int 21h
                 
                 cmp al, 0Dh
                 je exitProc1
                 
                 sub al, 30h
                 
                 mov binArrFrac[si], al
                 inc si
                 
                 loop takeBinFrac
           
           
           exitProc1: 
           ret
        
    takeBinaryInput endp
    
    
    
    binToIF proc
        
     ;converting binary to Integer
        
       binToInteger:
        
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
            xor si, si
            
                                                
            mov cx, 16
            sub cx, firstIdx
            
            cmp cx, 0
            je binToFraction
            
            mov si, 15
            mov bl, 2
            
            binToBuildInt:         
               
               push bx
               mov al, binArrInt[si]
               mov bx, mltpl
               
               mul bx
               
               add ax, integer
               mov integer, ax
               
               pop bx
               mov ax, mltpl
               mul bx 
               mov mltpl, ax
               xor ax, ax
               
               sub si, 1
               
               loop binToBuildInt
        
        
     ;converting binary to fraction
   
       binToFraction:
       
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
            xor si, si
            
                                                
            mov cx, 4
            mov bx, 2
            mov divisor, bx
            mov bx, 10000
            mov mltpl, bx
            mov si, 0
            
            binToBuildFrac:
            
            mov al, binArrFrac[si]
            mov bx, mltpl     
            mul bx                     
             
            mov bx, divisor            
            div bx                     
            
            add ax, fraction 
            mov fraction, ax
            
            mov ax, divisor
            mov bx, 2
            mul bx          
            mov divisor, ax
            
            inc si
            
            loop binToBuildFrac
        
        ret
        
    binToIF endp
    
        
        
    makeBinArrays proc 
        
        
        ;converting ingeter part
        binIntegerConversion:
             
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
             
             mov ax, integer
             mov cx, 16
             mov si, 15
             mov bx, 2
             
             nextBin1:
             
               div bx

               add dl, 30h
               mov binInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextBin1
           
                
         ;converting the fraction part
         binFractionConversion:
         
         xor ax, ax
         xor bx, bx
         xor cx, cx
         xor dx, dx
       
               mov cx, 4
               mov bx, 10000 ; the modular is in bx
               mov si, 0
               mov ax, fraction
               
               
               nextBin2:
                push bx
                mov bx, 2
                mul bx
                
                pop bx
                div bx
                
                add al, 30h
                mov binFrac[si], al
                xor ax, ax
                mov ax, dx
                xor dx, dx
                inc si
                loop nextBin2
        
        endProc9:
        ret
        
    makeBinArrays endp
    
    
    
    printBin proc
         
         mov ah, 9
         lea dx, msg9
         int 21h
         
         mov ah, 2
                
         mov cx, 16
         mov di, 0
         printBin1:
            
             mov dl, binInt[di]
             int 21h
                    
             inc di
             loop printBin1
                
             mov bx, fraction
             cmp bx, 0
             je endProc8
                
             mov dl, 2Eh
             int 21h
                
             mov cx, 4
             mov si, 0
             printBin2:
                    
                mov dl, binFrac[si]
                int 21h
                inc si
                loop printBin2
        
        endProc8:
        ret
   
    printBin endp
    
    
    
    ;octal
    
    takeOctalInput proc
        
        mov ah, 9
        lea dx, msg10
        int 21h
        xor dx, dx
        
        inputIntegerOct:
    
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        mov firstIdx, dx
        mov integer, dx
        mov fraction, dx    
        
        mov ah, 1
        mov cx, 6
        mov si, 0
        
        takeOctInt:
        
            int 21h
            
            cmp al, 0Dh
            je arrangeIntOct
            
            
            cmp al, 2Eh
            je arrangeIntOct
            
            
            sub al, 30h
            mov octDummy[si], al
            inc si
            
            loop takeOctInt
            
         mov ah, 2
         mov dl, 2Eh
         int 21h
          
         arrangeIntOct:
            
            mov firstIdx, cx
             
             mov cx, 6
             sub cx, firstIdx
             mov si, 0
             
             cmp cx, 0
             je inputFractionOct
             
             nextOctDigit:
                 
                 mov bl, octDummy[si]
                 push si
                 add si, firstIdx
                 mov octArrInt[si], bl
                 pop si
                 inc si
                 
                 loop nextOctDigit
                 
             cmp al, 0Dh
             je endProc7
             
                                   
      
      inputFractionOct:
                                   
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
            xor si, si
               
            mov ah, 1
            mov cx, 4
            mov si, 0
               
         takeOctFrac:
             
             int 21h
             
             cmp al, 0Dh
             je endProc7
                 
             sub al, 30h
             
             mov octArrFrac[si], al
             inc si
             
             loop takeOctFrac
        
        endProc7:
        ret
        
    takeOctalInput endp
    
    
    
    octToIF proc
         
         
        octToInteger:
    
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
            xor si, si
            
                                                
            mov cx, 6
            sub cx, firstIdx
            
            cmp cx, 0
            je octToFraction
            
            mov si, 5
            mov bl, 8
            
            octToBuildInt:         
               
               push bx
               mov al, octArrInt[si]
               mov bx, mltpl
               
               mul bx
               
               add ax, integer
               mov integer, ax
               
               pop bx
               mov ax, mltpl
               mul bx 
               mov mltpl, ax
               xor ax, ax
               
               sub si, 1
               
               loop octToBuildInt
        
        
       
       octToFraction:
       
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
            xor si, si
            
                                                
            mov cx, 4
            mov bx, 8
            mov divisor, bx
            mov bx, 10000
            mov mltpl, bx
            mov si, 0
            
            octToBuildFrac:
            
                mov al, octArrFrac[si]
                mov bx, mltpl     
                mul bx                     
                 
                mov bx, divisor            
                div bx                     
                
                add ax, fraction 
                mov fraction, ax
                
                xor dx, dx
                mov ax, divisor
                mov bx, 8
                mul bx          
                mov divisor, ax
                
                xor ax, ax
                
                inc si
                
                loop octToBuildFrac
         
         ret
         
    octToIF endp
    
            
            
    makeOctArrays proc
        
        ;converting ingeter part
        octIntegerConversion:
             
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
             
             mov ax, integer
             mov cx, 6
             mov si, 5
             mov bx, 8
             
             nextOct1:
             
               div bx

               add dl, 30h
               mov octInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextOct1
           
                
         ;converting the fraction part
         octFractionConversion:
         
         xor ax, ax
         xor bx, bx
         xor cx, cx
         xor dx, dx
         xor si, si
         
       
               mov cx, 4
               mov bx, 10000 ; the modular is in bx
               mov si, 0
               mov ax, fraction
               
               nextOct2:
                push bx
                mov bx, 8
                mul bx
                
                pop bx
                div bx
                
                add al, 30h
                mov octFrac[si], al
                xor ax, ax
                mov ax, dx
                xor dx, dx
                inc si
                loop nextOct2
        
        endProc4:
        ret
        
    makeOctArrays endp
    
    
    
    printOct proc
        
        mov ah, 9
        lea dx, msg10
        int 21h
        xor dx, dx
        
        mov ah, 2
        
        mov cx, 6
        mov di, 0
        printOct1:
                    
            mov dl, octInt[di]
            int 21h
                    
            inc di
            loop printOct1
                    
                    
        mov bx, fraction
        cmp bx, 0
        je endproc2
                
        mov dl, 2Eh
        int 21h
                
        mov cx, 4
        mov si, 0
        printOct2:
                    
             mov dl, octFrac[si]
             int 21h
             inc si
             loop printOct2
             
         
         endproc2:  
         ret  
           
    printOct endp
    
    
    
    ;decimal
    
    takeDecimalInput proc
        
        mov ah, 9
        lea dx, msg11
        int 21h
        xor dx, dx
        
        takeIntPart:
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        xor di, si
        mov integer, dx
        mov fraction, dx

        
        mov ah, 1
        mov cx, 5
        mov bx, 10 
        
        takeIntDigit:
        
             int 21h;
             
             cmp al, 02Eh;
             je takeFracPart;
             
             cmp al, 0Dh;
             je endProc10;
             
             sub al, 30h
             push ax
             mov ax, integer
             mul bx
             mov integer, ax
             pop ax
             push bx
             mov bh, ah
             xor ah, ah
             add ax, integer
             mov integer, ax
             mov ah, bh
             pop bx
             loop takeIntDigit;
              
            mov ah, 2
            mov dl, 02Eh 
            int 21h       ;for the decimalpoint after the 16th digit    

;taking the fraction part of the decimal number
    
    takeFracPart:
    
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        
        mov ah, 1
        mov cx, 4
        mov bx, 1000 
        
        takeFracDigit:
             
             int 21h
             
             cmp al, 0Dh
             je endProc10
             
             sub al, 30h
             
             push ax
             xor ah, ah
             mul bx
             
             add ax, fraction
             mov fraction, ax
             
             mov ax, bx
             mov bx, 10
             div bx
             mov bx, ax
             
             pop ax
             
             loop takeFracDigit
          
        endProc10:
        ret
        
    takeDecimalInput endp
    
    
    
    makeDecArrays proc
        
        ;converting ingeter part
        decIntegerConversion:
             
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
             
             mov ax, integer
             mov cx, 5
             mov si, 4
             mov bx, 10
             
             nextDec1:
             
               div bx

               add dl, 30h
               mov decInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextDec1
           
                
         ;converting the fraction part
         decFractionConversion:
         
             mov ax, fraction
             mov cx, 4
             mov si, 3
             mov bx, 10
             
             nextDec2:
             
               div bx

               add dl, 30h
               mov decFrac[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextDec2
        
          ret
        
    makeDecArrays endp
    
    
    
    printDec proc
        
        mov ah, 9
        lea dx, msg11
        int 21h
        xor dx, dx
           
        mov ah, 2
                 
        mov cx, 5
        mov di, 0
        printDec1:
                    
            mov dl, decInt[di]
            int 21h
                    
            inc di
            loop printDec1
                
                
        mov bx, fraction
        cmp bx, 0
        je endProc6
                
        mov dl, 2Eh
        int 21h
                
        mov cx, 4
        mov si, 0
        printDec2:
                    
           mov dl, decFrac[si]
           int 21h
           inc si
           loop printDec2   
        
        endProc6:   
        ret
        
    printDec endp
    
    
    
    ;hexadecimal
    
    takeHexadecimalInput proc
        
        mov ah, 9
        lea dx, msg12
        int 21h
        xor dx, dx
        
        inputIntegerHex:
    
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        mov firstIdx, dx
        mov integer, dx
        mov fraction, dx    
        
        mov ah, 1
        mov cx, 4
        mov si, 0
        
        takeHexInt:
        
            int 21h
            
            cmp al, 0Dh
            je arrangeIntHex
            
            
            cmp al, 2Eh
            je arrangeIntHex
            
            
            cmp al, 39h
            jg setAlph_1
            
            sub al, 30h
            
            setvalue1:
            
            mov hexDummy[si], al
            inc si
            
            loop takeHexInt
            
         mov ah, 2
         mov dl, 2Eh
         int 21h
          
          jmp arrangeIntHex
          setAlph_1:
          
             sub al, 37h
             jmp setValue1
         
         
         arrangeIntHex:
            
            mov firstIdx, cx
             
             mov cx, 4
             sub cx, firstIdx
             mov si, 0
             
             cmp cx, 0
             je inputFractionHex
             
             nextHexDigit:
                 
                 mov bl, hexDummy[si]
                 push si
                 add si, firstIdx
                 mov hexArrInt[si], bl
                 pop si
                 inc si
                 
                 loop nextHexDigit
                 
             cmp al, 0Dh
             je endProc11
             
                                   
      ; taking the binary fraction part
      
      inputFractionHex:
                                   
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
            xor si, si
               
            mov ah, 1
            mov cx, 4
            mov si, 0
               
         takeHexFrac:
             
             int 21h
             
             cmp al, 0Dh
             je endProc11
             
             cmp al, 39h
             jg setAlph_2
             
             sub al, 30h
             
             setValue2:
             mov hexArrFrac[si], al
             inc si
             
             loop takeHexFrac
             
          jmp endProc11
          setAlph_2:
          
             sub al, 37h
             jmp setValue2
        
        endProc11:
        ret
        
    takeHexadecimalInput endp
    
    
    
    hexToIF proc
        
        
        hexToInteger:
    
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        
                                            
        mov cx, 4
        sub cx, firstIdx
        
        cmp cx, 0
        je hexToFraction
        
        mov si, 3
        mov bl, 16
        
        hexToBuildInt:         
           
           push bx
           mov al, hexArrInt[si]
           mov bx, mltpl
           
           mul bx
           
           add ax, integer
           mov integer, ax
           
           pop bx
           mov ax, mltpl
           mul bx 
           mov mltpl, ax
           xor ax, ax
           
           sub si, 1
           
           loop hexToBuildInt
        
        
   ;converting octal to fraction
   
   hexToFraction:
   
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        
                                            
        mov cx, 3
        mov bx, 16
        mov divisor, bx
        mov bx, 10000
        mov mltpl, bx
        mov si, 0
        
        hexToBuildFrac:
        
        mov al, hexArrFrac[si]
        mov bx, mltpl     
        mul bx                     
         
        mov bx, divisor            
        div bx                     
        
        add ax, fraction 
        mov fraction, ax
        
        xor dx, dx
        mov ax, divisor
        mov bx, 16
        mul bx          
        mov divisor, ax
        
        xor ax, ax
        
        inc si
        
        loop hexToBuildFrac
        
        ret
        
    hexToIF endp
    
    
    
    makeHexArrays proc
        
        ;converting ingeter part
        hexIntegerConversion:
             
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
             
             mov ax, integer
             mov cx, 4
             mov si, 3
             mov bx, 16
             
             nextHex1:
             
               div bx

               add dl, 30h
               cmp dl, 39h
               jg getAlph_1
                
               setAlph_3: 
               
               mov hexInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextHex1
               
               getAlph_1:
                    add cx, 1
                    add dl, 7h
                    loop setAlph_3
               
                
         ;converting the fraction part
         hexFractionConversion:
         
         xor ax, ax
         xor bx, bx
         xor cx, cx
         xor dx, dx
         xor si, si
         
       
               mov cx, 4
               mov bx, 10000 ; the modular is in bx
               mov si, 0
               mov ax, fraction
               
               nextHex2:
                push bx
                mov bx, 16
                mul bx
                
                pop bx
                div bx
                
                add al, 30h
                cmp al, 39h
                jg getAlph_2
                
                setAlph_4:
                
                mov hexFrac[si], al
                xor ax, ax
                mov ax, dx
                xor dx, dx
                inc si
                loop nextHex2
                 
                getAlph_2:
                    
                    add cx, 1
                    add al, 7h
                    loop setAlph_4
        
        endProc5:
        ret
        
    makeHexArrays endp
    
            
            
    printHex proc
        
        mov ah, 9
        lea dx, msg12
        int 21h
        xor dx, dx
        
        mov ah, 2
                
        mov cx, 4
        mov di, 0
        printHex1:
           
           mov dl, hexInt[di]
           int 21h
                    
           inc di
           loop printHex1
                
           mov bx, fraction
           cmp bx, 0
           je endProc3
                
           mov dl, 2Eh
           int 21h
                
        mov cx, 4
        mov si, 0
        printHex2:
                    
           mov dl, hexFrac[si]
           int 21h
           inc si
           loop printHex2
        
        endProc3:
        ret
        
    printHex endp
    
    
    
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
   
   
          
   newLine proc
             
         push ax
         push dx
             
         xor ax, ax
         xor dx, dx  
         
         mov ah, 2  
         mov dl, 0Ah
         int 21h
         mov dl, 0Dh
         int 21h
         mov ah, 2  
         mov dl, 0Ah
         int 21h
         mov dl, 0Dh
         int 21h       
                
         pop dx
         pop ax
             
         ret 
         
   newLine endp
   
   
   
   exitmsg proc
         
         push ax
         push dx
        
         xor ax, ax
         xor dx, dx
         
         mov ah, 9
         lea dx, msg8    
         int 21h
         call newLine
         
         pop dx
         pop ax
         
         ret
   
   exitmsg endp
   
   
   
   Hline proc
        
        push ax
        push dx
        
        xor ax, ax
        xor dx, dx
         
        mov ah, 9
        lea dx, msg13    
        int 21h
         
        pop dx
        pop ax
         
        ret
        
   Hline endp
   
ends

        
       
     

        
        ; YOUR CODE ENDS HERE
        
        MOV AX, 4C00H
        INT 21H 
        
    ;MAIN ENDP 
    END MAIN 
                      