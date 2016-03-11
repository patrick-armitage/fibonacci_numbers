TITLE Fibonacci Numbers

; Author:              Patrick Armitage    
; Date:                01/18/2016
; Description: A MASM program which receives user input of the number of terms
;              they want displayed in the Fibonacci sequence, between 1 - 46,
;              and displays them 5 terms per line.  The program also requests
;              the user's name, and terminates with a personal parting message.

INCLUDE Irvine32.inc

.data
authorname  BYTE  "Patrick Armitage",0
intro_1     BYTE  "Fibonacci Numbers",0
intro_2     BYTE  "Programmed by ",0
prompt_1    BYTE  "What's your name? ",0
intro_3     BYTE  "Enter the number of Fibonacci terms to be displayed",0dh,0ah
            BYTE  "Give the number as an integer in the range [1..46].",0
prompt_2    BYTE  "How many Fibonacci terms do you want? ",0
username    BYTE  16 DUP(0)   ; user enters--must be one more than string size
greeting    BYTE  "Hello, ",0
num_terms   DWORD ?   ; user enters
start_term  equ   0           ; constant used in both prev and curr terms
prev_term   DWORD start_term  ; start at 0, since prev + curr = next, & curr = 1
curr_term   DWORD (start_term + 1)
col_spacer  BYTE  "     ",0
ch_counter  DWORD 0   ; used to count # of terms printed up to 5, then new row
outofrange  BYTE  "Out of range.  Enter a number in [1..46]",0
goodbye_1   BYTE  "Results certified by ",0
goodbye_2   BYTE  "Goodbye, ",0
period      BYTE  ".",0

.code
main PROC

;########## INTRODUCTION
; Introduce this program
  mov   edx, OFFSET intro_1
  call  WriteString
  call  CrLf
  mov   edx, OFFSET intro_2
  call  WriteString
  mov   edx, OFFSET authorname
  call  WriteString
  call  CrLf
  call  CrLf

;########## GATHER DATA
; Prompt user to enter username
  mov   edx, OFFSET prompt_1
  call  WriteString
  mov   ecx, 15   ; string size allowed
  mov   edx, OFFSET username   ; mov string to edx so ReadString can write to it
  call  ReadString
  mov   edx, OFFSET greeting
  call  WriteString
  mov   edx, OFFSET username
  call  WriteString
  call  CrLf

; Explain the rules of entering Fibonacci terms
  mov   edx, OFFSET intro_3
  call  WriteString
  call  CrLf
  call  CrLf

; Ask the user for the number of terms
terms:
  mov   edx, OFFSET prompt_2
  call  WriteString
  call  ReadInt
  mov   num_terms, eax   ; move the number of terms to eax for comparison
  cmp   eax, 0
  jle   invalid          ; if number of terms <= 0, jump to invalid
  cmp   eax, 46
  jg    invalid          ; if number of terms > 46, jump to invalid
  call  CrLf
  jmp   checkterms

; Print user input invalid message, then jump back to terms (post test loop)
invalid:
  mov   edx, OFFSET outofrange
  call  WriteString
  call  CrLf
  jmp   terms

;########## CALCULATE
; Finds the values of each of the Fibonacci terms

; Check the number of terms and print the 1st term, increment ch_counter
checkterms:
  mov   ecx, num_terms
  mov   eax, 1   ; we print the 1st 1, because it doesn't fit into formula well
  call  WriteDec
  mov   edx, OFFSET col_spacer  ; prints 5 spaces after each number
  call  WriteString
  mov   eax, ecx
  sub   eax, 1    ; decrement ecx since we printed one of the numbers
  mov   ecx, eax
  cmp   eax, 0    ; if ecx = 0 now, no need to enter the loop, we can quit now
  je    earlygoodbye
  mov   eax, ch_counter
  add   eax, 1  ; since we've printed the 1st number, increment counter by 1
  mov   ch_counter, eax

; Loops for the number of terms specified by the user, calculating and
; printing Fibonacci sequence numbers in rows of 5
fibloop:
  mov   eax, curr_term
  mov   ebx, prev_term
  add   eax, ebx        ; add together prev & curr terms, per Fibonacci formula
  call  WriteDec        ; write the result
  mov   ebx, curr_term
  mov   prev_term, ebx  ; store the current term as previous term
  mov   curr_term, eax  ; so we can store the new sum of the two terms
  mov   edx, OFFSET col_spacer  ; then write 5 spaces after the result
  call  WriteString
  mov   eax, ch_counter
  add   eax, 1
  cmp   eax, 5  ; once 5 numbers have been printed, print an endline
  je    endline
  mov   ch_counter, eax  ; store result for each loop so it adds up to 5
  loop  fibloop

; Call at the end of each row of five terms
endline:
  call CrLf
  mov  ch_counter, 0
  cmp  ecx, 0     ; if ecx is at 0 we don't want to go back to fibloop
  sub  ecx, 1     ; since we exited the loop early, manually decrement ecx
  jg   fibloop
  jmp  goodbye

;########## GOODBYE
; Print parting message to user
earlygoodbye:
  call  CrLf   ; we use earlygoodbye when only 1 term is requested
goodbye:
  call  CrLf
  mov   edx, OFFSET goodbye_1
  call  WriteString
  mov   edx, OFFSET authorname  ; we print the author who certifies the result
  call  WriteString
  mov   edx, OFFSET period
  call  WriteString
  call  CrLf
  mov   edx, OFFSET goodbye_2
  call  WriteString
  mov   edx, OFFSET username    ; say goodbye to the user personally
  call  WriteString
  mov   edx, OFFSET period
  call  WriteString
  call  CrLf

  exit  ; exit to operating system
main ENDP

END main
