//Biblioteca com os SFR's do PIC18F4550
#include <p18f4550.h>


// Defines Saídas Digitais
#define	LED_VERDE		LATCbits.LATC2
#define	LED_AMARELO		LATDbits.LATD0
#define	LED_VERMELHO	LATDbits.LATD1
#define	BUZZER			LATCbits.LATC1
#define	RELE			LATCbits.LATC0

// Defines Entradas digitais
#define	BOTAO1	PORTEbits.RE1
#define	BOTAO2	PORTEbits.RE2
#define	BOTAO_BOOT	PORTBbits.RB4


//Função principal do firmware
void main (void)
{
	//Configurações do firmware
	ADCON1 = ADCON1 | 0x0f;	//Desabilita pinos analógicos

	//Saidas digitais
	TRISCbits.TRISC2 = 0;	//RC2 (LED_VERDE)
	TRISDbits.TRISD0 = 0;	//RD0 (LED_AMARELO)
	TRISDbits.TRISD1 = 0;	//RD1 (LED_VERMELHO)
	TRISCbits.TRISC1 = 0;	//RC1 (BUZZER)
	TRISCbits.TRISC0 = 0; //RC0 (RELE)
	
	//Entradas digitais
	TRISEbits.TRISE1 = 1; //RE1 (BOTAO1)
	TRISEbits.TRISE2 = 1; //RE2 (BOTAO2)
	TRISBbits.TRISB4 = 1; //RB4 (BOTAO_BOOT)
	
	
	// Laço de repetição infinito que executa aplicação do firmware
	while(1)
	{
		//Guarda estado atual dos Botões no PORTE: BOTAO1 e BOTAO2
		char estado = PORTE;
		
		//Limpa bits que não interessam e desloca para uso dos valores
		estado = (estado & 0b00000110) >> 1;

		//Executa tarefa dependendo do valor dos Botões
		switch (estado)
		{
			case 1:
				LED_VERMELHO = 1;
				LED_AMARELO = 0;
				RELE = 0;
			break;
			case 2:
				LED_VERMELHO = 0;
				LED_AMARELO = 1;
				RELE = 0;
			break;
			case 3:
				LED_VERMELHO = 0;
				LED_AMARELO = 0;
				RELE = 1;
			break;
			default:
				LED_VERMELHO = 0;
				LED_AMARELO = 0;
				RELE = 0;
			break;
		}

	}//end while
		
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

