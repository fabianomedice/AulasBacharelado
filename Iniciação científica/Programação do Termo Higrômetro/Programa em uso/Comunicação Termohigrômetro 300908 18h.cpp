#include <windows.h>
#include <conio.h>
#include <stdio.h>
#include <iostream.h>
#include <math.h>

int main (){
    
    
    int vaux4 = 0, contar = 2, val, i, j, lim, pos, inst;
    int  le = 0;
    float vaux = 0, temp, umidade;
    int LEN_BUFFER = 33;


    
    HANDLE  hCom; // Handle para a Porta Serial (identificador).
    hCom = CreateFile("COM4",GENERIC_READ | GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,NULL);

     if(hCom == INVALID_HANDLE_VALUE){
        MessageBox(NULL,"Verifique se a porta COM1 não está sendo utilizada!","Erro de Comunicação Serial",MB_OK);
        return 9999;   //Erro ao tentar abrir a porta especificada.
    }
 
    DCB dcb; //Estrutura DCB é utilizada para definir todos os parâmetros da comunicação.



    if( !GetCommState(hCom, &dcb)){
        return 9999;  //// Erro na leitura de DCB.
    }
   
    BuildCommDCB("9600,N,8,1", &dcb); //Atribui os valores a estrutura dcb.

    if( SetCommState(hCom, &dcb) == 0 )
      return false;

   COMMTIMEOUTS CommTimeouts;

   if( GetCommTimeouts(hCom, &CommTimeouts) == 0 )
       return false;   //Erro.

    //Define novos valores.
   CommTimeouts.ReadIntervalTimeout = 1;
   CommTimeouts.ReadTotalTimeoutMultiplier = 15;
   CommTimeouts.ReadTotalTimeoutConstant = 30;
   //CommTimeouts.WriteTotalTimeoutMultiplier = 5;
   //CommTimeouts.WriteTotalTimeoutConstant = 5;

   if( SetCommTimeouts(hCom, &CommTimeouts) == 0 )
      return false;   //Erro.
      
   DWORD BytesLidos = 0;
   char BufferRecebe[LEN_BUFFER];   //Para armazenar a string a ser lida. 
   int TamaString;

   DWORD BytesEscritos = 0;
while(true){   
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
    cout << temp << " C " << endl;
    
   BufferRecebe[0] = 83;
   BufferRecebe[1] = 67;
   BufferRecebe[2] = 13;
   //strcpy(BufferRecebe, "SC");  //Prepara a string a ser enviada.
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
    cout << umidade <<" %RH "<< endl ;
}
    if (temp ==0 || umidade == 0){
        CloseHandle (hCom);
        getch ();
        return 9999;
    }
    CloseHandle(hCom);


        getch ();

        return 0;
}

