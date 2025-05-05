.MODEL SMALL 
.STACK 100H  

.DATA                           

MSG1 DB 'For Add type   :'1'$'  
MSG2 DB 10, 13, 'For Sub type   :'2'$'  
MSG3 DB 10, 13, 'For Mul type   :'3'$'  
MSG4 DB 10, 13, 'For Div type   :'4'$'  
MSG5 DB 10, 13, 'For Mod type   :'5'$'  
MSG6 DB 10, 13, 'For Pow type   :'6'$'  
MSG7 DB 10, 13, 'Choose Any One:$'          ;to choose any one operation.    
MSG8 DB 10, 13, 10, 13, 'Enter 1st Number:$'
MSG9 DB 10, 13, 'Enter 2nd Number:$'         
MSG10 DB 10, 13, 10, 13, 'The Result is:$'   
MSG DB 10, 13, 10, 13,              

NUM1 DB ?   ;hold input 
NUM2 DB ?  
RESULT DB ?  ; show and  to store the result
.CODE
MAIN PROC
    MOV AX, @DATA  ;Load the address of the data segment into the AX register.
    MOV DS, AX 
    

    
    LEA DX, MSG1  ; choose addition
    MOV AH, 9
    INT 21H         

    LEA DX, MSG2  ; choose subtraction
    MOV AH, 9
    INT 21H

    LEA DX, MSG3   ; choose multiplica
    MOV AH, 9
    INT 21H

    LEA DX, MSG4
    MOV AH, 9
    INT 21H

    LEA DX, MSG5
    MOV AH, 9
    INT 21H

    LEA DX, MSG6    ; to choose Power
    MOV AH, 9
    INT 21H

    LEA DX, MSG7   ;General prompt to choose any one operation
    MOV AH, 9
    INT 21H 
    
    
    ;to Accept User Input for Operation
            
    MOV AH, 1  ;Set up AH register for reading a input 
    INT 21H    ; Call the DOS interrupt to read a character from the keyboard.
    
    
    MOV BH, AL  ;Moving the input character to register BH.
    SUB BH, 48  ;Convert the ASCII character representing the digit to its numeric value by subtracting the ASCII value of '0' (48).
    
    
    CMP BH, 1   ;Compare the user's choice (stored in BH) with the numeric values for each arithmetic operation.

    JE ADDITION  ;instructions: If the comparison matches a specific operation, jump to the corresponding section of code to perform that operation.
            
    CMP BH, 2
    JE SUBTRACTION

    CMP BH, 3
    JE MULTIPLICATION

    CMP BH, 4
    JE DIVISION

    CMP BH, 5
    JE MODULUS

    CMP BH, 6
    JE POWER

    JMP EXIT_PROGRAM

;Jump to Respective Operation Sections

ADDITION:  
    LEA DX, MSG8  ;enter the first number into the DX .

    MOV AH, 9 ;to display a string.
    INT 21H  ;Call to display the message.
    
    ;Reading First Number Input
    MOV AH, 1 ;Set up AH register for reading input.
    INT 21H  
    MOV BL, AL 
    
    
    ;Display 2nd Input 
    LEA DX, MSG9  
    MOV AH, 9    
    INT 21H   
    
    
    ;Reading Second Number Input       
    MOV AH, 1
    INT 21H
    MOV CL, AL  ;Move the input character (second digit) to register CL
    
    
    ;Perform Addition
    ADD AL, BL  ;Add the ASCII values of the first and second numbers
    MOV AH, 0  ;Clear AH register for division operation
    AAA   ; ASCII adjust after addition

    
    
    ;Convert Result to ASCII and Display
    MOV BX, AX  
    ADD BH, 48   ;Converting the result  to ASCII 
    ADD BL, 48   
    LEA DX, MSG10  ;indicating the result into the DX register.
    
    
    MOV AH, 9 ;to display string
    INT 21H   
           
           
    ;Display Result       
    MOV AH, 2    ;Set up AH register for display character function.
    MOV DL, BH
    INT 21H  

    MOV AH, 2
    MOV DL, BL   ; display low byte
    INT 21H 

    JMP EXIT_PROGRAM  

