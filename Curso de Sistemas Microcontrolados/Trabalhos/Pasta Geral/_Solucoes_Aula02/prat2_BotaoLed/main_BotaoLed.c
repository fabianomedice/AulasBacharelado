//Biblioteca com os SFR's do PIC18F4550
#include <p18f4550.h>

//Fun��o principal do firmware
void main (void)
{
	//Configura��es do firmware
	ADCON1 = ADCON1 | 0x0f; //Desabilita pinos anal�gicos
	TRISCbits.TRISC2 = 0;   //Configura pino RC2 (LED_VERDE) como sa�da digital
	TRISDbits.TRISD1 = 0;   //Configura pino RD1 (LED_VERMELHO) como sa�da digital
	TRISEbits.TRISE1 = 1;   //Configura pino RE1 (BOTAO1) como entrada digital


	//Liga o LED_VERDE conectado no pino RC2
	LATCbits.LATC2 = 1;

	// La�o de repeti��o infinito que executa aplica��o do firmware
	while(1)
	{
		// Se BOTAO1 pressionado, liga LED_VERMELHO
		if ( PORTEbits.RE1 )
		{
			LATDbits.LATD1 = 1; //Liga LED_VERMELHO
		}
		else
		{
			LATDbits.LATD1 = 0; //Desliga LED_VERMELHO
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

