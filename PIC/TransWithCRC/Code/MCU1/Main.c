/*
MCU1 PIC16F727
из приведения убраны *
*/

#include <heder_file.h>
#define STOP 100
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
             /*UART1_Write(0x33);
             Delay_ms(1000);*/
             Butt.oldstate0 = 0;
         }
//_________Регулировка ШИМ______________________________________________________
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
        /*for(i = 0; i<180; i++){
           PWM2_Set_Duty(i);
           Delay_ms(STOP);
_________}*///__________________________________________________________________
      }
}

void init_main(){
     ANSELA = 0; //all i/o PORTA is digit
     TRISA.F0 = 1; //PINA0 installed as input (include button)

     mess.DST = MCU1_Adr;
     mess.SRC = MCU2_Adr;
     //mess.Data = 0x33;

     UART1_Init(9600);
     
     PWM2_Init(500);
}

void send_mess(){
     unsigned short  i;     
 
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