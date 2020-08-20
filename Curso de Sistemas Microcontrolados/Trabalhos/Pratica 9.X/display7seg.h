/******************************************************************************
 *
 *            Curso SEMPRA de Microcontroladores (PIC18F4550)
 *
 ******************************************************************************
 * Nome do Arquivo:     display7seg.h
 * Dependencias:    	Veja se��o INCLUDES
 * Processador:       	PIC18F4550
 * Op��o de Clock:		HS 20MHz (externo) - CPU: 48MHz	
 * Compilador:        	C18 v3.20 ou superior
 * Empresa:         	SEMPRA - Axoon - UFMG
 *
 * Plataforma:			E-P18 v3.5, v3.6
 *
 * Autor:				M.Sc. Henrique Resende Martins
 * 						Mauricio Ferrari Santos Corr�a
 *						Bruno Silveira Avelar
 *
 * Revis�o:				v1 - 16/Fev/2009 - M.Sc. Henrique Resende Martins
 *						v2 - 27/Abr/2009 - Mauricio Ferrari Santos Corr�a
 *						v3 - 29/Out/2009 - Mauricio Ferrari Santos Corr�a
 *						v4 - 21/jan/2010 - Mauricio Ferrari Santos Corr�a
 *						v5 - 28/fev/2010 - Bruno Silveira Avelar
 *						v6 - 30/abr/2010 - Mauricio Ferrari Santos Corr�a
 *						v7 - 24/set/2010 - Mauricio Ferrari Santos Corr�a
 *						v8 - 16/nov/2010 - Bruno Silveira Avelar, Mauricio Ferrari Santos Corr�a
 *						v9 - 19/jan/2011 - Mauricio Ferrari Santos Corr�a
 *						v10- 04/Out/2011 - Mauricio Ferrari Santos Corr�a
 *
 * Descri��o:        	Biblioteca de fun��es para escrever no display duplo
 *						de 7 segmentos da placa de desenvolvimento E-P18.
 *						O display duplo � do tipo ANODO COMUM e seus segmentos 
 *						s�o LIGADOS com nivel l�gico ZERO.
 *						O display apresenta 2 dois digitos e seus respectivos
 *						pontos decimais.
 *						Nesta biblioteca usa-se os r�tulos:
 *						D1 - digito mais significativo
 *						D2 - digito menos significativo
 *						p1 - ponto decimal do digito mais significativo
 *						p2 - ponto decimal do digito mais significativo
 *
 *						Nomes usados para os segmentos do display duplo presente
 *						na placa E-P18:
 * 
 *						D1: Digito mais			D2: Digito menos
 *					    significativo		    significativo
 *						  ---a1---  			 ---a2---  
 *						 |        |				|        |	
 *						 f1       b1			f2       b2
 *						 |        |				|        |
 *						  ---g1--- 				 ---g2--- 
 *						 |        |				|        |
 *						 e1       c1			e2       c2
 *						 |        |				|        |
 *						  ---d1---  .p1			 ---d2---  .p2
 *						 
 *
 *****************************************************************************/
#ifndef __DISPLAY7SEG_H
#define __DISPLAY7SEG_H

/** I N C L U D E S **********************************************************/
#include <p18cxxx.h>	// Biblioteca com as defini��es do PIC selecionado 
						//no projeto, neste caso, o modelo 18F4550.

/** D E F I N E S ************************************************************/

// Define os pinos do display de 7 seg que est�o ligados nas portas do PIC18F4550
// LEMBRANDO QUE O DISPLAY � DO TIPO ANODO COMUM e para cada segmento:
//			0: LIGADO
//			1: desligado

// Digito mais significativo
#define Display_a1 	LATDbits.LATD5
#define Display_b1 	LATDbits.LATD4
#define Display_c1 	LATBbits.LATB5
#define Display_d1 	LATBbits.LATB6
#define Display_e1 	LATBbits.LATB7
#define Display_f1 	LATDbits.LATD7
#define Display_g1 	LATDbits.LATD6
#define Display_p1 	LATBbits.LATB4

#define TRIS_a1 	TRISDbits.TRISD5
#define TRIS_b1 	TRISDbits.TRISD4
#define TRIS_c1 	TRISBbits.TRISB5
#define TRIS_d1 	TRISBbits.TRISB6
#define TRIS_e1 	TRISBbits.TRISB7
#define TRIS_f1 	TRISDbits.TRISD7
#define TRIS_g1 	TRISDbits.TRISD6
#define TRIS_p1 	TRISBbits.TRISB4

// Digito menos significativo
#define Display_a2 	LATCbits.LATC6
#define Display_b2 	LATDbits.LATD2
#define Display_c2 	LATBbits.LATB0
#define Display_d2 	LATBbits.LATB2
#define Display_e2 	LATBbits.LATB3
#define Display_f2 	LATCbits.LATC7
#define Display_g2 	LATBbits.LATB1
#define Display_p2 	LATDbits.LATD3

#define TRIS_a2 	TRISCbits.TRISC6
#define TRIS_b2 	TRISDbits.TRISD2
#define TRIS_c2 	TRISBbits.TRISB0
#define TRIS_d2 	TRISBbits.TRISB2
#define TRIS_e2 	TRISBbits.TRISB3
#define TRIS_f2 	TRISCbits.TRISC7
#define TRIS_g2 	TRISBbits.TRISB1
#define TRIS_p2		TRISDbits.TRISD3

// defines para habilita��o dos pontos decimais
#define PONTO_NENHUM   0x00	//Desliga ambos pontos decimais
#define PONTO_DIREITA  0x01	//Liga ponto decimal do digito 2 (� direita)
#define PONTO_ESQUERDA 0x02	//Liga ponto decimal do digito 1 (� esquerda)
#define PONTO_AMBOS    0x03	//Liga ambos pontos decimais


/** P R O T O T I P O S *******************************************************/

/******************************************************************************
 * Funcao:        	void ConfiguraDisplay7seg (void)
 * Entrada:         Nenhuma (void)
 * Sa�da:          	Nenhuma (void)
 * Descri��o:       Configura portas do PIC 18F4550 que est�o conectadas ao 
 *					display duplo de 7 segmentos como saida. 
 *					Desliga todos os segmentos do display apos a configura��o
 *
 *****************************************************************************/
 extern void ConfiguraDisplay7seg (void);

/******************************************************************************
 * Funcao:		void EscreveDisplay7seg(unsigned char valor, unsigned char ponto)
 * 
 * Entrada:		unsigned char valor: valor decimal de 0 a 99 a ser apresentado
 *					no display de 7 segmentos. Se esse valor estiver acima
 *					de 99 ser� mostrado o simbolo de erro --.
 *
 *				unsigned char ponto: valor correspondente a configura��o dos 
 *					pontos decimais. Use os #define para facilitar a configura��o
 *						PONTO_NENHUM:	Desliga ambos pontos decimais.
 *						PONTO_ESQUERDA:	Liga ponto decimal da esquerda.
 *						PONTO_AMBOS:	Liga ambos pontos decimais.
 *					    PONTO_DIREITA:	Liga o ponto decimal da direita.
 * 
 * Sa�da:       Nenhuma (void)
 * Descri��o:   Escreve valor decimal de 00 a 99 nos display's de 7 segmentos.
 *				Liga/desliga os pontos decimais.
 *
 *****************************************************************************/
 extern void EscreveDisplay7seg(unsigned char valor, unsigned char ponto);

#endif
