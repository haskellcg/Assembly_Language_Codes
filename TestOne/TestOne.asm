TITLE TestOne(EXE) ����:����y=(a+b)*c
PAGE 60,132
	.MODEL SMALL
	.STACK 64
	.DATA
DATA_A	DB	25
DATA_B	DB	5
DATA_C	DB	18
DATA_Y	DW	?
	.CODE
MAIN	PROC	FAR
	MOV AX,@DATA
	MOV DS,AX
	
	MOV AL,DATA_A
	MOV AH,DATA_B
	ADD AL,AH

    MOV AH,DATA_C
	MUL AH
	
	MOV BX,OFFSET DATA_Y
	MOV [BX],AX
	
	MOV AH,4CH
	INT 21H
MAIN	ENDP
		END	MAIN