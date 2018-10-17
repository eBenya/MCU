#line 1 "C:/Users/User/Desktop/TransWithCRC/Code/MCU2/Main.c"
#line 1 "c:/users/user/desktop/transwithcrc/code/heder_file.h"
#line 1 "c:/users/user/desktop/transwithcrc/code/structofmess/structofmess.h"

struct _Data{
 char DST;
 char SRC;
 char Data;
 unsigned int CRC;
};
#line 1 "c:/users/user/desktop/transwithcrc/code/crc/protocol_lib.h"






unsigned char Crc8(unsigned char *pcBlock, unsigned char len);




unsigned int CRC16(unsigned char * pcBlock, unsigned char len);



void CRC16_Byte(unsigned char byte, unsigned int *crc);
#line 7 "C:/Users/User/Desktop/TransWithCRC/Code/MCU2/Main.c"
struct _Data mess_in;
bit oldstate, send_in, verif;
unsigned int check_CRC;
char n_byte, *poin;




void init_main();
void read_message();

void interrupt(){
 if (PIR1.RCIF){
 read_message();

 if ( mess_in.SRC ==  0x32  ) send_in = 1;
 PIR1.RCIF = 0;
 }
}

void main() {

 init_main();
 while(1){

 if (n_byte > 4){
 n_byte = 0;
 poin = (char*) &mess_in;
 }
 if (send_in){
 check_CRC = CRC16( (char*)&mess_in, sizeof(mess_in) - 2 );
 if( mess_in.CRC == check_CRC ) verif = 1;
 send_in = 0;
 }
 if (verif){
  PORTA.F1  = 1;
 Delay_ms(1000);
 switch (mess_in.Data){
 case 0x33: {
  PORTA.F2  = 0;
 mess_in.CRC = 0;
 mess_in.DST = 0;
 mess_in.SRC = 0;
 mess_in.Data = 0;
 Delay_ms(500);
 break;
 }
 }
 verif = 0;
 }
 if (( PORTA.F1  == 1) || ( PORTA.F2  == 0)) {
  PORTA.F1  = 0;
  PORTA.F2  = 1;
 }
 }

}

void init_main(){
 ANSELA = 0;
 TRISA = 0;
 TRISA.F0 = 1;
  PORTA.F1  = 1;
 poin = (char*)&mess_in;

 mess_in.CRC = 0;

 UART1_Init(9600);

 PIE1.RCIE = 1;
 INTCON.PEIE = 1;
 INTCON.GIE = 1;


 send_in = verif = oldstate = n_byte = 0;

 Delay_ms(500);
  PORTA.F1  = ! PORTA.F1 ;

}

void read_message(){
 *(poin + n_byte++) = UART1_Read();
 Delay_us(1);


}