SUBTRACTION: 
    LEA DX, MSG8  ;enter 1st number
    MOV AH, 9      ; to display string
    INT 21H 
    
    ;Read First Number Input
    MOV AH, 1
    INT 21H
    MOV BL, AL
    
    ;to display 2nd num 
    LEA DX, MSG9
    MOV AH, 9
    INT 21H  
     
     
    ; read 2nd num 
    MOV AH, 1
    INT 21H
    MOV CL, AL
    
    ;Perform Subtraction: 
    SUB BL, CL
    ADD BL, 48 
    
    ;convert result into ascii
    LEA DX, MSG10
    MOV AH, 9
    INT 21H 
            
    MOV AH, 2
    MOV DL, BL
    INT 21H 

    JMP EXIT_PROGRAM   

MULTIPLICATION: 
    LEA DX, MSG8
    MOV AH, 9
    INT 21H 

    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV NUM1, AL
    LEA DX, MSG9
    MOV AH, 9
    INT 21H 

    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV NUM2, AL   
    MUL NUM1
    MOV RESULT, AL
    AAM     
    ADD AH, 30H
    ADD AL, 30H
              
    MOV BX, AX
    LEA DX, MSG10
    MOV AH, 9
    INT 21H

    MOV AH, 2
    MOV DL, BH
    INT 21H    

    MOV AH, 2
    MOV DL, BL
    INT 21H   

    JMP EXIT_PROGRAM   
    
DIVISION: 
    LEA DX, MSG8
    MOV AH, 9
    INT 21H  

    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV NUM1, AL 
    
    LEA DX, MSG9
    MOV AH, 9
    INT 21H 

    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV NUM2, AL 

    MOV CL, NUM1
    MOV CH, 00
    MOV AX, CX 
    
    DIV NUM2
    MOV RESULT, AL
    MOV AH, 00
    AAD  
    

    ADD AH, 30H
    ADD AL, 30H
             
             
    MOV BX, AX
    
    LEA DX, MSG10
    MOV AH, 9
    INT 21H 

    MOV AH, 2
    MOV DL, BH
    INT 21H  

    MOV AH, 2
    MOV DL, BL
    INT 21H   

    JMP EXIT_PROGRAM    
    
MODULUS: 

    LEA DX, MSG8
    MOV AH, 9
    INT 21H   

    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV NUM1, AL 
    
    LEA DX, MSG9
    MOV AH, 9
    INT 21H 

    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV NUM2, AL   
    MOV CL, NUM1
    MOV CH, 00
    MOV AX, CX  

    DIV NUM2
    MOV RESULT, AH
    ADD RESULT, 30H  
    LEA DX, MSG10
    MOV AH, 9
    INT 21H 

    MOV AH, 2
    MOV DL, 00
    INT 21H  

    MOV AH, 2
    MOV DL, RESULT
    INT 21H 

    JMP EXIT_PROGRAM 

POWER:
    LEA DX, MSG8   
    MOV AH, 9   
    INT 21H  

    MOV AH, 1  
    
    INT 21H 
    
    SUB AL, 30H  
    MOV NUM1, AL 

    LEA DX, MSG9 
    MOV AH, 9   
    INT 21H     

    MOV AH, 1 
    INT 21H
    SUB AL, 30H 
    MOV NUM2, AL 

    MOV CL, NUM1 
    MOV AX, 1    

POWER_LOOP:
    MUL CX   
    LOOP POWER_LOOP  

    MOV RESULT, AL  
    ADD RESULT, 30H 

    LEA DX, MSG10   
    MOV AH, 9       
    INT 21H         

    MOV AH, 2       
    MOV DL, 00      
    INT 21H         

    MOV AH, 2       
    MOV DL, RESULT  
    INT 21H         

    JMP EXIT_PROGRAM 
EXIT_PROGRAM:
    LEA DX, MSG  
    MOV AH, 9 
    INT 21H

    MOV AH, 4CH
    INT 21H 
MAIN ENDP   
END MAIN    
                                       
                            

