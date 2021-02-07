TITLE mainmod(EXE) 主模块，用于调用其他模块
PAGE 60,132
			INCLUDE Video.mac
			EXTRN	DrawBG:FAR
			
			EXTRN	FillValidate:NEAR
			EXTRN	EmptyValidate:NEAR
			EXTRN	FillInValidate:NEAR
			EXTRN	EmptyInValidate:NEAR
			
			EXTRN	AddNumber:NEAR
			EXTRN	SubNumber:NEAR
			EXTRN	MulNumber:NEAR
			EXTRN	DivNumber:NEAR
			EXTRN	Conv_H2ASC:NEAR
			EXTRN	Conv_ASC2H:NEAR
			EXTRN	FillSignal:NEAR
			
			
			EXTRN	Add_Result:WORD
			EXTRN	Sub_Result:WORD
			EXTRN	Mul_Result:DWORD
			EXTRN	Quot_Result:WORD
			EXTRN	Remain_Result:WORD
			
			EXTRN	Add_Result_A:BYTE
			EXTRN	Sub_Result_A:BYTE
			EXTRN	Mul_Result_A:BYTE
			EXTRN	Quot_Result_A:BYTE
			EXTRN	Remain_Result_A:BYTE
			
			
				.MODEL	SMALL
				.STACK 64
				.DATA
Input_Num1_A	LABEL	BYTE					;num1的缓冲区
		Num1_Size	DB	5
		Num1_Count	DB	?
		Num1_Data	DB	5 DUP(30H)
Input_Num2_A	LABEL	BYTE					;num2的缓冲区
		Num2_Size	DB	5
		Num2_Count	DB	?
		Num2_Data	DB	5 DUP(30H)
		
		
Input_Num1			DW	?
Input_Num2			DW	?

Operation			DB	'+','-','*','/'	
Temp_Opr			DB	?
				.CODE
MAIN	PROC	FAR	
			MOV AX,@DATA
			MOV DS,AX
			
			CALL DrawBG
			
		REPMAIN:
			CALL InputFormatNum1			
			MOV BL,Num1_Count
			MOV BH,0
			MOV DI,BX
			MOV BX,OFFSET Num1_Data
			CALL Conv_ASC2H
			MOV	Input_Num1,AX 
			
			CALL InputFormatNum2
			MOV BL,Num2_Count
			MOV BH,0
			MOV DI,BX
			MOV BX,OFFSET Num2_Data
			CALL Conv_ASC2H
			MOV	Input_Num2,AX 
			
			
			CALL SelectOperate
			
			CMP Temp_Opr,'+'
			JZ	CALLADD
			CMP Temp_Opr,'-'
			JZ	CALLSUB
			CMP Temp_Opr,'*'
			JZ	CALLMUL
			CMP Temp_Opr,'/'
			JZ	CALLDIV
		
		MEDIUMP:
			JMP REPMAIN
		
			
		CALLADD:
			MOV AX,Input_Num1
			MOV BX,Input_Num2
			CALL AddNumber
			CALL Conv_Print_Add
			JMP OVERMAIN
		CALLSUB:
			MOV AX,Input_Num1
			MOV BX,Input_Num2
			CALL SubNumber
			CALL Conv_Print_Sub
			JMP OVERMAIN
		CALLMUL:
			MOV AX,Input_Num1
			MOV BX,Input_Num2
			CALL MulNumber
			CALL Conv_Print_Mul
			JMP OVERMAIN
		CALLDIV:
			MOV AX,Input_Num1
			MOV BX,Input_Num2
			CALL DivNumber
			CALL Conv_Print_Div
			JMP OVERMAIN	
			
		OVERMAIN:
			MOV AH,10H
			INT 16H
			CMP AL,'Q'
			JZ	QUIT
			CMP AL,'q'
			JZ	QUIT
			CMP AL,'R'
			JZ	MEDIUMP
			CMP AL,'r'
			JZ  MEDIUMP
			JMP	OVERMAIN
			
		QUIT:
			MOV AH,4CH
			INT 21H
MAIN	ENDP

IOOperate	PROC
			;该函数完场输入与输出显示
			RET
IOOperate	ENDP

