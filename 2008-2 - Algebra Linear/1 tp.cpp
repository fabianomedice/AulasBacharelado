#include <iostream>
using namespace std;
#include <stdio.h>
int main (void)
{
    cout<<"Os componente do grupo sao: \n"
        <<"Fabiano Viana Oliveira da Cunha Medice \n";
    int linhaA, colunaA, i, j;
    cout<<"Digite o numero de linhas da Matriz A \n";
    cin>>linhaA;
    cout<<"Digite o numero de colunas da Matriz A \n";
    cin>>colunaA;
    int MatrizA[linhaA][colunaA];
    for (i=0;i<linhaA;i++)
        for(j=0;j<colunaA;j++)
        {
              cout<<"Digite o elemento [" <<i <<"] [" <<j <<"] da Matriz A \n";
              cin>>MatrizA[i][j];
        }
        int linhaB, colunaB;
    cout<<"Digite o numero de linhas da Matriz B \n";
    cin>>linhaB;
    cout<<"Digite o numero de colunas da Matriz B \n";
    cin>>colunaB;
    int MatrizB[linhaB][colunaB];
    for (i=0;i<linhaB;i++)
        for(j=0;j<colunaB;j++)
        {
              cout<<"Digite o elemento [" <<i <<"] [" <<j <<"] da Matriz B \n";
              cin>>MatrizB[i][j];
        }
    cout<<"A Matriz A e'\n";
    for (i=0;i<linhaA;i++)
    {
        for(j=0;j<colunaA;j++)
              printf("%d\t" , MatrizA[i][j]);
        printf("\n");
    }
    cout<<"A Matriz B e'\n";
    for (i=0;i<linhaB;i++)
    {
        for(j=0;j<colunaB;j++)
              printf("%d\t", MatrizB[i][j]);
        printf("\n");
    }
    if(linhaA==linhaB && colunaA==colunaB)
    {
        int MatrizC[linhaA][colunaB];
        for (i=0;i<linhaB;i++)
            for(j=0;j<colunaA;j++)
              MatrizC[i][j] = MatrizA[i][j] + MatrizB[i][j];
        cout<<"A Matriz soma A+B e' \n";
        for (i=0;i<linhaB;i++)
        {
            for(j=0;j<colunaA;j++)
              cout<<MatrizC[i][j] <<"\t";
            cout<<"\n";
        }
    }
    else
    cout<<"Impossivel fazer a soma das matrizes, pois elas nao sao de mesmo indice.\n";
    system("pause");
    return 0;
}
