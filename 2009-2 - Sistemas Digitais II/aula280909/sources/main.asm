

					XDEF main


					Include 'qtqy_registers.inc'    ; For the QT1, QT2, QT4, QY1, QY2, QY4

          

DEFAULT_RAM				SECTION SHORT    
VARDELAY:  DS  1
TEMPOSINAL: DS 1
; Place RAM Variables here
 
DEFAULT_ROM				SECTION
main:      
                   
                     MOV #$40,CONFIG2
                    
                   MOV  #$39,CONFIG1
                 ;  MOV #$80,PTAPUE
                     
                     MOV #$38,DDRA
                     MOV #0,PORTA
                     MOV #$83,PTAPUE

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
                            


PISCA: MOV #$10,PORTA
				BSR D1SEG
				MOV #0,PORTA
				BSR D1SEG
				RTI

TEMP0:

VERDE:                     
         MOV #$20,PORTA
                
               MOV #4,TEMPOSINAL
                
LVERDE:        BSR D1SEG   
               DEC TEMPOSINAL
               BNE LVERDE
               
               
                        
AMARELO:                     
           MOV #$10,PORTA
                    
         MOV #2,TEMPOSINAL           
LAMARELO:    BSR D1SEG   
             DEC TEMPOSINAL
             BNE LAMARELO               
VERMELHO: 
            MOV #$8,PORTA
              MOV #3,TEMPOSINAL
LVERMELHO:     BSR D1SEG   
               DEC TEMPOSINAL
               BNE LVERMELHO                                    
                     BRA LERCHAVE
                    
TEMP1:

VERDE1:                     
         MOV #$20,PORTA
                
               MOV #3,TEMPOSINAL
                
LVERDE1:        BSR D1SEG   
               DEC TEMPOSINAL
               BNE LVERDE1
               
               
                        
AMARELO1:                     
           MOV #$10,PORTA
                    
         MOV #1,TEMPOSINAL           
LAMARELO1:    BSR D1SEG   
             DEC TEMPOSINAL
             BNE LAMARELO1               
VERMELHO1: 
            MOV #$8,PORTA
              MOV #5,TEMPOSINAL
LVERMELHO1:     BSR D1SEG   
               DEC TEMPOSINAL
               BNE LVERMELHO1                                    
                     BRA LERCHAVE
                     
                     
                     
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
                     
 PEDESTRE: 
 
 
 			RTI
 
 
 			ORG $FFFA
 			DC.W PEDESTRE
  			ORG $FFFC
  			DC.W PISCA
                     
                     
                     
  END