/******************************************************************************
 *
 *            Curso SEMPRA de Microcontroladores (PIC18F4550)
 *
 ******************************************************************************
 * Nome do Arquivo:	displayLCD.c
 * Dependencias:	Veja arquivo "displayLCD.h"
 * Processador:		PIC18F4550
 * Op��o de Clock:	HS 20MHz (externo) - CPU: 48MHz
 * Compilador:		C18 v3.20 ou superior
 * Empresa:			SEMPRA - Axoon - UFMG
 *
 * Plataforma:		Placa E-P18 v3.0, v3.5 e v3.6
 *
 * Autor:			M.Sc. Henrique Resende Martins
 *					Mauricio Ferrari Santos Corr�a
 *					Bruno Silveira Avelar
 *					James Hamilton Oliveira Junior
 *
 * Data:			v1 - 15/Fev/2009 - M.Sc. Henrique Resende Martins
 *					v2 - 28/Abr/2009 - Mauricio Ferrari Santos Corr�a
 *					v3 - 16/Jun/2009 - Mauricio Ferrari Santos Corr�a
 *					v4 - 18/Nov/2009 - Mauricio Ferrari Santos Corr�a
 *					v5 - 05/Dez/2009 - Mauricio Ferrari Santos Corr�a
 *					v6 - 28/fev/2010 - Bruno Silveira Avelar
 *					v7 - 10/Mar/2010 - Mauricio Ferrari Santos Corr�a
 *					v8 - 15/Out/2010 - Mauricio Ferrari Santos Corr�a
 *					v9 - 15/Dez/2010 - Mauricio Ferrari Santos Corr�a
 *					v10- 17/Jan/2011 - Mauricio Ferrari Santos Corr�a
 *					v11- 19/Jan/2011 - James Hamilton Oliveira Junior
 *					v12- 02/Mai/2011 - Mauricio Ferrari Santos Corr�a
 *					v13- 05/Out/2011 - Mauricio Ferrari Santos Corr�a
 *					v14- 06/Jun/2012 - Mauricio Ferrari Santos Corr�a
 *
 * Descri��o:   Modifica��o da biblioteca xlcd.h fornecida com o compilador
 *		C18 da Microchip. A biblioteca xlcd.h trata da comunica��o
 *		com display de LCD por meio de 4-bits (length), utilizando o 
 *		PORTB tanto para os 4 bits de dados quanto para os 3 bits de
 *		controle (RS, RW e E).
 *		No projeto da placa E-P18 o display LCD � ligado �s portas
 *		digitais diversas do PIC 18F4550. A placa E-P18 utiliza
 *		os seguintes pinos para comunica��o com o display LCD:
 *			PIC18F4550(pino):: Display LCD
 *				RD4 (27)  	::	  D4
 *				RD5 (28)  	::	  D5
 *				RD6 (29)  	::	  D6
 *				RD7 (30)  	::	  D7
 *				RD2 (21)  	::	  RS
 *				RD3 (22)  	::	  E
 *				 GND		::	  R/W
 *		OBS: o pino R/W do display � ligado na placa E-P18 ao GND
 *		atrav�s de um resistor de pull-down, assim o LCD opera no 
 *		modo escrite(Write) o tempo todo. No entanto o c�digo C foi
 *		escrito mostrando a imlementa��o onde um pino do PIC � 
 *		utilizado para a fun��o R/W, assim comentando o inicio das 
 *		linhas correspondentes com "//n�o usado //".
 *	Notas:
 *	- Essa bliblioteca de rotinas foi escrita pensando em um LCD
 *	16x2 FDCC1602E implementado com o controlador SPLC780D, mas pode
 *	ser utilizado com qualquer LCD 16x2 com controladores equivalentes
 *	como, por exemplo, o controlador Hitachi HD44780 LCD controller.
 *
 *	- O usu�rio deve definir os seguintes itens:
 *		-- O tipo de interface de comunica��o do LDC com o PIC (4 ou 8-bits):
 *		Se for o modo 4-bit, utilizar o upper nibble (nibble � metade de um Byte)
 *		, ou seja, enviar primeiro os 4 bits mais significativos (upper nibble)
 *		e depois os 4 bits menos sgnificativos (lower nibble).
 *
 *		-- Cursor e/ou Blink:
 *		O usu�rio poder� definir se quer visualizar cursor, blink
 *		ou nenhum dos dois.
 *
 *		-- O sincronismo da comunica��o com o LCD:
 *		As temporiza��es entre o envio de comandos, n�o foi utilizado
 *		o bit de Busy do LCD, mas sim, atrav�s de fun��es de atraso.
 *		A fun��o utilizada foi a Delay10KTCYx() da bilioteca padr�o C18
 *		delays.h que aparece na se��o INCLUDE deste arquivo.
 *		Os tempos de delay escolhidos est�o colocados nos defines:
 *		DELAY_SINC e DELAY_INICIO, que foram ecolhidos bem acima do 
 *		tempo m�nimo requerido pelo display de LCD (5ms o de sincronismo e
 *		15ms o inicial).
 *****************************************************************************/


