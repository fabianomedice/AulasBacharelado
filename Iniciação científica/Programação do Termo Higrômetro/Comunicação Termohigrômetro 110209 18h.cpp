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
    
    char* porta="COM1";
    
    int nport;
    cin >> nport;
    /*switch (nport){
        case 1:
            porta = "COM1";
            cout << porta << endl;
            break;
            
        case 2:
            porta = "COM2";
            cout << porta << endl;
            break;
    }
    */
    
    HANDLE  hCom; // Handle para a Porta Serial (identificador).
    hCom = CreateFile(porta,GENERIC_READ | GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,NULL);

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
      
   DWORD BytesLidos = 0;
   char BufferRecebe[LEN_BUFFER];   //Para armazenar a string a ser lida. 
   int TamaString;

   DWORD BytesEscritos = 0;
   
   //cout << "Aguardando";
   //getch ();
   
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
        //printf ("%c",BufferRecebe[0]);
        le = BufferRecebe[0];
        if (le>=48 && le <= 57){
            temp += (le-48)*pow(10,contar);
            contar--;
        }
    }
    cout << temp;
    
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
        //printf ("%c",BufferRecebe[0]);
        le = BufferRecebe[0];
        if (le>=48 && le <= 57){
            umidade += (le-48)*pow(10,contar);
            contar--;
        }
    }
    cout << umidade;
 
/*    for (i =0; i<158;i++){
        ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
        printf ("%c",BufferRecebe[0]);
    }

    for (i =0; i<255;i++){
        ReadFile (hCom,BufferRecebe, LEN_BUFFER, &BytesLidos, NULL);
        printf ("%c",BufferRecebe[0]);
    }
*/    

    CloseHandle(hCom);


        getch ();

        return 0;
}

