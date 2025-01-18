; Student Marks Management System

.MODEL SMALL
.STACK 100H
.DATA
roll_numbers db 101, 102, 103, 104, 105, 106, 0, 0, 0, 0 
marks1       db 98, 69, 44, 88, 99, 30, 0, 0, 0, 0 
marks2       db 95, 44, 98, 98, 91, 33, 0, 0, 0, 0 
marks3       db 88, 78, 75, 82, 93, 66, 0, 0, 0, 0 
totals       dw 10 dup(0) 
average      dw ?         
max_marks    dw ?        
min_marks    dw ?        
found        dw ?        
mul1         db 100
mul2         db 10
student_count db 6       
temp          dw ?
max_idx       db ?
max_roll_idx  db ?
min_idx       db ?
min_roll_idx  db ?
temp_count    db ?
temp_count2   db ?
print_max     db "Highest Number: $"
print_max_roll db " Roll No.: $"
print_min     db "Lowest Number: $"
print_min_roll db " Roll No.: $"
print_avg     db "Average: $"
for_printing_roll db ":  Roll No.$"
for_printing_marks1 db " :  Marks1$"
for_printing_marks2 db " :  Marks2$"
for_printing_marks3 db " :  Marks3$"
for_printing_total_marks db " :  Total Marks$"
inp_roll            db ?
inp_roll_idx        db 0
failed_search       db "Student not found!$"
search_roll         db "Roll No.: $"
search_mark1        db "Marks 1: $"
search_mark2        db "Marks 2: $"
search_mark3        db "Marks 3: $"
search_total        db "Total Marks: $"
search_result       db "<<Result>>$"
search_position     db "Position in class: $"
inp_message         db "Enter your roll no.: $"
no_entry            db 0DH, 0AH, 0DH, 0AH, "Class capacity is full!$"
mark1               db ?
mark2               db ?
mark3               db ?
add_title_prompt    db 0DH, 0AH, 0DH, 0AH, "<<Enter information of the new student>>$"
curr_prompt         db "<<Updated Students info.>>$"
delete_failed       db "Student not found!$"
delete_roll         db 0DH, 0AH, 0DH, 0AH, "Enter the roll number to delete: $"
print_overall       db 0DH, 0AH, "<<Overall Result>>$"
prompt_standing     db "<<Standings>>$"
individual_res      db 0DH, 0AH, 0DH, 0AH, "<<Individual Result>>$"
WELCOME_MESSAGE     db "<<WELCOME TO OUR SYSTEM!>>$"
OPERATION_SHOW      db 0DH,0AH, 0DH, 0AH, "List of the operations:$"
FUNC1               db 0DH, 0AH, "  1. Add a student$"
FUNC2               db 0DH, 0AH, "  2. Delete a student$"
FUNC3               db 0DH, 0AH, "  3. Show the overall result$"
FUNC4               db 0DH, 0AH, "  4. Show individual result$"
FUNC5               db 0DH, 0AH, "  5. Exit$"
INP_OP              db 0DH, 0AH, "Your choice: $"
INV_MESSAGE         db 0DH, 0AH, "INVALID INPUT! PLEASE TRY AGAIN!$"
THANKS_MESSAGE      db 0DH, 0AH, "<<THANK YOU FOR USING OUR SYSTEM! HAVE A VERY GOOD DAY!>>$"
DELETE_FAILED_MSG   db 0DH, 0AH, 0DH, 0AH, "DUDE! THE LIST IS ALREADY EMPTY! DO YOU WANNA DELETE THE GHOST TOO?!$"
ADD_FAILED_MSG      db 0DH, 0AH, "This roll number already exists!$"
POPULATE_MSG        db 0DH, 0AH, 0DH, 0AH, "Sorry! All the lists are empty! Add some students first!$"
NO_STUDENT_SHOW     db 0DH, 0AH, 0DH, 0AH, "NO MORE STUDENTS TO SHOW!$"

.CODE
MAIN PROC
    ; Initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, WELCOME_MESSAGE
    MOV AH, 9
    INT 21H

