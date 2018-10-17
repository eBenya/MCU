bit oldstate;

#define LED PORTA.F0
#define MESS PORTA.F2

void init_main();

void main() {
     init_main();

     while(1){
       if ( Button(&PORTA, 1, 1, 1) ) oldstate = 1;
       if ( oldstate && Button(&PORTA, 1, 1, 0) ){
          MESS = 0;
          LED = 1;
          UART1_Write_Text("MOXA");
          Delay_ms(10);
          oldstate  = 0;
       }
        else {
           MESS = 1;
           LED = 0;
        }
     }
}

void init_main(){
     ANSELA = 0; //all i/o is digit
     TRISA = 0;
     MESS = 1;
     TRISA.F1 = 1; //button
     LED = 0;
     
     APFCON.RXDTSEL = 1;
     APFCON.TXCKSEL = 1;

     oldstate = 0;
     
     OSCCON = 0b01110010; //8MHz Internal osc
     OSCTUNE = 0b00100000; //OSCTUNE: OSCILLATOR TUNING REGISTER
     
     //TXSTA.BRGH = 0;  //BRGH: High Baud Rate Select bit
     
     UART1_Init(9600);
}
