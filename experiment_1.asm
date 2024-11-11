DATAS SEGMENT
    PORTA        EQU 288H     ;A口输出地址
    PORTB        EQU 289H     ;B口输出地址
    PORTC        EQU 28AH     ;C口输出地址
    CONTR        EQU 28BH     ;工作方式控制字地址
    LIST DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH ;共阴极数码
    MSG_EME DB 'Emergency','$'						;紧急情况下的打印字符串

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
    MOV AL,10000000B 		;8255初始化,A、B、C口为方式0输出
    OUT DX,AL
    
LIGHT1:						;南北绿灯，东西红灯，持续9秒
	MOV DX,PORTC
	MOV	AL,00100100B
	OUT DX,AL
	MOV BX,9    			;九秒	
DIGITAL_CUBE1:				;对应LIGHT1的倒计时功能
	MOV DX,PORTA	
	MOV AL,10001000B 		;选通数码管
	OUT DX,AL
	MOV SI,OFFSET LIST
	ADD SI,BX
	MOV AL,[SI]
	MOV DX,PORTB			;让选通的数码管显示对应的数字
	OUT DX,AL
	
	MOV AH,06H
	MOV DL,0FFH				;启用6号中断并设置为读取键盘按键
	INT 21H
	JZ CONTINUE1			;如果没有按键输入，就继续执行程序
	MOV BL,74H				;如果有按键输入，判断是否为T
	CMP AL,BL
	JNZ	CONTINUE1
	CALL EMERGENCY			;如果按下了按键T，就跳到紧急情况处理函数
	
CONTINUE1:
	CALL DELAY_1S   		;延时一秒
	DEC BX			
	JNZ DIGITAL_CUBE1
    
LIGHT2:						;南北黄灯，东西红灯，持续3秒
	MOV DX,PORTC
	MOV AL,01000100B
	OUT DX,AL
	MOV BX,3    			;三秒	
DIGITAL_CUBE2:				;对应LIGHT2的倒计时功能
	MOV DX,PORTA	
	MOV AL,10001000B 		;选通数码管
	OUT DX,AL
	MOV SI,OFFSET LIST
	ADD SI,BX
	MOV AL,[SI]
	MOV DX,PORTB			;让选通的数码管显示对应的数字
	OUT DX,AL
	
	MOV AH,06H
	MOV DL,0FFH				;启用6号中断并设置为读取键盘按键
	INT 21H
	JZ CONTINUE2			;如果没有按键输入，就继续执行程序
	MOV BX,74H				;如果有按键输入，判断是否为T
	CMP AL,BL
	JNZ	CONTINUE2
	CALL EMERGENCY			;如果按下了按键T，就跳到紧急情况处理函数

CONTINUE2:
	CALL DELAY_1S   		;延时一秒
	DEC BX			
	JNZ DIGITAL_CUBE2

LIGHT3:						;南北红灯，东西绿灯，持续9秒
	MOV DX,PORTC
	MOV AL,10000001B
	OUT DX,AL
	MOV BX,9    			;九秒	
DIGITAL_CUBE3:				;对应LIGHT3的倒计时功能
	MOV DX,PORTA	
	MOV AL,10001000B 		;选通数码管
	OUT DX,AL
	MOV SI,OFFSET LIST
	ADD SI,BX
	MOV AL,[SI]
	MOV DX,PORTB			;让选通的数码管显示对应的数字
	OUT DX,AL
	
	MOV AH,06H
	MOV DL,0FFH				;启用6号中断并设置为读取键盘按键
	INT 21H
	JZ CONTINUE3			;如果没有按键输入，就继续执行程序
	MOV BX,74H				;如果有按键输入，判断是否为T
	CMP AL,BL
	JNZ	CONTINUE3
	CALL EMERGENCY			;如果按下了按键T，就跳到紧急情况处理函数

CONTINUE3:
	CALL DELAY_1S   		;延时一秒
	DEC BX			
	JNZ DIGITAL_CUBE3
	
LIGHT4:						;南北红灯，东西黄灯，持续3秒
	MOV DX,PORTC	
	MOV AL,10000010B
	OUT DX,AL
	MOV BX,3    			;三秒	
DIGITAL_CUBE4:				;对应LIGHT4的倒计时功能
	MOV DX,PORTA	
	MOV AL,10001000B 		;选通数码管
	OUT DX,AL
	
	MOV SI,OFFSET LIST
	ADD SI,BX
	MOV AL,[SI]
	MOV DX,PORTB			;让选通的数码管显示对应的数字
	OUT DX,AL
	
	MOV AH,06H
	MOV DL,0FFH				;启用6号中断并设置为读取键盘按键
	INT 21H
	JZ CONTINUE4			;如果没有按键输入，就继续执行程序
	MOV BX,74H				;如果有按键输入，判断是否为T
	CMP AL,BL
	JNZ	CONTINUE4
	CALL EMERGENCY			;如果按下了按键T，就跳到紧急情况处理函数
			
CONTINUE4:
	CALL DELAY_1S   		;延时一秒
	DEC BX			
	JNZ DIGITAL_CUBE4
 
 	JMP LIGHT1				;跳转回LIGHT1，无限循环

 



EMERGENCY PROC				;紧急情况子处理函数，全部亮红灯，停止倒计时
	PUSH AX					;压栈保护现场
	PUSH BX
	PUSH CX
	PUSH DX
	
	MOV DX,OFFSET MSG_EME	;在屏幕显示模式（调试用,可删）
	MOV AH,09H
	INT 21
	
	MOV AH,06H		
	MOV DL,0FFH				;启用6号中断并设置为读取键盘按键
LOOP_EME:
	INT 21
	JNZ LOOP_EME			;判断是否有按键按下
	MOV BX,72H
	CMP AL,BL
	JNZ LOOP_EME			;判断是否为R被按下，如果不是，继续等待
	
	POP DX 					;如果是R被按下，就弹栈恢复现场并恢复主循环
	POP	CX			
	POP BX
	POP AX
	RET
EMERGENCY ENDP



DELAY_1S PROC		;延时1S的函数
	PUSH BX			;压栈保护现场
	PUSH CX
	MOV CX,1000		;二层嵌套循环
T1:	MOV BX,2000
T2:	DEC BX
	JNZ T2
	LOOP T1	
	POP CX			;弹栈恢复现场
	POP BX
	RET
DELAY_1S ENDP

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



















