/******************************************************************************
 *
 *            SEMPRA PROJETOS PLACA E-P18 (PIC18F4550)
 *
 ******************************************************************************
 * Nome do Arquivo:		modelo_main_define.c
 * Dependencias:		Veja a seção INCLUDES abaixo
 * Microcontrolador:	PIC18F4550
 * Opção de Clock:		HS 20MHz (externo) - CPU:48MHz (interno)
 * Compilador:			C18 v3.37 ou superior
 * Empresa:				Texugos S/A
 * Plataforma:			Placa E-P18 v3.6
 * Autor:				Fabiano Viana Oliveira da Cunha Médice
 * Versão:				v1.0
 * Descrição:	
 *	
 *	
 *	
 *	
 *	
 *****************************************************************************/

/** I N C L U D E S **********************************************************/
#include <p18cxxx.h>				// Necessário para que o compilador adicione a biblioteca
						// com as definições do PIC selecionado no projeto, neste
						// caso, o modelo 18F4550.

#include <string.h>                             // Necessário para que o compilador adicione a biblioteca
						// com as definições e funções para se mexer com Strings

#include "displayLCD.h"                         // Necessário para que o compilador adicione a biblioteca
						// com as definições e funções para mexer com o visor LCD

/** D E F I N E S ************************************************************/
// Saídas Digitais
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
 * Saída:		Nenhuma (void)
 * Descrição:	Função principal do programa.
 *****************************************************************************/
void main(void)
{
        //Criação de variáveis locais
/*        char string1[20] = "Curso ";
        static rom char string2[20] = "SEMPRA";
        char string3[20];*/

	//Função que faz configurações do firmware
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

	// Laço de repetição infinito que executa aplicação do firmware
	while(1)
	{
            if(BOTAO1)                              //Botão de escrita
            {
                if (!(borda & 0b00000001))          //Fazendo uma máscara com o botao1 0b xxxx.x001
                {                                   //Se não for segurado, borda será 0b xxxx.xxx0
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
                borda = borda & 0b01110110;         //Zerando a borda, mantendo os outros valores dos outros botões 0b x111.x110
            }
            if (BOTAO2)                             //Botão de deslocamento do cursor para direita
            {
                if(!(borda & 0b00000010))           //Fazendo uma máscara com o botao2 0b xxxx.x010
                {                                   //Se não for segurado, borda será 0b xxxx.xx0x
                    borda = borda | 0b00000010;     //Coloca 0b xxxx.xx1x em borda
                    DeslocaCursorDir();
                    caracter = 'a';
                }
            }
            else
            {
                borda = borda & 0b01110101;         //Zerando a borda, mantendo os outros valores dos outros botões 0b x111.x101
            }
            if (BOTAO_BOOT)                         //Botão de deslocameno do cursor para esquerda
            {
                if(!(borda & 0b00000100))                    //Fazendo uma máscara com o botao2 0b xxxx.x100
                {                                   //Se não for segurado, borda será 0b xxxx.x0xx
                    borda = borda | 0b00000100;              //Coloca 0b xxxx.x1xx em borda
                    DeslocaCursorEsq();
                    caracter = 'a';
                }
                
            }
            else
            {
                borda = borda & 0b01110011;         //Zerando a borda, mantendo os outros valores dos outros botões 0b x111.x011
            }
            if (BOTAO2 & BOTAO_BOOT)                //Botão de resetar o LCD
            {
                if(!(borda & 0b01000000))           //Fazendo uma máscara com o botao2 e botao_boot 0b x100.xxxx
                {                                   //Se não for segurado, borda será 0b x0xx.xxxx
                    borda = borda | 0b01000000;     //Coloca 0b x1xx.xxxx em borda
                    LimpaDisplay();
                    CursorHome();
                    caracter = 'a';
                }
            }
            else
            {
                borda = borda & 0b00110111;         //Zerando a borda, mantendo os outros valores dos outros botões 0b x100.x111
            }
            if(BOTAO1 & BOTAO2)                     //Botão de deslocamento do LCD para direita
            {
                if(!(borda & 0b00010000))           //Fazendo uma máscara com o botao1 e botao2 0b 0001.xxxx
                {                                   //Se não for segurado, borda será 0b xxx0.xxxx
                    borda = borda | 0b00010000;     //Coloca 0b xxx1.xxxx em borda
                    DeslocaDisplayDir();
                }
            }
            else
            {
                borda = borda & 0b01100111;         //Zerando a borda, mantendo os outros valores dos outros botões 0b x001.x111
            }
            if(BOTAO1 & BOTAO_BOOT)                 //Botão de deslocamento do LCD para esquerda
            {
                if(!(borda & 0b00100000))           //Fazendo uma máscara com o botao1 e botao_boot 0b x010.xxxx
                {                                   //Se não for segurado, borda será 0b xx0x.xxxx
                    borda = borda | 0b00100000;     //Coloca 0b xx1x.xxxx em borda
                    DeslocaDisplayEsq();
                }
            }
            else
            {
                borda = borda & 0b01010111;        //Zerando a borda, mantendo os outros valores dos outros botões 0b x101.x111
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

        //Configura os pinos do display LCD
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
