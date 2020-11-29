	PRESERVE8
	AREA MyCode, CODE, READONLY
	EXPORT asmmain
CR EQU 0x0D
LF EQU 0x0A
mask EQU 0x0F
		
asmmain
	IMPORT myfprint
	IMPORT mygetchar
	IMPORT myputchar
	IMPORT myintprint
	IMPORT getElement
	IMPORT myMenuPrint

getrpn	
	LDR r0, =menuMessage
	BL myfprint
	
	BL mygetchar
	PUSH {r0}
	BL myputchar
	POP {r0}
	
	CMP R0,#0x30
	BEQ printMenu
	B getrpn
	
printMenu
	MOV r0, #LF
	BL myputchar
	BL myMenuPrint

options
	BL mygetchar
	PUSH {r0}
	BL myputchar
	MOV r0, #LF
	BL myputchar
	POP {r0}
	
	CMP R0,#0x31
	BEQ menu1
	
	CMP R0,#0x32
	BEQ menu2
	
	CMP R0,#0x33
	BEQ menu3

	B options
	
menu1 
	LDR r0, =menuMessage1
	BL myfprint
	
	MOV r0, #0
	BL getElement
	BL myintprint
	B printMenu
	
menu2
	LDR r0, =menuMessage2
	BL myfprint
	LDR r2, =dailyValue
	LDR r6, [r2]
	MOV r3, #0
mloop
	MOV r0, r3 
	BL getElement
	ADD r0, r0, r6
	STR r0, [r2]
	LDR r6, [r2]
	ADD r3, r3, #1
	CMP r3, #23
	BEQ m2div
	B mloop
m2div
	MOV r3, #24
	UDIV r0,r0,r3
	BL myintprint
	B printMenu

menu3
	LDR r0, =menuMessage3
	BL myfprint
	LDR r2, =weeklyValue
	LDR r6, [r2]
	MOV r3, #0
m3loop
	MOV r0, r3 
	BL getElement
	ADD r0, r0, r6
	STR r0, [r2]
	LDR r6, [r2]
	ADD r3, r3, #1
	CMP r3, #167
	BEQ m3div
	B m3loop
m3div
	MOV r3, #168
	UDIV r0,r0,r3
	BL myintprint
	B printMenu


	ALIGN
	AREA MyData, DATA, READWRITE

openingmessage DCB "welcome press 0 to enter",0
menuMessage DCB "enter 0 to enter menu", 0
message DCB "Incorrect Value",0
menuMessage1 DCB "Energy Consumption last hour watts(W)", 0
menuMessage2 DCB "Energy Consumption last day watts(W)", 0
menuMessage3 DCB "Energy Consumption last week watts(W)", 0
weeklyValue DCD 0
dailyValue DCD 0
	END

