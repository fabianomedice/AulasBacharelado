#include <windows.h>
#include <conio.h>
#include <stdio.h>
#include <iostream.h>
#include <math.h>

#define LEN_BUFFER 11 //Define o tamanho do buffer de leitura. 

int main (){
    
    
    int i, tam = LEN_BUFFER-4, lim;
    char*  val;
    val = (char*)malloc(7*sizeof(char));
    
    HANDLE  hCom; // Handle para a Porta Serial (identificador).
    hCom = CreateFile("COM1",GENERIC_READ | GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,NULL);

    if(hCom == INVALID_HANDLE_VALUE)
        return false;   //Erro ao tentar abrir a porta especificada.

    DCB dcb; //Estrutura DCB é utilizada para definir todos os parâmetros da comunicação.

    if( !GetCommState(hCom, &dcb))
     return false;  //// Erro na leitura de DCB.
    
    BuildCommDCB("9600,N,8,1", &dcb); //Atribui os valores a estrutura dcb.

    if( SetCommState(hCom, &dcb) == 0 )
      return false;
      
   DWORD BytesLidos = 0;
   char BufferRecebe[LEN_BUFFER];   //Para armazenar a string a ser lida. 
   
   lim =0; 
   while (lim < 300){           
        while (BufferRecebe [0] == 02){
                ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
        }    
        ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
        for (i=1;i<(LEN_BUFFER-3);i++){ 
             val[i-1] = BufferRecebe [i];
             printf("%c",BufferRecebe[i]);
            
        }
        lim++;
        for(i=0;i<tam;i++){
            printf("%c",val[i]);
        }
        cout << endl;
    }

    CloseHandle(hCom);


    getch ();

    return 0;
}

