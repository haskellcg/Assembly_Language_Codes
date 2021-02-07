TITLE GetTime(exe) 这个程序根据系统的时间返回，并转换为ASCⅡ
PAGE 60,132
		
			PUBLIC Data_Year_A,Data_Month_A,Data_Day_A,Data_WeekDay,Data_Hour_A,Data_Minu_A,Data_Second_A
			PUBLIC GetTime

			.MODEL SMALL
			.STACK 64
			.DATA
Data_Year	DW	?				;年
Data_Year_A	DB	4 DUP(30H)

Data_Month	DB	?				;月
Data_Month_A	DB	2 DUP(30H)

Data_Day	DB	?				;日
Data_Day_A	DB	2 DUP(30H)

Data_WeekDay	DB	?			;星期

Data_Hour	DB	?				;时
Data_Hour_A	DB	2 DUP(30H)

Data_Minu	DB	?				;分
Data_Minu_A	DB	2 DUP(30H)

Data_Second	DB	?				;秒
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
		MOV AH,2AH				;调用INT 21H实现获得系统的日期
		INT 21H
		MOV Data_Year,CX
		MOV Data_Month,DH
		MOV Data_Day,DL
		MOV Data_WeekDay,AL
		
		MOV AH,2CH				;调用INT 21H实现获得系统的时间
		INT 21H
		MOV Data_Hour,CH
		MOV Data_Minu,CL
		MOV Data_Second,DH
		RET
GETTIMEDATE	ENDP		

CONV_ASC	PROC
		;输入参数:SI--源数据   DI--目的数据的偏移量	BX--目的地址的长度
		;根据输入的16进制转换为压缩ASC
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
		;该函数将年月日以及时分秒转换为ASC
		;调用CONV_ASC
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