PERFORM_OPERATION_LOOP:
    LEA DX, OPERATION_SHOW
    MOV AH, 9
    INT 21H
    LEA DX, FUNC1
    MOV AH, 9
    INT 21H
    LEA DX, FUNC2
    MOV AH, 9
    INT 21H
    LEA DX, FUNC3
    MOV AH, 9
    INT 21H
    LEA DX, FUNC4
    MOV AH, 9
    INT 21H
    LEA DX, FUNC5
    MOV AH, 9
    INT 21H
    LEA DX, INP_OP
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV BL, 1
    CMP AL, BL
    JE ADD_STUDENT_OP
    MOV BL, 2
    CMP AL, BL
    JE DELETE_STUDENT_OP
    MOV BL, 3
    CMP AL, BL
    JE SHOW_OVERALL_OP
    MOV BL, 4
    CMP AL, BL
    JE SHOW_IND_RES_OP
    MOV BL, 5
    CMP AL, BL
    JE EXIT_OP
    LEA DX, INV_MESSAGE
    MOV AH, 9
    INT 21H
    JMP PERFORM_OPERATION_LOOP
    
ADD_STUDENT_OP:
    CALL ADD_STUDENT
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    JMP PERFORM_OPERATION_LOOP

DELETE_STUDENT_OP:    
    CALL DELETE_STUDENT
    JMP PERFORM_OPERATION_LOOP
    
SHOW_OVERALL_OP:
    MOV AL, student_count
    MOV BL, 0
    CMP AL, BL
    JE POPULATE_THE_CLASS
    
    CALL CALC_TOTALS
    CALL FIND_MAX_MIN    
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    MOV AH, 9
    LEA DX, print_overall
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    CALL PRINT_MAX_MIN
    CALL CALC_AVERAGE
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H

    CALL PRINT_AVERAGE
    
    CALL SORT_TOTALS
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    LEA DX, prompt_standing
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    CALL PRINT_ROLLS_ARRAY
    
    LEA DX, for_printing_roll
    MOV AH, 9
    INT 21H
    
    MOV AH,2 
    MOV DL,0DH 
    INT 21H 
    MOV DL,0AH 
    INT 21H 
    
    CALL PRINT_MARKS1_ARRAY
    
    LEA DX, for_printing_marks1
    MOV AH, 9
    INT 21H
    
    MOV AH,2 
    MOV DL,0DH 
    INT 21H 
    MOV DL,0AH 
    INT 21H 
    
    CALL PRINT_MARKS2_ARRAY
    
    LEA DX, for_printing_marks2
    MOV AH, 9
    INT 21H
    
    MOV AH,2 
    MOV DL,0DH
    INT 21H
    MOV DL,0AH 
    INT 21H
    
    CALL PRINT_MARKS3_ARRAY
    
    LEA DX, for_printing_marks3
    MOV AH, 9
    INT 21H
    
    MOV AH,2 
    MOV DL,0DH
    INT 21H
    MOV DL,0AH 
    INT 21H

    CALL PRINT_TOTALS_ARRAY
    
    LEA DX, for_printing_total_marks
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    JMP PERFORM_OPERATION_LOOP

SHOW_IND_RES_OP:
    MOV AL, student_count
    MOV BL, 0
    CMP AL, BL
    JE POPULATE_THE_CLASS
    
    LEA DX, individual_res
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H    
    CALL SEARCH_STUDENT
    JMP PERFORM_OPERATION_LOOP
    
POPULATE_THE_CLASS:
    LEA DX, POPULATE_MSG
    MOV AH, 9
    INT 21H
    JMP PERFORM_OPERATION_LOOP
    
EXIT_OP:
    LEA DX, THANKS_MESSAGE
    MOV AH, 9
    INT 21H

    ; Exit to DOS
    MOV AX, 4C00H
    INT 21H

