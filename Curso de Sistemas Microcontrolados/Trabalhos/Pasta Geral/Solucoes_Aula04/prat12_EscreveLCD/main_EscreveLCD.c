/******************************************************************************
 *
 *            SEMPRA PROJETOS PLACA E-P18 (PIC18F4550)
 *
 ******************************************************************************
 * Nome do Arquivo:		main_EscreveLCD.c
 * Dependencias:		Veja a seção INCLUDES abaixo
 * Microcontrolador:	PIC18F4550
 * Opção de Clock:		HS 20MHz (externo) - CPU:48MHz (interno)
 * Compilador:			C18 v3.37 ou superior
 * Empresa:				SEMPRA
 * Plataforma:			Placa E-P18 v3.6
 * Autor:				SEMPRA
 * Versão:				v1.0
 * Descrição:	Prática 12: Escreve Display LCD
 *		Utilizando a biblioteca displayLCD.h, escreva no display LCD
 *	- Linha 1: “CURSO SEMPRA”, rom string : armazenada na Mem. de Programa (FLASH)
 *	- Linha 2: “SEU NOME”, ram string : armazenada na Memória de Dados (SRAM)
 *****************************************************************************/

/** I N C L U D E S **********************************************************/
#include <p18cxxx.h>	// Necessário para que o compilador adicione a biblioteca
						// com as definições do PIC selecionado no projeto, neste
						// caso, o modelo 18F4550.

#include <delays.h>		// Biblioteca C18 com funções de delay: Delay10KTCYx()

#include <string.h>		// Bilioteca C18 para manipulação de strings: strcpy()

#include "displayLCD.h"	// Biblioteca com funções do Display LCD


/** D E F I N E S ************************************************************/
// Saídas Digitais
#define	LED_VERDE		LATCbits.LATC2
#define	LED_AMARELO		LATDbits.LATD0
#define	LED_VERMELHO	LATDbits.LATD1
#define	BUZZER			LATCbits.LATC1
#define	RELE			LATCbits.LATC0

//Entradas digitais
#define	CH1		PORTAbits.RA1
#define	CH2		PORTAbits.RA2
#define	CH3		PORTAbits.RA3
#define	CH4		PORTAbits.RA4
#define	BOTAO1	PORTEbits.RE1
#define	BOTAO2	PORTEbits.RE2
#define	BOTAO_BOOT	PORTBbits.RB4


/** V A R I A V E I S   G L O B A I S ****************************************/


/**  P R O T O T I P O S   P R I V A D O S ***********************************/
void ConfiguraSistema(void);


/** F U N C O E S ************************************************************/

/******************************************************************************
 * Funcao:		void main(void)
 * Entrada:		Nenhuma (void)
 * Saída:		Nenhuma (void)
 * Descrição:	Função principal do programa.
 *****************************************************************************/
void main(void)
{
	// String que será escrita na linha2 do display LCD, vetor de caracteres ASCII
	char frase[17] = "sempratec.com.br";
	
	//Função que faz configurações do firmware
	ConfiguraSistema();
	
	//Escolhe estado inicial das saidas digitais
	LED_VERDE = 0;
	LED_AMARELO = 0;
	LED_VERMELHO = 0;
	BUZZER = 0;
	RELE = 0;
	
	//Escreve frase na linha1 do display LCD
	PosicaoCursorLCD(1,1);
	EscreveFraseRomLCD("Curso SEMPRA");
	//Escreve frase na linha2 do display LCD
	PosicaoCursorLCD(2,1);
	EscreveFraseRamLCD(frase);
	
	// Laço de repetição infinito que executa aplicação do firmware
	while(1)
	{
		// Pisca LED_VERDE a cada 200ms
		LED_VERDE = 1;  	// Liga LED_VERDE
		Delay10KTCYx(240);	// Atraso de 200ms
		LED_VERDE = 0;		// Desliga LED_VERDE
		Delay10KTCYx(240);	// Atraso de 200ms
		
		//Testa se BOTAO_1 esta pressionado
		if(BOTAO1)  
		{
			LED_VERMELHO = 1;  //Liga LED_VERMELHO
		}
		else
		{
			LED_VERMELHO = 0;	//Desliga LED_VERMELHO
		}
	}//end while(1)
	
}//end main


/******************************************************************************
 * Funcao:		void ConfiguraSistema(void)
 * Entrada:		Nenhuma (void)
 * Saída:		Nenhuma (void)
 * Descrição:	ConfiguraSistema é a rotina de configuração principal do PIC.
 *		Seu objetivo é configurar as portas de I/O e os periféricos
 *		do microcontrolador para que os mesmos trabalhem da maneira
 *		desejada no projeto.
 *****************************************************************************/
void ConfiguraSistema(void)
{
	// Desabilita pinos analógicos
	ADCON1 = ADCON1 | 0x0f;

	// Configura saidas digitais
	TRISCbits.TRISC2 = 0;	//RC2 (LED_VERDE)
	TRISDbits.TRISD0 = 0;	//RD0 (LED_AMARELO)
	TRISDbits.TRISD1 = 0;	//RD1 (LED_VERMELHO)
	TRISCbits.TRISC1 = 0;	//RC1 (BUZZER)
	TRISCbits.TRISC0 = 0;	//RC0 (RELE)

	// Configura entradas digitais
	TRISAbits.TRISA1 = 1;	//RA1 (CH1)
	TRISAbits.TRISA2 = 1;	//RA2 (CH2)
	TRISAbits.TRISA3 = 1;	//RA3 (CH3)
	TRISAbits.TRISA4 = 1;	//RA4 (CH4)
	TRISEbits.TRISE1 = 1;	//RE1 (BOTAO1)
	TRISEbits.TRISE2 = 1;	//RE2 (BOTAO2)
	TRISBbits.TRISB4 = 1; 	//RB4 (BOTAO_BOOT)

	// Configura pinos do display LCD
	ConfiguraLCD();		

}//end ConfiguraSistema


/** V E C T O R   R E M A P P I N G ******************************************/
// Rotina necessária para o compilador C18 saber onde é o início do vetor de
// "reset".
// ATENÇÃO: Copiar esta parte do código dentro do arquivo "main.c" dos
// projetos usados com o Bootloader USB-HID para gravação in-circuit.

extern void _startup (void);        // See c018i.c in your C18 compiler dir
#pragma code REMAPPED_RESET_VECTOR = 0x1000
void _reset (void)
{
	_asm goto _startup _endasm
}
#pragma code	// Diretiva que retorna a alocação dos endereços 
				// da memória de programa para seus valores padrão

/** F I M  D A  S E Ç Ã O  D E   V E C T O R   R E M A P P I N G *************/

/** FIM DO ARQUIVO main.c ***************************************************************/
