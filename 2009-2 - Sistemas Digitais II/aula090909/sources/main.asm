

					XDEF main


					Include 'qtqy_registers.inc'    ; For the QT1, QT2, QT4, QY1, QY2, QY4

          

DEFAULT_RAM				SECTION SHORT    
VARDELAY:  DS  1
; Place RAM Variables here
 
DEFAULT_ROM				SECTION
main:      
                     LDA #0
                     STA CONFIG2; 3,2 MHZ, SEM IRQ E NEM RESET
                     LDA #$39
                     STA CONFIG1; DESABILITA COP; LVI, STOP E +5V
                   MOV #$80,PTAPUE
                     LDA #$38
                     STA DDRA; PTA5,PTA4 E PTA3 SAIDAS
VERDE: LDA #$20
              STA PORTA                     
                  BSR D1SEG   
         ;ESPERAR 100 MICRO
         
AMARELO: LDA #$10
                    STA PORTA                     
                     BSR D1SEG   
               ;ESPERAR 100 MICRO
               
VERMELHO: LDA #$8
                      STA PORTA
                      BSR D1SEG   
                          ;ESPERAR 100 MICRO                         
                     BRA VERDE
                     
  D1SEG:          LDA #100
                         STA VARDELAY                   
 D10MILI:        LDA #100                    
 D100MICRO: LDX #80
 LOOP0:          DECX
                        BNE LOOP0 
                        DECA
                        BNE D100MICRO
                        DEC VARDELAY
                        BNE D10MILI                   
                         RTS
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     












END  

