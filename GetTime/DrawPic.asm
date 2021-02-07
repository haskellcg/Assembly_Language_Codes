TITLE	DrawPicture(EXE) 这个程序主要实现画图的功能		
			;HH:mm:ss
			;数字部分80*150
			;标号部分25*150
PAGE 60,132

			EXTRN Data_Year_A:BYTE
			EXTRN Data_Month_A:BYTE
			EXTRN Data_Day_A:BYTE
			EXTRN Data_WeekDay:BYTE
			EXTRN Data_Hour_A:BYTE
			EXTRN Data_Minu_A:BYTE
			EXTRN Data_Second_A:BYTE
			EXTRN GetTime:FAR
			
			PUBLIC DrawPic,DrawBottom
			
			
			.MODEL SMALL
			.STACK 64
			.DATA
Data_Hour_B	DB	2 DUP(0FFH)		;初始化FF
Data_Minu_B	DB	2 DUP(0FFH)		;初始化FF
Data_Second_B	DB	2 DUP(0FFH)	;初始化FF

Message_Time	DB	'Now the time is following:'
Length_Time		DW 	26
Message_Date	DB	'And the date is following:'
Length_Date		DW	26
Message_Year	DB	'Year:'
Length_Year		DW	5
Message_Month	DB	'Month:'
Length_Month	DW	6
Message_Day		DB	'Day:'
Length_Day		DW	4
Message_WeekDay	DB	'Day of week:'
Length_WeekDay	DW	12

Message_Sunday		DB	'Sunday'
Length_Sunday		DW	6
Message_Monday		DB	'Monday'
Length_Monday		DW	6
Message_Tuesday		DB	'Tuesday'
Length_Tuesday		DW	7
Message_Wednesday	DB	'Wednesday'
Length_Wednesday	DW	9
Message_Thursday	DB	'Thursday'
Length_Thursday		DW	8
Message_Friday		DB	'Friday'
Length_Friday		DW	6
Message_Saturday	DB	'Saturday'
Length_Saturday		DW	8

Message_Compile	DB	'This program was compiled with MASM.EXE'
Length_Compile	DW	39
Message_Link	DB	'And linked with LINK.EXE (Q or q to quit)'
Length_Link		DW	41

			.CODE
DrawPic	PROC	FAR
			MOV AX,@DATA
			MOV ES,AX
			MOV DS,AX
			
			MOV BL,3BH
			MOV CX,Length_Time
			MOV BP,OFFSET Message_Time
			MOV DH,1
			MOV DL,0
			CALL DrawString
			
			
			CALL GetTime
			
			MOV CX,40
			MOV DX,40
			MOV BL,Data_Hour_A
			CMP BL,Data_Hour_B
			JZ NEXT0
			CALL ClearNumber
			CALL DrawNumber
			MOV Data_Hour_B,BL
			
		NEXT0:	
			MOV CX,130
			MOV DX,40
			MOV BL,Data_Hour_A+1
			CMP BL,Data_Hour_B+1
			JZ	NEXT1
			CALL ClearNumber
			CALL DrawNumber
			MOV Data_Hour_B+1,BL
			
		NEXT1:	
			MOV CX,210
			CALL DrawSignal
			
			MOV CX,235
			MOV BL,Data_Minu_A
			CMP BL,Data_Minu_B
			JZ NEXT2
			CALL ClearNumber
			CALL DrawNumber
			MOV Data_Minu_B,BL
			
		NEXT2:
			MOV CX,325
			MOV BL,Data_Minu_A+1
			CMP BL,Data_Minu_B+1
			JZ NEXT3
			CALL ClearNumber
			CALL DrawNumber
			MOV Data_Minu_B+1,BL
			
		NEXT3:
			MOV CX,405
			CALL DrawSignal
			
			MOV CX,430
			MOV BL,Data_Second_A
			CMP BL,Data_Second_B
			JZ NEXT4
			CALL ClearNumber
			CALL DrawNumber
			MOV Data_Second_B,BL
			
		NEXT4:
			MOV CX,520
			MOV BL,Data_Second_A+1
			CMP BL,Data_Second_B+1
			JZ NEXT5
			CALL ClearNumber
			CALL DrawNumber
			MOV Data_Second_B+1,BL
			
		NEXT5:
		
			MOV BL,3BH
			MOV CX,Length_Date
			MOV BP,OFFSET Message_Date
			MOV DH,13
			MOV DL,0
			CALL DrawString
			
			MOV BL,32H
			MOV CX,Length_Year
			MOV BP,OFFSET Message_Year
			MOV DH,15
			MOV DL,21
			CALL DrawString
			
			MOV BL,33H
			MOV CX,4
			MOV BP,OFFSET Data_Year_A
			MOV DH,15
			MOV DL,26
			CALL DrawString
			
			MOV BL,32H
			MOV CX,Length_Month
			MOV BP,OFFSET Message_Month
			MOV DH,17
			MOV DL,20
			CALL DrawString
			
			MOV BL,33H
			MOV CX,2
			MOV BP,OFFSET Data_Month_A
			MOV DH,17
			MOV DL,26
			CALL DrawString
			
			MOV BL,32H
			MOV CX,Length_Day
			MOV BP,OFFSET Message_Day
			MOV DH,19
			MOV DL,22
			CALL DrawString
			
			MOV BL,33H
			MOV CX,2
			MOV BP,OFFSET Data_Day_A
			MOV DH,19
			MOV DL,26
			CALL DrawString
			
			MOV BL,32H
			MOV CX,Length_WeekDay
			MOV BP,OFFSET Message_WeekDay
			MOV DH,21
			MOV DL,14
			CALL DrawString
			
			MOV BL,33H
			CALL SelectWeekDay
			MOV DH,21
			MOV DL,26
			CALL DrawString
			
			MOV BL,36H
			MOV CX,Length_Compile
			MOV BP,OFFSET Message_Compile
			MOV DH,25
			MOV DL,14
			CALL DrawString
			
			MOV BL,36H
			MOV CX,Length_Link
			MOV BP,OFFSET Message_Link
			MOV DH,27
			MOV DL,14
			CALL DrawString
			
				RET
