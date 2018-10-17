
_Crc8:

;protocol_lib.c,107 :: 		unsigned char Crc8(unsigned char *pcBlock, unsigned char len)
;protocol_lib.c,109 :: 		unsigned char crc = 0xFF;
	MOVLW      255
	MOVWF      Crc8_crc_L0+0
;protocol_lib.c,110 :: 		while (len--)  crc = Crc8Table[crc ^ *pcBlock++];
L_Crc80:
	MOVF       FARG_Crc8_len+0, 0
	MOVWF      R0+0
	DECF       FARG_Crc8_len+0, 1
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Crc81
	MOVF       FARG_Crc8_pcBlock+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORWF      Crc8_crc_L0+0, 0
	MOVWF      R3+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVLW      _Crc8Table+0
	ADDWF      R0+0, 1
	MOVLW      hi_addr(_Crc8Table+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      Crc8_crc_L0+0
	INCF       FARG_Crc8_pcBlock+0, 1
	GOTO       L_Crc80
L_Crc81:
;protocol_lib.c,111 :: 		return crc;
	MOVF       Crc8_crc_L0+0, 0
	MOVWF      R0+0
;protocol_lib.c,112 :: 		}
L_end_Crc8:
	RETURN
; end of _Crc8

_CRC16:

;protocol_lib.c,118 :: 		unsigned int CRC16(unsigned char * pcBlock, unsigned char len)
;protocol_lib.c,120 :: 		unsigned int crc = 0xFFFF;
	MOVLW      255
	MOVWF      CRC16_crc_L0+0
	MOVLW      255
	MOVWF      CRC16_crc_L0+1
;protocol_lib.c,121 :: 		while (len--)  crc = (crc >> 8) ^ Crc16Table[(crc & 0xFF) ^ *pcBlock++];
L_CRC162:
	MOVF       FARG_CRC16_len+0, 0
	MOVWF      R0+0
	DECF       FARG_CRC16_len+0, 1
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_CRC163
	MOVF       CRC16_crc_L0+1, 0
	MOVWF      R5+0
	CLRF       R5+1
	MOVLW      255
	ANDWF      CRC16_crc_L0+0, 0
	MOVWF      R0+0
	MOVF       CRC16_crc_L0+1, 0
	MOVWF      R0+1
	MOVLW      0
	ANDWF      R0+1, 1
	MOVF       FARG_CRC16_pcBlock+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORWF      R0+0, 0
	MOVWF      R3+0
	MOVF       R0+1, 0
	MOVWF      R3+1
	MOVLW      0
	XORWF      R3+1, 1
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVLW      _Crc16Table+0
	ADDWF      R0+0, 1
	MOVLW      hi_addr(_Crc16Table+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	INCF       ___DoICPAddr+0, 1
	BTFSC      STATUS+0, 2
	INCF       ___DoICPAddr+1, 1
	CALL       _____DoICP+0
	MOVWF      R0+1
	MOVF       R0+0, 0
	XORWF      R5+0, 0
	MOVWF      CRC16_crc_L0+0
	MOVF       R5+1, 0
	XORWF      R0+1, 0
	MOVWF      CRC16_crc_L0+1
	INCF       FARG_CRC16_pcBlock+0, 1
	GOTO       L_CRC162
L_CRC163:
;protocol_lib.c,122 :: 		return crc;
	MOVF       CRC16_crc_L0+0, 0
	MOVWF      R0+0
	MOVF       CRC16_crc_L0+1, 0
	MOVWF      R0+1
;protocol_lib.c,123 :: 		}
L_end_CRC16:
	RETURN
; end of _CRC16

_CRC16_Byte:

;protocol_lib.c,127 :: 		void CRC16_Byte(unsigned char byte, unsigned char *crc)
;protocol_lib.c,129 :: 		*crc = (*crc >> 8) ^ Crc16Table[(*crc & 0xFF) ^ byte];
	MOVF       FARG_CRC16_Byte_crc+0, 0
	MOVWF      FSR
	MOVLW      255
	ANDWF      INDF+0, 0
	MOVWF      R0+0
	MOVF       FARG_CRC16_Byte_byte+0, 0
	XORWF      R0+0, 0
	MOVWF      R3+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVLW      _Crc16Table+0
	ADDWF      R0+0, 1
	MOVLW      hi_addr(_Crc16Table+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	MOVF       FARG_CRC16_Byte_crc+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;protocol_lib.c,130 :: 		}
L_end_CRC16_Byte:
	RETURN
; end of _CRC16_Byte
