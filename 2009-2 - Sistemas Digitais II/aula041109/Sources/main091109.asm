;

					XDEF main


					Include 'qtqy_registers.inc'    ; For the QT1, QT2, QT4, QY1, QY2, QY4

          

DEFAULT_RAM				SECTION SHORT    

HORA: DS 1
MIN: DS 1
SEG: DS 1
DECEN: DS 1
TEMPO: DS 1
; Place RAM Variables here
CARACTER: DS 1
TEMPO1:  DS 3
AUS: DS 1
AUX: DS 2
BUFFER: DS 32
EBUFFER: DS 2
MEDIAH: DS 1
MEDIABCD: DS 2
MEDIAVOLTS1: DS 2
MEDIAVOLTS2: DS 2

DEFAULT_ROM				SECTION
main:      
                   
                     MOV #$0,CONFIG2 ; HABILITA IRQ COM PULLUP 3,2 MHZ SEM RESET
                    
                     MOV  #$39,CONFIG1
                 
                     MOV #$30,TSC      ; parar e resetar
                     MOV #$46,TSC      ;/64 HABILITA TOF 
                     LDHX #500     ; /500   --> 1INT/SEG
                     STHX TMODH
                     MOV #$09,DDRA;PTA5 VERDE PTA3 VERMELHO
                                    
                     MOV #0,PORTA
                     MOV #$80  ,ADICLK;12500 CONV/SEG
                     MOV #$62,ADSCR ; INT CONTINUA NO PTA4
                     JSR LCD_INIT; LCD MODO 4 BITS
                    
                                           
                    
		    
;@@@@@@@@@@@@@@@@@@ ZERA RAM @@@@@@@@@@@@@@@@@@@@@@@@@@@@
                    LDHX #$0080; INICIO DA RAM
LZERA:
                    CLR ,X
                    INCX
                    BNE LZERA
                    
;@@@@@@@@@@@@@@@@@ INICIALIZA BUFFER COM $FF @@@@@@@@@@@@@@@@@@@2                 
                    LDHX #BUFFER
                    LDA #$FF
LBUFFER:
                    STA ,X
                    AIX #1
                    CPHX #BUFFER+31
                    BNE LBUFFER
 ;@@@@@@@@@@@@@@@@@@  INICIALIZA PONTEIRO DO BUFFER (EBUFFER)@@@@@@@@                    
                     
                     LDHX #BUFFER
                     STHX EBUFFER
                     
  ;@@@@@@@@@@@@@@@@ HORA INICIAL @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  
                                       
                     MOV #$9,HORA
                     MOV #$35,MIN
                  
                    CLI
INICIO:
	                 	LDA SEG
                		ADD #5
                		DAA
                		CMP #$60
                		BCS MOSTRA
                		AND #$0F

 MOSTRA:            PSHA
    		            JSR TELA1
    		            PULA
              	    CMP SEG
              		  BNE MOSTRA
              		  
                	  LDA SEG
                		ADD #5
                		DAA
                		CMP #$60
                		BCS MOSTRA1
                		AND #$0F
MOSTRA1:            PSHA
                		JSR TELA2
                		PULA
                		CMP SEG
                		BNE MOSTRA1
	                	BRA INICIO
;@@@@@@@@@@@@@@@@@@@ TELA 1 @@@@@@@@@@@@@@@@@@@@@@@@@@@@	                	
TELA1:
                    JSR TIRAMEDIA
                    LDA MEDIAH
                    JSR HEXABCD
                    JSR CONVOLTS1
                    JSR CONVOLTS2
                    JSR MOSTRAMEDIA
                    MOV #$2, CARACTER 
                		JSR LCD_GO_TO ;POSICIONA O CURSOR NA POSICAO 2                    
                		LDHX #CURSO
                		JSR VARRELETRAS	
                		MOV #$4C, CARACTER ;POSICIONA O CURSOR NA POSICAO 4C
                		JSR LCD_GO_TO
                		LDA HORA
                		JSR ESCREVE
                		MOV #':',CARACTER
                		BSET 0,PORTA
                		JSR LCD_WRITE
                		LDA MIN
                		JSR ESCREVE
                		MOV #':',CARACTER
                		BSET 0,PORTA
                		JSR LCD_WRITE
                		LDA SEG
                		JSR ESCREVE	
                		RTS                	
                  	
;@@@@@@@@@@@@@@@@@@@@@@@ TELA 2 @@@@@@@@@@@@@@@@@@@@@@@@	                	
	                	
