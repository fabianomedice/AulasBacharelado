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

CARROS: DS 1 ;contadores de carros
TEMPO: DS 1 ;auxiliar para os tempos de ruas
TEMPOAUX: DS 1 ;auxiliar para a rotina de tempo
BUFFER: DS 32 ;velocidades de ate 16 carros

; code section
MyCode:     SECTION
main:
_Startup:
            ;LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
            ;TXS
            ;CLI                     ; enable interrupts

mainLoop:

            ; começo do programa
            
            
;@@@@@@@@@@@@@@@@@@@@@@ configuracao do microcontrolador @@@@@@@@@@@@@@@@@@@@@@@@@@@@@

            MOV #$00,DDRA ;todos como input
            MOV #$FF,DDRB ;todos como output
            MOV #$1F,PTAPUE ;todos com resistor de pull up
            MOV #$08,CONFIG2 ;IRQ desahabilitado com oscilador externo
            MOV #$39,CONFIG1 ;5V , STOP ativado
            MOV #$02,OSCSTAT ;oscilador externo da central enable no bit 1
            MOV #$00,KBSCR ;interrupçoes de borda de descida e habilitados (nao mascarados)
            MOV #$03,KBIER ;as portas PTA 1 e 0 sao interrupçoes
*            MOV #$20,TSC ;parado e com 0 de divisor                               
                        
clock:      
            BRSET 0,OSCSTAT,controlck
            BRA clock      
            
                        
;@@@@@@@@@@@@@@@@@ leitura das entradas da central para ver que tempo que é @@@@@@@@@@@
controlck:
            LDA PTA ; carrega o acumulador A com a porta A
            AND #$1C ; deixou no acumulador somente as chaves
            CBEQA #$04,jncarnvel ; compara as chaves de entrada com a 001
            CBEQA #$08,jnvel ; compara as chaves de entrada com a 010
            CBEQA #$0C,jncar ; compara as chaves de entrada com a 011
            CBEQA #$10,jpcar ; compara as chaves de entrada com a 100
            CBEQA #$14,jpvel ; compara as chaves de entrada com a 101
            CBEQA #$18,jpcarpvel ; compara as chaves de entrada com a 110
            CBEQA #$1C,jpdefault ; compara as chaves de entrada com a 111
            
              MOV #0,CARROS ; zera o contador de carros
              
              BCLR 1,PTB ; zera a velocidade
              BCLR 2,PTB ;
              
  ;            JSR zerabuffer ;zera o buffer
              
              BRA ndefault ;se nao for nenhuma vai para ndefault
              
              ;jumps pelo tamanho do programa
  jncarnvel:  
              MOV #0,CARROS ; zera o contador de carros
                          
              BCLR 1,PTB ; zera a velocidade
              BCLR 2,PTB ;
              
  ;            JSR zerabuffer ;zera o buffer
              JMP ncarnvel
  jnvel:      
              MOV #0,CARROS ; zera o contador de carros
              
              BCLR 1,PTB ; zera a velocidade
              BCLR 2,PTB ;
              
  ;            JSR zerabuffer ;zera o buffer
              JMP nvel
  jncar:      
              MOV #0,CARROS ; zera o contador de carros
              
              BCLR 1,PTB ; zera a velocidade
              BCLR 2,PTB ;
              
  ;            JSR zerabuffer ;zera o buffer
              JMP ncar
  jpcar:      
              MOV #0,CARROS ; zera o contador de carros
              
              BCLR 1,PTB ; zera a velocidade
              BCLR 2,PTB ;
              
  ;            JSR zerabuffer ;zera o buffer            
              JMP pcar
  jpvel:      
              MOV #0,CARROS ; zera o contador de carros
              
              BCLR 1,PTB ; zera a velocidade
              BCLR 2,PTB ;
              
  ;            JSR zerabuffer ;zera o buffer
              JMP pvel
  jpcarpvel:  
              MOV #0,CARROS ; zera o contador de carros
              
              BCLR 1,PTB ; zera a velocidade
              BCLR 2,PTB ;
              
  ;            JSR zerabuffer ;zera o buffer
              JMP pcarpvel
  jpdefault:  
              MOV #0,CARROS ; zera o contador de carros
              
              BCLR 1,PTB ; zera a velocidade
              BCLR 2,PTB ;
              
  ;            JSR zerabuffer ;zera o buffer
              JMP pdefault

            
            ; tempo default-            
