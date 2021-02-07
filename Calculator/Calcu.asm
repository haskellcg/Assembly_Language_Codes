TITLE Calculate(EXE) 这个程序主要包含一些计算和转换函数,便于其他模块调用
PAGE 60,132
			PUBLIC	AddNumber,SubNumber,MulNumber,DivNumber,Conv_H2ASC,Conv_ASC2H,FillSignal
			PUBLIC	Add_Result,Sub_Result,Mul_Result,Quot_Result,Remain_Result
			PUBLIC 	Add_Result_A,Sub_Result_A,Mul_Result_A,Quot_Result_A,Remain_Result_A
			
			.MODEL SMALL
			.STACK 64
			.DATA
Add_Result		DW	?			;和
Add_Result_A	DB	6 DUP(30H),'$'

Sub_Result		DW	?			;差
Sub_Result_A	DB	5 DUP(30H),'$'

Mul_Result		DD	?			;积
Mul_Result_A	DB	9 DUP(30H),'$'


Quot_Result		DW	?			;商
Quot_Result_A	DB	5 DUP(30H),'$'

Remain_Result	DW	?			;余数
Remain_Result_A	DB	5 DUP(30H),'$'

Ten4			DW	10000
Ten				DW	10
Temp_Quot		DW	?
			.CODE
AddNumber	PROC
			;这个函数完成两个字的加法(由于最大为9999,所以不必考虑进位)
			;AX--第一个字 BX--第二个字 
			;返回值在Add_Result
		PUSH AX
			ADD AX,BX
			MOV Add_Result,AX
		POP AX
			RET
AddNumber	ENDP

SubNumber	PROC
			;这个函数完成两个字的减法
			;AX--第一个字 BX--第二个字 
			;返回值在Sub_Result
		PUSH AX
			SUB AX,BX
			MOV Sub_Result,AX
		POP AX
			RET
SubNumber	ENDP

MulNumber	PROC
			;这个函数完成两个字的乘法
			;AX--第一个字 BX--第二个字
			;返回值在Mul_Result
		PUSH AX
		PUSH DX
			IMUL BX
			MOV Mul_Result,AX
			MOV Mul_Result+2,DX
		POP DX
		POP AX
			RET
MulNumber	ENDP

DivNumber	PROC
			;这个函数完成两个字的除法
			;AX--第一个字 BX--第二个字
			;返回值在Quot_Result--Remain_Result
		PUSH AX
		PUSH DX
			CWD
			IDIV BX
			MOV Quot_Result,AX
			MOV Remain_Result,DX
		POP DX
		POP AX
			RET
DivNumber 	ENDP

Conv_H2ASC	PROC
	
			;这个函数根据传入的参数将16进制数转换为ASC码，便于显示(第一位使用其他函数填充)
			;DXAX--16进制数 BX--ASC码存储地址偏移量 DI--ASC码存储地址长度
			;对于小于32为的用位扩展CWD
			;由于直接使用IDIV会越界，所以使用下面算法
		PUSH AX
		PUSH DX
		PUSH DI
		PUSH SI
		PUSH CX
			MOV SI,DX
			AND SI,1000000000000000B
			CMP SI,0
			JZ	SKIP
			
			XOR DX,0FFFFH
			XOR	AX,0FFFFH
			ADD AX,1
			ADC DX,0
		SKIP:									;正数不变，负数变反加一
			IDIV Ten4
			MOV Temp_Quot,AX
			MOV AX,DX
			
			
			MOV CX,4
		REDIV1:	
			MOV DX,0
			DIV Ten
			OR DL,30H
			MOV [BX][DI]-1,DL
			DEC DI
			CMP DI,1
			JZ	OVERc
			DEC CX
			JNZ REDIV1
			
			MOV AX,Temp_Quot
			
		REDIV2:
			MOV DX,0
			IDIV Ten
			OR	DL,30H
			MOV [BX][DI]-1,DL
			DEC DI
			CMP DI,1
			JZ	OVERC
			JMP REDIV2
			
		
		OVERC:
			POP CX
			POP SI
			POP DI
			POP DX
			POP AX
			RET
Conv_H2ASC	ENDP

Conv_ASC2H	PROC
			;这个函数根据输入的参数将其转换为16进制数
			;BX--ASCII码的地址偏移量 DI--ASCII码地址的长度 AX--转换后的字
			
			MOV CX,0
			MOV Temp_Quot,1
		RECONV:	
			MOV AL,BYTE PTR [BX][DI]-1 
			AND AL,0FH
			MOV AH,0
			MUL Temp_Quot
			ADD CX,AX
			MOV AX,Temp_Quot
			MUL Ten
			MOV Temp_Quot,AX
			DEC	DI
			JNZ RECONV
			
			MOV AX,CX
			
			RET
Conv_ASC2H	ENDP

FillSignal	PROC
			;这个函数主要完成填充ASC的符号位
			;DXAX--16进制数	BX--ASC码存储地址偏移量
			;对于小于32为的用位扩展CWD
		PUSH DX
			AND	DX,1000000000000000B
			CMP DX,0
			JZ	FILL0
			MOV BYTE PTR [BX],2DH			;符号'-'
			JMP OVER0
		FILL0:
			MOV BYTE PTR [BX],00H			;符号' '	
		OVER0:
		POP DX
			RET
FillSignal	ENDP
		END