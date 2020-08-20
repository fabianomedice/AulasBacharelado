#include "Termh.h"
#include <windows.h>
#include <conio.h>
#include <stdio.h>
//#include <iostream.h>
#include <math.h>

extern "C" __declspec(dllexport) float LeituraT (int &nport, float &temp, float &umidade){
    
    int vaux4 = 0, contar = 2, val, i, j, lim, pos, inst;
    int  le = 0;
    float vaux = 0;
    int LEN_BUFFER = 33;
    //char* porta= "COM4";
    
/*    switch (nport){
        
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
            MessageBox(NULL,"A porta está ocupada ou não está devidamente \nconectada!","Erro ao tentar abrir a porta especificada (Termo Higrômetro)",MB_OK);
            return 9999;
    
    }
 */   
    HANDLE  hCom; // Handle para a Porta Serial (identificador).
    hCom = CreateFile("COM1",GENERIC_READ | GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,NULL);

    if(hCom == INVALID_HANDLE_VALUE){
        MessageBox(NULL,"A porta está ocupada ou não está devidamente \nconectada!","Erro ao tentar abrir a porta especificada (Termo Higrômetro)",MB_OK);
        CloseHandle(hCom);
        return 9999;   //Erro ao tentar abrir a porta especificada.
    }
    DCB dcb; //Estrutura DCB é utilizada para definir todos os parâmetros da comunicação.

    if( !GetCommState(hCom, &dcb)){
        MessageBox(NULL,"Erro ao criar configuração da porta!","Erro de Comunicação Serial",MB_OK);
        return 9999;  //// Erro na leitura de DCB.
    }
    
    BuildCommDCB("9600,N,8,1", &dcb); //Atribui os valores a estrutura dcb.

    if( SetCommState(hCom, &dcb) == 0 ){
        MessageBox(NULL,"Erro ao criar configuração da porta!","Erro de Comunicação Serial",MB_OK);
        return 9999;
    }
    
    
    COMMTIMEOUTS CommTimeouts;

    if( GetCommTimeouts(hCom, &CommTimeouts) == 0 ){
        MessageBox(NULL,"Erro ao criar configuração da porta!","Erro de Comunicação Serial",MB_OK);
        return 9999;   //Erro.
    }
    //Define novos valores.
    CommTimeouts.ReadIntervalTimeout = 1;
    CommTimeouts.ReadTotalTimeoutMultiplier = 15;
    CommTimeouts.ReadTotalTimeoutConstant = 30;
    CommTimeouts.WriteTotalTimeoutMultiplier = 15;
    CommTimeouts.WriteTotalTimeoutConstant = 15;

    if( SetCommTimeouts(hCom, &CommTimeouts) == 0 ){
        MessageBox(NULL,"Erro ao criar configuração da porta!","Erro de Comunicação Serial",MB_OK);
        return 9999;   //Erro.
    }    
    
    
   DWORD BytesLidos = 0;
   char BufferRecebe[LEN_BUFFER];   //Para armazenar a string a ser lida. 
   int TamaString;

   DWORD BytesEscritos = 0;
   
   BufferRecebe[0] = 83;
   BufferRecebe[1] = 65;
   BufferRecebe[2] = 13;
   TamaString = strlen(BufferRecebe); //Calcula o tamanho da string a ser enviada.
   WriteFile( hCom, BufferRecebe, TamaString, &BytesLidos, NULL );
    
    temp = 0;
    contar = 1;
    LEN_BUFFER =1;
    for (i =0; i<9;i++){
        ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
        le = BufferRecebe[0];
        if (le>=48 && le <= 57){
            temp += (le-48)*pow(10,contar);
            contar--;
        }
    }
   
   BufferRecebe[0] = 83;
   BufferRecebe[1] = 67;
   BufferRecebe[2] = 13;
   TamaString = strlen(BufferRecebe); //Calcula o tamanho da string a ser enviada.
   WriteFile( hCom, BufferRecebe, TamaString, &BytesLidos, NULL );
   
    umidade = 0;
    LEN_BUFFER =1;
    contar = 1;
    for (i =0; i<9;i++){
        ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
        le = BufferRecebe[0];
        if (le>=48 && le <= 57){
            umidade += (le-48)*pow(10,contar);
            contar--;
        }
    }
    
    if (temp ==0 && umidade == 0){
        MessageBox(NULL,"  Erro ao tentar comunicar com o Termo Higrômetro  \n      verifique se está conectado corretamente!","Erro de comunicação serial",MB_OK);
        CloseHandle (hCom);
        return 9999;
    }
    
    CloseHandle(hCom);
}