DrawPic	ENDP

DrawLine Proc
			;该函数画一条横线
			;输入CX--开始X坐标 DX--开始Y坐标 SI--终止X坐标 AL--颜色
	PUSH BX
	PUSH AX
	PUSH CX
	
	BACK_LINE:
			MOV AH,0CH
			MOV BH,00H
			INT 10H
			CMP CX,SI
			JA	OVER_LINE
			INC CX
			JMP BACK_LINE
			
	OVER_LINE:	
			POP CX
			POP AX
			POP BX
			RET
DrawLine ENDP

DrawRect	Proc
			;该函数画一个指定的矩形
			;输入CX--开始X坐标 DX--开始Y坐标  SI--终止X坐标  DI--终止Y坐标  AL--颜色
	BACK_RECT:
			CALL DrawLine
			CMP DX,DI
			JA OVER_RECT
			INC DX
			JMP BACK_RECT
	OVER_RECT:
				RET
DrawRect	ENDP

			
DrawVLong	PROC
			;该函数画出数字组件中的长竖条
			;CX--开始X坐标 DX--开始Y坐标	AL--颜色
			PUSH CX
			PUSH DX
				ADD CX,2
				ADD DX,2
				MOV SI,CX
				ADD SI,6
				MOV DI,DX
				ADD DI,26
				CALL DrawRect
			POP DX
			POP CX
		
			RET
DrawVLong	ENDP

DrawShort	PROC
			;该函数画出数字组件中的短竖条
			;CX--开始X坐标 DX--开始Y坐标  AL--颜色
			PUSH CX
			PUSH DX
				ADD CX,2
				ADD DX,2
				MOV SI,CX
				ADD SI,6
				MOV DI,DX
				ADD DI,6
				CALL DrawRect
			POP DX
			POP CX
		
			RET
DrawShort	ENDP

DrawBottom	PROC
		
		MOV CX,40
		MOV DX,380
		MOV AL,07H
		CALL DrawShort
		
		ADD CX,10
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawHLong
		ADD CX,30
		CALL DrawShort
		
		ADD DX,10
		CALL DrawVLong
		ADD DX,30
		CALL DrawVLong
		ADD DX,30
		CALL DrawShort
		
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		SUB CX,30
		CALL DrawHLong
		
		SUB CX,10
		CALL DrawShort
		SUB DX,30
		CALL DrawVLong
		SUB DX,30
		CALL DrawVLong
		
			RET
DrawBottom	ENDP

DrawHLong	PROC
			;该函数画出数字组件中的短横条
			;CX--开始X坐标 DX--开始Y坐标 AL--颜色
			PUSH CX
			PUSH DX
				ADD CX,2
				ADD DX,2
				MOV SI,CX
				ADD SI,26
				MOV DI,DX
				ADD DI,6
				CALL DrawRect
			POP DX
			POP CX
		
			RET
DrawHLong	ENDP

