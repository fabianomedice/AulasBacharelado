#include <iostream.h>
#include <fstream.h>
#include <stdio.h>

int main (void)
{
    fstream ALUNO,ARQUIVO,VER,TAMANHO,TAM;
    char mat[43],ch;
    int contador,i,a,num;
    ARQUIVO.open("ALUNO2.TXT", ios::out);
    ALUNO.open ("ALUNO.TXT", ios::in);
    TAM.open ("ALUNO.TXT", ios::in);
    //tamanho de linhas
    num=0;
    while(TAM.get(ch))
    {
          if(ch=='\n')
          {
              num=num+1;
          }
    }
    TAM.close();
    int tam[num];
    //tamanho de cada linha
    TAMANHO.open ("ALUNO.TXT", ios::in);
    a=0;
    while(TAMANHO.getline(mat,43))
    {
          contador=0;
          for(i=0;i<43;i++)
          {
               if(mat[i]!=' ')
               {
                    contador=contador+1;
               }
          }
          tam[a]=contador;
          a=a+1;
    }
    TAMANHO.close();
    //criando o aluno 2
    contador=0;
    a=0;
    while(ALUNO.getline(mat,'CR/LF'))
    {
          ARQUIVO<<tam[a]<<"|";          
          for(i=0;i<5;i++)
                 ARQUIVO<<mat[i];
          ARQUIVO<<"|";
          for(i=6;i<43;i++)
          {
                 if(mat[i]!=' ')
                 {
                              ARQUIVO<<mat[i];
                              contador=0;
                 }
                 else
                 {
                              contador=contador+1;
                              if(contador==1)
                                             ARQUIVO<<"|";
                 }
          }
    }
    ALUNO.close();
    ARQUIVO.close();
    //mostrar o aluno 2
    VER.open("ALUNO2.TXT", ios::in);
    while(VER.getline(mat,43,'|'))
    {
          cout<<mat <<" ";
    }
    VER.close();
    system ("pause");
    return 0;
}
