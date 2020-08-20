;

					XDEF main


					Include 'qtqy_registers.inc'    ; For the QT1, QT2, QT4, QY1, QY2, QY4

          

DEFAULT_RAM				SECTION SHORT    

HORA: DS 1
MIN: DS 1
SEG: DS 1
TEMPO: DS 1
STATUSPORTA: DS 1
; Place RAM Variables here
 
DEFAULT_ROM				SECTION
main:      
                   
                     MOV #$40,CONFIG2 ; HABILITA IRQ COM PULLUP 3,2 MHZ SEM RESET
                    
                   MOV  #$39,CONFIG1
                 
                     MOV #$30,TSC      ; parar e resetar
                     MOV #$46,TSC      ;/64 HABILITA TOF 
                     LDHX #50000     ; /50000   --> 1INT/SEG
                     STHX TMODH
                     MOV #$28,DDRA;PTA5 VERDE PTA3 VERMELHO
                     MOV #0,PORTA
                     MOV #$3,PTAPUE; PULLUP EM PTA1 E PTA0
                     CLR INTSCR   ; HABILTA LOCAL (IMASK1=0) NA TRANSIÇÃO DE DESCIDA, SEM PULSO NO ACK 
                  
                     LDHX #$0080; INICIO DA RAM

LZERA:
                    CLR ,X
                    INCX
                    BNE LZERA
                  
                     MOV #$9,HORA
                     MOV #$35,MIN
                  
                  
                  
                     CLI

LERCHAVE: 
          LDA HORA
          CMP #$22
          BNE KAA
          LDA MIN
          CMP #$30
          BCC PISCAAMARELO; DESVIA SE FOR MAIOR OU IGUAL A 30
          
 KAA:         
          LDA PORTA
          AND #3
          BEQ TEMP0
           CMP #1
           BEQ TEMP1
           CMP #2
           BEQ FIXAVERMELHO     
          
          
          
         ; BEQ TEMP0
         ; DECA
         ; BEQ TEMP1
         ; DECA
         ; BEQ PISCAAMARELO
FIXAVERDE: MOV #$20,PORTA
			BRA LERCHAVE

FIXAVERMELHO: MOV #$8, PORTA
                                BRA LERCHAVE
			
PISCAAMARELO: SWI
                            BRA LERCHAVE
                            


PISCA:
		BSET 1, INTSCR
		CLI
		 MOV #$28,PORTA
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
				
				LDA HORA
				CMP #$6
				BNE PISCA
				LDA MIN
				CMP #$5
				BCS PISCA
				
				;BSR D1SEG
				;BRCLR 1,PORTA,SAI;CH1=0 SAI
				;BRCLR 0,PORTA,PISCA; CH1=1 E CH0=0 PISCA
				
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
            MOV #$4, TEMPO              
LVERDE:       
              LDA TEMPO
              BNE LVERDE

; BSR D1SEG   
              
 ;              DBNZ TEMPOSINAL,LVERDE
               
                        
AMARELO:                     
           MOV #$28,PORTA
           MOV #$2, TEMPO
 LAMARELO:      
                                 
 
          LDA TEMPO
              BNE LAMARELO         
           
VERMELHO: 
            MOV #$8,PORTA
              MOV #$3, TEMPO
LVERMELHO:      
               LDA TEMPO
               BNE LVERMELHO
               BRA LERCHAVE     
TEMP1:

VERDE1:                     
         MOV #$20,PORTA
                
          MOV #$3, TEMPO
                
LVERDE1:       
		 LDA TEMPO
          BNE LAMARELO 
               
                        
AMARELO1:                     
           MOV #$28,PORTA
                    
         MOV #1, TEMPO           
LAMARELO1:   
		LDA TEMPO
        BNE LAMARELO               
VERMELHO1: 
            MOV #$8,PORTA
             MOV #$4, TEMPO
LVERMELHO1:    
		LDA TEMPO
                  BNE LAMARELO                                     
                     JMP LERCHAVE
                                          
 PEDESTRE:
 			CLI 
 			 MOV PORTA,STATUSPORTA
                   
                     MOV #8,PORTA
                     MOV #$4, TEMPO
 LPE:            
 		LDA TEMPO
 		BNE LPE               
                     MOV STATUSPORTA,PORTA
                        
 			RTI
 			
ROTTIMER:
                     DEC TEMPO
                     
                     
                     LDA SEG
                     ADD #1 ; INCA
                     DAA
                     STA SEG
                     CMP #$60
                     BNE SAIROT
                     CLR SEG 
                        
                        LDA MIN
                     ADD #1 ; INCA
                     DAA
                     STA MIN
                     CMP #$60
                     BNE SAIROT
                     CLR MIN
                     
                     
                      LDA HORA
                     ADD #1 ; INCA
                     DAA
                     STA HORA
                     CMP #$24
                     BNE SAIROT
                     CLR HORA  
SAIROT:			BCLR 7,TSC

			RTI 			
 			
                     ORG $FFF2
                     DC.W ROTTIMER
 
 			ORG $FFFA
 			DC.W PEDESTRE
  			ORG $FFFC
  			DC.W PISCA
                     
                     
                     
  END