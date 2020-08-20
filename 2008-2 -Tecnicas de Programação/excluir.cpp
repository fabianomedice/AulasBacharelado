//Fabiano Viana Oliveira da Cunha Médice

#include<iostream.h>

struct celula
{
    int X;
    celula *prox, *ant;  
};

typedef celula *cel;

void insere (cel&ini, int N)
{
     cel atual, nova;
     if (ini==NULL)
     {
        ini=new celula;
        ini->X=N;
        ini->prox=NULL;
        ini->ant=NULL;
     }
     else
     {
         atual=ini;
         while(atual->prox!=NULL)
            atual=atual->prox;
         nova=new celula;
         nova->X=N;
         nova->ant=atual;
         atual->prox=nova;
         nova->prox=NULL;
     }
}

void lista(cel&ini)
{
     cel atual;
     atual=ini;
     while(atual->prox!=NULL)
     {
         cout<<atual->X <<"\t";
         atual=atual->prox;
     }
     cout<<atual->X <<"\n";
}

void consulta(cel &ini, int N)
{
     cel atual;
     atual=ini;
     while (atual->prox!= NULL&&atual-> X!=N)
         atual=atual->prox;
     if(atual-> X==N)
         cout<<"\n" <<atual->X <<"\n\n";
     else
         cout<<"Nao existe\n\n";
}         
void exclui(cel &ini,int N)
{
     cel atual, anterior,proximo;
     if(ini->X==N)
     {
                  anterior=ini;
                  ini=ini->prox;
                  delete anterior;
     }
     else
     {
          atual=ini;
          while(atual->prox != NULL && atual-> X!= N)
          {
                  anterior=atual;
                  atual=atual->prox;
          }
          if(atual->prox == NULL && atual->X == N)
          {
                  anterior->prox=NULL;
                  delete atual;
          }
          else
          {
                  if(atual->X == N) 
                  {
                              anterior->prox=atual->prox;
                              proximo=atual->prox;
                              proximo->ant=atual->ant;           
                              delete atual;
                  }   
                  else
                              cout<<"O numero nao existe\n\n";
                  }
          }
     }
int main()
{
    cel p;
    p = NULL;
    int num, A, B;
    do
    {
        cout<<"Digite um numero; e para parar digite um numero negativo \n\n";
        cin>>num;
        if(num<0)
            break;
        insere(p,num);
    }
    while(2);
    lista(p);
    cout<<"Digite o valor procurado\n\n";
    cin>>A;
    consulta(p,A);
    cout<<"Digite o valor a ser deletado\n\n";
    cin>>B;
    exclui(p,B);
    lista(p);
    system("pause");
    return(0);
}
