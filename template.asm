TITLE Programming Assignment #4    (Assignment4.asm)
	
	
; Author:					Jeff Blake
; Last Modified:
; OSU email address:		blakejef@oregonstate.edu
; Course number/section:	CS271 400
; Project Number:   4       Due Date: 4 Nov 2018
; Description:				Program calculates composite numbers
;							First, the user is instructed to enter the number of composites to be displayed, and is prompted to enter an integer in the range [1 .. 400].
;							The user enters a number, n, and the program verifies that number is greater than or equal to 1 and less than 400
;							If n is out of range, the user is re-prompted until s/he enters a value in the specified range. 
;							The program then calculates and displays all of the composite numbers up to and including the nth composite.
;							The results should be displayed 10 composites per line with at least 3 spaces between the numbers.

INCLUDE Irvine32.inc

UPPER_LIMIT = 400

.data

progIntro			BYTE	"Integer Accumulator by Jeff Blake", 0
instruct			BYTE	"Enter the number of composite numbers you would like to see.", 0
instruct2			BYTE	"Please enter a number between 1 and 400: ", 0
instruct3			BYTE	"I'll accept orders for up to 400 composites.", 0
compNum				SDWORD	?		;Stores the number of composite numbers to display
tryAgainMes			BYTE	"Out of Range. Try Again", 0
space				BYTE	"   ",0
rowCounter			DWORD	1		;Counts the number of values in each row
compositeNumber		DWORD	4		; Composite Number to be displayed
.code
main PROC

	call	intro
	call	getData
	call	showComposites
	exit	; exit to operating system
main ENDP

;Procedure to introduce the program ,and give user instructions.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
intro	PROC

;Display your name and program title on the output screen.
	mov		edx, OFFSET progIntro
	call	WriteString
	call	CrLf
	call	Crlf
	call	CrLf
;Give User insructions
	mov		edx, OFFSET instruct
	call	WriteString
	Call	CrLf
	mov		edx, OFFSET instruct3
	call	WriteString
	Call	CrLf
	call	CrLf


	ret
intro	ENDP

;Procedure to get values for the number of composite numbers to display
;receives: none
;returns: user input values for global variables compNum
;preconditions:  none
;registers changed: eax, edx
getData	PROC

;get an integer for CompNum

	mov		edx, OFFSET instruct2
	call	WriteString
	call	ReadInt
	call	validate
	mov		compNum, eax

	ret
getData	ENDP

;Procedure to validate user input
;receives: none
;returns: none
;preconditions:  none
;registers changed: eax, edx
validate PROC

;Check if compNum is greater than 1 and less than equal to 400
GreaterThan1: 
	cmp		eax, 1
	jle		TryAgain
	cmp		eax, 0
	js		TryAgain
	jmp		LessThan400
LessThan400:
	cmp		eax, UPPER_LIMIT
	jg		TryAgain
	jmp		GotAGoodNum
TryAgain:
	mov		edx, OFFSET	tryAgainMes
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	instruct2
	call	WriteString
	call	ReadInt
	jmp		GreaterThan1
GotAGoodNum:
	mov		compNum, eax
	ret
validate ENDP

;Procedure to display composite numbers 10 per line with 3 spaces between
;receives: none
;returns: none
;preconditions:  none
;registers changed: eax, ebx, edx, ecx
showComposites	PROC

;
	mov		ecx, compNum
newLine:
;Ensure ecx does not equal 0 before starting loops
	cmp		ecx, 0
	je		finish
;If our rowCounter is less than 10 go to loop
	mov		ebx, rowCounter
	cmp		ebx, 10
	jl		myLoop
;if row counter is over 10 we create a new line and reset rowCounter to 1 now that i think of it this could be done by (mov eax, 1)
	mov		eax, rowCounter
	sub		eax, 9
	mov		rowCounter, eax
	call	CrLf
;Before we go back to the loop, since the loop was not finished we decrement ecx by 1 not sure if this is proper? It feels wrong but
;it is working and I believe becasue i test for 0 at the top and before i go back to loop it makes it safe. Please tell if this is a nono
	mov		eax, ecx
	sub		eax, 1
	mov		ecx, eax
	cmp		ecx, 0
	je		finish
	jmp		myLoop

myLoop:

;Display Current Composite Number number
	call	isComposite
	mov		eax, compositeNumber
	inc		eax
	mov		compositeNumber, eax
;Store current value of ecx beacasue since the loop does not technically complete the value will not be decremented
	mov		compNum, ecx
;Keep track of every term because there must be a line break after the fifth term
	mov		eax, rowCounter
	cmp		eax, 11
	je		newLine

	loop	myLoop

finish:
	call	crLf

	ret
showComposites	ENDP

;Procedure to display composite numbers 10 per line with 3 spaces between
;receives: none
;returns: none
;preconditions:  none
;registers changed: eax, ebx, edx
isComposite	PROC

	mov		ebx, 2
CalcComp:
	mov		eax, compositeNumber
	xor		edx, edx
	div		ebx
	cmp		edx, 0
	je		PrintComposite
	inc		ebx
	mov		eax, compositeNumber
	cmp		ebx, eax
	jl		CalcComp
	mov		eax, compositeNumber
	cmp		ebx, eax
	je		notComp
	jmp		quittt
PrintComposite:
	mov		eax, compositeNumber
	call	WriteDec
	mov		edx, OFFSET	space
	call	WriteString
	;If a number was printed increment our row counting varibale
	mov		ebx, rowCounter
	inc		ebx
	mov		rowCounter, ebx
	jmp		quittt
notComp:
	inc		ecx
quittt:

	ret
isComposite	ENDP

END main
