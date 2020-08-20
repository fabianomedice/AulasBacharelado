

					XDEF main


					Include 'qtqy_registers.inc'    ; For the QT1, QT2, QT4, QY1, QY2, QY4

          

DEFAULT_RAM				SECTION SHORT    
VARDELAY:  DS  1
TEMPOSINAL: DS 1
STATUSTEMPO: DS 1
STATUSPORTA: DS 1
; Place RAM Variables here
 
DEFAULT_ROM				SECTION
main:      
                   
                     MOV #$40,CONFIG2
                    
                   MOV  #$39,CONFIG1
                 ;  MOV #$80,PTAPUE
                     
                     MOV #$38,DDRA
                     MOV #0,PORTA
                     MOV #$83,PTAPUE
			CLR INTSCR ; HABILITA LOCAL  IRQ NA TRANSICAO
			CLI 

LERCHAVE: LDA PORTA
          AND #3
          BEQ TEMP0
          DECA
          BEQ TEMP1
          DECA
          BEQ PISCAAMARELO
FIXAVERDE: MOV #$20,PORTA
			BRA LERCHAVE
			
PISCAAMARELO: SWI
                            BRA LERCHAVE
                            


PISCA: 
				
				MOV #$10,PORTA
				BSR D1SEG
				MOV #0,PORTA
				BSR D1SEG
				BRSET 0, PORTA, SAI ; SE CH0 = 1 SAI
				BRSET 1, PORTA, PISCA ; SE CH1CH0 = 10 PISCA
SAI:
				BSET 2, INTSCR 
				NOP
				NOP
				BCLR 2, INTSCR


				RTI

TEMP0:

VERDE:                     
         MOV #$20,PORTA
                
               MOV #4,TEMPOSINAL
                
LVERDE:        BSR D1SEG   
               DBNZ TEMPOSINAL, LVERDE
               
               
                        
AMARELO:                     
           MOV #$10,PORTA
                    
         MOV #2,TEMPOSINAL           
LAMARELO:    BSR D1SEG   
             DBNZ TEMPOSINAL, LAMARELO
            
VERMELHO: 
            MOV #$8,PORTA
              MOV #3,TEMPOSINAL
LVERMELHO:     BSR D1SEG   
               DBNZ TEMPOSINAL, LVERMELHO        
                     BRA LERCHAVE
                    
TEMP1:

VERDE1:                     
         MOV #$20,PORTA
                
               MOV #3,TEMPOSINAL
                
LVERDE1:        BSR D1SEG   
               DBNZ TEMPOSINAL, LVERDE1
               
               
                        
AMARELO1:                     
           MOV #$10,PORTA
                    
         MOV #1,TEMPOSINAL           
LAMARELO1:    BSR D1SEG   
             DBNZ TEMPOSINAL, LAMARELO1
                            
VERMELHO1: 
            MOV #$8,PORTA
              MOV #5,TEMPOSINAL
LVERMELHO1:     BSR D1SEG   
               DBNZ TEMPOSINAL, LVERMELHO1
                                                 
                     BRA LERCHAVE
                     
                     
                     
 D1SEG:          LDA #100
                         STA VARDELAY                   
 D10MILI:        LDA #100                    
 D100MICRO: LDX #107
 LOOP0:          DBNZX LOOP0
                       
                        DBNZA D100MICRO
                        
                        DBNZ VARDELAY, D10MILI
                       
                         RTS
                     
 PEDESTRE: 
 			MOV PORTA, STATUSPORTA
 			MOV TEMPOSINAL, STATUSTEMPO
 			MOV #08, PORTA
 			MOV #03, TEMPOSINAL
			
 LPE: 		BSR D1SEG
 			DBNZ TEMPOSINAL, LPE
 			MOV STATUSTEMPO, TEMPOSINAL
 			MOV STATUSPORTA, PORTA
 
 			RTI
 
 
 			ORG $FFFA
 			DC.W PEDESTRE
  			ORG $FFFC
  			DC.W PISCA
                     
                     
                     
  END