/** I N C L U D E S **********************************************************/
#include "displayLCD.h"
#include <math.h>		//Biblioteca Microchip C18 com fun��es matem�ticas: fabs()
#include <stdlib.h>		//Biblioteca Microchip C18 com fun��es convers�o de dados: itoa()


/** F U N C O E S ************************************************************/

/******************************************************************************
 * Funcao:		void ConfiguraLCD(void)
 * Entrada:		Nenhuma (void)
 * Sa�da:		Nenhuma (void)
 * Descri��o:	Configura portas do PIC 18F4550 que est�o conectadas ao 
 *	display LCD como saida. Essa rotina � baseada no controlador de LCD 
 *  Hitachi HD44780. Configura os parametros de comunica��o com o display,
 *  tais como:
 *	- modo de opera��o (4 ou 8 data bits)
 *	- tipo de cursor
 *	- tamanho da fonte
 *	Ao final da configura��o limpa o display.
 *****************************************************************************/
void ConfiguraLCD(void)
{
	// Desabilita todas as 13 portas anal�gicas ANx (portas do conversor A/D),
	// assim as mesmas fucionam como pinos digitais
	ADCON1 |= 0x0F;

	// Configura os pinos de controle (RW,RS,E) como sa�da.
	//n�o usado // 	TRIS_RW = 0;
	TRIS_RS = 0;
	TRIS_E = 0;

	// Configura os pinos de dados (D4,D5,D6,D7) como sa�da.
	TRIS_D4=0;
	TRIS_D5=0;
	TRIS_D6=0;
	TRIS_D7=0;

// Inicio da rotina de inicializa��o do display LCD
// Aguardar tempos e enviar 3 vezes o comando 0b0011XXXX como descrito no datasheet
// do controlador HD44780 ou SPLC780D

	//Seleciona pinos de Controle para escrita do comando
	//n�o usado // 	RW_PIN = 0;	//escrita=0, leitura=1
	RS_PIN = 0;		// comando=0, dados=1
	E_PIN =  0; 	// desabilita=0, habilita=1

	//selecioan pinos de dados com comando de inicializa��o 0b0011 no Nibble-High
	//(os 4 bits de dados mais significativos), os bits do Nibble-Low s�o Don't Care 
	D7=0;
	D6=0;
	D5=1;
	D4=1;

//Passo 1: Envio do comando de inicializa��o 0b0011

	// Delay inicial de 15ms ap�s alimentar o LCD: Vdd > 4,5V
	DELAY_5ms();
	DELAY_5ms();
	DELAY_5ms();

	//Habilita leitura do comando pelo LCD, atrav�s do pino de enable, para tanto,
	//um pulso de 1ms com borda de descida � efetuado
	E_PIN = 1;      			
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();

//Passo 2: Envio do comando de inicializa��o 0b0011

	// Delay de pelo menos 4.1ms
	DELAY_5ms();

	//Pulso no pino de Enable para habilitar leitura do LCD na borda de descida
	E_PIN = 1;      			
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();

//Passo 3: Envio do comando de inicializa��o 0b0011

	// Delay de pelo menos 100us
	DELAY_5ms();

	//Pulso no pino de Enable para habilitar leitura do LCD na borda de descida
	E_PIN = 1;      			
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();

//Passo 4: Envio da Configura��o 0b0010 no Nibble-High
	D7=0;
	D6=0;
	D5=1;
	D4=0;


	//Pulso no pino de Enable para habilitar leitura do LCD na borda de descida
	E_PIN = 1;      			
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();


//Envio dos comandos de Configura��o do LCD
	EscreveComandoLCD(0b00101000);	// Function Set: 4bit interface, 2 lines, Font 5x7  
	EscreveComandoLCD(0b00000110);	// Entry mode set: Increment, Shift OFF
	EscreveComandoLCD(0b00001110);	// Display Control: Display ON, Cursor ON, Blink OFF
	EscreveComandoLCD(0b00000001);	// Clear display
}


