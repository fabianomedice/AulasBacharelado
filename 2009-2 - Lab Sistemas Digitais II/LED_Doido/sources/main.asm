					XDEF Entry,main


					Include 'qtqy_registers.inc'    

 

T50MS EQU 31249
DEFAULT_RAM				SECTION SHORT    

DEFAULT_ROM				SECTION 

Entry:
main:
INICIO:
      LDA #00000000B
      STA CONFIG2   
      LDA #00011001B
      STA CONFIG1
      LDA #00110100B
      STA PTAPUE
      
      LDA #$FF
      STA PORTA
      LDA #$34
      STA DDRA
      
      
VERDE:
	  LDA PORTA
	  AND #$04
	  BEQ AMARELO
	  
	  LDA #$8
	  STA PORTA
	  BRA VERDE
	  
AMARELO:

	  LDA #2
	  STA PORTA
	  JSR Dly_1s

VERMELHO:

	  LDA #1
	  STA PORTA
	  JSR Dly_1s
	  BRA VERDE

FICA:	  
	  LDA PORTA
	  AND #$04
	  BEQ FICA
	  
	  BRA VERDE
	  
Dly_1s: LDA #20
Loop0: LDHX #T50MS
Loop1: AIX #-1
		CPHX #0
		BNE Loop1
		DECA
		BNE Loop0
		RTS



END  

