#include<iostream>
#include<conio.h>
using namespace std;


int main()
{
   //Indentificação Pessoal
    cout<<"\nDesenvolvido por: ";
    textcolor(9);
    cout<<"Crhistofi Meira Rocha\n\t\t  Daniel Luiz Barreto\n\t\t  Fabiano Viana Oliveira da Cunha Medice\n\t\t  Gilberto Castro de Rezende Zschaber";
    textcolor(7);
    cout<<"\n\nPontificia Universidade Catolica de Minas Gerais\nEngenharia Mecatronica\nDisciplina Algebra Linear - Professor Fabiano\n\nTrabalho Computacional - Parte 2\n\n\n";
    
    while(1){
    float **matriz;
    int linhas, colunas, i, j;
    
    cout<<"\n\n>>CRIACAO DE MATRIZ<<";                              //Criação de matriz
    cout<<"\n\nInsira a quantidade de linhas para a matriz: ";
    cin>>linhas;
    cout<<"\nInsira a quantidade de colunas para a matriz: ";
    cin>>colunas;
    if(linhas > 0 && colunas > 0)
              {
              matriz = new float *[linhas];
              for(i=0; i<linhas; i++)
                         matriz[i] = new float[colunas];
                         
    
    
    
                         cout<<"\n\n\n>>PREENCHIMENTO DA MATRIZ<<\n";               //Preenchimento da matriz
                         for(i=0; i<linhas; i++)
                                  for(j=0; j<colunas; j++)
                                  {
                                           cout<<"\nInsira o termo MATRIZ ["<<i+1<<","<<j+1<<"]: ";
                                           cin>>matriz[i][j];
                                           }
                      
                      
                      float vetor_auxiliar[colunas];
                      int teste_NULA, aux;                                                //Teste da Matriz NULA
                      teste_NULA = 0;
                      
                      for(i=0; i<linhas; i++)
                                  for(j=0; j<colunas; j++)
                                  if(matriz[i][j] != 0)                               //Teste da Matriz NULA
                                                  {
                                                       teste_NULA++;
                                                       break;
                                                       break;
                                                       }                              //Teste da Matriz NULA
                      
                      if(teste_NULA != 0)                                            //Teste da Matriz NULA
                      { 
                      
                      int vetor_posicao[linhas], contador_NULL, contador_posicao_NULL, verifica_pivo, zeros, col; //Teste de matriz escalonada
    
                      for(i=0; i<linhas; i++)
                      vetor_posicao[i]=0;
    
                      verifica_pivo = 0;
                      contador_NULL = 0;
                      contador_posicao_NULL = 0;
                      zeros = 0;
     
                      for(i=0; i<linhas; i++)
                               for(j=0; j<colunas; j++)
                                        if(matriz[i][j] != 0)
                                        {
                                                        vetor_posicao[i] = j+1;
                                                        break;
                                                        }
                      
                      cout<<"\n\n\noriginal de entrada";
                      for(i=0; i<linhas; i++)
                      cout<<"\n"<<vetor_posicao[i];      //teste       
                      
                      
                      for(i=0; i<linhas; i++)
                               if(vetor_posicao[i] == 0)
                                                   contador_NULL++;
                                  
                      if(contador_NULL>0)
                                         for(i=linhas-1; i>=linhas-contador_NULL; i--) //for(i=linhas-1; i>=linhas-1-contador_NULL; i--)
                                                         if(vetor_posicao[i] == 0)
                                                                             contador_posicao_NULL++;
                    
                      for(i=0; i<=linhas-2-contador_NULL; i++)
                             if(vetor_posicao[i] < vetor_posicao[i+1])
                                                 verifica_pivo++;
    
    
                      if(contador_NULL == contador_posicao_NULL && verifica_pivo == linhas-1-contador_NULL) //Verificação Gauss-Jordan
                      {
                                     int vetor_contador_zeros[linhas-1-contador_NULL];                     
    
                                     for(i=0; i<=linhas-1-contador_NULL; i++)
                                              vetor_contador_zeros[i] = 0;
             
                                     for(j=0; j<=linhas-1-contador_NULL; j++)
                                              {
                                                          col = vetor_posicao[j] - 1;
                                                          for(i=0; i<=linhas-1-contador_NULL; i++)
                                                                   if(matriz[i][col] != 0)
                                                                                     vetor_contador_zeros[col]++;
                                                                                     }
                                        
                                     for(i=0; i<=linhas-1-contador_NULL; i++)
                                              if(vetor_contador_zeros[i] > 1)
                                                                         zeros++;
                                                                         }                                 
                             
    cout<<"\n\n\n>>MATRIZ INSERIDA<<\n";                         //Escrevendo a matriz
    for(i=0; i<linhas; i++)
    {
             cout<<"\n";
             for(j=0; j<colunas; j++)
             cout<<"\t"<<matriz[i][j];
             }
    
                                                                 //seguranca especial para matriz de duas linhas
    if(linhas == 2 && contador_NULL != contador_posicao_NULL)
                   {
                   for(j=0; j<colunas; j++)
                   {
                            vetor_auxiliar[j] = matriz[0][j];
                            aux = vetor_posicao[0];
                       
                            matriz[0][j] = matriz[1][j];
                            vetor_posicao[0] = vetor_posicao[1];
                       
                            matriz[1][j] = vetor_auxiliar[j];
                            vetor_posicao[1] = aux;
                            }
                            
                            cout<<"\n\nMatriz NAO escalonada";
                            cout<<"\n\n\n>>MATRIZ INSERIDA: ESCALONADA POR GAUSS-JORDAN<<\n";                         //Escrevendo a matriz escalonada por gauss
                            for(i=0; i<linhas; i++)
                            {
                                      cout<<"\n";
                                      for(j=0; j<colunas; j++)
                                               cout<<"\t"<<matriz[i][j];
                                               }
                            
                            }
    
                         
                
                       
                                                                                    //conclusao : Matriz escalonada ou nao
    if(verifica_pivo == linhas-1-contador_NULL && contador_NULL == contador_posicao_NULL)
    {               
                     cout<<"\n\n>>A matriz inserida esta escalonada por Gauss";
                     if(zeros == 0)
                              cout<<"-Jordan";
                              }
   else
   {                      
           cout<<"\n\nMatriz NAO escalonada";                                              //escalonamento
           float matriz_E[linhas][colunas], matriz_ED[linhas][colunas];
           int troca_linha = 0;
                             
                                                                       //coloca linha nula abaixo das outras
           if(contador_NULL != contador_posicao_NULL)
           {
                            for(i=0; i<linhas; i++)
                                     {
                                               if(vetor_posicao[i] != 0)
                                                        {
                                                                   for(j=0; j<colunas; j++)
                                                                            matriz_E[troca_linha][j] = matriz[i][j];
                                                                   troca_linha++;
                                                                   }
                                                                   }
                            for(i=linhas-1; i>=linhas-contador_NULL; i--)
                                            for(j=0; j<colunas; j++)
                                                     matriz_E[i][j] = 0;
                                                     
                                                     
                                                     
           for(i=0; i<linhas; i++)                //gera novamente o vetor_posicao com as novas configuracoes de linhas nulas abaixo das demais
                      vetor_posicao[i]=0;
              
              for(i=0; i<linhas; i++)
                               for(j=0; j<colunas; j++)
                                        if(matriz_E[i][j] != 0)
                                        {
                                                        vetor_posicao[i] = j+1;
                                                        break;
                                                        }
                                                     
                                                     
                                                     } // fim ---->>>> //coloca linha nula abaixo das outras
                                                     
              else //gera a matriz_E caso nao haja linhas nulas
              {
                   for(i=0; i<linhas; i++)
                            for(j=0; j<colunas; j++)
                                     matriz_E[i][j] = matriz[i][j];                                                     
                                                    }// fim do else
                                                     
                                                     
          /* cout<<"\n\n\n>>MATRIZ INSERIDA: ESCALONADA POR GAUSS<<\n";                         //Escrevendo a matriz escalonada por gauss
           for(i=0; i<linhas; i++)
                    {
             cout<<"\n";
             for(j=0; j<colunas; j++)
             cout<<"\t"<<matriz_E[i][j];
             }*/
              
              
             
            cout<<"\n\n\ndepois de abaixar as linhas nulas";                                           
            for(i=0; i<linhas; i++)
             cout<<"\n"<<vetor_posicao[i];      //teste
                                                                                     
                                                     
                                                     //coloca as linhas nao nulas em ordem de pivo
                                                     //ordenamento bolha
           
             int M, X, Y;
             float vetor_auxiliar[colunas];
             
             for(M=1; M<=(linhas-1-contador_NULL); M++)
             {
                     //cout<<"\n\n\nrepeticao iniciada";
                     //cout<<"\n"<<linhas-2-contador_NULL;             //teste
                     for(X=(linhas-1-contador_NULL); X>=M; X--)
                     {
                                      Y=X-1;
                                      if(vetor_posicao[X]<vetor_posicao[Y])
                                      {
                                                           for(j=0;j<colunas;j++)
                                                           {
                                                                                 vetor_auxiliar[j] = matriz_E[X][j];
                                                                                 matriz_E[X][j] = matriz_E[Y][j];
                                                                                 matriz_E[Y][j] = vetor_auxiliar[j];
                                                           }
                                                           aux = vetor_posicao[X];
                                                           vetor_posicao[X] = vetor_posicao[Y];
                                                           vetor_posicao[Y] = aux;
                                                           }
                                      }
                     }
           
                    
   cout<<"\n\n\n depois de colocar as linhas nao lunas em ordem";
   for(i=0; i<linhas; i++)
             cout<<"\n"<<vetor_posicao[i];      //teste
   
   
   
    cout<<"\n\n\n>>MATRIZ INSERIDA: ESCALONADA POR GAUSS<<\n";                         //Escrevendo a matriz escalonada por gauss
    for(i=0; i<linhas; i++)
    {
             cout<<"\n";
             for(j=0; j<colunas; j++)
             cout<<"\t"<<matriz_E[i][j];
             }
   
   for(i=0; i<linhas; i++)
             cout<<"\n"<<vetor_posicao[i];      //teste
   
   
     //testes
    cout<<"\n\n";
    for(i=0; i<linhas; i++)
             cout<<"\n"<<vetor_posicao[i];         
    cout<<"\n\ncontador_NULL: "<<contador_NULL;
    cout<<"\ncontador_posicao_NULL: "<<contador_posicao_NULL;
    cout<<"\nverifica_pivo: "<<verifica_pivo;
    cout<<"\nzeros: "<<zeros;
    
    
   
   
   
   
   
   
   }                         
}//if(teste_NULLA != 0)                          
   else
   {
                  cout<<"\n\n\n>>MATRIZ INSERIDA<<\n";                         //Escrevendo a matriz NULA
                  for(i=0; i<linhas; i++)
                  {
                           cout<<"\n";
                           for(j=0; j<colunas; j++)
                           cout<<"\t"<<matriz[i][j];
                           }
                  cout<<"\n\n>> ERROR! Foi inserida uma matriz NULA!";      
}
             
   /* //testes
    cout<<"\n\n";
    for(i=0; i<linhas; i++)
             cout<<"\n"<<vetor_posicao[i];         
    cout<<"\n\ncontador_NULL: "<<contador_NULL;
    cout<<"\ncontador_posicao_NULL: "<<contador_posicao_NULL;
    cout<<"\nverifica_pivo: "<<verifica_pivo;
    cout<<"\nzeros: "<<zeros;
    */
    

} //chave que fecha o if de linhas > 0 && colunas > 0
    
    else
    cout<<"\n\n\n>> ERROR! Matriz de ordem invalida!\n\n";    
    
   }// while(1) testes 
    
    cout<<"\n\n\n";
    system("pause");
    return 0;
}