TELA2:
                    JSR TIRAMEDIA
                    LDA MEDIAH
                    JSR HEXABCD
                   JSR CONVOLTS1
                   JSR CONVOLTS2
                    JSR MOSTRAMEDIA
                   	MOV #$7, CARACTER 
                		JSR LCD_GO_TO ;POSICIONA O CURSOR NA POSICAO 8                     
                		LDHX #INSTITUTO
                		JSR VARRELETRAS	
                		MOV #$49, CARACTER ;POSICIONA O CURSOR NA POSICAO 4C
                		JSR LCD_GO_TO
                		LDA HORA
                		JSR ESCREVE
                		MOV #':',CARACTER
                		BSET 0,PORTA
                		JSR LCD_WRITE
                		LDA MIN
                		JSR ESCREVE
                		MOV #':',CARACTER
                		BSET 0,PORTA
                		JSR LCD_WRITE
                		LDA SEG
                		JSR ESCREVE	
                		MOV #':',CARACTER
                		BSET 0,PORTA
                		JSR LCD_WRITE
                		LDA DECEN
                		JSR ESCREVE
                		RTS
  ;@@@@@@@@@@@@@@@@@@@@@@ SOMA BUFFER @@@@@@@@@@@@@@@@@@@@@              	
                	
 TIRAMEDIA:  
                    PSHA
                    PSHX
                    PSHH
                    LDHX #0
                    STHX AUX
                    LDHX #BUFFER
                    LDA ,X
SOMABUFFER2:        ADD ,X
                    BCC CONTMEDIA
                    INC AUX
CONTMEDIA:          AIX #1
                    CPHX #BUFFER+32
                    BNE SOMABUFFER2
                    STA AUX+1
                    
 ;@@@@@@@@@@@@@@@@  DIVIDE POR 32 @@@@@@@@@@@@@@@@@@@@@@@@@                   
MEDIA:              LDX #5
KAMEDIA:            CLC
                    ROR AUX
                    ROR AUX+1
                    DBNZX KAMEDIA
                    MOV AUX+1,MEDIAH  
                    PULH
                    PULX
                    PULA
                    RTS
;@@@@@@@@@@@@@@@@@@@@  CONVERSAO HEXA BYTE PARA BCD @@@@@@@@@@                    
HEXABCD:            LDHX #0
                    STHX AUX     
TIRACEM:            SUB #100         
                    BCS PULCEM
                    INC AUX
                    BRA TIRACEM
PULCEM:             ADD #100
TIRADEZ:            SUB #10
                    BCS PULDEZ
                    PSHA
                    LDA AUX+1
                    ADD #$10  ;ADICIONANDO EM DEZENA
                    DAA           ;CONSERTA PARA DECIMAL
                    STA AUX+1
                    PULA
                    BRA TIRADEZ
PULDEZ:             ADD #10
                    ORA AUX+1
                    STA AUX+1
                    LDHX AUX
                    STHX MEDIABCD
                    RTS                                     
                    
;@@@@@@@@@@@@@@@@@@@@@@@@@ CONVOLTS 1 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

CONVOLTS1:
                     LDA MEDIABCD+1
                     ADD MEDIABCD+1
                     DAA 
                     STA MEDIAVOLTS1+1
                     LDA MEDIABCD                     
                     ADC MEDIABCD
                     STA MEDIAVOLTS1
                     RTS         
;@@@@@@@@@@@@@@@@@@@@@@@@ CONVOLTS2 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CONVOLTS2:
                    LDA MEDIAH
                    LDX #$5
                    MUL
                    PSHX  ; TRANSFERE X PARA O H
                    PULH  ; TRANSFERE X PARA H
                    LDX #$FF
                    DIV
                    STA MEDIAVOLTS2
                    CLRA 
                    DIV  ; O A TEM A PARTE DECIMAL EM HEXA DA LEITURA
;@@@@@@@@@@@@@@@@@@@@ CONVERTE PARTE DECIMAL PARA BCD @@@@@@@@@@@@@@@@@@@                    
                    LDHX #$0
                    STHX AUX
                    PSHA ;0,XY
                    NSA ; YX
                    AND #$0F ; 0X
                    TAX 
LSOMA25:
                    ADD #$25
                    DAA
                    BCC PULA25
                    PSHA 
                    LDA AUX
                    ADD #$1
                    DAA 
                    STA AUX
                    PULA  
PULA25:
                    DBNZX LSOMA25
                    PULA ; XY
                    PSHA
                    AND #$0F ; 0Y
                    TAX
                    
LSOMA39:
                    ADD #$39
                    DAA
                    BCC PULA39
                    PSHA 
                    LDA AUX
                    ADD #$1
                    DAA 
                    STA AUX
                    PULA  
PULA39:
                    DBNZX LSOMA39
                    STA AUX+1
                    PULA ; XY
                    NSA ; YX
                    AND #$0F ; 0X
                    TAX                   
                   LDA AUX
LSOMA6:
                    
                    ADD #$6
                    DAA
                    
                                        
                                        
PULA6:
                    DBNZX LSOMA6                    
                    STA AUX
