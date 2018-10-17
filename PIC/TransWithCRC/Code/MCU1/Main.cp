#line 1 "C:/Users/User/Desktop/TransWithCRC/Code/MCU1/Main.c"
#line 1 "c:/users/user/desktop/transwithcrc/code/heder_file.h"
#line 1 "c:/users/user/desktop/transwithcrc/code/structofmess/structofmess.h"

struct _Data{
 char DST;
 char SRC;
 char Data;
 unsigned int CRC;
};

struct _Button{
 short oldstate0;
 short oldstate1;
 short oldstate2;
 short oldstate3;
 short oldstate4;
 short oldstate5;
 short oldstate6;
 short oldstate7;
} ;
#line 1 "c:/users/user/desktop/transwithcrc/code/crc/protocol_lib.h"






unsigned char Crc8(unsigned char *pcBlock, unsigned char len);




unsigned int CRC16(unsigned char * pcBlock, unsigned char len);



void CRC16_Byte(unsigned char byte, unsigned int *crc);
#line 8 "C:/Users/User/Desktop/TransWithCRC/Code/MCU1/Main.c"
struct _Button Butt = {0, 0, 0, 0, 0, 0, 0, 0};

struct _Data mess;
char *poin;

void send_mess();
void init_main();
void dutyUp();
void dutyDown();

short i, duty = 0;

void main() {



 init_main();

 PWM2_Start();
 PWM2_Set_Duty(duty);

 while(1){
 if ( Button(&PORTA, 0, 170, 0) ) Butt.oldstate0 = 1;
 if ( Butt.oldstate0 && Button(&PORTA, 0, 1, 1) ){
 mess.Data = 0x33;
 send_mess();
#line 36 "C:/Users/User/Desktop/TransWithCRC/Code/MCU1/Main.c"
 Butt.oldstate0 = 0;
 }

 if ( Button(&PORTA, 1, 100, 0) ) Butt.oldstate1 = 1;
 if ( Butt.oldstate1 && Button(&PORTA, 0, 10, 1) ){

 dutyUp();
 PWM2_Set_Duty(duty);

 Butt.oldstate1 = 0;
 }
 if ( Button(&PORTA, 2, 100, 0) ) Butt.oldstate2 = 1;
 if ( Butt.oldstate2 && Button(&PORTA, 0, 10, 1) ){

 dutyDown();
 PWM2_Set_Duty(duty);

 Butt.oldstate2 = 0;

 }
#line 60 "C:/Users/User/Desktop/TransWithCRC/Code/MCU1/Main.c"
 }
}

void init_main(){
 ANSELA = 0;
 TRISA.F0 = 1;

 mess.DST =  0x31 ;
 mess.SRC =  0x32 ;


 UART1_Init(9600);

 PWM2_Init(500);
}

void send_mess(){
 unsigned short i;

 mess.CRC = CRC16( (char*)&mess, sizeof(mess) - 2 );

 poin = (char*)&mess;

 for ( i = 0; i < sizeof(mess); i++){
 UART1_Write(*poin++);
 delay_us(100);
 }
}
void dutyUp(){
 if(duty > 254) duty = 254;
 duty += 1;
}
void dutyDown(){
 if(duty < 1) duty = 1;
 duty -= 1;
}
