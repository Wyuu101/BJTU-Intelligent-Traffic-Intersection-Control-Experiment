DATAS SEGMENT
    PORTA        EQU 288H     ;A�������ַ
    PORTB        EQU 289H     ;B�������ַ
    PORTC        EQU 28AH     ;C�������ַ
    CONTR        EQU 28BH     ;������ʽ�����ֵ�ַ
    LIST DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH ;����������
    MSG_EME DB 'Emergency','$'						;��������µĴ�ӡ�ַ���

DATAS ENDS

STACKS SEGMENT
    DB 100H DUP(?)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV DX,CONTR
    MOV AL,10000000B 		;8255��ʼ��,A��B��C��Ϊ��ʽ0���
    OUT DX,AL
    
LIGHT1:						;�ϱ��̵ƣ�������ƣ�����9��
	MOV DX,PORTC
	MOV	AL,00100100B
	OUT DX,AL
	MOV BX,9    			;����	
DIGITAL_CUBE1:				;��ӦLIGHT1�ĵ���ʱ����
	MOV DX,PORTA	
	MOV AL,10001000B 		;ѡͨ�����
	OUT DX,AL
	MOV SI,OFFSET LIST
	ADD SI,BX
	MOV AL,[SI]
	MOV DX,PORTB			;��ѡͨ���������ʾ��Ӧ������
	OUT DX,AL
	
	MOV AH,06H
	MOV DL,0FFH				;����6���жϲ�����Ϊ��ȡ���̰���
	INT 21H
	JZ CONTINUE1			;���û�а������룬�ͼ���ִ�г���
	MOV BL,74H				;����а������룬�ж��Ƿ�ΪT
	CMP AL,BL
	JNZ	CONTINUE1
	CALL EMERGENCY			;��������˰���T���������������������
	
CONTINUE1:
	CALL DELAY_1S   		;��ʱһ��
	DEC BX			
	JNZ DIGITAL_CUBE1
    
LIGHT2:						;�ϱ��Ƶƣ�������ƣ�����3��
	MOV DX,PORTC
	MOV AL,01000100B
	OUT DX,AL
	MOV BX,3    			;����	
DIGITAL_CUBE2:				;��ӦLIGHT2�ĵ���ʱ����
	MOV DX,PORTA	
	MOV AL,10001000B 		;ѡͨ�����
	OUT DX,AL
	MOV SI,OFFSET LIST
	ADD SI,BX
	MOV AL,[SI]
	MOV DX,PORTB			;��ѡͨ���������ʾ��Ӧ������
	OUT DX,AL
	
	MOV AH,06H
	MOV DL,0FFH				;����6���жϲ�����Ϊ��ȡ���̰���
	INT 21H
	JZ CONTINUE2			;���û�а������룬�ͼ���ִ�г���
	MOV BX,74H				;����а������룬�ж��Ƿ�ΪT
	CMP AL,BL
	JNZ	CONTINUE2
	CALL EMERGENCY			;��������˰���T���������������������

CONTINUE2:
	CALL DELAY_1S   		;��ʱһ��
	DEC BX			
	JNZ DIGITAL_CUBE2

LIGHT3:						;�ϱ���ƣ������̵ƣ�����9��
	MOV DX,PORTC
	MOV AL,10000001B
	OUT DX,AL
	MOV BX,9    			;����	
DIGITAL_CUBE3:				;��ӦLIGHT3�ĵ���ʱ����
	MOV DX,PORTA	
	MOV AL,10001000B 		;ѡͨ�����
	OUT DX,AL
	MOV SI,OFFSET LIST
	ADD SI,BX
	MOV AL,[SI]
	MOV DX,PORTB			;��ѡͨ���������ʾ��Ӧ������
	OUT DX,AL
	
	MOV AH,06H
	MOV DL,0FFH				;����6���жϲ�����Ϊ��ȡ���̰���
	INT 21H
	JZ CONTINUE3			;���û�а������룬�ͼ���ִ�г���
	MOV BX,74H				;����а������룬�ж��Ƿ�ΪT
	CMP AL,BL
	JNZ	CONTINUE3
	CALL EMERGENCY			;��������˰���T���������������������

CONTINUE3:
	CALL DELAY_1S   		;��ʱһ��
	DEC BX			
	JNZ DIGITAL_CUBE3
	
LIGHT4:						;�ϱ���ƣ������Ƶƣ�����3��
	MOV DX,PORTC	
	MOV AL,10000010B
	OUT DX,AL
	MOV BX,3    			;����	
DIGITAL_CUBE4:				;��ӦLIGHT4�ĵ���ʱ����
	MOV DX,PORTA	
	MOV AL,10001000B 		;ѡͨ�����
	OUT DX,AL
	
	MOV SI,OFFSET LIST
	ADD SI,BX
	MOV AL,[SI]
	MOV DX,PORTB			;��ѡͨ���������ʾ��Ӧ������
	OUT DX,AL
	
	MOV AH,06H
	MOV DL,0FFH				;����6���жϲ�����Ϊ��ȡ���̰���
	INT 21H
	JZ CONTINUE4			;���û�а������룬�ͼ���ִ�г���
	MOV BX,74H				;����а������룬�ж��Ƿ�ΪT
	CMP AL,BL
	JNZ	CONTINUE4
	CALL EMERGENCY			;��������˰���T���������������������
			
CONTINUE4:
	CALL DELAY_1S   		;��ʱһ��
	DEC BX			
	JNZ DIGITAL_CUBE4
 
 	JMP LIGHT1				;��ת��LIGHT1������ѭ��

 



EMERGENCY PROC				;��������Ӵ�������ȫ������ƣ�ֹͣ����ʱ
	PUSH AX					;ѹջ�����ֳ�
	PUSH BX
	PUSH CX
	PUSH DX
	
	MOV DX,OFFSET MSG_EME	;����Ļ��ʾģʽ��������,��ɾ��
	MOV AH,09H
	INT 21
	
	MOV AH,06H		
	MOV DL,0FFH				;����6���жϲ�����Ϊ��ȡ���̰���
LOOP_EME:
	INT 21
	JNZ LOOP_EME			;�ж��Ƿ��а�������
	MOV BX,72H
	CMP AL,BL
	JNZ LOOP_EME			;�ж��Ƿ�ΪR�����£�������ǣ������ȴ�
	
	POP DX 					;�����R�����£��͵�ջ�ָ��ֳ����ָ���ѭ��
	POP	CX			
	POP BX
	POP AX
	RET
EMERGENCY ENDP



DELAY_1S PROC		;��ʱ1S�ĺ���
	PUSH BX			;ѹջ�����ֳ�
	PUSH CX
	MOV CX,1000		;����Ƕ��ѭ��
T1:	MOV BX,2000
T2:	DEC BX
	JNZ T2
	LOOP T1	
	POP CX			;��ջ�ָ��ֳ�
	POP BX
	RET
DELAY_1S ENDP

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



















