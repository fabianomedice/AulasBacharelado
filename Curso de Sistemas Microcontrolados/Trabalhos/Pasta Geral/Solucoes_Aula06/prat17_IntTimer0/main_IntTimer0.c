/******************************************************************************
 *
 *            SEMPRA PROJETOS PLACA E-P18 (PIC18F4550)
 *
 ******************************************************************************
 * Nome do Arquivo:		main_interrupTimer0.c
 * Dependencias:		Veja a seção INCLUDES abaixo
 * Microcontrolador:	PIC18F4550
 * Opção de Clock:		HS 20MHz (externo) - CPU:48MHz (interno)
 * Compilador:			C18 v3.37 ou superior
 * Empresa:				SEMPRA
 * Plataforma:			Placa E-P18 v3.6
 * Autor:				SEMPRA
 * Versão:				v1.0
 * Descrição:	Prática 17: Interrupção de Overflow do Timer0
 *		Usar a interrupção de overflow do Timer0 para ser a base
 *	de tempo para piscar o LED_VERDE. 
 *		O Timer0 deve estourar a cada 100ms e sua interrupção deve tratada 
 *	dentro da ISR do vetor de alta prioridade.
 *		Essa tarefa deve ocorrer independente do contador que apresenta
 *	valores no display de 7 segmentos.
 *****************************************************************************/

/** I N C L U D E S **********************************************************/
#include <p18cxxx.h>	// Necessário para que o compilador adicione a biblioteca
						// com as definições do PIC selecionado no projeto, neste
						// caso, o modelo 18F4550.

#include <delays.h>		//Biblioteca C18 com funções de Delay

#include <timers.h>		//Biblioteca C18 com funções de Timer

#include "display7seg.h"	// Biblioteca com funções do Display de 7 segmentos


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

// Valor inicial do Timer0 para contar 100ms
#define INICIO_TIMER0	28036


/** V A R I A V E I S   G L O B A I S ****************************************/


/**  P R O T O T I P O S   P R I V A D O S ***********************************/
void ConfiguraSistema(void);
void TocaBuzina(void);


/**  P R O T O T I P O S   D A S   F U N Ç Õ E S   D E   I N T E R R U P Ç Ã O*/
void ConfiguraInterrupcao(void);
void Tratamento_High_Interrupt(void);
void Tratamento_Low_Interrupt(void);


/** F U N C O E S ************************************************************/

/******************************************************************************
 * Funcao:		void main(void)
 * Entrada:		Nenhuma (void)
 * Saída:		Nenhuma (void)
 * Descrição:	Função principal do programa.
 *****************************************************************************/
