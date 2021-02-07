TITLE GetTime(exe) ����������ϵͳ��ʱ�䷵�أ���ת��ΪASC��
PAGE 60,132
		
			PUBLIC Data_Year_A,Data_Month_A,Data_Day_A,Data_WeekDay,Data_Hour_A,Data_Minu_A,Data_Second_A
			PUBLIC GetTime

			.MODEL SMALL
			.STACK 64
			.DATA
Data_Year	DW	?				;��
Data_Year_A	DB	4 DUP(30H)

Data_Month	DB	?				;��
Data_Month_A	DB	2 DUP(30H)

Data_Day	DB	?				;��
Data_Day_A	DB	2 DUP(30H)

Data_WeekDay	DB	?			;����

Data_Hour	DB	?				;ʱ
Data_Hour_A	DB	2 DUP(30H)

Data_Minu	DB	?				;��
Data_Minu_A	DB	2 DUP(30H)

Data_Second	DB	?				;��
Data_Second_A	DB	2 DUP(30H)

Ten			DW	10
Sixty		DB	60
TentyF		DB	24

			.CODE
GetTime	PROC	FAR
		
		CALL GETTIMEDATE
		CALL CONV_ALL
		
		RET
GetTime	ENDP

GETTIMEDATE	PROC
		MOV AH,2AH				;����INT 21Hʵ�ֻ��ϵͳ������
		INT 21H
		MOV Data_Year,CX
		MOV Data_Month,DH
		MOV Data_Day,DL
		MOV Data_WeekDay,AL
		
		MOV AH,2CH				;����INT 21Hʵ�ֻ��ϵͳ��ʱ��
		INT 21H
		MOV Data_Hour,CH
		MOV Data_Minu,CL
		MOV Data_Second,DH
		RET
GETTIMEDATE	ENDP		

CONV_ASC	PROC
		;�������:SI--Դ����   DI--Ŀ�����ݵ�ƫ����	BX--Ŀ�ĵ�ַ�ĳ���
		;���������16����ת��Ϊѹ��ASC
		PUSH CX
		PUSH DX
		PUSH AX
					MOV AX,SI
			BACK:	
					MOV DX,0
					DIV	Ten
					OR	DL,30H
					MOV [BX][DI]-1,DL
					DEC BX
					CMP AX,0
					JNZ	BACK
					
			CHECK:
					CMP BX,0
					JZ  OVER
					MOV BYTE PTR [BX][DI]-1,30H
					DEC BX
					JMP CHECK
								
	OVER:	
		POP AX
		POP DX
		POP CX
		RET
CONV_ASC	ENDP

CONV_ALL	PROC
		;�ú������������Լ�ʱ����ת��ΪASC
		;����CONV_ASC
		MOV SI,Data_Year
		MOV	DI,OFFSET Data_Year_A
		MOV BX,4
		CALL CONV_ASC
		
		
		MOV BX,Data_Month
		AND BX,00FFH
		MOV SI,BX
		MOV DI,OFFSET Data_Month_A
		MOV BX,2
		CALL CONV_ASC
		
		MOV BX,Data_Day
		AND BX,00FFH
		MOV SI,BX
		MOV DI,OFFSET Data_Day_A
		MOV BX,2
		CALL CONV_ASC
		
		MOV BX,Data_Hour
		AND BX,00FFH
		MOV SI,BX
		MOV DI,OFFSET Data_Hour_A
		MOV BX,2
		CALL CONV_ASC
		
		MOV BX,Data_Minu
		AND BX,00FFH
		MOV SI,BX
		MOV DI,OFFSET Data_Minu_A
		MOV BX,2
		CALL CONV_ASC
		
		MOV BX,Data_Second
		AND BX,00FFH
		MOV SI,BX
		MOV DI,OFFSET Data_Second_A
		MOV BX,2
		CALL CONV_ASC
		RET
CONV_ALL	ENDP
		END