InputFormatNum1	PROC
			;这个函数完成Num1的输入
	REINP1:
			ClearRect	8,23,8,27,07H
			SetCursor 8,23
			MOV AH,0AH
			MOV DX,OFFSET Input_Num1_A
			INT 21H
			
			MOV BL,Num1_Count
			MOV BH,0
			MOV DI,BX
			MOV BX,OFFSET Num1_Data
		RECHECK1:
			MOV AL,BYTE PTR [BX][DI]-1
			CMP AL,'0'
			JB	CLSRECT1
			CMP AL,'9'
			JA	CLSRECT1
			DEC DI
			JNZ	RECHECK1
			JMP	VALIDATE1
		CLSRECT1:
			CALL EmptyValidate
			CALL FillInValidate
			JMP	REINP1
		VALIDATE1:
			CALL EmptyInValidate
			CALL FillValidate
			RET
InputformatNum1	ENDP

InputFormatNum2	PROC
			;这个函数完成Num1的输入
	REINP2:
			ClearRect	10,23,10,27,07H
			SetCursor 10,23
			MOV AH,0AH
			MOV DX,OFFSET Input_Num2_A
			INT 21H
			
			MOV BH,0
			MOV BL,Num2_Count
			MOV DI,BX
			MOV BX,OFFSET Num2_Data
		RECHECK2:
			MOV AL,BYTE PTR [BX][DI]-1
			CMP AL,'0'
			JB	CLSRECT2
			CMP AL,'9'
			JA	CLSRECT2
			DEC DI
			JNZ	RECHECK2
			JMP	VALIDATE2
		CLSRECT2:
			CALL EmptyValidate
			CALL FillInValidate
			JMP	REINP2
		VALIDATE2:
			CALL EmptyInValidate
			CALL FillValidate
			RET
InputformatNum2	ENDP

SelectOperate	PROC
				;该函数完成操作符的选择
			MOV CL,0					;初始操作符'+'
			
		REINP3:
			SetCursor 12,23
			MOV BX,OFFSET Operation
			MOV AL,CL
			XLAT
			MOV Temp_Opr,AL
			MOV AH,02H
			MOV DL,AL
			INT 21H
			
			MOV AH,10H
			INT 16H
			CMP AH,1CH
			JZ	OVERSE
			CMP AH,48H
			JZ	UPOPR
			CMP AH,50H
			JZ	DOWNOPR
			JMP	REINP3
		
		UPOPR:
			INC CL
			CMP CL,4
			JB	REINP3
			SUB CL,4
			JMP REINP3
		DOWNOPR:
			DEC CL
			CMP CL,-1
			JG	REINP3
			ADD CL,4
			JMP REINP3
			
			
		OVERSE:
			RET
SelectOperate	ENDP

Conv_Print_Add	PROC
			MOV AX,Add_Result
			CWD
			MOV BX,OFFSET Add_Result_A
			MOV DI,6
			CALL Conv_H2ASC
			CALL FillSignal
			ClearRect	15,23,15,40,07H
			SetCursor 15,23
			PrintString  Add_Result_A
			RET
Conv_Print_Add	ENDP
Conv_Print_Sub	PROC
			MOV AX,Sub_Result
			CWD
			MOV BX,OFFSET Sub_Result_A
			MOV DI,5
			CALL Conv_H2ASC
			CALL FillSignal
			ClearRect	15,23,15,40,07H
			SetCursor 15,23
			PrintString  Sub_Result_A
			RET
Conv_Print_Sub	ENDP
Conv_Print_Mul	PROC
			MOV AX,Mul_Result
			MOV DX,Mul_Result+2
			MOV BX,OFFSET Mul_Result_A
			MOV DI,9
			CALL Conv_H2ASC
			CALL FillSignal
			ClearRect	15,23,15,40,07H
			SetCursor 15,23
			PrintString  Mul_Result_A
			RET
Conv_Print_Mul	ENDP
Conv_Print_Div	PROC
			MOV AX,Quot_Result
			CWD
			MOV BX,OFFSET Quot_Result_A
			MOV DI,5
			CALL Conv_H2ASC
			CALL FillSignal
			ClearRect	15,23,15,40,07H
			SetCursor 15,23
			PrintString  Quot_Result_A
			
			SetCursor 15,28
			MOV AH,02H
			MOV DL,2DH
			INT 21H
			SetCursor 15,29
			MOV AH,02H
			MOV DL,2DH
			INT 21H
			
			MOV AX,Remain_Result
			CWD
			MOV BX,OFFSET Remain_Result_A
			MOV DI,5
			CALL Conv_H2ASC
			CALL FillSignal
			SetCursor 15,30
			PrintString  Remain_Result_A
			RET
Conv_Print_Div	ENDP
		END	MAIN