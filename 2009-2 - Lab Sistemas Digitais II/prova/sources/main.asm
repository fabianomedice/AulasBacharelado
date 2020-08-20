

					XDEF Entry,main


					Include 'qtqy_registers.inc'    ; For the QT1, QT2, QT4, QY1, QY2, QY4


DEFAULT_RAM				SECTION SHORT    

; Place RAM Variables here

AUX: DS 1
TEMPO: DS 1
PORT: DS 1
DEFAULT_ROM				SECTION


Entry:
main:
     MOV #$00,CONFIG2
     MOV #$39,CONFIG1
     MOV #$00,DDRA ;TUDO COMO ENTRADA
     MOV #$FF,DDRB ;TUDO COMO SAIDA
     MOV #$3F,PTAPUE ;TUDO COM PULL UP
     
     MOV #$0,AUX
     
inicio:    		
		        LDA PORTA
		        STA PORT
		        BRSET 0,PORT,crescente ;vai para a rotina crescente se bit 0 = 1
		        BRSET 1,PORT,diminui ;vai para a rotina decrescente se bit 1 = 1		        

fica:			BRA delay		        
		        
crescente:
				BRSET 1,PORTA,reset ;ambos selecionado

				;MOV AUX,PORTB
				LDA AUX
				STA PORTB
				INC AUX
				LDA AUX
				CBEQA #$08,reset
				
				BRA delay
				
diminui:		
				LDA AUX
				CBEQA #$0,diminui2
				DEC AUX
				;MOV AUX, PORTB
				LDA AUX
				STA PORTB
				
diminui2:		MOV #$7,AUX
				;MOV AUX, PORTB
				LDA AUX
				STA PORTB
				BRA delay				
				
reset:			MOV #$00,AUX
     			BRA delay

delay:
D1SEG:          LDA #100
                STA TEMPO                   
D10MILI:        LDA #100                    
D100MICRO:      LDX #80
LOOP0:          DBNZX LOOP0
                       
                DBNZA D100MICRO
                        
                DBNZ TEMPO, D10MILI
                       
                BRA inicio
                         
				END                         