ndefault:            
            
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
             
            ;tempo do sinal verde + tempo do sinal amarelo do sinal positivo
            MOV #$6,TEMPO
            JSR tempo           
             
            ;sinal trafico vermelho ligado e sinal pedreste verde ligado
            BSET 3,PTB ;sinal pedreste verde ligado
            BCLR 4,PTB ;sinal pedreste vermelho desligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal de pedrestre do sinal positivo
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico verde ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BSET 5,PTB ;sinal trafico verde ligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BCLR 7,PTB ;sinal trafico vermelho desligado            
            
            ;tempo do sinal trafico vermelho - tempo do sinal de pedrestre - tempo do sinal amarelo -1 (do tempo vermelho final)
            MOV #$3,TEMPO
            JSR tempo           
              
            ;sinal trafico amarelo ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BSET 6,PTB ;sinal trafico amarelo ligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
            
            ;tempo do sinal amarelo
            MOV #$1,TEMPO
            JSR tempo           
            
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
              
            ;tempo vermelho final
            MOV #$1,TEMPO
            JSR tempo   
              
            JMP clock           
                        
            ; tempo car-vel-
ncarnvel:            
            
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
             
            ;tempo do sinal verde + tempo do sinal amarelo do sinal positivo
            MOV #$9,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste verde ligado
            BSET 3,PTB ;sinal pedreste verde ligado
            BCLR 4,PTB ;sinal pedreste vermelho desligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal de pedrestre do sinal positivo
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico verde ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BSET 5,PTB ;sinal trafico verde ligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BCLR 7,PTB ;sinal trafico vermelho desligado            
            
            ;tempo do sinal trafico vermelho - tempo do sinal de pedrestre - tempo do sinal amarelo -1 (do tempo vermelho final)
            MOV #$1,TEMPO
            JSR tempo           
             
              
            ;sinal trafico amarelo ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BSET 6,PTB ;sinal trafico amarelo ligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
            
            ;tempo do sinal amarelo
            MOV #$1,TEMPO
            JSR tempo           
            
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
              
            ;tempo vermelho final
            MOV #$1,TEMPO
            JSR tempo   
              
            JMP clock 
            
            ; tempo vel-
nvel:            
            
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
             
            ;tempo do sinal verde + tempo do sinal amarelo do sinal positivo
            MOV #$8,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste verde ligado
            BSET 3,PTB ;sinal pedreste verde ligado
            BCLR 4,PTB ;sinal pedreste vermelho desligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal de pedrestre do sinal positivo
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico verde ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BSET 5,PTB ;sinal trafico verde ligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BCLR 7,PTB ;sinal trafico vermelho desligado            
            
            ;tempo do sinal trafico vermelho - tempo do sinal de pedrestre - tempo do sinal amarelo -1 (do tempo vermelho final)
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico amarelo ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BSET 6,PTB ;sinal trafico amarelo ligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
            
            ;tempo do sinal amarelo
            MOV #$1,TEMPO
            JSR tempo           
            
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado 
            
            ;tempo vermelho final
            MOV #$1,TEMPO
            JSR tempo 
              
            JMP clock 
            
            ; tempo car-
ncar:            
            
            
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
             
            ;tempo do sinal verde + tempo do sinal amarelo do sinal positivo
            MOV #$7,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste verde ligado
            BSET 3,PTB ;sinal pedreste verde ligado
            BCLR 4,PTB ;sinal pedreste vermelho desligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal de pedrestre do sinal positivo
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico verde ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BSET 5,PTB ;sinal trafico verde ligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BCLR 7,PTB ;sinal trafico vermelho desligado            
            
            ;tempo do sinal trafico vermelho - tempo do sinal de pedrestre - tempo do sinal amarelo -1 (do tempo vermelho final)
            MOV #$2,TEMPO
            JSR tempo           
              
            ;sinal trafico amarelo ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BSET 6,PTB ;sinal trafico amarelo ligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
            
            ;tempo do sinal amarelo
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
            
            ;tempo vermelho final
            MOV #$1,TEMPO
            JSR tempo  
              
            JMP clock 
            
            ; tempo car+            
pcar:                        
            ;sinal trafico verde ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BSET 5,PTB ;sinal trafico verde ligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
            
            ;tempo do sinal verde
            MOV #$6,TEMPO
            JSR tempo           
              
            ;sinal trafico amarelo ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BSET 6,PTB ;sinal trafico amarelo ligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
                        
            ;tempo do sinal amarelo
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste verde ligado
            BSET 3,PTB ;sinal pedreste verde ligado
            BCLR 4,PTB ;sinal pedreste vermelho desligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal de pedrestre
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal trafico vermelho - tempo do sinal de pedrestre
            MOV #$4,TEMPO
            JSR tempo           
              
            JMP clock 
            
            ; tempo vel+            
