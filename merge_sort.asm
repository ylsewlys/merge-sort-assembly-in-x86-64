%include "io64.inc"


section .data
        ; integer array to be sorted
        numArr dd -5, 4, 3, 3, 1, 9, 15, 14, 27, 0, -13
        ; number of elements in numArr
        arraySize dq 11
	left_array times 1000 dq -999
	right_array times 1000 dq -999
	curr_size dq 0
	left_start dq 0
	limit dq 0
	mid dq 0
	right_end dq 0
	i dq 0
	j dq 0
	k dq 0
	n1 dq 0
	n2 dq 0

section .text
global CMAIN
CMAIN:
    mov rbp, rsp; for correct debugging
		xor rax, rax
		xor rbx, rbx ; to be used as temporary register for limit
		xor rsi, rsi
		xor r10, r10
		xor r11, r11
		xor r12, r12 ; to be used as temporary register for curr_size
		xor r13, r13 ; to be used as temporary register for '2 * curr_size' expression
		xor r14, r14 

		;xor r15, r15
		lea rcx, [numArr] ; load address of array to r15
                    
                PRINT_STRING "Iterative Merge Sort Algorithm in x86-64 Assembly Language"
                NEWLINE
                NEWLINE
                PRINT_STRING "Given Array: "
                NEWLINE
                
PRINT_GIVEN_ARRAY:
                cmp r10, [arraySize]
                jge START_ALGORITHM
                PRINT_DEC 4, [rcx+4*r10]
                PRINT_STRING " "
                inc r10
                jmp PRINT_GIVEN_ARRAY
                
                
                ; clear r10 register
                xor r10, r10
                NEWLINE

                
                
                
START_ALGORITHM:                

		; initialize n - 1 as limit for loops
                 mov rdx, [arraySize]
		mov qword [limit], rdx
		sub qword [limit], 1

		; initialize curr_size to 1
		mov qword [curr_size], 1

		; load limit value to register RBX
		mov rbx, [limit]


		; outer for loop
OUTER_FOR_LOOP:
		cmp [curr_size], rbx
		jg END


		mov qword [left_start], 0
INNER_FOR_LOOP:
		cmp [left_start], rbx
		jge UPDATE_OUTER_FOR_LOOP_EXPRESSION


		; assign (left_start + curr_size - 1) to r14
		xor r14, r14
		add r14, qword [left_start]
		add r14, qword [curr_size]
		sub r14, 1

		; a -> r14 | b -> [limit]
		cmp r14, [limit]
		JL get_A_mid
get_B_mid:
		xor r14, r14
		mov r14, [limit]
		mov qword [mid], r14
		jmp next_get_min
get_A_mid:
		mov qword [mid], r14
	
next_get_min:
		; assign (left_start + 2 * curr_size - 1) to r14
		xor r14, r14
		imul r14, [curr_size], 2
		add r14, qword [left_start]
		sub r14, 1		

		; a -> r14 | b -> [limit]
		cmp r14, [limit]
		JL get_A_right_end
get_B_right_end:
		xor r14, r14
		mov r14, [limit]
		mov qword [right_end], r14
		jmp skip_get_A_right_end

get_A_right_end:
		mov qword [right_end], r14

skip_get_A_right_end:

		; implement merge here

		; int n1 = m - l + 1;
		mov qword [n1], 0
		xor r14, r14
		mov r14, [mid]
		add qword [n1], r14
		mov r14, [left_start]
		sub qword [n1], r14
		add qword [n1], 1


		; int n2 = r - m;
		mov qword [n2], 0
		xor r14, r14
		mov r14, [right_end]
		add qword [n2], r14
		mov r14, [mid]
		sub qword [n2], r14
		

		;for (i = 0; i < n1; i++)
		;	L[i] = arr[l + i];
		lea rsi, [left_array]


		; load integer i to r11
		xor r11, r11
		mov r11, 0