/******************************************************************************
 * Funcao:		void EscreveComandoLCD(unsigned char cmd)
 * Entrada:		cmd: comando que ser� enviado para o LCD
 * Sa�da:		Nenhuma (void)
 * Descri��o:	(Write a command to the LCD)
 *	Escreve um comando para o display de LCD.
 *****************************************************************************/
void EscreveComandoLCD(unsigned char cmd)
{
	//Seleciona pinos de Controle para escrita do comando
	//n�o usado // 	RW_PIN = 0;	//escrita=0, leitura=1
	RS_PIN = 0;		// comando=0, dados=1
	E_PIN =  0; 	// desabilita=0, habilita=1

	//Seleciona pinos de Dados: Nibble-High
	if(cmd&0b00010000){D4=1;}
	else {D4=0;}
	if(cmd&0b00100000){D5=1;}
	else {D5=0;}
	if(cmd&0b01000000){D6=1;}
	else {D6=0;}
	if(cmd&0b10000000){D7=1;}
	else {D7=0;}

	//Pulso no pino de Enable para habilitar leitura do LCD na borda de descida
	E_PIN = 1;
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();

	//Seleciona pinos de Dados: Nibble-Low
	if(cmd&0b00000001){D4=1;}
	else {D4=0;}
	if(cmd&0b00000010){D5=1;}
	else {D5=0;}
	if(cmd&0b00000100){D6=1;}
	else {D6=0;}
	if(cmd&0b00001000){D7=1;}
	else {D7=0;}    

	//Pulso no pino de Enable para habilitar leitura do LCD na borda de descida
	E_PIN = 1;
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();
	
	//Como os comandos Clear Display(0b00000001) e Cursor Home(0b0000001x),
	//demoram mais tempo para serem executados,cerca de cerca de 1,5ms.
	//Garante-se um atraso maior caso os mesmos sejam efetuados
	if (cmd==0x01 || cmd==0x02 || cmd==0x03)
	{ DELAY_SINC(); }
}


/******************************************************************************
 * Funcao:		void EnderecoCursor(unsigned char endereco)
 * Entrada:		endereco: endere�o da memoria de dados do display que se 
 *				colocar o cursor
 * Sa�da:		Nenhuma (void)
 * Descri��o:	(Set the Display Data RAM Address)
 *	Essa rotina posiciona o cursor no endere�o desejado da memoria RAM do 
 *	display LCD. Os comandos de escrita seguintes v�o come�ar a partir da
 *	posi��o escolhida por esta fun��o
 *****************************************************************************/
void EnderecoCursor(unsigned char endereco)
{
	//Seleciona pinos de Controle para escrita do comando
	//n�o usado // 	RW_PIN = 0;	//escrita=0, leitura=1
	RS_PIN = 0;		// comando=0, dados=1
	E_PIN =  0; 	// desabilita=0, habilita=1

	//Seleciona pinos de Dados: Nibble-High
	D7 = 1;	
	if(endereco&0b00010000){D4=1;}
	else {D4=0;}
	if(endereco&0b00100000){D5=1;}
	else {D5=0;}
	if(endereco&0b01000000){D6=1;}
	else {D6=0;}
	
	//Pulso no pino de Enable para habilitar leitura do LCD na borda de descida
	E_PIN = 1;
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();

	//Seleciona pinos de Dados: Nibble-Low
	if(endereco&0b00000001){D4=1;}
	else {D4=0;}
	if(endereco&0b00000010){D5=1;}
	else {D5=0;}
	if(endereco&0b00000100){D6=1;}
	else {D6=0;}
	if(endereco&0b00001000){D7=1;}
	else {D7=0;}

	//Pulso no pino de Enable para habilitar leitura do LCD na borda de descida
	E_PIN = 1;
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();
}


/******************************************************************************
 * Funcao:		void PosicaoCursorLCD(unsigned char linha, unsigned char coluna)
 * Entrada:		linha: n�mero de 1 � 4 da linha em que se deseja deixar o cursor
 *
 *				coluna: n�mero de 1 � 16 coluna linha em que se deseja deixar o cursor
 *
 * Sa�da:		Nenhuma (void)
 * Descri��o:	Essa rotina posiciona o cursor na tela do display, na linha 
 *	e coluna desejados. Os comandos de escrita seguintes v�o come�ar a partir
 *  da posi��o escolhida por esta fun��o
 *****************************************************************************/