pvel:                        
            ;sinal trafico verde ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BSET 5,PTB ;sinal trafico verde ligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
            
            ;tempo do sinal verde
            MOV #$7,TEMPO
            JSR tempo           
              
            ;sinal trafico amarelo ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BSET 6,PTB ;sinal trafico amarelo ligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
                        
            ;tempo do sinal amarelo
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste verde ligado
            BSET 3,PTB ;sinal pedreste verde ligado
            BCLR 4,PTB ;sinal pedreste vermelho desligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                       
            ;tempo do sinal de pedrestre
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal trafico vermelho - tempo do sinal de pedrestre
            MOV #$3,TEMPO
            JSR tempo           
              
            JMP clock  
            
            ; tempo car+vel+            
pcarpvel:                        
            ;sinal trafico verde ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BSET 5,PTB ;sinal trafico verde ligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
            
            ;tempo do sinal verde
            MOV #$8,TEMPO
            JSR tempo           
              
            ;sinal trafico amarelo ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BSET 6,PTB ;sinal trafico amarelo ligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
                        
            ;tempo do sinal amarelo
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste verde ligado
            BSET 3,PTB ;sinal pedreste verde ligado
            BCLR 4,PTB ;sinal pedreste vermelho desligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal de pedrestre
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal trafico vermelho - tempo do sinal de pedrestre
            MOV #$3,TEMPO
            JSR tempo           
              
            JMP clock 
            
            
            ; tempo default+            
pdefault:                        
            ;sinal trafico verde ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BSET 5,PTB ;sinal trafico verde ligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
            
            ;tempo do sinal verde
            MOV #$5,TEMPO
            JSR tempo           
              
            ;sinal trafico amarelo ligado e sinal pedrestre vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BSET 6,PTB ;sinal trafico amarelo ligado
            BCLR 7,PTB ;sinal trafico vermelho desligado
                        
            ;tempo do sinal amarelo
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste verde ligado
            BSET 3,PTB ;sinal pedreste verde ligado
            BCLR 4,PTB ;sinal pedreste vermelho desligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal de pedrestre
            MOV #$1,TEMPO
            JSR tempo           
              
            ;sinal trafico vermelho ligado e sinal pedreste vermelho ligado
            BCLR 3,PTB ;sinal pedreste verde desligado
            BSET 4,PTB ;sinal pedreste vermelho ligado
            BCLR 5,PTB ;sinal trafico verde desligado
            BCLR 6,PTB ;sinal trafico amarelo desligado
            BSET 7,PTB ;sinal trafico vermelho ligado
                        
            ;tempo do sinal trafico vermelho - tempo do sinal de pedrestre
            MOV #$5,TEMPO
            JSR tempo           
              
            JMP clock 
            
            
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ rotina de tempo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
tempo:            

DTEMPOSEG:  

D1SEG:      LDA #100
            STA TEMPOAUX
                               
D10MILI:    LDA #100                    

D100MICRO:  LDX #100

LOOP0:      DECX
            BNE LOOP0 
            
            DECA
            BNE D100MICRO
            
            DEC TEMPOAUX
            BNE D10MILI                   
            
            DEC TEMPO
            BNE DTEMPOSEG
            
            RTS
            
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@ leitura dos sensores de velocidade @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

sensor:     
            LDA PTA
            AND #$03
            CBEQA #$02,sensorB            
       
sensorA:    
            BCLR 5,TSC ; inicia o timmer
            
            INC CARROS ;adiciona +1 a variavel
            LDA CARROS
            CBEQA #$0F,contadora ; se tiver passado 16 carros vai para a funçao contadora

            BCLR 0,PTB

            BRA saida

sensorB:            
            BSET 5,TSC; para o timmer
            
            ;mede a velocidade
            LDHX TCNT
*            CPHX #1500 ;tempo para calcular a velocidade 60km/h (16,7m/s) 149700599ns
            BLS vel
            
            BSET 4,TSC ;reseta o timmer
            BRA saida
            
            ;manda as velocidades para a central

vel:        
            BSET 1,PTB
            BSET 2,PTB
            
            BSET 4,TSC ;reseta o timmer
            
            BRA saida

            ;contador de carros que passaram pelo sensor A
contadora:                        
            BSET 0,PTB ; pulso para o microcontrolador central para avisar que passaram 16 carros                    
saida:
            RTI            
                                         
;zerabuffer: 
;            LDHX #BUFFER ;carregando o endereço do buffer
;            CLR ,X ;zera o conteudo do endereço
;            AIX #1 ;adiciona 1 para o SP
;            CPHX #BUFFER+31 ;compara com o ultimo endereço de buffer
;            BNE zerabuffer ;se nao for volta
;            RTS           
            
            ;vetor de interrupçao de teclado             
            ORG $FFE0
            DC.W sensor           
                        
            ;fim do programa
            
            ; Insert your code here
            ;NOP

            ;feed_watchdog
            ;BRA    mainLoop


            END