MAIN ENDP

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Feature 6.1: Add Student (Muntasir) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ADD_STUDENT PROC
    MOV AL, student_count
    MOV CL, AL           
    CMP CL, 10           
    JE MEMORY_FULL       

    ; Input Roll Number
    LEA DX, add_title_prompt
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    LEA DX, search_roll
    MOV AH, 9
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul1
    MUL BL
    MOV inp_roll, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul2
    MUL BL
    ADD inp_roll, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    ADD inp_roll, AL        
    
    XOR SI, SI
    XOR CX, CX
    MOV AL, inp_roll
    MOV CL, student_count
    MOV SI, 0
SEARCH_DUP_LOOP:
    MOV BL, roll_numbers[SI]
    CMP AL, BL
    JE FOUND_DUP
    INC SI
    LOOP SEARCH_DUP_LOOP
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H

    ; Input Marks for Subject 1
    LEA DX, search_mark1
    MOV AH, 9
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul1
    MUL BL
    MOV mark1, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul2
    MUL BL
    ADD mark1, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    ADD mark1, AL
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H

    ; Input Marks for Subject 2
    LEA DX, search_mark2
    MOV AH, 9
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul1
    MUL BL
    MOV mark2, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul2
    MUL BL
    ADD mark2, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    ADD mark2, AL
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H

    ; Input Marks for Subject 3
    LEA DX, search_mark3
    MOV AH, 9
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul1
    MUL BL
    MOV mark3, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul2
    MUL BL
    ADD mark3, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    ADD mark3, AL
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    LEA DX, curr_prompt
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    XOR AX, AX
    MOV AL, student_count
    MOV SI, AX
    MOV AL, inp_roll
    MOV roll_numbers[SI], AL
    MOV AL, mark1
    MOV marks1[SI], AL
    MOV AL, mark2
    MOV marks2[SI], AL
    MOV AL, mark3
    MOV marks3[SI], AL

    ; Increment student count
    INC student_count
    ;Printing the current list
    XOR CX, CX
    MOV CL, student_count
    XOR DI, DI

FOR_PRINTING_STUDENT_LIST:
    XOR AX, AX
    MOV AL, roll_numbers[DI]
    CALL PRINT_NUMBER
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    INC DI
    LOOP FOR_PRINTING_STUDENT_LIST
    
    LEA DX, for_printing_roll
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    XOR CX, CX
    MOV CL, student_count
    XOR DI, DI

FOR_PRINTING_MARKS1_OUTPUT:
    XOR AX, AX
    MOV AL, marks1[DI]
    CALL PRINT_NUMBER
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    INC DI
    LOOP FOR_PRINTING_MARKS1_OUTPUT
    
    LEA DX, for_printing_marks1
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    XOR CX, CX
    MOV CL, student_count
    XOR DI, DI

FOR_PRINTING_MARKS2_OUTPUT:
    XOR AX, AX
    MOV AL, marks2[DI]
    CALL PRINT_NUMBER
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    INC DI
    LOOP FOR_PRINTING_MARKS2_OUTPUT
    
    LEA DX, for_printing_marks2
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    XOR CX, CX
    MOV CL, student_count
    XOR DI, DI

FOR_PRINTING_MARKS3_OUTPUT:
    XOR AX, AX
    MOV AL, marks3[DI]
    CALL PRINT_NUMBER
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    INC DI
    LOOP FOR_PRINTING_MARKS3_OUTPUT
    
    LEA DX, for_printing_marks3
    MOV AH, 9
    INT 21H
        
    RET
FOUND_DUP:
    LEA DX, ADD_FAILED_MSG
    MOV AH, 9
    INT 21H
    RET

MEMORY_FULL:
    LEA DX, no_entry
    MOV AH, 9
    INT 21H
    RET
ADD_STUDENT ENDP

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Feature 6.2: Delete Student (Muntasir) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DELETE_STUDENT PROC
    MOV AL, student_count
    MOV BL, 0
    CMP AL, BL
    JE ALREADY_EMPTY
    
    LEA DX, delete_roll
    MOV AH, 9
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul1
    MUL BL
    MOV inp_roll, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul2
    MUL BL
    ADD inp_roll, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    ADD inp_roll, AL
    MOV AL, inp_roll

    XOR SI, SI
    XOR CX, CX            
    MOV CL, student_count