void PosicaoCursorLCD(unsigned char linha, unsigned char coluna)
{
	//endere�o de inicio de cada linha
	#define linha1	0x00	
	#define	linha2	0x40
	#define linha3	0x14
	#define	linha4	0x54
	
	unsigned char endereco = 0x00;
	
	coluna--;
	
	if (coluna >= 0)
	{
		//Calcula o endere�o da mem�ria RAM do display que deve ser usado
		//para posicionar o cursor na linha e coluna desejados
		switch (linha)
		{
			case 1:
				endereco = linha1 + coluna;
				EnderecoCursor(endereco);		
			break;
		
			case 2:
				endereco = linha2 + coluna;
				EnderecoCursor(endereco);
			break;
			
			case 3:
				endereco = linha3 + coluna;
				EnderecoCursor(endereco);		
			break;
		
			case 4:
				endereco = linha4 + coluna;
				EnderecoCursor(endereco);
			break;
			
			default:
				endereco = linha1;
			break;
		}
	}
	else
	{
		endereco = linha1;
	}
}


/******************************************************************************
 * Funcao:		void EscreveCaractereLCD(unsigned char data)
 * Entrada:		data: Byte de dados para ser escrito na memoria RAM do LCD
 * Sa�da:		Nenhuma (void)
 * Descri��o:	(Write a Data byte to the LCD)
 *	Essa rotina escreve o byte de caracteres no display a partir da posi��o
 *	de memoria atual do cursor ou da posi��o de mem�ria	escolhida com as
 *	fun��es PosicaoCursorLCD() ou EnderecoCursor().
 *****************************************************************************/
void EscreveCaractereLCD(char data)
{
	//Seleciona pinos de Controle para escrita do comando
	//n�o usado // 	RW_PIN = 0;	//escrita=0, leitura=1
	RS_PIN = 1;		// comando=0, dados=1
	E_PIN =  0; 	// desabilita=0, habilita=1

	//Seleciona pinos de Dados: Nibble-High
	if(data&0b00010000){D4=1;}
	else {D4=0;}
	if(data&0b00100000){D5=1;}
	else {D5=0;}
	if(data&0b01000000){D6=1;}
	else {D6=0;}
	if(data&0b10000000){D7=1;}
	else {D7=0;}

	//Pulso no pino de Enable para habilitar leitura do LCD na borda de descida
	E_PIN = 1;
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();


	//Seleciona pinos de Dados: Nibble-Low
	if(data&0b00000001){D4=1;}
	else {D4=0;}
	if(data&0b00000010){D5=1;}
	else {D5=0;}
	if(data&0b00000100){D6=1;}
	else {D6=0;}
	if(data&0b00001000){D7=1;}
	else {D7=0;}    

	//Pulso no pino de Enable para habilitar leitura do LCD na borda de descida
	E_PIN = 1;
    DELAY_SINC();
	E_PIN = 0;
	DELAY_SINC();
}


/******************************************************************************
 * Funcao:		void EscreveInteiroLCD(int valor)
 * Entrada:		valor: numero inteiro com sinal (de -32768 a 32767) a ser escrito no
 *				display.
 *
 * Sa�da:		Nenhuma (void)
 * Descri��o:	Essa rotina escreve o numero inteiro no display a partir da posi��o
 *	de memoria atual do cursor ou da posi��o de mem�ria escolhida com as
 *	fun��es PosicaoCursorLCD() ou EnderecoCursor().
 *****************************************************************************/
void EscreveInteiroLCD(int valor)
{
	char texto[7] = " ";
	itoa( valor, texto);
	EscreveFraseRamLCD(texto);
}


/******************************************************************************
 * Funcao:		void EscreveFloatLCD(float valor, char formatacao)
 * Entrada:		valor: numero float com sinal (de -9999.9999 a 9999.9999) que
 *				ser� escrito no display
 *
 *				formatacao: numero de casas decimais desejadas ap�s a 
 *				virgula (de 0 � 4 casas decimais).
 *
 * Sa�da:	Nenhuma (void)
 * Descri��o:	Essa rotina escreve o numero float no display a partir da posi��o
 *	atual do cursor com quantas casas decimais forem definidas no
 *  par�metro formatacao.
 *****************************************************************************/
void EscreveFloatLCD(float valor, char formatacao)
{
	int numInt = 0;		// Guarda parte inteira
	float numFloat = 0; // Guarda parte fracion�ria
	char n;				// contador do comando for
	
	// Escreve parte inteira
	numInt = (int)valor;
	EscreveInteiroLCD(numInt);
	
	// Escreve as casas decimais indicada na formata��o
	if( formatacao > 0 )
	{
		EscreveCaractereLCD('.');
		// Separa parte fracion�ria
		numFloat = (valor - numInt);
		// Se NumFloat � negativo, corrige o sinal
		numFloat = fabs(numFloat);
		
		// Garante que so escreve ate 5 casas decimais
		if(formatacao>4)
			{formatacao=4;}
		
		// Calcula as casas decimais
		for (n = formatacao; n>0; n--)
		{
			numFloat *= 10;
			// Escreve zeros ap�s a virgula
			if( (numFloat<1) && (n>1))
			{
				EscreveCaractereLCD('0');
			}
		}
		// Escreve parte fracion�ria
		EscreveInteiroLCD((int)numFloat);

	}
}


