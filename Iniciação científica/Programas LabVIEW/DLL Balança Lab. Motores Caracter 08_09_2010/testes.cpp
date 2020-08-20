#include "mydll.h"
#include <windows.h>
#include <conio.h>
#include <stdio.h>
//#include <iostream.h>
#include <math.h>

#define LEN_BUFFER 11 //Define o tamanho do buffer de leitura. 

extern "C" __declspec(dllexport) char* Leitura (int &nportb, int &inst, int &pos, float vaux){
        
   int vaux4, contar = 2, val, i, j, lim;
   char aux = 0;
   float status =0, peso;
   char* porta = "COM1";
 
/*    switch (nportb){
        
        case 1:
            porta = "COM1";
            break;
            
        case 2:
            porta = "COM4";
            break;
        
        case 3:
            porta = "COM5";
            break;
            
        default:
            MessageBox(NULL,"A porta está ocupada ou não está devidamente \nconectada!","Erro ao tentar abrir a porta especificada (Balança)",MB_OK);
            return 9999;
    
    }
 */   
    HANDLE  hCom; // Handle para a Porta Serial (identificador).
    hCom = CreateFile(porta,GENERIC_READ | GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,NULL);

    if(hCom == INVALID_HANDLE_VALUE){
        MessageBox(NULL,"A porta está ocupada ou não está devidamente \nconectada!","Erro ao tentar abrir a porta especificada (Balança)",MB_OK);
        CloseHandle(hCom);
        return 9999;   //Erro ao tentar abrir a porta especificada.
    }
    DCB dcb; //Estrutura DCB é utilizada para definir todos os parâmetros da comunicação.

    if( !GetCommState(hCom, &dcb))
     return 9999;  //// Erro na leitura de DCB.
    
    BuildCommDCB("9600,N,8,1", &dcb); //Atribui os valores a estrutura dcb.

    if( SetCommState(hCom, &dcb) == 0 )
      return 9999;
   
    COMMTIMEOUTS CommTimeouts;

    if( GetCommTimeouts(hCom, &CommTimeouts) == 0 ){
        MessageBox(NULL,"Erro ao criar configuração da porta!","Erro de Comunicação Serial",MB_OK);
        return 9999;   //Erro.
    }

    //Define novos valores.
    CommTimeouts.ReadIntervalTimeout = 50;
    CommTimeouts.ReadTotalTimeoutMultiplier = 80;
    CommTimeouts.ReadTotalTimeoutConstant = 35;
    CommTimeouts.WriteTotalTimeoutMultiplier = 5;
    CommTimeouts.WriteTotalTimeoutConstant = 5;

    if( SetCommTimeouts(hCom, &CommTimeouts) == 0 ){
        MessageBox(NULL,"Erro ao criar configuração da porta!","Erro de Comunicação Serial",MB_OK);
        return 9999;   //Erro.
    }
   
   DWORD BytesLidos = 0;
   char BufferRecebe[LEN_BUFFER];   //Para armazenar a string a ser lida. 
   
   lim =0; 
   peso = 0;
   
   while (lim < 1){           
        while (BufferRecebe [0] == 02){
                ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
        }    
        peso = 0;
        ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
           if (BufferRecebe [9]== 69){
                inst = 0;
            }else{
                inst = 1;
            }            
                
           if (BufferRecebe[1] == 45){
                pos = 0;
            }
            if (BufferRecebe [1] != 45) {
                pos = 1;
           } 
            contar = 2;
           for (i=1;i<(LEN_BUFFER-3);i++){ 
                val = BufferRecebe [i] - 48;
                if (val == -16 || val == -3){
                    contar--;
                }
                if (val >= 0 && val < 10){ //!= -2 && val != -16){
                    printf("%c",BufferRecebe[i]);
                    peso += val*pow(10,contar);
                    contar--;
                    //printf (" Val= %i Contar= %i Peso= %i \n", val, contar, vaux4);
                    
                }
           }
          lim++;
    }
    CloseHandle(hCom);
    
    
    //status = vaux;
    //vaux = peso;
    
    return peso;//printf ( "-> Peso %f \n ", peso);
               
}

