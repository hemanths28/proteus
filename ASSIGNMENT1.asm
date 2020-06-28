ORG 0

MOV TMOD,#20H ;TIMER 1,MODE 2
MOV TH1,#0FDH ;BAUD RATE=9600
MOV SCON,#50H ;SERIAL COMMN SETUP
SETB TR1	  ;START TIMER

MOV A,#38H   
ACALL COMMAND
ACALL DELAY

MOV A,#0EH	  ;DISPLAY ON,CURSOR ON
ACALL COMMAND
ACALL DELAY

MOV A,#01H	  ;CLEAR LCD
ACALL COMMAND
ACALL DELAY

START:

HERE:JNB RI,HERE  ;CHECK FOR RI FLAG
     MOV A,SBUF	  
	 ;BACKSPACE
	 CJNE A,#08H,ENTER
	 MOV A,#10H        ;SHIFT CURSOR POSITION TO LEFT
	 ACALL COMMAND
	 MOV A,#' '		   ;CLEARING A POSITION
	 ACALL DAT
	 MOV A,#10H
	 ACALL COMMAND
	 CLR RI
	 SJMP START

ENTER:CJNE A,#0DH,DAT1 ;ENTER
      MOV A,#0C0H	   ;FORCE CURSOR TO THE BEGINNING OF SECOND LINE
	  ACALL COMMAND
	  CLR RI
	  SJMP START

DAT1:ACALL DAT
      CLR RI
	  SJMP START

COMMAND:MOV P2,A
        CLR P3.2 ;RS=0 FOR SELECTING COMMAND REGISTERS
		SETB P3.3
		ACALL DELAY
		CLR P3.3
		RET

DAT: MOV P2,A  
     SETB P3.2 ;RS =1 FOR SELECTING DATA REGISTERS 
	 SETB P3.3
	 ACALL DELAY
	 CLR P3.3
	 RET

DELAY:MOV R0,#255 ;DELAY FOR 10mS 
LOOP:MOV R1,#20
     LOOP1:DJNZ R1,LOOP1
	 DJNZ R0,LOOP
	 RET
END

