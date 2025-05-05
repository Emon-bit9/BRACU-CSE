.MODEL SMALL 
.STACK 100H  

.DATA                           

MSG1 DB 'For Add type   :'1'$'  
MSG2 DB 10, 13, 'For Sub type   :'2'$'  
MSG3 DB 10, 13, 'For Mul type   :'3'$'  
MSG4 DB 10, 13, 'For Div type   :'4'$'  
MSG5 DB 10, 13, 'For Mod type   :'5'$'  
MSG6 DB 10, 13, 'For Pow type   :'6'$'  
MSG7 DB 10, 13, 'Choose Any One:$'      
MSG8 DB 10, 13, 10, 13, 'Enter 1st Number:$'
MSG9 DB 10, 13, 'Enter 2nd Number:$'         
MSG10 DB 10, 13, 10, 13, 'The Result is:$'   
MSG DB 10, 13, 10, 13,              

NUM1 DB ? 
NUM2 DB ?  
RESULT DB ?
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX 
    LEA DX, MSG1
    MOV AH, 9
    INT 21H         

    LEA DX, MSG2
    MOV AH, 9
    INT 21H

    LEA DX, MSG3
    MOV AH, 9
    INT 21H

    LEA DX, MSG4
    MOV AH, 9
    INT 21H

    LEA DX, MSG5
    MOV AH, 9
    INT 21H

    LEA DX, MSG6
    MOV AH, 9
    INT 21H

    LEA DX, MSG7
    MOV AH, 9
    INT 21H 
            
    MOV AH, 1
    INT 21H
    MOV BH, AL
    SUB BH, 48 
    CMP BH, 1
    JE ADDITION
            
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

ADDITION:  
    LEA DX, MSG8
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV BL, AL
    
    LEA DX, MSG9
    MOV AH, 9
    INT 21H
           
    MOV AH, 1
    INT 21H
    MOV CL, AL 
    
    ADD AL, BL
    MOV AH, 0
    AAA


    MOV BX, AX
    ADD BH, 48
    ADD BL, 48
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

SUBTRACTION: 
    LEA DX, MSG8
    MOV AH, 9
    INT 21H 

    MOV AH, 1
    INT 21H
    MOV BL, AL 
    LEA DX, MSG9
    MOV AH, 9
    INT 21H  

    MOV AH, 1
    INT 21H
    MOV CL, AL 
    SUB BL, CL
    ADD BL, 48 
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
                                       
                            