DrawZero	PROC
			;该函数画数字'0' 灰色
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSH DX
				MOV AL,08H
				CALL DrawShort
				
				ADD DX,10
				MOV AL,08H
				CALL DrawVLong
				
				ADD DX,30
				MOV AL,08H
				CALL DrawVLong

				ADD DX,30
				MOV AL,08H
				CALL DrawShort
			
				ADD DX,10
				MOV AL,08H
				CALL DrawVLong
			
				ADD DX,30
				MOV AL,08H
				CALL DrawVLong
			
				ADD DX,30
				MOV AL,08H
				CALL DrawShort
				
				ADD CX,10
				MOV AL,08H
				CALL DrawHLong
				
				ADD CX,30
				MOV AL,08H
				CALL DrawHLong
				
				ADD CX,30
				MOV AL,08H
				CALL DrawShort
				
				SUB DX,30
				MOV AL,08H
				CALL DrawVLong
				
				SUB DX,30
				MOV AL,08H
				CALL DrawVLong
				
				SUB DX,10
				MOV AL,08H
				CALL DrawShort
				
				SUB DX,30
				MOV AL,08H
				CALL DrawVLong
				
				SUB DX,30
				MOV AL,08H
				CALL DrawVLong
				
				SUB DX,10
				MOV AL,08H
				CALL DrawShort
				
				SUB CX,30
				MOV AL,08H
				CALL DrawHLong
				
				SUB CX,30
				MOV AL,08H
				CALL DrawHLong
		POP DX
		POP CX
			RET
DrawZero	ENDP

DrawOne		Proc
			;该函数画数字'1' 青色
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSH DX
			ADD CX,70
			MOV AL,03
			CALL DrawShort
			
			ADD DX,10
			MOV AL,03H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,03H
			CALL DrawVLong

			ADD DX,30
			MOV AL,03H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,03H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,03H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,03H
			CALL DrawShort
		POP DX
		POP CX
				RET
DrawOne		ENDP

DrawTwo		PROC
			;该函数画数字'2'   绿色
			;CX--开始X坐标 DX--开始Y坐标
			
		PUSH CX
		PUSH DX
			MOV AL,02H
			CALL DrawShort
			
			ADD CX,10
			MOV AL,02H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,02H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,02H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,02H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,02H
			CALL DrawVLong

			ADD DX,30
			MOV AL,02H
			CALL DrawShort
			
			SUB CX,30
			MOV AL,02H
			CALL DrawHLong
			
			SUB CX,30
			MOV AL,02H
			CALL DrawHLong
			
			SUB CX,10
			MOV AL,02H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,02H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,02H
			CALL DrawVLong

			ADD DX,30
			MOV AL,02H
			CALL DrawShort
			
			ADD CX,10
			MOV AL,02H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,02H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,02H
			CALL DrawShort
		POP DX
		POP CX
				RET
DrawTwo		ENDP

DrawThree	PROC
			;该函数画数字'3'	黄色
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSH DX
			MOV AL,0EH
			CALL DrawShort
			
			ADD CX,10
			MOV AL,0EH
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,0EH
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,0EH
			CALL DrawShort
			
			ADD DX,10
			MOV AL,0EH
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,0EH
			CALL DrawVLong

			ADD DX,30
			SUB CX,70
			MOV AL,0EH
			CALL DrawShort
			
			ADD CX,10
			MOV AL,0EH
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,0EH
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,0EH
			CALL DrawShort
			
			ADD DX,10
			MOV AL,0EH
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,0EH
			CALL DrawVLong
			
			ADD DX,30
			SUB CX,70
			MOV AL,0EH
			CALL DrawShort
			
			ADD CX,10
			MOV AL,0EH
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,0EH
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,0EH
			CALL DrawShort
		POP DX
		POP CX
				RET
DrawThree	ENDP

DrawFour	Proc
			;该函数画数字'4'	浅红色
			;CX--开始X坐标 DX--开始Y坐标
		PUSh CX
		PUSH DX
			MOV AL,0CH
			CALL DrawShort
			
			ADD DX,10
			MOV AL,0CH
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,0CH
			CALL DrawVLong

			ADD DX,30
			MOV AL,0CH
			CALL DrawShort
			
			ADD CX,10
			MOV AL,0CH
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,0CH
			CALL DrawHLong
			
			ADD CX,30
			SUB DX,70
			MOV AL,0CH
			CALL DrawShort
			
			ADD DX,10
			MOV AL,0CH
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,0CH
			CALL DrawVLong

			ADD DX,30
			MOV AL,0CH
			CALL DrawShort
			
			ADD DX,10
			MOV AL,0CH
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,0CH
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,0CH
			CALL DrawShort
		POP DX
		POP CX
				RET