/******************************************************************************
 * Funcao:		void EscreveFraseRamLCD(char *buffer)
 * Entrada:		*buffer: apontador para string na memoria de dados(RAM)
 * Sa�da:		Nenhuma (void)
 * Descri��o:	Essa rotina copia uma string terminada com caracter nulo
 *	da memoria de dados do microcontrolador para o display de LCD.
 *	A string apontada por *buffer � copiada no display a partir da posi��o
 *  de memoria atual do cursor ou da posi��o de mem�ria
 *  escolhida com as fun��es PosicaoCursorLCD() ou EnderecoCursor().
 *****************************************************************************/
void EscreveFraseRamLCD(char *buffer)
{
	while(*buffer)		// escreve dados no LCD ate achar caracter nulo
	{
		EscreveCaractereLCD(*buffer); // escreve caracter no LCD
		buffer++;		// incrementa apontador
	}
}


/******************************************************************************
 * Funcao:		void EscreveFraseRomLCD(const rom char *buffer)
 * Entrada:		*buffer: apontador para string na memoria de programa(ROM)
 * Sa�da:		Nenhuma (void)
 * Descri��o:	Essa rotina copia uma string terminada com caracter nulo
 *	da memoria de programa do microcontrolador para o display de LCD.
 *	A string apontada por *buffer � copiada no display a partir da
 *	posi��o de memoria atual do cursor ou da posi��o de mem�ria escolhida
 *	com as fun��es PosicaoCursorLCD() ou EnderecoCursor().
 *****************************************************************************/
void EscreveFraseRomLCD(const rom char *buffer)
{
	while(*buffer)		// escreve dados no LCD ate achar caracter nulo
	{
		EscreveCaractereLCD(*buffer); // escreve caracter no LCD
		buffer++;		// incrementa apontador
	}
}


/******************************************************************************
 * Funcao:		void CriaCaractereLCD(unsigned char endereco, const char *buffer)
 * Entrada:		endereco: Numero de 0 � 7 que indica a posi��o da CGRAM que o 
 *				caractere ser� criado.
 *
 *				*buffer: apontador para o vetor de char com tamanho 8 que 
 *				guarda cada linha de desenho do caractere que ser� criado.
 *
 * Sa�da:		Nenhuma (void)
 * Descri��o:   Essa rotina cria um caractere de usu�rio em uma das 7 posi��es
 *	disponiveis na CGRAM do display. O caractere criado tem tamanho 8x5 pixel
 *  (8 linhas e 5 colunas), portanto cada valor do vetor buffer representa
 *  uma linha, onde os 3 bits mais significativos de cada valor � desprezado.
 *****************************************************************************/
void CriaCaractereLCD(unsigned char endereco, const char *buffer)
{
	unsigned char cmd;		//guarda comando a ser enviado para LCD
	unsigned char n = 0;	//contador do comando for

	//Dependendo do valor de endereco, seleciona o comando correto
	//Garante que enderco s� tenha valores de 0 � 7
	endereco = endereco & 0b00000111;
	
	switch (endereco)
	{	case 0: cmd = 0b01000000;	break;
		case 1: cmd = 0b01001000;	break;
		case 2: cmd = 0b01010000;	break;
		case 3: cmd = 0b01011000;	break;
		case 4: cmd = 0b01100000;	break;
		case 5: cmd = 0b01101000;	break;
		case 6: cmd = 0b01110000;	break;
		case 7: cmd = 0b01111000;	break;
		default:cmd = 0b01000000;	break;
	}	
	//Comando de escrita na CGRAM (cria��o de caratere personalizado)
	EscreveComandoLCD(cmd);
	
	//Escreve cada linha do caractere com a sequencia de valores do buffer
	for(n=0; n<8; n++)
	{
		EscreveCaractereLCD(*buffer);	// escreve caracter no LCD
	    buffer++;	// incrementa apontador
	}
	
	//Comando para sair do modo cria��o de caratere e posicionar cursor
	//na linha 1, coluna 1 da tela.
	EnderecoCursor(0x00);
	
}


