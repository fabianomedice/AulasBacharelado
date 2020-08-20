;

					XDEF main


					Include 'qtqy_registers.inc'    ; For the QT1, QT2, QT4, QY1, QY2, QY4

          

DEFAULT_RAM				SECTION SHORT    
TEMPO: DS 1
STATUSPORTA: DS 1
; Place RAM Variables here
 
DEFAULT_ROM				SECTION
main:      
                   
                     MOV #$40,CONFIG2
                    
                   MOV  #$39,CONFIG1
                 ;  MOV #$80,PTAPUE
                     MOV #$30,TSC
                     MOV #$46,TSC
                     LDHX #50000
                     STHX TMODH
                     MOV #$38,DDRA
                     MOV #0,PORTA
                     MOV #$83,PTAPUE
                     CLR INTSCR
                     CLR TEMPO
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
		BSET 1, INTSCR
		CLI
		 MOV #$10,PORTA
				CLR TEMPO
LPI: 
		LDA TEMPO
		BEQ LPI
				;BSR D1SEG
				MOV #0,PORTA
				CLR TEMPO
LPI2:
		LDA TEMPO
		BEQ LPI2
				;BSR D1SEG
				BRCLR 1,PORTA,SAI;CH1=0 SAI
				BRCLR 0,PORTA,PISCA; CH1=1 E CH0=0 PISCA
				
SAI:	                      BSET 2,INTSCR
				NOP
LANUNCA:		BRN LANUNCA
				NOP
				BCLR 2,INTSCR
		BCLR 1, INTSCR
				RTI

TEMP0:

VERDE:                     
         MOV #$20,PORTA
                
              ; MOV #4,TEMPOSINAL
            CLR TEMPO              
LVERDE:       
              LDA TEMPO
              EOR #4
              BNE LVERDE

; BSR D1SEG   
              
 ;              DBNZ TEMPOSINAL,LVERDE
               
                        
AMARELO:                     
           MOV #$10,PORTA
           CLR TEMPO
 LAMARELO:      
                                 
 
          LDA TEMPO
              EOR #2
              BNE LAMARELO         
           
VERMELHO: 
            MOV #$8,PORTA
              CLR TEMPO
LVERMELHO:      
               LDA TEMPO
              EOR #3
              BNE LVERMELHO
               BRA LERCHAVE     
TEMP1:

VERDE1:                     
         MOV #$20,PORTA
                
          CLR TEMPO
                
LVERDE1:       
		 LDA TEMPO
              EOR #3
              BNE LAMARELO 
               
                        
AMARELO1:                     
           MOV #$10,PORTA
                    
         CLR TEMPO           
LAMARELO1:   
		LDA TEMPO
              EOR #1
              BNE LAMARELO               
VERMELHO1: 
            MOV #$8,PORTA
              CLR TEMPO
LVERMELHO1:    
		LDA TEMPO
              EOR #4
              BNE LAMARELO                                     
                     BRA LERCHAVE
                                          
 PEDESTRE:
 			CLI 
 			 MOV PORTA,STATUSPORTA
                   
                     MOV #8,PORTA
                     CLR TEMPO
 LPE:            
 		LDA TEMPO
 		EOR #4
 		BNE LPE               
                     MOV STATUSPORTA,PORTA
                        
 			RTI
 			
ROTTIMER:
                     INC TEMPO

			BCLR 7,TSC

			RTI 			
 			
                     ORG $FFF2
                     DC.W ROTTIMER
 
 			ORG $FFFA
 			DC.W PEDESTRE
  			ORG $FFFC
  			DC.W PISCA
                     
                     
                     
  END