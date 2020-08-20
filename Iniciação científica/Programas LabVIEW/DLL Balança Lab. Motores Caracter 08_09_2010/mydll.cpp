#include "mydll.h"
#include <windows.h>
//#include <conio.h>
//#include <stdio.h>
//#include <iostream.h>
//#include <math.h>

#define LEN_BUFFER 11 //Define o tamanho do buffer de leitura.

extern "C" __declspec(dllexport) char* Leitura (){
        
   char *porta = "COM1", *val;
    val = (char*)malloc(7*sizeof(char));
    HANDLE  hCom; // Handle para a Porta Serial (identificador).
    hCom = CreateFile(porta,GENERIC_READ | GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,NULL);

    if(hCom == INVALID_HANDLE_VALUE){
        MessageBox(NULL,"A porta está ocupada ou não está devidamente \nconectada!","Erro ao tentar abrir a porta especificada (Balança)",MB_OK);
        CloseHandle(hCom);
        return "falha";   //Erro ao tentar abrir a porta especificada.
    }
    DCB dcb; //Estrutura DCB é utilizada para definir todos os parâmetros da comunicação.

    if( !GetCommState(hCom, &dcb))
     return "falha";  //// Erro na leitura de DCB.
    
    BuildCommDCB("9600,N,8,1", &dcb); //Atribui os valores a estrutura dcb.

    if( SetCommState(hCom, &dcb) == 0 )
      return "falha";
   
    COMMTIMEOUTS CommTimeouts;

    if( GetCommTimeouts(hCom, &CommTimeouts) == 0 ){
        MessageBox(NULL,"Erro ao criar configuração da porta!","Erro de Comunicação Serial",MB_OK);
        return "falha";   //Erro.
    }

    //Define novos valores.
    CommTimeouts.ReadIntervalTimeout = 50;
    CommTimeouts.ReadTotalTimeoutMultiplier = 80;
    CommTimeouts.ReadTotalTimeoutConstant = 35;
    CommTimeouts.WriteTotalTimeoutMultiplier = 5;
    CommTimeouts.WriteTotalTimeoutConstant = 5;

    if( SetCommTimeouts(hCom, &CommTimeouts) == 0 ){
        MessageBox(NULL,"Erro ao criar configuração da porta!","Erro de Comunicação Serial",MB_OK);
        return "falha";   //Erro.
    }
   
   DWORD BytesLidos = 0;
   char BufferRecebe[LEN_BUFFER];   //Para armazenar a string a ser lida. 
   
   while (BufferRecebe [0] == 02){
            ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
    }    
    ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
    
    for (int i=1;i<(LEN_BUFFER-3);i++){ 
         val[i-1] = BufferRecebe [i];
    }
    
    CloseHandle(hCom);
    
    
    
    return val;
               
}

