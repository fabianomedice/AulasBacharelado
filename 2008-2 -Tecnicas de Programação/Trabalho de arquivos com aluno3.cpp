#include <iostream.h>
#include <fstream.h>
#include <stdio.h>

int main (void)
{
    fstream ALUNO,ARQUIVO,VER,TAMANHO,TAM,ALUNO2,ALUNO3;
    char mat[43],ch;
    int contador,i,a,num;
    ARQUIVO.open("ALUNO2.TXT", ios::out);
    ALUNO.open ("ALUNO.TXT", ios::in);
    TAM.open ("ALUNO.TXT", ios::in);
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
    contador=0;
    while(ALUNO.get(ch))
    {
          if(ch!=' ')
          {
              ARQUIVO<<ch;
              contador=0;
          }
          else
          {
              contador=contador+1;
              if(contador==1)
                   ARQUIVO<<"|";
          }
    }
    ALUNO.close();
    ARQUIVO.close();
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
    ALUNO2.open("ALUNO2.TXT",ios::in);
    ALUNO3.open("ALUNO3.TXT",ios::out);
    a=0;
    while(ALUNO2.getline(mat,43))
    {
            ALUNO3<<tam[a] <<"|" <<mat <<"\n";
            a=a+1;
    }
    ALUNO2.close();
    ALUNO3.close();
    VER.open("ALUNO3.TXT", ios::in);
    while(VER.getline(mat,43,'|'))
    {
          cout<<mat <<" ";
    }
    VER.close();
    system ("pause");
    return 0;
}