DELETE_LOOP:
    MOV BL, roll_numbers[SI]
    CMP AL, BL
    JE DELETE_FOUND

    INC SI
    LOOP DELETE_LOOP

    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    LEA DX, delete_failed
    MOV AH, 9
    INT 21H
    RET

DELETE_FOUND:
    MOV DI, SI
    XOR CX, CX
    MOV CX, 9
    SUB CX, DI
    DEC CX

SHIFT_LOOP:
    MOV AL, roll_numbers[DI+1]
    MOV roll_numbers[DI], AL

    MOV AL, marks1[DI+1]
    MOV marks1[DI], AL

    MOV AL, marks2[DI+1]
    MOV marks2[DI], AL

    MOV AL, marks3[DI+1]
    MOV marks3[DI], AL

    INC DI
    LOOP SHIFT_LOOP
    
    MOV DI, 9
    MOV roll_numbers[DI], 0
    MOV marks1[DI], 0
    MOV marks2[DI], 0
    MOV marks3[DI], 0

    ; Decrement student count
    DEC student_count
    MOV AL, student_count
    CMP AL, 0
    JE NO_STUDENT
    
    XOR AX, AX
    XOR CX, CX
    XOR DI, DI
    MOV CL, student_count
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    LEA DX, curr_prompt
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    FOR_PRINTING_STUDENT_LIST_DEL:
    XOR AX, AX
    MOV AL, roll_numbers[DI]
    CALL PRINT_NUMBER
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    INC DI
    LOOP FOR_PRINTING_STUDENT_LIST_DEL
    
    LEA DX, for_printing_roll
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    XOR CX, CX
    MOV CL, student_count
    XOR DI, DI

FOR_PRINTING_MARKS1_OUTPUT_DEL:
    XOR AX, AX
    MOV AL, marks1[DI]
    CALL PRINT_NUMBER
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    INC DI
    LOOP FOR_PRINTING_MARKS1_OUTPUT_DEL
    
    LEA DX, for_printing_marks1
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    XOR CX, CX
    MOV CL, student_count
    XOR DI, DI

FOR_PRINTING_MARKS2_OUTPUT_DEL:
    XOR AX, AX
    MOV AL, marks2[DI]
    CALL PRINT_NUMBER
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    INC DI
    LOOP FOR_PRINTING_MARKS2_OUTPUT_DEL
    
    LEA DX, for_printing_marks2
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    
    XOR CX, CX
    MOV CL, student_count
    XOR DI, DI

FOR_PRINTING_MARKS3_OUTPUT_DEL:
    XOR AX, AX
    MOV AL, marks3[DI]
    CALL PRINT_NUMBER
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    INC DI
    LOOP FOR_PRINTING_MARKS3_OUTPUT_DEL
    
    LEA DX, for_printing_marks3
    MOV AH, 9
    INT 21H
    RET
    
ALREADY_EMPTY:
    LEA DX, DELETE_FAILED_MSG
    MOV AH, 9
    INT 21H
    RET
NO_STUDENT:
    LEA DX, NO_STUDENT_SHOW
    MOV AH, 9
    INT 21H
    RET

DELETE_STUDENT ENDP


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Feature 1: Calculate totals (Puspita) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CALC_TOTALS PROC
    MOV CX, 0
    MOV CL, student_count
    MOV SI, 0
    MOV DI, 0

CALC_LOOP:
    MOV AX, 0
    MOV BX, 0
    MOV AL, marks1[DI]
    MOV BL, AL
    MOV AL, marks2[DI]
    ADD BX, AX
    MOV AL, marks3[DI]
    ADD BX, AX
    MOV totals[SI], BX
    INC DI
    ADD SI, 2
    LOOP CALC_LOOP
    RET
CALC_TOTALS ENDP

