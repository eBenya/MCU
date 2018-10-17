//Пакет сообщения
struct _Data{
        char DST;  //Адрес источника
        char SRC;  //Адрес назначения
        char Data;  //Команда
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

#define MCU1_Adr 0x31
#define MCU2_Adr 0x32