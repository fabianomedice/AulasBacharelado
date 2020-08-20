/**************************************************************************/

/** I N C L U D E S **********************************************************/


#include <p18cxxx.h>           // Necess�rio para que o compilador adicione a biblioteca
                                               // com as defini��es do PIC selecionado no projeto, neste
                                               // caso, o modelo 18F4550.

#include <adc.h>                                //Necess�rio para que o compilador adicione a biblioteca
						// com as defini��es e fun��es dos pinos anal�gicos

/** D E F I N E S ************************************************************/

// Sa�das Digitais

#define           FECHAR_ADMISSAO       LATDbits.LATD0 //LED AMARELO
#define           ABRIR_ADMISSAO        LATDbits.LATD1// LED VERMELHO
#define           FECHAR_ESCAPE         LATCbits.LATC2 // LED VERDE
#define           ABRIR_ESCAPE          LATCbits.LATC1 // BUZZER

//Entradas digitais

#define           SENSOR_HALL                   PORTAbits.RA1 // CHAVE1
#include "displayLCD.h"

/** V A R I A V E I S   G L O B A I S ****************************************/

/**  P R O T O T I P O S   P R I V A D O S ***********************************/

void ConfiguraSistema(void);

/**FUNCOES ************************************************************/

/**********************************************************************

 * Funcao:                   void main(void)
 * Entrada:                  Nenhuma (void)
 * Sa�da:                     Nenhuma (void)
 * Descri��o:   Fun��o principal do programa.

***************************************************************************/

void main(void)
{
            //Fun��o que faz configura��es do firmware

            ConfiguraSistema();

            //Escolhe estado inicial das saidas digitais

            ABRIR_ADMISSAO = 0;
            FECHAR_ADMISSAO = 0;
            ABRIR_ESCAPE = 0;
            FECHAR_ESCAPE = 0;

            // La�o de repeti��o infinito que executa aplica��o do firmware
            while(1)
            {
                        LimpaDisplay();
                        while(SENSOR_HALL)
                        {
                                    PosicaoCursorLCD(1,1);
                                    EscreveFraseRomLCD("Escape");
                                    ABRIR_ESCAPE = 1;
                        }

                        ABRIR_ESCAPE = 0;
                        FECHAR_ESCAPE = 1;

                        LimpaDisplay();
                        while(SENSOR_HALL==0)
                        {
                                    PosicaoCursorLCD(1,1);
                                    EscreveFraseRomLCD("Admissao");
                                    ABRIR_ADMISSAO = 1;
                        }

                        FECHAR_ESCAPE = 0;
                        ABRIR_ADMISSAO = 0;
                        FECHAR_ADMISSAO = 1;

                        LimpaDisplay();
                        while(SENSOR_HALL)
                        {
                                    PosicaoCursorLCD(1,1);
                                    EscreveFraseRomLCD("Compressao");
                        }

                        FECHAR_ADMISSAO = 0;

                        LimpaDisplay();
                        while(SENSOR_HALL==0)
                        {
                                    PosicaoCursorLCD(1,1);
                                    EscreveFraseRomLCD("Explosao");
                        }
            }//end while(1)
}//end main

/***************************************************************************

 * Funcao:                   void ConfiguraSistema(void)
 * Entrada:                  Nenhuma (void)
 * Sa�da:                     Nenhuma (void)

 * Descri��o:   ConfiguraSistema � a rotina de configura��o principal do PIC.
 *                     Seu objetivo � configurar as portas de I/O e os perif�ricos
 *                     do microcontrolador para que os mesmos trabalhem da maneira
 *                     desejada no projeto.

 **************************************************************************/

void ConfiguraSistema(void)
{
            // Desabilita pinos anal�gicos
            ADCON1 = ADCON1 | 0x0f;

            // Configura saidas digitais
            TRISCbits.TRISC2 = 0;        //RC2 (ABRIR_ADMISSAO)
            TRISDbits.TRISD0 = 0;        //RD0 (FECHAR_ADMISSAO)
            TRISDbits.TRISD1 = 0;        //RD1 (ABRIR_ESCAPE)
            TRISCbits.TRISC1 = 0;        //RC1 (FECHAR_ESCAPE)
            TRISCbits.TRISC0 = 0;        //RC0

            // Configura entradas digitais
            TRISAbits.TRISA1 = 1;        //RA1 (SENSOR_HALL)
            TRISAbits.TRISA2 = 1;        //RA2
            TRISAbits.TRISA3 = 1;        //RA3
            TRISAbits.TRISA4 = 1;        //RA4
            TRISEbits.TRISE1 = 1;        //RE1 (BOTAO1)
            TRISEbits.TRISE2 = 1;        //RE2
            TRISBbits.TRISB4 = 1;        //RB4
            
            ConfiguraLCD();

}//end ConfiguraSistema

/** V E C T O R   R E M A P P I N G ******************************************/

// Rotina necess�ria para o compilador C18 saber onde � o in�cio do vetor de "reset".
// ATEN��O: Copiar esta parte do c�digo dentro do arquivo "main.c" dos
// projetos usados com o Bootloader USB-HID para grava��o in-circuit.

extern void _startup (void);        // See c018i.c in your C18 compiler dir

#pragma code REMAPPED_RESET_VECTOR = 0x1000

void _reset (void)

{
            _asm goto _startup _endasm
}

#pragma code // Diretiva que retorna a aloca��o dos endere�os

                        // da mem�ria de programa para seus valores padr�o

/** F I M  D A  S E � � O  D E   V E C T O R   R E M A P P I N G *************/
/**FIM DO ARQUIVO main.c ***************************************************************************/

