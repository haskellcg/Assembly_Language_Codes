TITLE Calculate(EXE) ���������Ҫ����һЩ�����ת������,��������ģ�����
PAGE 60,132
			PUBLIC	AddNumber,SubNumber,MulNumber,DivNumber,Conv_H2ASC,Conv_ASC2H,FillSignal
			PUBLIC	Add_Result,Sub_Result,Mul_Result,Quot_Result,Remain_Result
			PUBLIC 	Add_Result_A,Sub_Result_A,Mul_Result_A,Quot_Result_A,Remain_Result_A
			
			.MODEL SMALL
			.STACK 64
			.DATA
Add_Result		DW	?			;��
Add_Result_A	DB	6 DUP(30H),'$'

Sub_Result		DW	?			;��
Sub_Result_A	DB	5 DUP(30H),'$'

Mul_Result		DD	?			;��
Mul_Result_A	DB	9 DUP(30H),'$'


Quot_Result		DW	?			;��
Quot_Result_A	DB	5 DUP(30H),'$'

Remain_Result	DW	?			;����
Remain_Result_A	DB	5 DUP(30H),'$'

Ten4			DW	10000
Ten				DW	10
Temp_Quot		DW	?
			.CODE
AddNumber	PROC
			;���������������ֵļӷ�(�������Ϊ9999,���Բ��ؿ��ǽ�λ)
			;AX--��һ���� BX--�ڶ����� 
			;����ֵ��Add_Result
		PUSH AX
			ADD AX,BX
			MOV Add_Result,AX
		POP AX
			RET
AddNumber	ENDP

SubNumber	PROC
			;���������������ֵļ���
			;AX--��һ���� BX--�ڶ����� 
			;����ֵ��Sub_Result
		PUSH AX
			SUB AX,BX
			MOV Sub_Result,AX
		POP AX
			RET
SubNumber	ENDP

MulNumber	PROC
			;���������������ֵĳ˷�
			;AX--��һ���� BX--�ڶ�����
			;����ֵ��Mul_Result
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
			;���������������ֵĳ���
			;AX--��һ���� BX--�ڶ�����
			;����ֵ��Quot_Result--Remain_Result
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
	
			;����������ݴ���Ĳ�����16������ת��ΪASC�룬������ʾ(��һλʹ�������������)
			;DXAX--16������ BX--ASC��洢��ַƫ���� DI--ASC��洢��ַ����
			;����С��32Ϊ����λ��չCWD
			;����ֱ��ʹ��IDIV��Խ�磬����ʹ�������㷨
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
		SKIP:									;�������䣬�����䷴��һ
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
			;���������������Ĳ�������ת��Ϊ16������
			;BX--ASCII��ĵ�ַƫ���� DI--ASCII���ַ�ĳ��� AX--ת�������
			
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
			;���������Ҫ������ASC�ķ���λ
			;DXAX--16������	BX--ASC��洢��ַƫ����
			;����С��32Ϊ����λ��չCWD
		PUSH DX
			AND	DX,1000000000000000B
			CMP DX,0
			JZ	FILL0
			MOV BYTE PTR [BX],2DH			;����'-'
			JMP OVER0
		FILL0:
			MOV BYTE PTR [BX],00H			;����' '	
		OVER0:
		POP DX
			RET
FillSignal	ENDP
		END