DrawFour	ENDP

DrawFive	PROC
			;该函数画数字'5'	洋红色
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSh DX
			ADD CX,70
			MOV AL,05H
			CALL DrawShort
			
			SUB CX,30
			MOV AL,05H
			CALL DrawHLong
			
			SUB CX,30
			MOV AL,05H
			CALL DrawHLong
			
			SUB CX,10
			MOV AL,05H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,05H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,05H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,05H
			CALL DrawShort
			
			ADD CX,10
			MOV AL,05H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,05H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,05H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,05H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,05H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,05H
			CALL DrawShort
			
			SUB CX,30
			MOV AL,05H
			CALL DrawHLong
			
			SUB CX,30
			MOV AL,05H
			CALL DrawHLong
			
			SUB CX,10
			MOV AL,05H
			CALL DrawShort
		POP DX
		POP CX
				RET
DrawFive	ENDP

DrawSix		PROC
			;该函数画数字'6'	浅蓝色
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSH DX
			ADD CX,70
			MOV AL,09H
			CALL DrawShort
			
			SUB CX,30
			MOV AL,09H
			CALL DrawHLong
			
			SUB CX,30
			MOV AL,09H
			CALL DrawHLong
			
			SUB CX,10
			MOV AL,09H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,09H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,09H
			CALL DrawVLong

			ADD DX,30
			MOV AL,09H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,09H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,09H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,09H
			CALL DrawShort
			
			ADD CX,10
			MOV AL,09H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,09H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,09H
			CALL DrawShort
			
			SUB DX,30
			MOV AL,09H
			CALL DrawVLong
			
			SUB DX,30
			MOV AL,09H
			CALL DrawVLong
			
			SUB DX,10
			MOV AL,09H
			CALL DrawShort
			
			SUB CX,30
			MOV AL,09H
			CALL DrawHLong
			
			SUB CX,30
			MOV AL,09H
			CALL DrawHLong
		POP DX
		POP CX
				RET
DrawSix		ENDP

DrawSeven	PROC
			;该函数画数字'7'	浅青色
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSH DX
			MOV AL,0BH
			CALL DrawShort
			
			ADD CX,10
			MOV AL,0BH
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,0BH
			CALL DrawHLOng
			
			ADD CX,30
			MOV AL,0BH
			CALL DrawShort
			
			ADD DX,10
			MOV AL,0BH
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,0BH
			CALL DrawVLong

			ADD DX,30
			MOV AL,0BH
			CALL DrawShort
			
			ADD DX,10
			MOV AL,0BH
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,0BH
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,0BH
			CALL DrawShort
		POP DX
		POP CX
				RET
DrawSeven	ENDP

DrawEight	PROC
			;该函数画数字'8'	浅灰色
			;CX--开始X坐标 DX--开始Y坐标
		PUSh CX
		PUSh DX
			MOV AL,07H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,07H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,07H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,07H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,07H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,07H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,07H
			CALL DrawShort
			
			ADD CX,10
			MOV AL,07H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,07H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,07H
			CALL DrawShort
			
			SUB DX,30
			MOV AL,07H
			CALL DrawVLong
			
			SUB DX,30
			MOV AL,07H
			CALL DrawVLong
			
			SUB DX,10
			MOV AL,07H
			CALL DrawShort
			
			SUB CX,30
			MOV AL,07H
			CALL DrawHLong
			
			SUB CX,30
			MOV AL,07H
			CALL DrawHLong
			
			SUB DX,70
			MOV AL,07H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,07H
			CALL DrawHLong 
			
			ADD CX,30
			MOV AL,07H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,07H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,07H
			CALL DrawVLong
		POP DX
		POP CX
				RET
DrawEight	ENDP

DrawNine	PROC
			;该函数画数字'9'	棕色
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSH DX
			ADD DX,140
			MOV AL,06H
			CALL DrawShort
			
			ADD CX,10
			MOV AL,06H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,06H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,06H
			CALL DrawShort
			
			SUB DX,30
			MOV AL,06H
			CALL DrawVLong
			
			SUB DX,30
			MOV AL,06H
			CALL DrawVLong
			
			SUB DX,10
			MOV AL,06H
			CALL DrawShort
			
			SUB DX,30
			MOV AL,06H
			CALL DrawVLong
			
			SUB DX,30
			MOV AL,06H
			CALL DrawVLong
			
			SUB DX,10
			MOV AL,06H
			CALL DrawShort
			
			SUB CX,30
			MOV AL,06H
			CALL DrawHLong
			
			SUB CX,30
			MOV AL,06H
			CALL DrawHLong
			
			SUB CX,10
			MOV AL,06H
			CALL DrawShort
			
			ADD DX,10
			MOV AL,06H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,06H
			CALL DrawVLong
			
			ADD DX,30
			MOV AL,06H
			CALL DrawShort
			
			ADD CX,10
			MOV AL,06H
			CALL DrawHLong
			
			ADD CX,30
			MOV AL,06H
			CALL DrawHLong
		POP DX
		POP CX
				RET
