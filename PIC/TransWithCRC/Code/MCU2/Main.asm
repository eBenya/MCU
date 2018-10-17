
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Main.c,18 :: 		void interrupt(){
;Main.c,19 :: 		if (PIR1.RCIF){
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt0
;Main.c,20 :: 		read_message();
	CALL       _read_message+0
;Main.c,22 :: 		if ( mess_in.SRC == MCU2_Adr ) send_in = 1;
	MOVF       _mess_in+1, 0
	XORLW      50
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
	BSF        _send_in+0, BitPos(_send_in+0)
L_interrupt1:
;Main.c,23 :: 		PIR1.RCIF = 0;
	BCF        PIR1+0, 5
;Main.c,24 :: 		}
L_interrupt0:
;Main.c,25 :: 		}
L_end_interrupt:
L__interrupt19:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Main.c,27 :: 		void main() {
;Main.c,29 :: 		init_main();
	CALL       _init_main+0
;Main.c,30 :: 		while(1){
L_main2:
;Main.c,32 :: 		if (n_byte > 4){
	MOVF       _n_byte+0, 0
	SUBLW      4
	BTFSC      STATUS+0, 0
	GOTO       L_main4
;Main.c,33 :: 		n_byte = 0;
	CLRF       _n_byte+0
;Main.c,34 :: 		poin = (char*) &mess_in;
	MOVLW      _mess_in+0
	MOVWF      _poin+0
;Main.c,35 :: 		}
L_main4:
;Main.c,36 :: 		if (send_in){
	BTFSS      _send_in+0, BitPos(_send_in+0)
	GOTO       L_main5
;Main.c,37 :: 		check_CRC = CRC16( (char*)&mess_in, sizeof(mess_in) - 2 );
	MOVLW      _mess_in+0
	MOVWF      FARG_CRC16_pcBlock+0
	MOVLW      3
	MOVWF      FARG_CRC16_len+0
	CALL       _CRC16+0
	MOVF       R0+0, 0
	MOVWF      _check_CRC+0
	MOVF       R0+1, 0
	MOVWF      _check_CRC+1
;Main.c,38 :: 		if( mess_in.CRC == check_CRC ) verif = 1;
	MOVF       _mess_in+4, 0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main21
	MOVF       R0+0, 0
	XORWF      _mess_in+3, 0
L__main21:
	BTFSS      STATUS+0, 2
	GOTO       L_main6
	BSF        _verif+0, BitPos(_verif+0)
L_main6:
;Main.c,39 :: 		send_in = 0;
	BCF        _send_in+0, BitPos(_send_in+0)
;Main.c,40 :: 		}
L_main5:
;Main.c,41 :: 		if (verif){
	BTFSS      _verif+0, BitPos(_verif+0)
	GOTO       L_main7
;Main.c,42 :: 		GREEN = 1;
	BSF        PORTA+0, 1
;Main.c,43 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
	NOP
;Main.c,44 :: 		switch (mess_in.Data){
	GOTO       L_main9
;Main.c,45 :: 		case 0x33: {
L_main11:
;Main.c,46 :: 		RED = 0;
	BCF        PORTA+0, 2
;Main.c,47 :: 		mess_in.CRC = 0;
	CLRF       _mess_in+3
	CLRF       _mess_in+4
;Main.c,48 :: 		mess_in.DST = 0;
	CLRF       _mess_in+0
;Main.c,49 :: 		mess_in.SRC = 0;
	CLRF       _mess_in+1
;Main.c,50 :: 		mess_in.Data = 0;
	CLRF       _mess_in+2
;Main.c,51 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
	NOP
	NOP
;Main.c,52 :: 		break;
	GOTO       L_main10
;Main.c,54 :: 		}
L_main9:
	MOVF       _mess_in+2, 0
	XORLW      51
	BTFSC      STATUS+0, 2
	GOTO       L_main11
L_main10:
;Main.c,55 :: 		verif = 0;
	BCF        _verif+0, BitPos(_verif+0)
;Main.c,56 :: 		}
L_main7:
;Main.c,57 :: 		if ((GREEN == 1) || (RED == 0)) {
	BTFSC      PORTA+0, 1
	GOTO       L__main17
	BTFSS      PORTA+0, 2
	GOTO       L__main17
	GOTO       L_main15
L__main17:
;Main.c,58 :: 		GREEN = 0;
	BCF        PORTA+0, 1
;Main.c,59 :: 		RED = 1;
	BSF        PORTA+0, 2
;Main.c,60 :: 		}
L_main15:
;Main.c,61 :: 		}
	GOTO       L_main2
;Main.c,63 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_init_main:

;Main.c,65 :: 		void init_main(){
;Main.c,66 :: 		ANSELA = 0; //all i/o is digit
	CLRF       ANSELA+0
;Main.c,67 :: 		TRISA = 0;
	CLRF       TRISA+0
;Main.c,68 :: 		TRISA.F0 = 1;
	BSF        TRISA+0, 0
;Main.c,69 :: 		GREEN = 1;
	BSF        PORTA+0, 1
;Main.c,70 :: 		poin = (char*)&mess_in;
	MOVLW      _mess_in+0
	MOVWF      _poin+0
;Main.c,72 :: 		mess_in.CRC = 0;
	CLRF       _mess_in+3
	CLRF       _mess_in+4
;Main.c,74 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Main.c,76 :: 		PIE1.RCIE = 1;
	BSF        PIE1+0, 5
;Main.c,77 :: 		INTCON.PEIE = 1;
	BSF        INTCON+0, 6
;Main.c,78 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;Main.c,81 :: 		send_in = verif = oldstate = n_byte = 0;
	CLRF       _n_byte+0
	BCF        _oldstate+0, BitPos(_oldstate+0)
	BTFSC      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L__init_main23
	BCF        _verif+0, BitPos(_verif+0)
	GOTO       L__init_main24
L__init_main23:
	BSF        _verif+0, BitPos(_verif+0)
L__init_main24:
	BTFSC      _verif+0, BitPos(_verif+0)
	GOTO       L__init_main25
	BCF        _send_in+0, BitPos(_send_in+0)
	GOTO       L__init_main26
L__init_main25:
	BSF        _send_in+0, BitPos(_send_in+0)
L__init_main26:
;Main.c,83 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_init_main16:
	DECFSZ     R13+0, 1
	GOTO       L_init_main16
	DECFSZ     R12+0, 1
	GOTO       L_init_main16
	DECFSZ     R11+0, 1
	GOTO       L_init_main16
	NOP
	NOP
;Main.c,84 :: 		GREEN = !GREEN;
	MOVLW      2
	XORWF      PORTA+0, 1
;Main.c,86 :: 		}
L_end_init_main:
	RETURN
; end of _init_main

_read_message:

;Main.c,88 :: 		void read_message(){ //прием сообщения
;Main.c,89 :: 		*(poin + n_byte++) = UART1_Read();
	MOVF       _n_byte+0, 0
	ADDWF      _poin+0, 0
	MOVWF      FLOC__read_message+0
	CALL       _UART1_Read+0
	MOVF       FLOC__read_message+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       _n_byte+0, 1
;Main.c,90 :: 		Delay_us(1);//при малой задержке не успевает заполнить структуру и пробегает по циклу дважды
	NOP
	NOP
;Main.c,93 :: 		}
L_end_read_message:
	RETURN
; end of _read_message
