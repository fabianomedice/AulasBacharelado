//Biblioteca com os SFR's do PIC18F4550
#include <p18f4550.h>


// Defines Saídas Digitais
#define	LED_VERDE		LATCbits.LATC2
#define	LED_AMARELO		LATDbits.LATD0
#define	LED_VERMELHO	LATDbits.LATD1

// Defines Entradas digitais
#define	BOTAO1	PORTEbits.RE1
#define	BOTAO2	PORTEbits.RE2


//Função principal do firmware
void main (void)
{
	//Configurações do firmware
	ADCON1 = ADCON1 | 0x0f; //Desabilita pinos analógicos
	TRISCbits.TRISC2 = 0;   //Configura pino RC2 (LED_VERDE) como saída digital
	TRISDbits.TRISD0 = 0;   //Configura pino RD0 (LED_AMARELO) como saída digital
	TRISDbits.TRISD1 = 0;   //Configura pino RD1 (LED_VERMELHO) como saída digital
	TRISEbits.TRISE1 = 1;   //Configura pino RE1 (BOTAO1) como entrada digital
	TRISEbits.TRISE2 = 1;   //Configura pino RE2 (BOTAO2) como entrada digital

	//Liga o LED_VERDE
	LED_VERDE = 1;
	
	// Laço de repetição infinito que executa aplicação do firmware
	while(1)
	{
		// Se BOTAO1 pressionado, liga LED_VERMELHO
		if ( BOTAO1 )
		{
			LED_VERMELHO = 1;
		}
		else
		{
			LED_VERMELHO = 0;
		}

		// Se BOTAO2 pressionado, liga LED_AMARELO
		if ( BOTAO2 )
		{
			LED_AMARELO = 1;
		}
		else
		{
			LED_AMARELO = 0;
		}
	}
		
}//end main


/** V E C T O R   R E M A P P I N G ******************************************/
// ATENÇÃO: Copiar esta parte do código dentro do arquivo "main.c" dos
// projetos usados com o Bootloader USB-HID para gravação in-circuit.
extern void _startup (void);        // See c018i.c in your C18 compiler dir
#pragma code REMAPPED_RESET_VECTOR = 0x1000
void _reset (void)
{
	_asm goto _startup _endasm
}
#pragma code
/** F I M  D A  S E Ç Ã O  D E   V E C T O R   R E M A P P I N G *************/