PRINT_TOTALS_ARRAY PROC
    MOV CL, 0
    MOV SI, 0             
    MOV CL, student_count 

PRINT_LOOP:
    MOV AX, totals[SI]    
    CALL PRINT_NUMBER     

    ; Print a space after each number
    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    ADD SI, 2             
    LOOP PRINT_LOOP      

    RET
PRINT_TOTALS_ARRAY ENDP


;<<<<<<<<<<<<<<<<<<<<<<<< Feature 2: Finding Maximum and Minimum marks and corresponding roll no. (Puspita) >>>>>>>>>>>>>>>>>>>>>>>>>>
FIND_MAX_MIN PROC
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    MOV AX, totals[0]
    MOV max_marks, AX
    MOV min_marks, AX
    MOV temp_count, 0
    MOV temp_count2, 0
    MOV max_idx, 0
    MOV min_idx, 0

    MOV CL, student_count
    MOV SI, 0

MAX_MIN_LOOP:
    MOV AX, totals[SI]
    CMP AX, max_marks
    JLE CHECK_MIN
    MOV max_marks, AX
    MOV DL, temp_count
    MOV max_roll_idx, DL
    MOV DL, temp_count2
    MOV max_idx, DL

CHECK_MIN:
    CMP AX, min_marks
    JGE NEXT
    MOV min_marks, AX
    MOV DL, temp_count
    MOV min_roll_idx, DL
    MOV DL, temp_count2
    MOV min_idx, DL

NEXT:
    ADD SI, 2
    INC temp_count
    ADD temp_count2, 2
    LOOP MAX_MIN_LOOP
    MOV AX, max_marks
    MOV BX, min_marks
    XOR AX, AX
    XOR BX, BX
    MOV AL, max_idx
    MOV BL, min_idx
    RET
FIND_MAX_MIN ENDP


PRINT_MAX_MIN PROC
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    XOR SI, SI
    XOR DI, DI
    
    MOV AH, 9
    LEA DX, print_max
    INT 21H
    
    XOR AX, AX
    MOV AL, max_idx
    MOV SI, AX
    MOV AX, totals[SI]
    CALL PRINT_NUMBER
    
    MOV AH, 9
    LEA DX, print_max_roll
    INT 21H
    
    XOR AX, AX
    XOR SI, SI
    MOV AL, max_roll_idx
    MOV SI, AX
    MOV AL, roll_numbers[SI]
    CALL PRINT_NUMBER
    
    MOV AH,2
    MOV DL,0DH
    INT 21H 
    MOV DL,0AH
    iNT 21H 
    
    MOV AH, 9
    LEA DX, print_min
    INT 21H
    
    XOR AX, AX
    MOV AL, min_idx
    MOV SI, AX
    MOV AX, totals[SI]
    CALL PRINT_NUMBER
    
    MOV AH, 9
    LEA DX, print_min_roll
    INT 21H
    
    XOR AX, AX
    XOR SI, SI
    MOV AL, min_roll_idx
    MOV SI, AX
    MOV AL, roll_numbers[SI]
    CALL PRINT_NUMBER
    
    RET    

PRINT_MAX_MIN ENDP


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Feature 3: Calculate the average marks of the class (Saj) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CALC_AVERAGE PROC
    XOR AX, AX
    XOR DX, DX
    MOV CL, student_count
    MOV SI, 0

SUM_LOOP:
    ADD AX, totals[SI]
    ADD SI, 2
    LOOP SUM_LOOP
    
    XOR CX, CX
    MOV CL, student_count
    DIV CX
    MOV average, AX
    RET
CALC_AVERAGE ENDP

PRINT_AVERAGE PROC
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    XOR SI, SI
    XOR DI, DI
    
    MOV AH, 9
    LEA DX, print_avg
    INT 21H
    
    XOR AX, AX
    MOV AX, average
    CALL PRINT_NUMBER
    
    RET    

PRINT_AVERAGE ENDP


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Feature 4: Sort all the marks and totals (Saj) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SORT_TOTALS PROC
    MOV AL, student_count
    MOV BL, 1
    CMP AL, BL
    JE ONE_MAN_ARMY
    
    MOV CL, student_count       
    DEC CX                     

