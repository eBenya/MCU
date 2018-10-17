
_main:

;Main.c,20 :: 		void main() {
;Main.c,24 :: 		init_main();
	CALL       _init_main+0
;Main.c,26 :: 		PWM2_Start();
	CALL       _PWM2_Start+0
;Main.c,27 :: 		PWM2_Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Main.c,29 :: 		while(1){
L_main0:
;Main.c,30 :: 		if ( Button(&PORTA, 0, 170, 0) ) Butt.oldstate0 = 1;
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      170
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main2
	MOVLW      1
	MOVWF      _Butt+0
L_main2:
;Main.c,31 :: 		if ( Butt.oldstate0 && Button(&PORTA, 0, 1, 1) ){
	MOVF       _Butt+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
L__main22:
;Main.c,32 :: 		mess.Data = 0x33;
	MOVLW      51
	MOVWF      _mess+2
;Main.c,33 :: 		send_mess();
	CALL       _send_mess+0
;Main.c,36 :: 		Butt.oldstate0 = 0;
	CLRF       _Butt+0
;Main.c,37 :: 		}
L_main5:
;Main.c,39 :: 		if ( Button(&PORTA, 1, 100, 0) ) Butt.oldstate1 = 1;
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	MOVLW      1
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main6
	MOVLW      1
	MOVWF      _Butt+1
L_main6:
;Main.c,40 :: 		if ( Butt.oldstate1 && Button(&PORTA, 0, 10, 1) ){
	MOVF       _Butt+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main9
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      10
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main9
L__main21:
;Main.c,42 :: 		dutyUp();
	CALL       _dutyUp+0
;Main.c,43 :: 		PWM2_Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Main.c,45 :: 		Butt.oldstate1 = 0;
	CLRF       _Butt+1
;Main.c,46 :: 		}
L_main9:
;Main.c,47 :: 		if ( Button(&PORTA, 2, 100, 0) ) Butt.oldstate2 = 1;
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	MOVLW      2
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main10
	MOVLW      1
	MOVWF      _Butt+2
L_main10:
;Main.c,48 :: 		if ( Butt.oldstate2 && Button(&PORTA, 0, 10, 1) ){
	MOVF       _Butt+2, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main13
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      10
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main13
L__main20:
;Main.c,50 :: 		dutyDown();
	CALL       _dutyDown+0
;Main.c,51 :: 		PWM2_Set_Duty(duty);
	MOVF       _duty+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Main.c,53 :: 		Butt.oldstate2 = 0;
	CLRF       _Butt+2
;Main.c,55 :: 		}
L_main13:
;Main.c,60 :: 		}
	GOTO       L_main0
;Main.c,61 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_init_main:

;Main.c,63 :: 		void init_main(){
;Main.c,64 :: 		ANSELA = 0; //all i/o PORTA is digit
	CLRF       ANSELA+0
;Main.c,65 :: 		TRISA.F0 = 1; //PINA0 installed as input (include button)
	BSF        TRISA+0, 0
;Main.c,67 :: 		mess.DST = MCU1_Adr;
	MOVLW      49
	MOVWF      _mess+0
;Main.c,68 :: 		mess.SRC = MCU2_Adr;
	MOVLW      50
	MOVWF      _mess+1
;Main.c,71 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Main.c,73 :: 		PWM2_Init(500);
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;Main.c,74 :: 		}
L_end_init_main:
	RETURN
; end of _init_main

_send_mess:

;Main.c,76 :: 		void send_mess(){
;Main.c,79 :: 		mess.CRC = CRC16( (char*)&mess, sizeof(mess) - 2 );
	MOVLW      _mess+0
	MOVWF      FARG_CRC16_pcBlock+0
	MOVLW      3
	MOVWF      FARG_CRC16_len+0
	CALL       _CRC16+0
	MOVF       R0+0, 0
	MOVWF      _mess+3
	MOVF       R0+1, 0
	MOVWF      _mess+4
;Main.c,81 :: 		poin = (char*)&mess;
	MOVLW      _mess+0
	MOVWF      _poin+0
;Main.c,83 :: 		for ( i = 0; i < sizeof(mess); i++){
	CLRF       send_mess_i_L0+0
L_send_mess14:
	MOVLW      5
	SUBWF      send_mess_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_send_mess15
;Main.c,84 :: 		UART1_Write(*poin++);
	MOVF       _poin+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
	INCF       _poin+0, 1
;Main.c,85 :: 		delay_us(100);
	MOVLW      66
	MOVWF      R13+0
L_send_mess17:
	DECFSZ     R13+0, 1
	GOTO       L_send_mess17
	NOP
;Main.c,83 :: 		for ( i = 0; i < sizeof(mess); i++){
	INCF       send_mess_i_L0+0, 1
;Main.c,86 :: 		}
	GOTO       L_send_mess14
L_send_mess15:
;Main.c,87 :: 		}
L_end_send_mess:
	RETURN
; end of _send_mess

_dutyUp:

;Main.c,88 :: 		void dutyUp(){
;Main.c,89 :: 		if(duty > 254) duty = 254;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	BTFSC      _duty+0, 7
	MOVLW      127
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dutyUp27
	MOVF       _duty+0, 0
	SUBLW      254
L__dutyUp27:
	BTFSC      STATUS+0, 0
	GOTO       L_dutyUp18
	MOVLW      254
	MOVWF      _duty+0
L_dutyUp18:
;Main.c,90 :: 		duty += 1;
	INCF       _duty+0, 1
;Main.c,91 :: 		}
L_end_dutyUp:
	RETURN
; end of _dutyUp

_dutyDown:

;Main.c,92 :: 		void dutyDown(){
;Main.c,93 :: 		if(duty < 1) duty = 1;
	MOVLW      128
	XORWF      _duty+0, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_dutyDown19
	MOVLW      1
	MOVWF      _duty+0
L_dutyDown19:
;Main.c,94 :: 		duty -= 1;
	DECF       _duty+0, 1
;Main.c,95 :: 		}
L_end_dutyDown:
	RETURN
; end of _dutyDown
