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

#include <string.h>                             // Necess�rio para que o compilador adicione a biblioteca
						// com as defini��es e fun��es para se mexer com Strings

#include "displayLCD.h"                         // Necess�rio para que o compilador adicione a biblioteca
						// com as defini��es e fun��es para mexer com o visor LCD

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
#define	BOTAO_BOOT	(!PORTBbits.RB4)


/** V A R I A V E I S   G L O B A I S ****************************************/
char caracter;
char borda;

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
        //Cria��o de vari�veis locais
/*        char string1[20] = "Curso ";
        static rom char string2[20] = "SEMPRA";
        char string3[20];*/

	//Fun��o que faz configura��es do firmware
	ConfiguraSistema();
	
	//Escolhe estado inicial das saidas digitais
	LED_VERDE = 0;
	LED_AMARELO = 0;
	LED_VERMELHO = 0;
	BUZZER = 0;
	RELE = 0;
        PosicaoCursorLCD(1,1);
        caracter = ' ';
        EscreveCaractereLCD(caracter);
        DeslocaCursorEsq();
        caracter = 'a';
        borda = 0;
        

/*        // Manipula Strings
        strcatpgm2ram(string1, string2); // Concatena string2 no final da string1
        strcpy (string3,string1); //copiar o string1 no string3

        //Escreveno LCD
        PosicaoCursorLCD(1,1);
        EscreveFraseRamLCD(string3);
        PosicaoCursorLCD(2,1);
        EscreveFraseRomLCD("12345678901234567");*/

	// La�o de repeti��o infinito que executa aplica��o do firmware
	while(1)
	{
            if(BOTAO1)                              //Bot�o de escrita
            {
                if (!(borda & 0b00000001))          //Fazendo uma m�scara com o botao1 0b xxxx.x001
                {                                   //Se n�o for segurado, borda ser� 0b xxxx.xxx0
                    borda = borda | 0b00000001;     //Coloca 0b xxxx.xxx1 em borda
                    EscreveCaractereLCD(caracter);
                    DeslocaCursorEsq();
                    if (caracter == 'z')
                    {
                        caracter = 'a';
                    }
                    else
                    {
                        caracter++;
                    }
                    
                }
            }
            else
            {
                borda = borda & 0b01110110;         //Zerando a borda, mantendo os outros valores dos outros bot�es 0b x111.x110
            }
            if (BOTAO2)                             //Bot�o de deslocamento do cursor para direita
            {
                if(!(borda & 0b00000010))           //Fazendo uma m�scara com o botao2 0b xxxx.x010
                {                                   //Se n�o for segurado, borda ser� 0b xxxx.xx0x
                    borda = borda | 0b00000010;     //Coloca 0b xxxx.xx1x em borda
                    DeslocaCursorDir();
                    caracter = 'a';
                }
            }
            else
            {
                borda = borda & 0b01110101;         //Zerando a borda, mantendo os outros valores dos outros bot�es 0b x111.x101
            }
            if (BOTAO_BOOT)                         //Bot�o de deslocameno do cursor para esquerda
            {
                if(!(borda & 0b00000100))                    //Fazendo uma m�scara com o botao2 0b xxxx.x100
                {                                   //Se n�o for segurado, borda ser� 0b xxxx.x0xx
                    borda = borda | 0b00000100;              //Coloca 0b xxxx.x1xx em borda
                    DeslocaCursorEsq();
                    caracter = 'a';
                }
                
            }
            else
            {
                borda = borda & 0b01110011;         //Zerando a borda, mantendo os outros valores dos outros bot�es 0b x111.x011
            }
            if (BOTAO2 & BOTAO_BOOT)                //Bot�o de resetar o LCD
            {
                if(!(borda & 0b01000000))           //Fazendo uma m�scara com o botao2 e botao_boot 0b x100.xxxx
                {                                   //Se n�o for segurado, borda ser� 0b x0xx.xxxx
                    borda = borda | 0b01000000;     //Coloca 0b x1xx.xxxx em borda
                    LimpaDisplay();
                    CursorHome();
                    caracter = 'a';
                }
            }
            else
            {
                borda = borda & 0b00110111;         //Zerando a borda, mantendo os outros valores dos outros bot�es 0b x100.x111
            }
            if(BOTAO1 & BOTAO2)                     //Bot�o de deslocamento do LCD para direita
            {
                if(!(borda & 0b00010000))           //Fazendo uma m�scara com o botao1 e botao2 0b 0001.xxxx
                {                                   //Se n�o for segurado, borda ser� 0b xxx0.xxxx
                    borda = borda | 0b00010000;     //Coloca 0b xxx1.xxxx em borda
                    DeslocaDisplayDir();
                }
            }
            else
            {
                borda = borda & 0b01100111;         //Zerando a borda, mantendo os outros valores dos outros bot�es 0b x001.x111
            }
            if(BOTAO1 & BOTAO_BOOT)                 //Bot�o de deslocamento do LCD para esquerda
            {
                if(!(borda & 0b00100000))           //Fazendo uma m�scara com o botao1 e botao_boot 0b x010.xxxx
                {                                   //Se n�o for segurado, borda ser� 0b xx0x.xxxx
                    borda = borda | 0b00100000;     //Coloca 0b xx1x.xxxx em borda
                    DeslocaDisplayEsq();
                }
            }
            else
            {
                borda = borda & 0b01010111;        //Zerando a borda, mantendo os outros valores dos outros bot�es 0b x101.x111
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

        //Configura os pinos do display LCD
        ConfiguraLCD();

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
