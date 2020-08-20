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

AUX: DS 1 ;variavel auxiliar para saida de clock

; code section
MyCode:     SECTION
main:
_Startup:
            ;LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
            ;TXS
            ;CLI                     ; enable interrupts

mainLoop:
            ; Insert your code here
            
            
            
            ; começo do programa
            
            ;configuracao do microcontrolador
            MOV #$33,DDRA ;pta5,pta4,pta1,pta0 como output e pta3,pta2 como input
            MOV #$00,DDRB ;todos como input
            MOV #$8C,PTAPUE ;pta1 com resistor de pull up
            MOV #$FF,PTBPUE ;ptb3 e ptb2 com resistor de pull up
            MOV #$00,CONFIG2 ;IRQ desahabilitado
            MOV #$3B,CONFIG1 ;5V , STOP ativado  (conferir se o sensor precisa de voltagem baixa ou n pq se n ativar o LVI)
            MOV #$00,OSCSC ;oscilador interno com frequencia de 4MHz (1 micro segundos)
            MOV #$00,AUX ;zera a variavel AUX e começa pelo default
            
            ; controle das ruas            
            
control:    BRSET 0,AUX,positivo ;carp 1
control1:   BRSET 4,AUX,negativo ;carp 0 e cari 1 ,vai para negativo para testar as velocidades
zero:       BRSET 1,AUX,zero1; carp 0 e cari 0, velp 1
            BRSET 5,AUX,velmenos ;carp 0 e cari 0, velp 0 e veli 1, vai para vel-
            ;carp 0 e cari 0, velp 0 e veli 0
defaultmais:;default+
            BSET 5,PTA       
            BSET 1,PTA
            BSET 0,PTA
            
            BRA zeradora

zero1:      BRSET 5,AUX,defaultmais;velp 1 e veli 1, vai para default
            ;vel+
            BSET 5,PTA         
            BCLR 1,PTA
            BSET 0,PTA
            
            BRA zeradora

velmenos:   ;vel-            
            BCLR 5,PTA
            BSET 1,PTA
            BCLR 0,PTA
            
            BRA zeradora

positivo:   BRSET 4,AUX,zero ;carp 1 e cari 1, vai para preparar zero para testar as velocidades
            BRSET 1,AUX,positivo1; carp 1 e cari 0, velp 1
carmais:    ;car+
            BSET 5,PTA         
            BCLR 1,PTA
            BCLR 0,PTA
            
            BRA zeradora
            
positivo1:  BRSET 5,AUX,carmais ;carp 1 e cari 0, velp 1 e veli 1
            ;car+vel+           
            BSET 5,PTA          
            BSET 1,PTA
            BCLR 0,PTA
            
            BRA zeradora

negativo:   BRSET 5,AUX,negativo1; carp 0 e cari 1, veli 1            
carmenos:   ;car-
            BCLR 5,PTA
            BSET 1,PTA
            BSET 0,PTA
            
            BRA zeradora
            
negativo1:  BRSET 1,AUX,carmenos ;carp 0 e cari 1, velp 1 e veli 1
            ;car-vel-     
            BCLR 5,PTA
            BCLR 1,PTA
            BSET 0,PTA
            
            
zeradora:   MOV #$00,AUX ;zera a variavel AUX
            ; controle do numero de carros

car:        LDA PTA ;carrega o acumulador A com a porta A
            AND #$0C ;seleciona apenas as entradas para o numero de carros
            CBEQA #$8,carp ;compara com 10
            CBEQA #$4,cari ;compara com 01
            CBEQA #$C,car1 ;compara com 11
                        
            ; controle da velocidade dos carros
            
vel:        LDA PTB ;carrega o acumulador A com a porta B
            AND #$C0
            CBEQA #$C0,velp ;compara com rua 4
            LDA PTB ;carrega o acumulador A com a porta B
            AND #$0C
            CBEQA #$0C,velp ;compara com rua 2
            LDA PTB ;carrega o acumulador A com a porta B
            AND #$30
            CBEQA #$30,veli ;compara com rua 3
            LDA PTB ;carrega o acumulador A com a porta B
            AND #$03
            CBEQA #$03,veli ;compara com rua 1
                                                       
            JMP control
            
carp:       BSET 0,AUX ;coloca o bit 0 da variavel AUX como 1
            BRA vel
            
cari:       BSET 4,AUX ;coloca o bit 4 da variavel AUX como 1 
            BRA vel
            
car1:       BSET 0,AUX ;coloca o bit 0 da variavel AUX como 1
            BSET 4,AUX ;coloca o bit 4 da variavel AUX como 1 
            BRA vel            
            
velp:       BSET 1,AUX ;coloca o bit 1 da variavel AUX como 1  
            JMP control

veli:       BSET 5,AUX ;coloca o bit 5 da variavel AUX como 1             
            JMP control
            
            ;fim do programa
            
            ;NOP

            ;feed_watchdog
            ;JMP    mainLoop


            END