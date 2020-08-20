#include<iostream.h>

int main (void)
{
    int coluna, linha,i,j,a;
    cout<<"linha/coluna";
    cin>>linha >>coluna;
    float matriz[linha][coluna],pivor[linha];
    for(i=0;i<linha;i++)
         for(j=0;j<coluna;j++)
         {
              cout<<"Mat [" <<i <<" ][ " <<j <<" ]:";
              cin>>matriz[i][j];
         }
    for(i=0;i<linha;i++)
    {
         for(j=0;j<coluna;j++)
         {
              cout<<matriz[i][j] <<"\t";
         }
         cout<<"\n";
    }
    cout<<"\n";
    for(i=0;i<linha-1;i++)
    {
         for(a=0;a<linha-1;a++)
         {
           if(a+i+1<linha)
           {
              pivor[a]=-matriz[i+a+1][i]/matriz[i][i];
              cout<<"L" <<i+a+2 <<"=" <<pivor[a] <<"*L" <<i+1 <<" + L" <<i+a+2 <<"\n";
              for(j=0;j<coluna;j++)
              {
                    matriz[i+a+1][j]=pivor[a]*matriz[i][j]+ matriz[i+a+1][j];
              }
           }
         }
    }
    cout<<"\nMatriz escalonada por Gauss\n";
    for(i=0;i<linha;i++)
    {
         for(j=0;j<coluna;j++)
         {
              cout<<matriz[i][j] <<"\t";
         }
         cout<<"\n";
    }
    cout<<"\n";
    for(i=0;i<linha;i++)
    {
         pivor[i]=matriz[i][i];
         if(pivor[i]!=1)
         {
              if(pivor[i]<0)
                  cout<<"L"<<i+1 <<"=-"<<-1/pivor[i] <<"L"<<i+1<<"\n";
              else
                  cout<<"L" <<i+1 <<"="<<1/pivor[i] <<"L" <<i+1<<"\n";
              pivor[i]=1/pivor[i];
              for(j=0;j<coluna;j++)
              {
                  matriz[i][j]=pivor[i]*matriz[i][j];
              }
         }
    }
    for(i=linha-1;i>=0;i--)
    {
        if(i-1>=0)
        {
              pivor[i-1]=-matriz[i-1][i]/matriz[i][i];
              cout<<"L"<<i<<"="<<pivor[i-1]<<"*L"<<i+1<<"+L"<<i<<"\n";
              for(j=0;j<coluna;j++)
              {
                    matriz[i-1][j]=pivor[i-1]*matriz[i][j]+ matriz[i-1][j];
              }
        }
    }
    cout<<"\nMatriz escalonada por Gauss-Jordan\n";
    for(i=0;i<linha;i++)
    {
         for(j=0;j<coluna;j++)
         {
              cout<<matriz[i][j] <<"\t";
         }
         cout<<"\n";
    }
    cout<<"\n";
    system("pause");
    return 0;
}