DrawNine	ENDP

ClearNumber	PROC
			;这个函数用于清除指定区域的数字
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSH DX
			MOV SI,CX
			ADD SI,80
			MOV DI,DX
			ADD DI,150
			MOV AL,00H
			CALL DrawRect
		POP DX
		POP CX
				RET
ClearNumber	ENDP

DrawSignal	PROC
			;这个函数画标号':' 浅洋红色
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSH DX
			ADD CX,9
			ADD DX,37
			MOV SI,CX
			ADD SI,6
			MOV DI,DX
			ADD DI,6
			MOV AL,0DH
			CALL DrawRect
			
			ADD DX,73
			MOV SI,CX
			ADD SI,6
			MOV DI,DX
			ADD DI,6
			MOV AL,0DH
			CALL DrawRect
		POP DX
		POP CX
			RET
DrawSignal	ENDP

ClearSignal PROC
			;这个函数清除标号，实现闪烁效果
			;CX--开始X坐标 DX--开始Y坐标
		PUSH CX
		PUSH DX
			MOV SI,CX
			ADD SI,25
			MOV DI,DX
			ADD DI,150
			MOV AL,00H
			CALL DrawRect
		POP DX
		POP CX
			RET
ClearSignal	ENDP

DrawNumber	PROC
			;这个函数根据输入的值('0'--'9')
			;BL--输入的值
			CMP BL,'0'
			JZ	CALL0
			CMP BL,'1'
			JZ	CALL1
			CMP BL,'2'
			JZ	CALL2
			CMP BL,'3'
			JZ	CALL3
			CMP BL,'4'
			JZ	CALL4
			CMP BL,'5'
			JZ	CALL5
			CMP BL,'6'
			JZ	CALL6
			CMP BL,'7'
			JZ	CALL7
			CMP BL,'8'
			JZ	CALL8
			CMP BL,'9'
			JZ	CALL9
			
		CALL0:
			CALL DrawZero
			JMP OVER
		CALL1:
			CALL DrawOne
			JMP OVER
		CALL2:
			CALL DrawTwo
			JMP OVER
		CALL3:
			CALL DrawThree
			JMP OVER
		CALL4:
			CALL DrawFour
			JMP OVER
		CALL5:
			CALL DrawFive
			JMP OVER
		CALL6:
			CALL DrawSix
			JMP OVER
		CALL7:
			CALL DrawSeven
			JMP OVER
		CALL8:
			CALL DrawEight
			JMP OVER
		CALL9:
			CALL DrawNine
			JMP OVER
			
		OVER:
			RET
DrawNumber	ENDP

DrawString	PROC
			;该函数在指定位置显示字符串
			;BL--颜色 DH--行 DL--列 BP--字符串偏移量 CX--字符串长度
			
			MOV AH,13H
			MOV AL,01H
			MOV BH,00H
			INT 10H
				RET
DrawString	ENDP

SelectWeekDay	PROC																
			MOV AL,Data_WeekDay
			CMP AL,0
			JZ	SUN
			CMP AL,1
			JZ	MON
			CMP	AL,2
			JZ	TUE
			CMP AL,3
			JZ	WED
			CMP AL,4
			JZ 	THU
			CMP AL,5
			JZ	FRI
			CMP AL,6
			JZ	SAT
		SUN:
			MOV BP,OFFSET Message_Sunday
			MOV CX,Length_Sunday
			JMP RT
		MON:
			MOV BP,OFFSET Message_Monday
			MOV CX,Length_Monday
			JMP RT
		TUE:
			MOV BP,OFFSET Message_Tuesday
			MOV CX,Length_Tuesday
			JMP RT
		WED:
			MOV BP,OFFSET Message_Wednesday
			MOV CX,Length_Wednesday
			JMP RT
		THU:
			MOV BP,OFFSET Message_Thursday
			MOV CX,Length_Thursday
			JMP RT
		FRI:
			MOV BP,OFFSET Message_Friday
			MOV CX,Length_Friday
			JMP RT
		SAT:
			MOV BP,OFFSET Message_Saturday
			MOV CX,Length_Saturday
			JMP RT
		
		RT:
				RET
SelectWeekDay	ENDP
		END