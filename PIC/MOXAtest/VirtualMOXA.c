bit oldstate;
char read_mess;

#define LED PORTA.F0
#define MESS PORTA.F2

void init_main();

void interrupt(){
     if( RCIF ){
      read_mess = RCREG;
      LED = 1;
      Delay_ms(1000);
      LED = 0;
     }
}
void main() {
     init_main();

     while(1){
       if ( Button(&PORTA, 1, 1, 1) ) oldstate = 1;
       if ( oldstate && Button(&PORTA, 1, 1, 0) ){
          INTCON.GIE = 0;
          MESS = 0;
          LED = 1;
          UART1_Write_Text("MOXA");
          Delay_ms(10);
          oldstate  = 0;
          INTCON.GIE = 1;
       }
        else {
           if(read_mess == 'M'){
              LED = 1;
              Delay_ms(500);
           }
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
     
     PIE1.RCIE = 1;
     INTCON.PEIE = 1;
     INTCON.GIE = 1;
}