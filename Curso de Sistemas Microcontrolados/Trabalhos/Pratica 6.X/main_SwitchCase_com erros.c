/******************************************************************************
 *
 *            SEMPRA PROJETOS PLACA E-P18 (PIC18F4550)
 *
 ******************************************************************************
 * Nome do Arquivo:		main_SwitchCase.c
 * Dependencias:		Veja a se��o INCLUDES abaixo
 * Microcontrolador:	PIC18F4550
 * Op��o de Clock:		HS 20MHz (externo) - CPU:48MHz (interno)
 * Compilador:			C18 v3.37 ou superior
 * Empresa:				SEMPRA
 * Plataforma:			Placa E-P18 v3.6
 * Autor:				SEMPRA
 * Vers�o:				v1.0
 * Descri��o:	Pr�tica 4: Switch-Case
 *	Acionar tr�s dispositivos distintos de acordo com as combina��es dos
 * dois Bot�es.
 *	BT2	BT1
 *	0	0	= Todos os dispositivos desligados
 *	0	1	= Liga somente LED_VERMELHO
 *	1	0	= Liga somente LED_AMARELO
 *	1	1	= Liga somente REL�
 *****************************************************************************/

/** I N C L U D E S **********************************************************/
#include <p18cxxx.h>	// Necess�rio para que o compilador adicione a biblioteca
						// com as defini��es do PIC selecionado no projeto, neste
						// caso, o modelo 18F4550.


/** D E F I N E S ************************************************************/
// Sa�das Digitais
#define	LED_VERDE		LATCbits.LATC2
#define	LED_AMARELO		LATDbits.LATD0
#define	LED_VERMELHO            LATDbits.LATD1
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
 * Sa�da:		Nenhuma (void)
 * Descri��o:	Fun��o principal do programa.
 *****************************************************************************/
void main(void)
{
	//Fun��o que faz configura��es do firmware
	ConfiguraSistema();

	//Escolhe estado inicial das saidas digitais
	LED_VERDE = 0;
	LED_AMARELO = 0;
	LED_VERMELHO = 0;
	BUZZER = 0;
	RELE = 0;

	// La�o de repeti��o infinito que executa aplica��o do firmware
	while(1)
	{
		//Guarda estado atual dos Bot�es no PORTE: BOTAO1 e BOTAO2
		char estado = PORTE;
		
		//Limpa bits que n�o interessam e desloca para uso dos valores
		estado = (estado & 0b00000110) >> 1;

		//Executa tarefa dependendo do valor dos Bot�es
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

	}//end while(1)

}//end main

/******************************************************************************
 * Funcao:		void ConfiguraSistema(void)
 * Entrada:		Nenhuma (void)
 * Sa�da:		Nenhuma (void)
 * Descri��o:	ConfiguraSistema � a rotina de configura��o principal do PIC.
 *		Seu objetivo � configurar as portas de I/O e os perif�ricos
 *		do microcontrolador para que os mesmos trabalhem da maneira
 *		desejada no projeto.
 *****************************************************************************/
void ConfiguraSistema(void)
{
	// Desabilita pinos anal�gicos
	ADCON1 = ADCON1 | 0x0f;

	// Configura saidas digitais
	TRISCbits.TRISC2 = 0; //RC2 (LED_VERDE)
	TRISDbits.TRISD0 = 0; //RD0 (LED_AMARELO)
	TRISDbits.TRISD1 = 0; //RD1 (LED_VERMELHO)
	TRISCbits.TRISC1 = 0; //RC1 (BUZZER)
	TRISCbits.TRISC0 = 0; //RC0 (RELE)

	// Configura entradas digitais
	TRISAbits.TRISA1 = 1; //RA1 (CH1)
	TRISAbits.TRISA2 = 1; //RA2 (CH2)
	TRISAbits.TRISA3 = 1; //RA3 (CH3)
	TRISAbits.TRISA4 = 1; //RA4 (CH4)
	TRISEbits.TRISE1 = 1; //RE1 (BOTAO1)
	TRISEbits.TRISE2 = 1; //RE2 (BOTAO2)
	TRISBbits.TRISB4 = 1; //RB4 (BOTAO_BOOT)

}//end ConfiguraSistema


/** V E C T O R   R E M A P P I N G ******************************************/
// Rotina necess�ria para o compilador C18 saber onde � o in�cio do vetor de
// "reset".
// ATEN��O: Copiar esta parte do c�digo dentro do arquivo "main.c" dos
// projetos usados com o Bootloader USB-HID para grava��o in-circuit.

extern void _startup(void); // See c018i.c in your C18 compiler dir
#pragma code REMAPPED_RESET_VECTOR = 0x1000

void _reset(void) {
	_asm goto _startup _endasm
}
#pragma code	// Diretiva que retorna a aloca��o dos endere�os 
// da mem�ria de programa para seus valores padr�o

/** F I M  D A  S E � � O  D E   V E C T O R   R E M A P P I N G *************/

/** FIM DO ARQUIVO main.c ***************************************************************/
