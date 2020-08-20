//Biblioteca com os SFR's do PIC18F4550
#include <p18f4550.h>

//Fazendo os Define
#define LED_VERDE LATCbits.LATC2
#define LED_AMARELO LATDbits.LATD0
#define LED_VERMELHO LATDbits.LATD1
#define BOTAO_1 PORTEbits.RE1
#define BOTAO_2 PORTEbits.RE2
#define RELE LATCbits.LATC0

//Fun��o principal do firmware
void main (void)
{
	//Configura��es do firmware
	ADCON1 = ADCON1 | 0x0f;		//Desabilita pinos anal�gicos
	TRISCbits.TRISC2 = 0;		//Configura pino RC2 (LED_VERDE) como sa�da digital
        TRISDbits.TRISD0 = 0;		//Configura pino RD0 (LED_AMARELO) como sa�da digital
        TRISDbits.TRISD1 = 0;		//Configura pino RD1 (LED_VERMELHO) como sa�da digital
        TRISEbits.TRISE1 = 1;           //Configura pino RE1 (botao_1) como entrada
        TRISEbits.TRISE2 = 1;           //Configura pino RE2 (botao_2) como entrada
        TRISCbits.TRISC0 = 0;           //Configura pino RC0 (rele) como sa�da.

	LED_VERDE = 0;                  //Desliga o LED_VERDE
        LED_AMARELO = 0;		//Desliga o LED_AMARELO 
        LED_VERMELHO = 0;		//Desliga o LED_VERMELHO

	// La�o de repeti��o infinito que executa aplica��o do firmware
	while(1)
	{
            if (BOTAO_1 == 0 && BOTAO_2 == 0)
            {
                LED_VERDE = 1;                  //Liga o LED_VERDE
                LED_AMARELO = 0;		//Desliga o LED_AMARELO
                LED_VERMELHO = 0;		//Desliga o LED_VERMELHO
                RELE = 0;                       //Desliga O RELE
            }
            if (BOTAO_1 && BOTAO_2 == 0)
            {
                LED_VERDE = 0;                  //Desliga o LED_VERDE
                LED_AMARELO = 0;		//Desliga o LED_AMARELO
                LED_VERMELHO = 1;		//Liga o LED_VERMELHO
                RELE = 0;                       //Desliga O RELE
            }
            if (BOTAO_1 == 0 && BOTAO_2)
            {
                LED_VERDE = 0;                  //Desliga o LED_VERDE
                LED_AMARELO = 1;		//Liga o LED_AMARELO
                LED_VERMELHO = 0;		//Desliga o LED_VERMELHO
                RELE = 0;                       //Desliga O RELE
            }
            if (BOTAO_1 && BOTAO_2)
            {
                LED_VERDE = 0;                  //Desliga o LED_VERDE
                LED_AMARELO = 0;		//Desliga o LED_AMARELO
                LED_VERMELHO = 0;		//Desliga o LED_VERMELHO
                RELE = 1;                       //ACIONA O RELE
            }
	}
		
}//end main


/** V E C T O R   R E M A P P I N G ******************************************/
// ATEN��O: Copiar esta parte do c�digo dentro do arquivo "main.c" dos
// projetos usados com o Bootloader USB-HID para grava��o in-circuit.
extern void _startup (void);        // See c018i.c in your C18 compiler dir
#pragma code REMAPPED_RESET_VECTOR = 0x1000
void _reset (void)
{
	_asm goto _startup _endasm
}
#pragma code
/** F I M  D A  S E � � O  D E   V E C T O R   R E M A P P I N G *************/