ARREDONDA:
                    LDA AUX+1
                    AND #$F0
                    CMP #$50
                    BCS SAIR
                    LDA AUX
                    ADD #$1
                    DAA
                    STA AUX
SAIR:
                    MOV AUX, MEDIAVOLTS2+1
                    RTS

;@@@@@@@@@@@@@@@@@@@@@@ MOSTRA MEDIA @@@@@@@@@@@@@@@@@@@@@@@@@@@@
MOSTRAMEDIA:
                    MOV #$40,CARACTER
                    JSR LCD_GO_TO
                    MOV #'$',CARACTER
                    BSET 0,PORTA
                    JSR LCD_WRITE
                    LDA MEDIAH
                    JSR ESCREVE
                    MOV #' ',CARACTER
                    BSET 0,PORTA
                    JSR LCD_WRITE
                    LDA MEDIABCD
                    JSR ESCREVE
                    LDA MEDIABCD+1
                    JSR ESCREVE
                    MOV #' ',CARACTER
                    BSET 0,PORTA
                    JSR LCD_WRITE
                    LDA MEDIAVOLTS1
                    JSR ESCREVE
                    MOV #',',CARACTER
                    BSET 0,PORTA
                    JSR LCD_WRITE
                    LDA MEDIAVOLTS1+1
                    JSR ESCREVE
                    MOV #'V',CARACTER
                    BSET 0,PORTA
                    JSR LCD_WRITE
                    RTS

;@@@@@@@@@@@@@@@@@@@@@@@@ INTERRUPCAO DO RELOGIO @@@@@@@@@@@@@@@@@@
ROTTIMER:
                     PSHA
 ; @@@@@@@@@@@@@@@@@@@ DECIMOS/CENTESIMOS @@@@@@@@@@@@@@@@@@@@                   
                     LDA DECEN
                     ADD #1 
            		     DAA 
            		     STA DECEN
            			   BNE SAIROT
                    
 ;@@@@@@@@@@@@@@@@@@@@  SEGUNDOS @@@@@@@@@@@@@@@@@@@@@@@@                    
                     LDA SEG
                     ADD #1 ; INCA
                     DAA
                     STA SEG
                     CMP #$60
                     BNE SAIROT
                     CLR SEG 
   ;@@@@@@@@@@@@@@@@@@ MINUTOS @@@@@@@@@@@@@@@@@@@@@@@@@                     
                     LDA MIN
                     ADD #1 ; INCA
                     DAA
                     STA MIN
                     CMP #$60
                     BNE SAIROT
                     CLR MIN
                     
  ;@@@@@@@@@@@@@@@@@@ HORAS @@@@@@@@@@@@@@@@@@@@                   
                     LDA HORA
                     ADD #1 ; INCA
                     DAA
                     STA HORA
                     CMP #$24
                     BNE SAIROT
                     CLR HORA  
SAIROT:			         BCLR 7,TSC
                     PULA
		                 RTI
;@@@@@@@@@@@@@@@@@@@ INTERRUPCAO DO CONVERSOR A/D @@@@@@@@@@@@@@			
			
ROTAD:              PSHH        ;4/11/09
                    LDA ADR
                    LDHX EBUFFER
                    STA ,X
                    AIX #1
                    CPHX #BUFFER+31
                    BNE SAIHD
                    LDHX #BUFFER
SAIHD:              STHX EBUFFER
                    PULH
                    RTI			

 ;*******************  ROTINAS LCD ****************                                             			
			; *********************** Escreve uma string no display ******************    
VARRELETRAS: ;IMPRIME UMA FRASE
                   PSHA
VARRE:             LDA ,X
                   CMP #$00
                   BEQ L1			;RETORNE
                   BSET 0,PORTA	;RS=1
                   STA CARACTER		;ESCRITA DE DADO
                   JSR LCD_WRITE
                   AIX #$01
                   BRA VARRE 
L1:                BCLR 0, PORTA	;RS=0
                   PULA
                   RTS    

;************* CONVERTE A= 0N PARA A= (ASCII) **************** 
HEXASC: 
                   AND #$0F
                   CMP #$0A
                   BCC ELETRA
                   ADD #$30
                   BRA SAIF
ELETRA:            ADD #$37
SAIF:              RTS   

; ******** Limpa o display e volta o cursor para a primeira posi��o ********   
LCD_CLR:
                   BCLR 0,PORTA		;RS=0
                   MOV #$01, CARACTER
                   JSR LCD_WRITE
                   JSR D5mseg
                   RTS         
; ********************** Escreve no display no modo 4bits *******************
LCD_WRITE:
;mais significativo   
                   LDA CARACTER  ; XY
                   NSA         ;YX
                   AND #$0F 
                   STA AUS	; 0X
                   LDA PORTB
                	 AND #$F0
                	 ORA AUS 
                   STA PORTB
                   JSR ENABLE   