OUTER_LOOP:
    MOV SI, 0                   
    MOV DI, 0                  
    MOV DX, CX                 

INNER_LOOP:
    ; Compare totals[SI] and totals[SI+2]
    MOV AX, totals[SI]
    MOV BX, totals[SI+2]

    CMP AX, BX
    JGE SKIP_SWAP              

    ; Swap totals
    MOV totals[SI], BX
    MOV totals[SI+2], AX

    ; Swap roll_numbers
    MOV AL, roll_numbers[DI]
    MOV BL, roll_numbers[DI+1]
    MOV roll_numbers[DI], BL
    MOV roll_numbers[DI+1], AL

    ; Swap marks1
    MOV AL, marks1[DI]
    MOV BL, marks1[DI+1]
    MOV marks1[DI], BL
    MOV marks1[DI+1], AL

    ; Swap marks2
    MOV AL, marks2[DI]
    MOV BL, marks2[DI+1]
    MOV marks2[DI], BL
    MOV marks2[DI+1], AL

    ; Swap marks3
    MOV AL, marks3[DI]
    MOV BL, marks3[DI+1]
    MOV marks3[DI], BL
    MOV marks3[DI+1], AL

SKIP_SWAP:
    INC DI                      
    ADD SI, 2                  
    DEC DX                     
    JNZ INNER_LOOP            

    DEC CX                    
    JNZ OUTER_LOOP             

    RET
    
ONE_MAN_ARMY:
    RET

SORT_TOTALS ENDP


PRINT_ROLLS_ARRAY PROC
    MOV CL, 0
    MOV SI, 0             
    MOV CL, student_count 

PRINT_LOOP1:
    XOR AX, AX
    XOR DX, DX
    MOV AL, roll_numbers[SI]   
    CALL PRINT_NUMBER    

    ; Print a space after each number
    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    ADD SI, 1             
    LOOP PRINT_LOOP1      

    RET
PRINT_ROLLS_ARRAY ENDP


PRINT_MARKS1_ARRAY PROC
    MOV CL, 0
    MOV SI, 0           
    MOV CL, student_count 

PRINT_LOOP2:
    XOR AX, AX
    XOR DX, DX
    MOV AL, marks1[SI]   
    CALL PRINT_NUMBER    

    ; Print a space after each number
    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    ADD SI, 1            
    LOOP PRINT_LOOP2      

    RET
PRINT_MARKS1_ARRAY ENDP


PRINT_MARKS2_ARRAY PROC
    MOV CL, 0
    MOV SI, 0            
    MOV CL, student_count

PRINT_LOOP3:
    XOR AX, AX
    XOR DX, DX
    MOV AL, marks2[SI]   
    CALL PRINT_NUMBER    

    ; Print a space after each number
    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    ADD SI, 1           
    LOOP PRINT_LOOP3     

    RET
PRINT_MARKS2_ARRAY ENDP
                      
                      
PRINT_MARKS3_ARRAY PROC
    MOV CL, 0
    MOV SI, 0            
    MOV CL, student_count 

PRINT_LOOP4:
    XOR AX, AX
    XOR DX, DX
    MOV AL, marks3[SI]   
    CALL PRINT_NUMBER   

    ; Print a space after each number
    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    ADD SI, 1            
    LOOP PRINT_LOOP4      

    RET
PRINT_MARKS3_ARRAY ENDP


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Feature 5: Search student and print the individual's result (Muntasir) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SEARCH_STUDENT PROC
    LEA DX, inp_message
    MOV AH, 9
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul1
    MUL BL
    MOV inp_roll, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL
    XOR AX, AX
    MOV AL, CL
    MOV BL, mul2
    MUL BL
    ADD inp_roll, AL
    XOR AX, AX
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    ADD inp_roll, AL

    XOR SI, SI
    MOV CL, student_count
    MOV BL, inp_roll