void main(void)
{
	char cont = 0;	// Armazena o valor da contagem de tempo do cronometro

	//Função que faz configurações do firmware
	ConfiguraSistema();
	
	//Escolhe estado inicial das saidas digitais
	LED_VERDE = 0;
	LED_AMARELO = 0;
	LED_VERMELHO = 0;
	BUZZER = 0;
	RELE = 0;
	
	// Habilita vetores de Alta e Baixa Prioridade
	INTCONbits.GIEH = 1;
	INTCONbits.GIEL = 1;
	
	// Laço de repetição infinito que executa aplicação do firmware
	while(1)
	{
		//Escreve o valor de contador no display de 7 segmentos		
		EscreveDisplay7seg(cont, PONTO_NENHUM);

		// Atraso de 100ms
		Delay10KTCYx(120);
		
		// Se contador menor que 99 conta mais um, senão volta a zero.
		if(cont<99)
		{
			cont++;	//incrementa contador: cont = cont + 1;
		}
		else
		{
			cont = 0;
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

	//Configura Display 7 segmentos
	ConfiguraDisplay7seg();
	
	// Sobre-escreve pino RB4 como entrada digital, após ConfiguraDisplay7seg()
	//te-lo configurado como saida digital para o ponto decimal.
	TRISBbits.TRISB4 = 1; 	//Configura pino RE2 (BOTAO_BOOT) como entrada digital
	
	// Função que configura as interrupções do firmware
	ConfiguraInterrupcao();
	
	OpenTimer0(	TIMER_INT_ON &	// Habilita Interrupção do Timer0
				T0_16BIT	 &	// Contagem do Timer0 com 16bits
				T0_SOURCE_INT&	// Fonte de clock interno
				T0_PS_1_32);	// Prescaler 1:32
				
	//Carrega valor inicial do Timer0
	WriteTimer0(INICIO_TIMER0);

}//end ConfiguraSistema


/******************************************************************************
 * Funcao:		void ConfiguraInterrupcao(void)
 * Entrada:		Nenhuma (void)
 * Saída:		Nenhuma (void)
 * Descrição:	Função que configura as interrupções utilizadas no projeto
 *****************************************************************************/
void ConfiguraInterrupcao(void)
{
	//Configuração Global das Interrupções
	RCONbits.IPEN = 1;		// Habilita prioridades de interrupcao
	INTCONbits.GIEH = 0;	// Desabilita vetor de alta prioridade
	INTCONbits.GIEL = 0;	// Desabilita vetor de baixa prioridade

	//Configurações da Interrupção de RB (PORTB4:7)	
	INTCONbits.RBIE = 1;	// Habilita interrupcao de RB (PORTB4:7)
	INTCONbits.RBIF = 0;	// Limpa a sinalização da  interrupcao,
							//para garantir que nao entra na interrupcao 
							//por sujeira na memoria
	INTCON2bits.RBIP = 0;	// Tratamento de interrupcao no vetor de Baixa prioridade
	INTCON2bits.RBPU = 1;	// Desabilita os resistores de pull-up internos
							//do PORTB

	//Configurações da Interrupção do Timer0
	INTCONbits.TMR0IE = 1;	// Habilita interrupcao de Timer0
	INTCONbits.TMR0IF = 0;	// Limpa a sinalização da interrupcao,
							//para garantir que nao entra na interrupcao 
							//por sujeira na memoria
	INTCON2bits.TMR0IP = 1;	// Tratamento de interrupcao no vetor de Alta prioridade

}// end ConfiguraInterrupcao

/******************************************************************************
 * Funcao:		void Tratamento_High_Interrupt(void)
 * Entrada:		Nenhuma (void)
 * Saída:		Nenhuma (void)
 * Descrição:	Função de tratamento das interrupções de ALTA prioridade
 *		Nessa função deve-se lembrar de fazer a seguinte lista:
 *			1- verificar qual foi a causa da interrupção, comparando 
 *		os flags de cada tipo de interrupção.
 *			2- tratar a interrupção selecionada.
 *			3- limpar o flag que causou a interrupção!!! Importante 
 *		para garantir que não ocorrerá uma chamada indesejada ao sair 
 *		do tratamento da interrupção.
 *
 *		Ao sair dessa função é usado o retorno do tipo "retfie fast",
 *		pois esta função é declarada como ALTA prioridade com a diretiva
 *		#pragma interrupt
 *****************************************************************************/
// ATENÇÃO NA SINTAXE de declaração com #pragma interrupt = Alta prioridade
#pragma interrupt Tratamento_High_Interrupt
void Tratamento_High_Interrupt(void)
{
	// Verifica se o motivo da chamada da interrupção foi 
	//estouro do Timer0
	if(INTCONbits.TMR0IF)
	{
		// Re-escreve o valor inicial da contagem do Timer0
		WriteTimer0(INICIO_TIMER0);	
		
		// Inverte estado do LED_VERDE (Toggle)
		LED_VERDE = !LED_VERDE;
		
		//Limpa flag da interrupção
		INTCONbits.TMR0IF = 0;		     
	}// end tratamento da interrupção do Timer0 (INTCONbits.TMR0IF)

}// end Tratamento_High_Interrupt

/******************************************************************************
 * Funcao:		void Tratamento_Low_Interrupt(void)
 * Entrada:		Nenhuma (void)
 * Saída:		Nenhuma (void)
 * Descrição:	Função de tratamento das interrupções de BAIXA prioridade
 *		Nessa função deve-se lembrar de fazer a seguinte lista:
 *			1- verificar qual foi a causa da interrupção, comparando 
 *		os flags de cada tipo de interrupção.
 *			2- tratar a interrupção selecionada.
 *			3- limpar o flag que causou a interrupção!!! Importante 
 *		para garantir que não ocorrerá uma chamada indesejada ao sair 
 *		do tratamento da interrupção.
 *
 *		Ao sair dessa função é usado o retorno do tipo "retfie",
 *		pois esta função é declarada como BAIXA prioridade com a diretiva
 *		#pragma interruptlow
 *****************************************************************************/
// ATENÇÃO NA SINTAXE de declaração com #pragma interruptlow = Baixa prioridade
#pragma interruptlow Tratamento_Low_Interrupt
void Tratamento_Low_Interrupt(void)
{
	// Verifica se o motivo da chamada da interrupção foi mudança 
	//de estado no PORTB
	if(INTCONbits.RBIF)
	{
		// Variavel temporaria, usada para corrigir erro na Note1 p101 do Datasheet
		// do PIC18F4550 revE. Nesta nota informa que para evitar falha na 
		// limpeza do flag RBIF, deve-se fazer uma leitura do PORTB pelo menos
		// 1TCY antes de limpar o flag!
		char temp;
		
		// A função Toca_Buzina funciona como um debouncer para o BOTAO_BOOT,
		// já que ela tem delay ~ 240ms!
		TocaBuzina();
 		
		// Leitura do PORTB para corrigir erro de limpeza do flag RBIF
		temp = PORTB;
		
		// Inverte estado do LED_AMARELO (Toggle)
		LED_AMARELO = !(LED_AMARELO);
		
		//Limpa flag da interrupção do PORTB
		INTCONbits.RBIF = 0;		     		
	}// end tratamento da interrupção do PORTB (INTCONbits.RBIF)


}//end Tratamento_Low_Interrupt


/******************************************************************************
 * Funcao:		void TocaBuzina(void)
 * Entrada:		Nenhuma (void)
 * Saída:		Nenhuma (void)
 * Descrição:	Aciona o buzzer (RC1) com dois bip's curtos	
 *****************************************************************************/
void TocaBuzina(void)
{
	BUZZER=0;			// desliga BUZZER
	BUZZER=1;			// liga BUZZER
	Delay10KTCYx(100);	// espera 83ms
	BUZZER=0;			// desliga BUZZER
	Delay10KTCYx(100);	// espera 83ms
	BUZZER=1;			// liga BUZZER
	Delay10KTCYx(100);	// espera 83ms
	BUZZER=0;			// desliga BUZZER
}


/** V E C T O R   R E M A P P I N G ******************************************/
// Seção necessária para informar ao compilador C18 onde são os novos endereços
//da memória de programa que ele deve alocar as rotinas de tratamento do "reset"
//do microcontrolador e das rotinas de tratamento de interrupção.

//
// ATENÇÃO: Copiar esta parte do código dentro do arquivo "main.c" dos
// projetos usados com o Bootloader USB-HID para gravação in-circuit.

// protótipo usado pelo compilador C18
extern void _startup (void);        // See c018i.c in your C18 compiler dir

// Alocação da função de tratamento do "reset" da aplicação principal 
// no endereço 0x1000 da memória de programa
#pragma code REMAPPED_RESET_VECTOR = 0x1000
void _reset (void)
{
    _asm goto _startup _endasm
}

// Alocação da função de tratamento das interrupções de ALTA prioridade
// no endereço 0x1008 da memória de programa.
// 
#pragma code REMAPPED_HIGH_INTERRUPT_VECTOR = 0x1008
void _high_ISR (void)
{
    _asm goto Tratamento_High_Interrupt _endasm
}

// Alocação da função de tratamento das interrupções de BAIXA prioridade 
// no endereço 0x1018 da memória de programa
#pragma code REMAPPED_LOW_INTERRUPT_VECTOR = 0x1018
void _low_ISR (void)
{
    _asm goto Tratamento_Low_Interrupt _endasm
}

#pragma code	// Diretiva que retorna a alocação dos endereços 
				// da memória de programa para seus valores padrão

/** F I M  D A  S E Ç Ã O  D E   V E C T O R   R E M A P P I N G *************/

/** EOF main.c ***************************************************************/
