/*
MCU2 PIC16F727
*/

#include <heder_file.h>

struct _Data mess_in;
bit oldstate, send_in, verif;
unsigned int check_CRC;
char n_byte, *poin;

#define GREEN PORTA.F1
#define RED PORTA.F2

void init_main();
void read_message();

void interrupt(){
     if (PIR1.RCIF){
        read_message();
//Принятое полностью совпадает с отправленным. Проверено!!!
        if ( mess_in.SRC == MCU2_Adr ) send_in = 1;
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
             GREEN = 1;
             Delay_ms(1000);
             switch (mess_in.Data){
                    case 0x33: {
                         RED = 0;
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
        if ((GREEN == 1) || (RED == 0)) {
                GREEN = 0;
                RED = 1;
        }
    }

}

void init_main(){
    ANSELA = 0; //all i/o is digit
    TRISA = 0;
    TRISA.F0 = 1;
    GREEN = 1;
    poin = (char*)&mess_in;
    
    mess_in.CRC = 0;
    
    UART1_Init(9600);

    PIE1.RCIE = 1;
    INTCON.PEIE = 1;
    INTCON.GIE = 1;
    //RCSTA.CREN = 1;

    send_in = verif = oldstate = n_byte = 0;

    Delay_ms(500);
    GREEN = !GREEN;
    
}

void read_message(){ //прием сообщения
     *(poin + n_byte++) = UART1_Read();
     Delay_us(1);//при малой задержке не успевает заполнить структуру и пробегает по циклу дважды
     //корректная работа от задержки равной 1000 единиц (1мс). Стоит внимательно отслеживать и сбрасывать
     //пришедшие данные, дабы не наплодить багов!(фич)
}