INIT_LEFT_ARRAY:
		cmp r11, [n1]
		jge DONE_INIT_LEFT_ARRAY

		; r14 = 0
		xor r14, r14
		; r14 += l
		add r14, [left_start]
		; r14 += i
		add r14, r11

		; r12 = arr[l + i]
		xor r12, r12
		mov r12, [rcx+4*r14]



		;L[i] = r12;
		mov [rsi+8*r11], r12

		
		inc r11
		jmp INIT_LEFT_ARRAY
		
DONE_INIT_LEFT_ARRAY:
		; for (j = 0; j < n2; j++)
			; R[j] = arr[m + 1 + j];
		xor rdi, rdi
		lea rdi, [right_array]


		; load integer i to r11
		xor r11, r11
		mov r11, 0

INIT_RIGHT_ARRAY:	
		cmp r11, [n2]
		je DONE_INIT_RIGHT_ARRAY

		
		; r14 = 0
		xor r14, r14
		; r14 += m
		add r14, [mid]
		; r14 += j
		add r14, r11
		; r14 += 1
		add r14, 1
		
		; r12 = arr[m + 1 + j];
		xor r12, r12
		mov r12, [rcx+4*r14]


		;R[j] = r12;
		mov [rdi+8*r11], r12


		mov r12, [rdi+8*r11]

		
		inc r11
		jmp INIT_RIGHT_ARRAY	


DONE_INIT_RIGHT_ARRAY:
	
		; i = 0
		mov r12, 0
		
		; j = 0
		mov r13, 0

		; k = l
		xor r14, r14
		xor r11, r11
		mov r14, [left_start]
		mov r11, r14


		lea rsi, [left_array]
		lea rdi, [right_array]


		
MERGE_TEMP_ARRAYS_BACK:
		;while(i < n1 && j < n2)
		cmp r12, [n1]
		jge END_CONDITION
		
		cmp r13, [n2]
		jge END_CONDITION
		

		xor r14d, r14d
		xor r15d, r15d
		mov r14d, [rsi+8*r12] ; Load L[i]
		mov r15d, [rdi+8*r13] ; Load R[j]

		; if (L[i] <= R[j])
		cmp r14d, r15d
		jg ELSE_CONDITION
		
		;arr[k] = L[i];
		mov [rcx+4*r11], r14d
		; i++
		inc r12
		jmp INCREMENT_K

ELSE_CONDITION:
		; arr[k] = R[j];
		mov [rcx+4*r11], r15d
		; j++
		inc r13
		
INCREMENT_K:
		; k++
		inc r11
		JMP MERGE_TEMP_ARRAYS_BACK

END_CONDITION:	
 
COPY_REMAINING_L_ELEMENTS:
                ;  (i < n1)
                cmp r12, [n1]
                jge GO_TO_NEXT_WHILE_LOOP
                
                xor r14d, r14d
                ;r14d = L[i]
                mov r14d, [rsi+8*r12]
                ; arr[k] = r14d
                mov [rcx+4*r11], r14d
                
                inc r12
                inc r11
                jmp COPY_REMAINING_L_ELEMENTS
            
GO_TO_NEXT_WHILE_LOOP:
                cmp r13, [n2]
                jge END_MERGE_FUNCTION
                
                xor r15d, r15d
                ;r15d = R[i]
                mov r15d, [rdi+8*r13]
                ; arr[k] = R[i]
                mov [rcx+4*r11], r15d
                 
                  
                inc r13
                inc r11
                jmp GO_TO_NEXT_WHILE_LOOP
                
END_MERGE_FUNCTION:
		xor r13, r13
		imul r13, [curr_size], 2
		add qword [left_start], r13
		jmp INNER_FOR_LOOP





UPDATE_OUTER_FOR_LOOP_EXPRESSION:
		;mov r12, [curr_size]
		imul r12, qword [curr_size], 2
		mov qword [curr_size], r12
		jmp OUTER_FOR_LOOP
		
END:
 
        ; print array
        xor r15, r15
        NEWLINE
        NEWLINE
        PRINT_STRING "Sorted Array:"
        NEWLINE
 
PRINT_LOOP:       
        cmp r15, [arraySize]
        je END_PRINT
        PRINT_DEC 4, [rcx+4*r15]
        PRINT_STRING " "
        inc r15
        jmp PRINT_LOOP
 
END_PRINT:

	ret