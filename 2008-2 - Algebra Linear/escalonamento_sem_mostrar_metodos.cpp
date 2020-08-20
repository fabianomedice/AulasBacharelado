#include<iostream.h>

int main (void)
{
    int coluna, linha,i,j,a;
    cout<<"linha/coluna";
    cin>>linha >>coluna;
    float matriz[linha][coluna],pivor[linha];
    int contador[linha];
    // mostrar a matriz colocada
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
    
    //escalonamento gauss                                                 
    for(i=0;i<linha-1;i++)
    {
         for(a=0;a<linha-1;a++)
         {
           if(a+i+1<linha)
           {
               if(matriz[i][i]!=0)
               {
                    pivor[a]=-matriz[i+a+1][i]/matriz[i][i];
                    for(j=0;j<coluna;j++)
                         matriz[i+a+1][j]=pivor[a]*matriz[i][j]+ matriz[i+a+1][j];

               }

           }
         }
    }
    cout<<"\nMatriz escalonada por Gauss\n";
    
    //arrumar matriz
    float aux[coluna];
    
    for(i=0;i<linha-1;i++)
    {
         a=0;
         for(j=0;j<coluna;j++)
         {
              if(matriz[i][j]==0)
                  a=a+1;
         }
         contador[i]=a;
         if(contador[i]==coluna)
         {
              for(j=0;j<coluna;j++)
              {
                  aux[j]=matriz[i][j];
                  matriz[i][j]=matriz[i+1][j];
                  matriz[i+1][j]=aux[j];
              }
         }
    }

    //mostrar a matriz
    
    for(i=0;i<linha;i++)
    {
         for(j=0;j<coluna;j++)
         {
              cout<<matriz[i][j] <<"\t";
         }
         cout<<"\n";
    }
    cout<<"\n";

    //escalonar por gauss jordan
    
    for(i=0;i<linha;i++)
    {
         if(matriz[i][i]!=0)
         {
         pivor[i]=matriz[i][i];
         if(pivor[i]!=1)
             {
                  pivor[i]=1/pivor[i];
                  for(j=0;j<coluna;j++)
                  {
                      matriz[i][j]=pivor[i]*matriz[i][j];
                  }
             }
         }
         
    }
    for(i=linha-1;i>0;i--)
    {
        if(i-1>=0)
        {
             for(a=linha-1;a>=0;a--)
             {                       
                 if(matriz[a][a]!=0&&a>=i)
                 {
                      pivor[i-1]=-matriz[i-1][a]/matriz[a][a];
                      for(j=0;j<coluna;j++)
                      {
                          matriz[i-1][j]=pivor[i-1]*matriz[a][j]+ matriz[i-1][j];
                      }
                 }
             }
        }
    }
    cout<<"\nMatriz escalonada por Gauss-Jordan\n";
    
    //mostrar matriz
    
    for(i=0;i<linha;i++)
    {
         for(j=0;j<coluna;j++)
         {
              cout<<matriz[i][j] <<"\t";
         }
         cout<<"\n";
    }
    cout<<"\n";
    
    //mostrar a solucao    
    
    cout<<"equacao parametrica eh:\n";
    
    for(i=0;i<linha;i++)
    {
         for(j=0;j<coluna;j++)
         {
         if(j!=coluna-1)
         {
              cout<<matriz[i][j] <<" X"<<j+1;
         }
         else
         {
              cout<<" = "<<matriz[i][j];
              break;
         }
         cout<<" + ";
         }
         cout<<"\n";
    }
    cout<<"\n";
    
    for(i=0;i<linha;i++)
    {
         a=0;
         for(j=0;j<coluna;j++)
         {
              if(matriz[i][j]==0)
                  a=a+1;
         }
         contador[i]=a;
    }
    a=0;
    for(i=0;i<linha;i++)
    {
         if(contador[i]==coluna-1)
         {
               for(j=0;j<coluna;j++)
                     if(matriz[i][j]!=0)
                     {
                         if(j==coluna-1)
                              cout<<"o sistema eh impossivel\n";
                     }
         }
         else
         {
               if(coluna==linha)
               {
                     if(contador[i]==coluna)
                     {
                              if(i==linha-1)
                                      cout<<"o sistema eh possivel e determinado\n";
                              else
                              {
                                      cout<<"o sistema eh possivel e indeterminado\n";
                                      break;
                              }
                     }
               }
               else
               {
                     if(coluna-1 <= linha)
                     {
                              if(contador[i]==coluna)
                              {
                                      cout<<"o sistema eh possivel e indeterminado\n";
                                      break;
                              }
                              else
                                      a=a+1;
                     }
                     else
                              cout<<"o sistema eh possivel e indeterminado\n";
               }
         }
    }
    if(a==linha)
         cout<<"o sistema eh possivel e determinado\n";
    cout<<"\n";
    system("pause");
    return 0;
}