;menos significativo   
                   LDA CARACTER         ;XY
                   AND #$0F                    ; 0Y
                   STA AUS	; 0Y
                  	LDA PORTB
                  	AND #$F0
                   ORA AUS 
                   STA PORTB
                   JSR ENABLE
                   MOV #$FF,TEMPO1;\
FICOU3:          ; |
FICOU4:            BRN FICOU4; |>DEMORA ~ 250useg     
                   DEC TEMPO1    ; |
                   BNE FICOU3    ;/
                   RTS      
   
;************ Move o cursor para a posi��o desejada vari�vel "CARACTER" **********   
LCD_GO_TO:
                   BCLR 0, PORTA;RS=0
                   LDA CARACTER
                   ADD #$80		;DB7=1 para mover o cursor pelo lcd
                   STA CARACTER
                   JSR LCD_WRITE
                   RTS
;******************** Pulso no enable *****************   
ENABLE:
                   BSET 3, PORTA
                   NOP
                   NOP
                   NOP
                   BCLR 3, PORTA
                   RTS
;*************** Inicializa��o do display no modo 4bits ********************
LCD_INIT:
   BCLR 0, PORTA;RS=0
   JSR D5mseg
   JSR D5mseg
   JSR D5mseg   
   MOV #$03, PORTB
   JSR ENABLE
   JSR D5mseg; DEMORA 5mseg   
   MOV #$03, PORTB
   JSR ENABLE   
   MOV #108, TEMPO;\
FICOU:            ; |
FICOU1:BRN FICOU1 ; |>DEMORA ~100useg     
   DEC TEMPO      ; |
   BNE FICOU      ;/
   MOV #$03, PORTB
   JSR ENABLE   
   JSR D5mseg; DEMORA 5mseg   
   
; RS  R/W DB7 DB6 DB5 DB4
; 0   0   0   0   1  D/L  
;D/L=0' 4bits | D/L=1 ' 8bits
;(#$02)
   
   MOV #$02, PORTB
   JSR ENABLE   
   MOV #8, TEMPO;\   
FICOU2:         ; |    
   JSR D5mseg   ; |> DEMORA ~40mseg
   DEC TEMPO    ; |
   BNE FICOU2   ;/     
   
;Function set:  DL = 0: 4 bit interface
;                N = 1: 2 line display
;                F = 0: 5 x 7 | F=1: 5x10
;                        (#$28) 
;RS  R/W DB7 DB6 DB5 DB4
; 0   0   0   0   1   DL
; 0   0   N   F   -   -       
 
   MOV #$28, CARACTER
   JSR LCD_WRITE   
   

;Display ON/OFF:D = 1: Display ligado
;               C = 0: Cursor desligado
;               B = 0: Cursor sem piscar
;               (#$0C)  
;RS  R/W DB7 DB6 DB5 DB4                
; 0   0   0   0   0   0                  
; 0   0   1   D   C   B  
 
   MOV #$0C, CARACTER
   JSR LCD_WRITE   
   
   JSR LCD_CLR;limpa o lcd e volta o cursor para 1� posi��o

;Entry mode set: I/D = 1: +1 (increment)
;                S = 0: display parado
;                 (#$06)

;RS  R/W DB7 DB6 DB5 DB4 
; 0   0   0   0   0   0   
; 0   0   0   1  I/D  S   

   MOV #$06,CARACTER
   JSR LCD_WRITE
   RTS   
;****************ESCREVE 1BYTE ************************
ESCREVE: ;IMPRIME BYTE EM A NA POSICAO DO CURSOR
                   PSHX
                   PSHA
                   TAX;X=A2A1
                ;mais significativo   
                   NSA;A1A2
                   AND #$0F;0A2
                   JSR HEXASC
                   STA CARACTER
                   BSET 0,PORTA;RS=1
                   JSR LCD_WRITE
                ;menos significativo   
                   TXA;A=A2A1
                   AND #$0F;0A1
                   JSR HEXASC
                   STA CARACTER
                   JSR LCD_WRITE
                   BCLR 0,PORTA;RS=0 "evitar a possibilidade de algum ruido escrever no lcd"
                   PULA
                   PULX
                   RTS 
   
;****** ******delay*******************************  
D5mseg:  MOV #14, TEMPO1
Tgasto1: MOV #$FF, TEMPO1+1
VOLTA0:  DEC TEMPO1+1
        BNE VOLTA0
        DEC TEMPO1
        BNE Tgasto1
        RTS



                  
                  
INSTITUTO: DC.B 'IPUC',$0

CURSO: DC.B   'ENG. MECATRONICA',$0 			          			
                     ORG $FFDE
                     DC.W ROTAD
                     ORG $FFF2
                     DC.W ROTTIMER
 
		                                 
                     
  END