;*******************************************************************
;* This stationery serves as the framework for a user application. *
;* For a more comprehensive program that demonstrates the more     *
;* advanced functionality of this processor, please see the        *
;* demonstration applications, located in the examples             *
;* subdirectory of the "Freescale CodeWarrior for HC08" program    *
;* directory.                                                      *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'

; export symbols
            XDEF _Startup, main
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on

            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
 CARACTER: DS 1
 HORA: DS 1
 MIN: DS 1
 SEG: DS 1
 DECN: DS 1
  DIVISOR: DS 1
 
 
; code section
MyCode:     SECTION
main:
_Startup:
          ;  LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
           ; TXS
         ;   CLI                     ; enable interrupts

mainLoop:
            ; Insert your code here
           MOV #$ 39, CONFIG1
           MOV #$0, CONFIG2
           MOV #$30, TSC
           MOV #$44, TSC
           LDHX #100
           STHX THODH
           MOV #$5A, TSC0
           MOV #20, DIVISOR
;@@@@@@@@@@@@@@@@@@@@@@@@ INTERRUPCAO DO RELOGIO @@@@@@@@@@@@@@@@@@
ROTTIMER:
                   DEC  DIVISOR
                   BNE SAIROT
                   MOV #$20, DIVISOR
                   
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
                         RTI

           
           
            feed_watchdog
            BRA    mainLoop
