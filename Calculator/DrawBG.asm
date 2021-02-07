TITLE DrawBG(EXE) �ó���ʵ����03��Ƶģʽ�µ�ͼ�η���Ĳ���(25*80)
PAGE	60,132
			INCLUDE Video.mac
			PUBLIC DrawBG,FillValidate,EmptyValidate,FillInValidate,EmptyInValidate
		
			.MODEL	SMALL
			.STACK 64
			.DATA
Note_Notice		DB	'Notice:','$'
Validate		DB	'Validate','$'
InValidate		DB	'InValidate','$'
Fill			DB	02H
Empty			DB	00H
Note_Help		DB	'Help:','$'
Message_Help1	DB	'This program is a calculator.You can input decimal smaller than 9999.','$'
Message_Help2	DB	'The Note can inform you of false format of inputing.','$'
Message_Help3	DB	'Q/q--quit R/r--repeat input  Up/Dwon--Select Operation','$'
Message_Cal		DB	'CALCULATOR FOR FOUR ARITHMETIC OPERATION','$'
Message_Num1	DB	'First Number:','$'
Message_Num2	DB	'Second Number:','$'
Message_Opre	DB	'Operation:','$'
Message_Result	DB	'The Result:','$'
			.CODE
DrawBG 	PROC	FAR
			MOV AX,@DATA
			MOV DS,AX
			MOV ES,AX
			
			ClearScreen
			
			MOV DH,18							;����ʾ��
			CALL DrawHLine
			MOV DH,20
			CALL DrawHLine
			ClearRect 19,0,19,79,34H
			SetCursor 19,0
			PrintString Note_Notice
			SetCursor 19,10
			PrintString Validate
			SetCursor 19,25
			PrintString InValidate
			
			ClearRect 21,0,25,79,2CH			;��������
			SetCursor 21,0
			PrintString Note_Help
			SetCursor 22,5
			PrintString Message_Help1
			SetCursor 23,5
			PrintString Message_Help2
			SetCursor 24,5
			PrintString Message_Help3
			
			MOV DH,6							;��������
			CALL DrawHLine
			MOV BH,73H
			CALL DrawCalculate
			
			SetCursor 8,10
			PrintString Message_Num1			;��ֹ��:8,23
			SetCursor 10,9
			PrintString Message_Num2			;��ֹ��:10,23
			SetCursor 12,13
			PrintString Message_Opre			;��ֹ��:12,23
			SetCursor 15,12
			PrintString Message_Result			;��ֹ��:15,23
			
			
			
			RET
DrawBG	ENDP

FillValidate	PROC		
				;�ú���������ʾ������Ч��־
		MOV AH,13H
		MOV AL,00H
		MOV BH,00H
		MOV BL,34H
		MOV CX,1
		MOV DH,19
		MOV DL,19
		MOV BP,OFFSET Fill
		INT 10H
			RET
FillValidate	ENDP

EmptyValidate	PROC
				;�ú����������������Ч��־
		MOV AH,13H
		MOV AL,00H
		MOV BH,00H
		MOV BL,34H
		MOV CX,1
		MOV DH,19
		MOV DL,19
		MOV BP,OFFSET Empty
		INT 10H
			RET
EmptyValidate	ENDP

FillInValidate	PROC
			;�ú���������ʾ������Ч��־
		MOV AH,13H
		MOV AL,00H
		MOV BH,00H
		MOV BL,34H
		MOV CX,1
		MOV DH,19
		MOV DL,36
		MOV BP,OFFSET Fill
		INT 10H
			RET
FillInValidate	ENDP
		
EmptyInValidate	PROC
			;�ú����������������Ч��־
		MOV AH,13H
		MOV AL,00H
		MOV BH,00H
		MOV BL,34H
		MOV CX,1
		MOV DH,19
		MOV DL,36
		MOV BP,OFFSET Empty
		INT 10H
			RET
EmptyInValidate	ENDP
		
DrawHLine	PROC
			;�ú�����һ����80�ĺ���
			;DH--��
			SetCursor DH,0
			
			MOV AH,09H
			MOV AL,2DH
			MOV BH,00H
			MOV BL,37H
			MOV CX,80
			INT 10H
			
			RET
DrawHLine	ENDP

DrawCalculate	PROC	
			;�ú����������"Calculate"
			;����BH--��ɫ����
			ClearRect 0,0,5,79,BH
			SetCursor 3,20
			PrintString  Message_Cal
			RET
DrawCalculate	ENDP
		END