SEARCH_LOOP:
    MOV AL, roll_numbers[SI]
    CMP AL, BL
    JE FOUND_ELEMENT

    INC SI
    LOOP SEARCH_LOOP

    MOV found, 0
    JMP MOVE_ON

FOUND_ELEMENT:
    MOV found, 1
    XOR AX, AX
    MOV AX, SI
    MOV inp_roll_idx, AL
    JMP MOVE_ON
    
MOVE_ON:
    MOV AH,2 
    MOV DL,0DH
    INT 21H 
    MOV DL,0AH
    INT 21H
    XOR AX, AX
    MOV BX, BX
    MOV AX, found
    MOV BX, 0
    CMP AX, BX
    JNE PRINT_DETAIL
    LEA DX, failed_search
    MOV AH, 9
    INT 21H
    JMP END_PROCEDURE

PRINT_DETAIL:
    XOR SI, SI
    LEA DX, search_result
    MOV AH, 9
    INT 21H
    
    MOV AH,2 
    MOV DL,0DH
    INT 21H 
    MOV DL,0AH
    INT 21H
    
    LEA DX, search_roll
    MOV AH, 9
    INT 21H
    
    XOR AX, AX
    MOV AL, inp_roll_idx
    MOV SI, AX
    MOV AL, roll_numbers[SI]
    CALL PRINT_NUMBER
    
    MOV AH,2 
    MOV DL,0DH
    INT 21H 
    MOV DL,0AH
    INT 21H
    
    LEA DX, search_mark1
    MOV AH, 9
    INT 21H
    
    XOR AX, AX
    MOV AL, inp_roll_idx
    MOV SI, AX
    MOV AL, marks1[SI]
    CALL PRINT_NUMBER
    
    MOV AH,2 
    MOV DL,0DH
    INT 21H 
    MOV DL,0AH
    INT 21H
    
    LEA DX, search_mark2
    MOV AH, 9
    INT 21H
    
    XOR AX, AX
    MOV AL, inp_roll_idx
    MOV SI, AX
    MOV AL, marks2[SI]
    CALL PRINT_NUMBER
    
    MOV AH,2 
    MOV DL,0DH
    INT 21H 
    MOV DL,0AH
    INT 21H
    
    LEA DX, search_mark3
    MOV AH, 9
    INT 21H
    
    XOR AX, AX
    MOV AL, inp_roll_idx
    MOV SI, AX
    MOV AL, marks3[SI]
    CALL PRINT_NUMBER
    
    MOV AH,2 
    MOV DL,0DH
    INT 21H 
    MOV DL,0AH
    INT 21H
    
    LEA DX, search_total
    MOV AH, 9
    INT 21H
    
    XOR AX, AX
    MOV AL, inp_roll_idx
    MOV BX, 2
    MUL BX
    MOV SI, AX
    MOV AX, totals[SI]
    CALL PRINT_NUMBER
    
    MOV AH,2 
    MOV DL,0DH
    INT 21H 
    MOV DL,0AH
    INT 21H
    
    LEA DX, search_position
    MOV AH, 9
    INT 21H
    
    XOR AX, AX
    MOV AL, inp_roll_idx
    ADD AL, 1
    CALL PRINT_NUMBER
    
    
    
END_PROCEDURE:    
    RET
SEARCH_STUDENT ENDP

;Print 3-digit number
PRINT_NUMBER PROC
    ; Print the hundreds digit
    XOR DX, DX          
    MOV BX, 100          
    DIV BX
    ADD AL, 30h       
    MOV temp, DX
    MOV DL, AL
    MOV AH, 02H
    INT 21H              

    ; Print the tens digit
    MOV AX, temp           
    XOR DX, DX          
    MOV BX, 10         
    DIV BX
    MOV temp, DX
    ADD AL, 30h
    MOV DL, AL
    MOV AH, 02H
    INT 21H              

    ; Print the units digit
    MOV DX, temp
    ADD DL, 30h
    MOV AH, 02H
    INT 21H 

    RET
PRINT_NUMBER ENDP


    END MAIN