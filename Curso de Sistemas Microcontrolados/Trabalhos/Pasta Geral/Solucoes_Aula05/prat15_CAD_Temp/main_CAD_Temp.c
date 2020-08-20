/******************************************************************************
 *
 *            SEMPRA PROJETOS PLACA E-P18 (PIC18F4550)
 *
 ******************************************************************************
 * Nome do Arquivo:		main_TempCAD.c
 * Dependencias:		Veja a seção INCLUDES abaixo
 * Microcontrolador:	PIC18F4550
 * Opção de Clock:		HS 20MHz (externo) - CPU:48MHz (interno)
 * Compilador:			C18 v3.37 ou superior
 * Empresa:				SEMPRA
 * Plataforma:			Placa E-P18 v3.6
 * Autor:				SEMPRA
 * Versão:				v1.0
 * Descrição:	Prática 15: Conversor AD e Sensor de Temperatura MCP9700A
 *		Utilizar o display de LCD para mostrar a medida de temperatura,
 *	em graus Celsius (ºC), do sensor de temperatura MCP9700A conectado no
 *	pino RA0/AN0.
 *		Utilize a biblioteca <adc.h> para configurar e usar o CAD.
 *		Utilize a biblioteca "displayLCD.h" para configurar e usar o display LCD.
 *****************************************************************************/

/** I N C L U D E S **********************************************************/
#include <p18cxxx.h>	// Necessário para que o compilador adicione a biblioteca
						// com as definições do PIC selecionado no projeto, neste
						// caso, o modelo 18F4550.

#include <adc.h>		// Biblioteca C18 com funções para Conversor AD

#include "displayLCD.h"	// Biblioteca com funções para o Display LCD


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

// Resolução do CAD de 10bits = 5V/(2^10-1)
#define RESOLUCAO (5.0/1023.0)


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
	int resultadoBin = 0;		// Guarda o valor da conversão AD em BINÁRIO.
	float resultadoVolts = 0;	// Guarda o valor da conversão AD em VOLTS.
	float resultadoCelsius = 0;	// Guarda o valor da conversão AD em graus Celsius.
	float resolucao = RESOLUCAO;// Guarda o valor da resolução do conversor AD.
	
	//Função que faz configurações do firmware
	ConfiguraSistema();
	
	//Escolhe estado inicial das saidas digitais
	LED_VERDE = 0;
	LED_AMARELO = 0;
	LED_VERMELHO = 0;
	BUZZER = 0;
	RELE = 0;
	
	//Escreve msg inicial no LCD
	PosicaoCursorLCD(1,1);
	EscreveFraseRomLCD("CAD Sensor Temp");
	
	// Inicia a primeira medida
	SelChanConvADC(ADC_CH0);
	
	// Laço de repetição infinito que executa aplicação do firmware
	while(1)
	{
		// Verifica se o CAD terminou uma conversão
		if( !BusyADC() ) 
		{
			// Guarda o resultado da conversão
			resultadoBin = ReadADC();
			
			//Inicia a nova medida
			ConvertADC();

			//Escreve no LCD, valor em Decimal
			PosicaoCursorLCD(2,1);
			EscreveInteiroLCD(resultadoBin);
			EscreveFraseRomLCD(":");

			// Converte a medida  para o valor em volts
			resultadoVolts = (resultadoBin * resolucao);

			//Escreve no LCD, valor em Volts
			EscreveFloatLCD(resultadoVolts,2);
			EscreveFraseRomLCD("V:");

			// Converte a medida em Volts para graus Celsius
			resultadoCelsius = (resultadoVolts*100)-50;

			//Escreve no LCD, valor em graus Celsius
			EscreveFloatLCD(resultadoCelsius,1);
			EscreveFraseRomLCD("oC  ");
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

	// Configura o Diaplay LCD
	ConfiguraLCD();
	
	// Configura o Conversor Analogico Digital (CAD)
	OpenADC(
			//Parâmetro Config
			ADC_FOSC_64		&	//Clock do AD como FOSC/64
			ADC_RIGHT_JUST	&	//Justificando a direita
			ADC_2_TAD,			//Tempo de aquisição de 2 TAD
			//Parâmetro Config2
			ADC_CH0			&	//Canal 0
			ADC_INT_OFF		&	//Não utiliza interrupção	
			ADC_REF_VDD_VSS,	// Tensoes de referencia: VDD - Microcontrolador VSS - Microcontrolador
			
			//Parâmetro PortConfig
			ADC_1ANA );			//Habilita 1 Porta analógica (AN0)
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
