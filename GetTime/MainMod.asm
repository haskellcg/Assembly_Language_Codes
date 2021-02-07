TITLE	Music(EXE)	�������ʵ�ֲ��������Լ���ʱ
PAGE 60,132
			EXTRN DrawPic:FAR
			EXTRN DrawBottom:NEAR

			.MODEL SMALL
			.STACK	64
			.DATA
			;happy birthday
NOTES	DW	11CAH,11CAH,0FDAH,11CAH,0D5BH,0E1FH, 11CAH,11CAH,0FDAH,11CAH,0BE3H,0D5BH, 11CAH,11CAH,08E9H,0A97H,0D5BH,0E1FH,0FDAH, 0A00H,0A00H,0A97H,0D5BH,0BE3H,0D5BH
Duration DB	2,2,4,4,4,8, 2,2,4,4,4,8, 2,2,4,4,4,4,12, 2,2,4,4,4,8
Length_0	EQU 25
			;mary had a little lamb
NOTES2 DW	0E1FH,0FDAH,11CAH,0FDAH,0E1FH,0E1FH, 0E1FH,0FDAH,0FDAH,0FDAH,0E1FH,0BE3H, 0BE3H,0E1FH,0FDAH,11CAH,0E1FH,0E1FH, 0E1FH,0E1FH,0E1FH,0FF5H,0FF5H,0E1FH, 0FDAH,11CAH
Duration2 DB	4,4,4,4,4,4, 8,4,4,8,4,4, 8,4,4,4,4,4, 4,4,4,4,4,4, 4,16

Old_Mod		DB	?		;�洢�ɵ���Ƶģʽ
New_Mod 	DB	12H		;�µ���Ƶģʽ(640 * 480f)
Length_2	EQU	26
			.CODE
MAIN	PROC	FAR
			MOV AX,@DATA
			MOV DS,AX
			
			MOV AH,0FH
			INT 10H
			MOV Old_Mod,AL
			
			MOV AH,00H
			MOV AL,New_Mod
			INT 10H
			
			
			
			CALL DrawBottom
		CIRCLE:
			CALL TimeDelay
			MOV AH,01H
			INT 16H
			JZ	CIRCLE
			MOV AH,10H
			INT 16H
			CMP AL,'q'
			JZ	TAIL
			CMP AL,'Q'
			JZ 	TAIL
			JMP CIRCLE
			
		TAIL:
			
			
			
			MOV AH,00H
			MOV AL,Old_Mod
			INT 10H
		
			CALL Music
			
			MOV AH,4CH
			INT 21H
MAIN	ENDP
			
			
Music	PROC
			;�ú����������������ͬ���Ų�ͬ����
			;BX--�������� I--��������ʱ������ DI--��������
			MOV AL,0B6H
			OUT 43H,AL
			
			MOV BX,Length_2
			LEA	SI,NOTES2
			LEA DI,Duration2
		AGAIN:
			MOV AX,[SI]
			OUT 42H,AL
			MOV AL,AH
			OUT 42H,AL
			MOV DL,[DI]
			CALL SpkON
			INC SI
			INC SI
			INC DI
			DEC BX
			JNZ AGAIN
			
		
			RET
Music	ENDP



SpkON	PROC
		PUSH SI
		PUSh DI
		PUSH BX
			IN	AL,61H
			MOV AH,AL
			OR  AL,00000011B
			OUT 61H,AL
		BACK:
			CALL DELAY
			DEC DL
			CMP DL,00
			JNE	BACK
			
			MOV AL,AH
			OUT 61H,AL
			CALL DELAY_OFF
			
		POP BX
		POP DI
		POP SI
			RET
SpkON	ENDP
		
TimeDelay	PROC				;ÿ��1��ˢ��һ��
			
			
			MOV DX,2
		BACKT:
			CALL DELAY
			DEC DX
			JNZ BACKT
		
			CALL DrawPic
			
			
			RET
TimeDelay	ENDP
		
DELAY		PROC	NEAR			;250ms
		MOV CX,33156
		PUSH AX
		
		WAIT1:
					IN	AL,61H
					AND	AL,00010000B
					CMP AL,AH
					JE	WAIT1
					MOV AH,AL
					LOOP WAIT1
					
		POP AX
		RET
DELAY	ENDP

DELAY_OFF		PROC	NEAR		;50ms
		MOV CX,331
		PUSH AX
		
		WAIT0:
					IN	AL,61H
					AND	AL,00010000B
					CMP AL,AH
					JE	WAIT0
					MOV AH,AL
					LOOP WAIT0
					
		POP AX
		RET
DELAY_OFF	ENDP
		END MAIN