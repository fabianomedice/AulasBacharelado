/******************************************************************************
 *
 *            SEMPRA PROJETOS PLACA E-P18 (PIC18F4550)
 *
 ******************************************************************************
 * Nome do Arquivo:		modelo_main_define.c
 * Dependencias:		Veja a se��o INCLUDES abaixo
 * Microcontrolador:	PIC18F4550
 * Op��o de Clock:		HS 20MHz (externo) - CPU:48MHz (interno)
 * Compilador:			C18 v3.37 ou superior
 * Empresa:				Texugos S/A
 * Plataforma:			Placa E-P18 v3.6
 * Autor:				Fabiano Viana Oliveira da Cunha M�dice
 * Vers�o:				v1.0
 * Descri��o:	
 *	
 *	
 *	
 *	
 *	
 *****************************************************************************/

/** I N C L U D E S **********************************************************/
#include <p18cxxx.h>				// Necess�rio para que o compilador adicione a biblioteca
						// com as defini��es do PIC selecionado no projeto, neste
						// caso, o modelo 18F4550.

#include "displayLCD.h"                         //Necess�rio para que o compilador adicione a biblioteca
						// com as defini��es e fun��es para utilizar o Display LCD

#include <adc.h>                                //Necess�rio para que o compilador adicione a biblioteca
						// com as defini��es e fun��es dos pinos anal�gicos

#include <delays.h>                             //Necess�rio para que o compilador adicione a biblioteca
						// com as defini��es e fun��es de Delay

/** D E F I N E S ************************************************************/
// Sa�das Digitais
#define	LED_VERDE		LATCbits.LATC2
#define	LED_AMARELO		LATDbits.LATD0
#define	LED_VERMELHO		LATDbits.LATD1
#define	BUZZER			LATCbits.LATC1
#define	RELE			LATCbits.LATC0

//Entradas digitais
#define	CH1		PORTAbits.RA1
#define	CH2		PORTAbits.RA2
#define	CH3		PORTAbits.RA3
#define	CH4		PORTAbits.RA4
#define	BOTAO1		PORTEbits.RE1
#define	BOTAO2		PORTEbits.RE2
#define	BOTAO_BOOT	!PORTBbits.RB4


/** V A R I A V E I S   G L O B A I S ****************************************/

char estado;
float valor;

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
        estado = 0;
        SetChanADC(ADC_CH5);
        ConvertADC();
	
	// La�o de repeti��o infinito que executa aplica��o do firmware
	while(1)
	{
            while(BusyADC())
            {

            }
            valor=ReadADC();
            ConvertADC();
            if(valor>350)
            {
                if(estado)
                {
                    LimpaDisplay();
                    estado = 0;
                    EscreveFraseRomLCD("Ambiente Escuro");
                    PosicaoCursorLCD(2,1);
                    valor = valor*4.88;
                    EscreveFloatLCD(valor,2);
                    EscreveFraseRomLCD(" mv");
                }                
                                                
            }
            else
            {
                if(!estado)
                {
                    LimpaDisplay();
                    estado = 1;
                    EscreveFraseRomLCD("Ambiente Claro");
                    PosicaoCursorLCD(2,1);
                    valor = valor*4.88;
                    EscreveFloatLCD(valor,2);
                    EscreveFraseRomLCD(" mv");
                }
                
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

        // Configura os pinos para usar o Display LCD
        ConfiguraLCD();

        // Habilita pinos anal�gicos
        OpenADC(ADC_FOSC_64&ADC_RIGHT_JUST&ADC_2_TAD,ADC_CH5&ADC_INT_OFF&ADC_REF_VDD_VSS,ADC_6ANA);

}//end ConfiguraSistema


/** V E C T O R   R E M A P P I N G ******************************************/
// Rotina necess�ria para o compilador C18 saber onde � o in�cio do vetor de
// "reset".
// ATEN��O: Copiar esta parte do c�digo dentro do arquivo "main.c" dos
// projetos usados com o Bootloader USB-HID para grava��o in-circuit.

extern void _startup (void);        // See c018i.c in your C18 compiler dir
#pragma code REMAPPED_RESET_VECTOR = 0x1000
void _reset (void)
{
	_asm goto _startup _endasm
}
#pragma code	// Diretiva que retorna a aloca��o dos endere�os 
				// da mem�ria de programa para seus valores padr�o

/** F I M  D A  S E � � O  D E   V E C T O R   R E M A P P I N G *************/

/** FIM DO ARQUIVO main.c ***************************************************************/
